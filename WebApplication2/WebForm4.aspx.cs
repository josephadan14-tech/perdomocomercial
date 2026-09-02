using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        private string conexionString = ConfigurationManager.ConnectionStrings["EmpresaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
            {
                Response.Redirect("WebForm1.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Control de visibilidad por rol
                string rol = Session["Rol"] != null ? Session["Rol"].ToString() : "";
                if (rol.Equals("Vendedor", StringComparison.OrdinalIgnoreCase))
                {
                    if (navReportes != null) navReportes.Visible = false;
                    if (navProveedores != null) navProveedores.Visible = false;
                }

                CargarCategorias();
                CargarProductos();
            }
        }

        private void CargarCategorias()
        {
            ddlCategoria.Items.Clear();
            ddlCategoria.Items.Add(new ListItem("Seleccione una categoría...", ""));
            ddlCategoria.Items.Add(new ListItem("Sala", "Sala"));
            ddlCategoria.Items.Add(new ListItem("Comedor", "Comedor"));
            ddlCategoria.Items.Add(new ListItem("Dormitorio", "Dormitorio"));
            ddlCategoria.Items.Add(new ListItem("Oficina", "Oficina"));
            ddlCategoria.Items.Add(new ListItem("Electrodomésticos", "Electrodomésticos"));
            ddlCategoria.Items.Add(new ListItem("General", "General"));
        }

        private void CargarProductos(string busqueda = "")
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "SELECT IdProducto AS ID, Nombre, Categoria, Stock, Precio, ISNULL(ImagenUrl, 'uploads/default.png') AS ImagenUrl " +
                               "FROM Productos WHERE Estado = 1";

                if (!string.IsNullOrEmpty(busqueda))
                {
                    query += " AND Nombre LIKE @Busqueda";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(busqueda))
                    {
                        cmd.Parameters.AddWithValue("@Busqueda", "%" + busqueda.Trim() + "%");
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvProductos.DataSource = dt;
                    gvProductos.DataBind();
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            int productoId = Convert.ToInt32(hfProductoID.Value);
            string rutaImagen = "uploads/default.png";

            if (productoId > 0)
            {
                rutaImagen = ObtenerRutaImagenActual(productoId);
            }

            if (fuImagen.HasFile)
            {
                try
                {
                    string extension = Path.GetExtension(fuImagen.FileName).ToLower();
                    string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".webp" };

                    if (Array.Exists(extensionesPermitidas, ext => ext == extension))
                    {
                        string carpetaUploads = Server.MapPath("~/uploads/");
                        if (!Directory.Exists(carpetaUploads))
                        {
                            Directory.CreateDirectory(carpetaUploads);
                        }

                        string nombreArchivo = Guid.NewGuid().ToString() + extension;
                        string rutaGuardado = Path.Combine(carpetaUploads, nombreArchivo);
                        fuImagen.SaveAs(rutaGuardado);

                        rutaImagen = "uploads/" + nombreArchivo;
                    }
                }
                catch (Exception)
                {
                    // Manejo de excepción en subida
                }
            }

            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query;
                if (productoId == 0)
                {
                    query = "INSERT INTO Productos (Nombre, Categoria, Stock, Precio, ImagenUrl, Estado) VALUES (@Nombre, @Categoria, @Stock, @Precio, @ImagenUrl, 1)";
                }
                else
                {
                    query = "UPDATE Productos SET Nombre = @Nombre, Categoria = @Categoria, Stock = @Stock, Precio = @Precio, ImagenUrl = @ImagenUrl WHERE IdProducto = @IdProducto";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                    cmd.Parameters.AddWithValue("@Categoria", ddlCategoria.SelectedValue);
                    cmd.Parameters.AddWithValue("@Stock", Convert.ToInt32(txtStock.Text));
                    cmd.Parameters.AddWithValue("@Precio", Convert.ToDecimal(txtPrecio.Text));
                    cmd.Parameters.AddWithValue("@ImagenUrl", rutaImagen);

                    if (productoId > 0)
                    {
                        cmd.Parameters.AddWithValue("@IdProducto", productoId);
                    }

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LimpiarFormulario();
            CargarProductos();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            CargarProductos(txtBuscar.Text);
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                CargarProductoParaEditar(id);
            }
            else if (e.CommandName == "Eliminar")
            {
                DesactivarProducto(id);
                CargarProductos();
            }
        }

        private void CargarProductoParaEditar(int id)
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "SELECT IdProducto, Nombre, Categoria, Stock, Precio FROM Productos WHERE IdProducto = @IdProducto";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        hfProductoID.Value = reader["IdProducto"].ToString();
                        txtNombre.Text = reader["Nombre"].ToString();

                        string cat = reader["Categoria"].ToString();
                        if (ddlCategoria.Items.FindByValue(cat) != null)
                        {
                            ddlCategoria.SelectedValue = cat;
                        }

                        txtStock.Text = reader["Stock"].ToString();
                        txtPrecio.Text = Convert.ToDecimal(reader["Precio"]).ToString("0.00");
                        btnGuardar.Text = "Actualizar Producto";
                    }
                }
            }
        }

        private void DesactivarProducto(int id)
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "UPDATE Productos SET Estado = 0 WHERE IdProducto = @IdProducto";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private string ObtenerRutaImagenActual(int id)
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "SELECT ISNULL(ImagenUrl, 'uploads/default.png') FROM Productos WHERE IdProducto = @IdProducto";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : "uploads/default.png";
                }
            }
        }

        private void LimpiarFormulario()
        {
            hfProductoID.Value = "0";
            txtNombre.Text = "";
            if (ddlCategoria.Items.Count > 0) ddlCategoria.SelectedIndex = 0;
            txtStock.Text = "";
            txtPrecio.Text = "";
            btnGuardar.Text = "Guardar Producto";
        }
    }
}
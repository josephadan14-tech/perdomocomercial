using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class WebForm8 : System.Web.UI.Page
    {
        private string conexionString = ConfigurationManager.ConnectionStrings["EmpresaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Usuario"] != null)
                {
                    lblUsuario.Text = Session["Usuario"].ToString();
                }

                CargarProveedores();
            }
        }

        // Cargar proveedores con filtro opcional de búsqueda
        private void CargarProveedores(string filtro = "")
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = @"SELECT IdProveedor, 
                                        NombreEmpresa, 
                                        ISNULL(Contacto, 'N/A') AS Contacto, 
                                        ISNULL(Telefono, 'N/A') AS Telefono, 
                                        ISNULL(Correo, 'N/A') AS Correo, 
                                        ISNULL(Direccion, 'N/A') AS Direccion 
                                 FROM Proveedores 
                                 WHERE Estado = 1";

                if (!string.IsNullOrWhiteSpace(filtro))
                {
                    query += " AND (NombreEmpresa LIKE @Filtro OR Contacto LIKE @Filtro)";
                }

                query += " ORDER BY IdProveedor DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrWhiteSpace(filtro))
                    {
                        cmd.Parameters.AddWithValue("@Filtro", "%" + filtro.Trim() + "%");
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvProveedores.DataSource = dt;
                        gvProveedores.DataBind();
                    }
                }
            }
        }

        // Guardar o Modificar proveedor
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreEmpresa.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Por favor ingrese el nombre de la empresa.');", true);
                return;
            }

            int idProveedor = Convert.ToInt32(hfIdProveedor.Value);

            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "";

                if (idProveedor == 0) // Guardar nuevo
                {
                    query = @"INSERT INTO Proveedores (NombreEmpresa, Contacto, Telefono, Correo, Direccion, Estado) 
                             VALUES (@NombreEmpresa, @Contacto, @Telefono, @Correo, @Direccion, 1)";
                }
                else // Modificar existente
                {
                    query = @"UPDATE Proveedores 
                             SET NombreEmpresa = @NombreEmpresa, 
                                 Contacto = @Contacto, 
                                 Telefono = @Telefono, 
                                 Correo = @Correo, 
                                 Direccion = @Direccion 
                             WHERE IdProveedor = @IdProveedor";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (idProveedor > 0)
                    {
                        cmd.Parameters.AddWithValue("@IdProveedor", idProveedor);
                    }

                    cmd.Parameters.AddWithValue("@NombreEmpresa", txtNombreEmpresa.Text.Trim());
                    cmd.Parameters.AddWithValue("@Contacto", string.IsNullOrWhiteSpace(txtContacto.Text) ? (object)DBNull.Value : txtContacto.Text.Trim());
                    cmd.Parameters.AddWithValue("@Telefono", string.IsNullOrWhiteSpace(txtTelefono.Text) ? (object)DBNull.Value : txtTelefono.Text.Trim());
                    cmd.Parameters.AddWithValue("@Correo", string.IsNullOrWhiteSpace(txtCorreo.Text) ? (object)DBNull.Value : txtCorreo.Text.Trim());
                    cmd.Parameters.AddWithValue("@Direccion", string.IsNullOrWhiteSpace(txtDireccion.Text) ? (object)DBNull.Value : txtDireccion.Text.Trim());

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            string mensaje = idProveedor == 0 ? "Proveedor registrado exitosamente." : "Proveedor modificado exitosamente.";
            LimpiarCampos();
            CargarProveedores();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{mensaje}');", true);
        }

        // Búsqueda por filtro
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarProveedores(txtBuscar.Text);
        }

        // Manejo de botones dentro de la tabla (Editar / Eliminar)
        protected void gvProveedores_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idProveedor = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                CargarDatosProveedor(idProveedor);
            }
            else if (e.CommandName == "Eliminar")
            {
                EliminarProveedor(idProveedor);
            }
        }

        // Cargar un proveedor al formulario para editar
        private void CargarDatosProveedor(int idProveedor)
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "SELECT NombreEmpresa, Contacto, Telefono, Correo, Direccion FROM Proveedores WHERE IdProveedor = @IdProveedor";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IdProveedor", idProveedor);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfIdProveedor.Value = idProveedor.ToString();
                        txtNombreEmpresa.Text = dr["NombreEmpresa"].ToString();
                        txtContacto.Text = dr["Contacto"].ToString();
                        txtTelefono.Text = dr["Telefono"].ToString();
                        txtCorreo.Text = dr["Correo"].ToString();
                        txtDireccion.Text = dr["Direccion"].ToString();

                        btnGuardar.Text = "Actualizar Proveedor";
                        btnGuardar.CssClass = "btn btn-warning px-4 fw-semibold";
                    }
                }
            }
        }

        // Eliminación lógica del proveedor (Estado = 0)
        private void EliminarProveedor(int idProveedor)
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                string query = "UPDATE Proveedores SET Estado = 0 WHERE IdProveedor = @IdProveedor";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IdProveedor", idProveedor);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LimpiarCampos();
            CargarProveedores();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Proveedor eliminado correctamente.');", true);
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("WebForm1.aspx");
        }

        private void LimpiarCampos()
        {
            hfIdProveedor.Value = "0";
            txtNombreEmpresa.Text = string.Empty;
            txtContacto.Text = string.Empty;
            txtTelefono.Text = string.Empty;
            txtCorreo.Text = string.Empty;
            txtDireccion.Text = string.Empty;

            btnGuardar.Text = "Guardar Proveedor";
            btnGuardar.CssClass = "btn btn-primary px-4 fw-semibold";
        }
    }
}
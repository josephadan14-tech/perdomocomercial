using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class WebForm3 : Page
    {
        private readonly string cadenaConexion = ConfigurationManager.ConnectionStrings["EmpresaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Usuario"] == null)
                {
                    Response.Redirect("WebForm1.aspx");
                    return;
                }

                CargarClientes();
               
            }
        }

        private void CargarClientes()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = "SELECT IDCliente, Nombre, Telefono, Correo, Direccion FROM Clientes ORDER BY IDCliente DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvClientes.DataSource = dt;
                        gvClientes.DataBind();

                        lblTotalClientes.Text = dt.Rows.Count.ToString();
                    }
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                MostrarAlerta("Campo Obligatorio", "Ingrese el nombre del cliente.", "warning");
                return;
            }

            int idCliente = Convert.ToInt32(hfIDCliente.Value);

            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query;
                if (idCliente == 0)
                {
                    // Guardar Nuevo (INSERT)
                    query = "INSERT INTO Clientes (Nombre, Telefono, Correo, Direccion) VALUES (@Nombre, @Telefono, @Correo, @Direccion)";
                }
                else
                {
                    // Modificar Existente (UPDATE)
                    query = "UPDATE Clientes SET Nombre = @Nombre, Telefono = @Telefono, Correo = @Correo, Direccion = @Direccion WHERE IDCliente = @IDCliente";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                    cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text.Trim());
                    cmd.Parameters.AddWithValue("@Correo", txtCorreo.Text.Trim());
                    cmd.Parameters.AddWithValue("@Direccion", txtDireccion.Text.Trim());

                    if (idCliente > 0)
                    {
                        cmd.Parameters.AddWithValue("@IDCliente", idCliente);
                    }

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            string msj = idCliente == 0 ? "El cliente se registró con éxito." : "El cliente fue actualizado correctamente.";
            LimpiarCampos();
            CargarClientes();
            MostrarAlerta("¡Éxito!", msj, "success");
        }

        protected void gvClientes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idCliente = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                CargarClienteParaEditar(idCliente);
            }
            else if (e.CommandName == "Eliminar")
            {
                EliminarCliente(idCliente);
            }
        }

        private void CargarClienteParaEditar(int idCliente)
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = "SELECT IDCliente, Nombre, Telefono, Correo, Direccion FROM Clientes WHERE IDCliente = @IDCliente";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IDCliente", idCliente);
                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfIDCliente.Value = dr["IDCliente"].ToString();
                            txtNombre.Text = dr["Nombre"].ToString();
                            txtTelefono.Text = dr["Telefono"].ToString();
                            txtCorreo.Text = dr["Correo"].ToString();
                            txtDireccion.Text = dr["Direccion"].ToString();

                            // Cambiar visualmente los textos
                            lblTituloFormulario.Text = "Editar Cliente #" + idCliente;
                            btnGuardar.Text = "Actualizar Cliente";
                            btnGuardar.CssClass = "btn btn-warning flex-grow-1 py-2 text-white font-weight-bold shadow-sm";
                        }
                    }
                }
            }
        }

        private void EliminarCliente(int idCliente)
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = "DELETE FROM Clientes WHERE IDCliente = @IDCliente";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IDCliente", idCliente);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LimpiarCampos();
            CargarClientes();
            MostrarAlerta("Eliminado", "El cliente fue eliminado.", "success");
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();
        }

        private void LimpiarCampos()
        {
            hfIDCliente.Value = "0";
            txtNombre.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            txtDireccion.Text = "";

            lblTituloFormulario.Text = "Registrar Cliente";
            btnGuardar.Text = "Guardar Cliente";
            btnGuardar.CssClass = "btn btn-custom flex-grow-1 py-2 shadow-sm";
        }

        private void MostrarAlerta(string titulo, string mensaje, string tipo)
        {
            string script = $@"
                Swal.fire({{
                    icon: '{tipo}',
                    title: '{titulo}',
                    text: '{mensaje}',
                    confirmButtonColor: '#d97706',
                    background: '#ffffff'
                }});";

            ClientScript.RegisterStartupScript(this.GetType(), "AlertaSweetAlert", script, true);
        }
    }
}
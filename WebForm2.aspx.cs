using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication2
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        private string conexionString = ConfigurationManager.ConnectionStrings["EmpresaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Verificar si hay sesión activa
            if (Session["Usuario"] == null)
            {
                Response.Redirect("WebForm1.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // 2. Mostrar nombre de usuario en la interfaz
                lblUsuario.Text = Session["Usuario"].ToString();

                // 3. Control de visibilidad según el Rol
                string rol = Session["Rol"] != null ? Session["Rol"].ToString() : "";

                if (rol.Equals("Vendedor", StringComparison.OrdinalIgnoreCase))
                {
                    // Ocultar tarjetas de la pantalla principal
                    cardReportes.Visible = false;
                    cardProveedores.Visible = false;

                    // Ocultar opciones de la barra de navegación
                    navReportes.Visible = false;
                    navProveedores.Visible = false;
                }
                // 4. Cargar datos de las métricas
                CargarMetricas();
            }
        }

        private void CargarMetricas()
        {
            using (SqlConnection con = new SqlConnection(conexionString))
            {
                con.Open();

                // 1. Total Clientes Activos
                string qClientes = "SELECT COUNT(*) FROM Clientes WHERE Estado = 1";
                using (SqlCommand cmd = new SqlCommand(qClientes, con))
                {
                    lblClientes.Text = cmd.ExecuteScalar().ToString();
                }

                // 2. Total Productos Activos en Inventario
                string qProductos = "SELECT ISNULL(SUM(Stock), 0) FROM Productos WHERE Estado = 1";
                using (SqlCommand cmd = new SqlCommand(qProductos, con))
                {
                    lblProductos.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }

                // 3. Total Ventas Emitidas
                string qVentas = "SELECT COUNT(*) FROM Ventas";
                using (SqlCommand cmd = new SqlCommand(qVentas, con))
                {
                    lblVentas.Text = cmd.ExecuteScalar().ToString();
                }

                // 4. Total Ingresos Generados (Suma total de ventas)
                string qIngresos = "SELECT ISNULL(SUM(Total), 0) FROM Ventas";
                using (SqlCommand cmd = new SqlCommand(qIngresos, con))
                {
                    decimal totalIngresos = Convert.ToDecimal(cmd.ExecuteScalar());
                    lblIngresos.Text = totalIngresos.ToString("N2"); // Formato 0.00
                }
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("WebForm1.aspx");
        }
    }
}
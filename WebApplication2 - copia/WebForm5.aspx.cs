using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class WebForm5 : System.Web.UI.Page
    {
        private string cadenaConexion = ConfigurationManager.ConnectionStrings["EmpresaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ValidarEstadoCaja();
                CrearEstructuraCarrito();
                CargarClientes();
                CargarProductos();
            }
        }

        // ==========================================
        // VALIDACIÓN DE ESTADO DE CAJA
        // ==========================================
        private bool ValidarEstadoCaja()
        {
            bool cajaAbierta = false;

            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                // Verifica si hay un registro de apertura activo para hoy
                // (Modifica 'Caja' y 'Estado' si en tu BD tienen nombres diferentes)
                string query = "SELECT COUNT(*) FROM Caja WHERE Estado = 'Abierta' AND CAST(FechaApertura AS DATE) = CAST(GETDATE() AS DATE)";
                SqlCommand cmd = new SqlCommand(query, con);

                try
                {
                    con.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    cajaAbierta = (count > 0);
                }
                catch
                {
                    cajaAbierta = false;
                }
            }

            // Mostrar/ocultar alerta y habilitar/deshabilitar botones
            pnlCajaCerrada.Visible = !cajaAbierta;
            btnAgregarCarrito.Enabled = cajaAbierta;
            btnProcesarVenta.Enabled = cajaAbierta;

            return cajaAbierta;
        }

        // ==========================================
        // CÓDIGO DE LÓGICA DE CARRITO Y DATOS
        // ==========================================
        private void CrearEstructuraCarrito()
        {
            if (Session["Carrito"] == null)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("ID", typeof(int));
                dt.Columns.Add("Nombre", typeof(string));
                dt.Columns.Add("Cantidad", typeof(int));
                dt.Columns.Add("Precio", typeof(decimal));
                dt.Columns.Add("Total", typeof(decimal));
                dt.Columns.Add("ImagenUrl", typeof(string));

                Session["Carrito"] = dt;
            }
        }

        private void CargarClientes()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = "SELECT IdCliente, Nombre FROM Clientes";
                SqlCommand cmd = new SqlCommand(query, con);
                try
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    ddlClientes.DataSource = dr;
                    ddlClientes.DataTextField = "Nombre";
                    ddlClientes.DataValueField = "IdCliente";
                    ddlClientes.DataBind();
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar clientes: " + ex.Message, "danger");
                }
            }
            ddlClientes.Items.Insert(0, new ListItem("-- Consumidor Final --", "0"));
        }

        private void CargarProductos()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = "SELECT IdProducto, Nombre FROM Productos WHERE Stock > 0";
                SqlCommand cmd = new SqlCommand(query, con);
                try
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    ddlProductos.DataSource = dr;
                    ddlProductos.DataTextField = "Nombre";
                    ddlProductos.DataValueField = "IdProducto";
                    ddlProductos.DataBind();
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar productos: " + ex.Message, "danger");
                }
            }
            ddlProductos.Items.Insert(0, new ListItem("-- Seleccione un producto --", "0"));
        }

        protected void ddlProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idProd = Convert.ToInt32(ddlProductos.SelectedValue);
            if (idProd > 0)
            {
                using (SqlConnection con = new SqlConnection(cadenaConexion))
                {
                    string query = "SELECT Nombre, Precio, Stock, ImagenUrl FROM Productos WHERE IdProducto = @Id";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Id", idProd);
                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();
                        if (dr.Read())
                        {
                            lblNombrePreview.InnerText = dr["Nombre"].ToString();
                            lblStockPreview.InnerText = "Stock disponible: " + dr["Stock"].ToString();
                            txtPrecioUnitario.Text = Convert.ToDecimal(dr["Precio"]).ToString("N2");

                            string img = dr["ImagenUrl"].ToString();
                            imgProductoPreview.ImageUrl = string.IsNullOrEmpty(img) ? "uploads/default.png" : img;
                        }
                    }
                    catch (Exception ex)
                    {
                        MostrarMensaje("Error al obtener detalle del producto: " + ex.Message, "danger");
                    }
                }
            }
            else
            {
                lblNombrePreview.InnerText = "Selecciona un producto";
                lblStockPreview.InnerText = "Stock disponible: -";
                txtPrecioUnitario.Text = "0.00";
                imgProductoPreview.ImageUrl = "uploads/default.png";
            }
        }

        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            if (!ValidarEstadoCaja())
            {
                MostrarMensaje("No se pueden agregar productos porque la caja no está abierta.", "danger");
                return;
            }

            int idProd = Convert.ToInt32(ddlProductos.SelectedValue);
            if (idProd == 0)
            {
                MostrarMensaje("Por favor, selecciona un producto.", "warning");
                return;
            }

            int cantidad = 0;
            if (!int.TryParse(txtCantidad.Text, out cantidad) || cantidad <= 0)
            {
                MostrarMensaje("Ingresa una cantidad válida mayor a cero.", "warning");
                return;
            }

            decimal precio = Convert.ToDecimal(txtPrecioUnitario.Text);
            decimal totalLinea = cantidad * precio;

            DataTable dt = (DataTable)Session["Carrito"];
            DataRow row = dt.NewRow();
            row["ID"] = idProd;
            row["Nombre"] = lblNombrePreview.InnerText;
            row["Cantidad"] = cantidad;
            row["Precio"] = precio;
            row["Total"] = totalLinea;
            row["ImagenUrl"] = imgProductoPreview.ImageUrl;

            dt.Rows.Add(row);
            Session["Carrito"] = dt;

            ActualizarDetalle();
            MostrarMensaje("Producto agregado al carrito.", "success");
        }

        private void ActualizarDetalle()
        {
            DataTable dt = (DataTable)Session["Carrito"];
            gvDetalleVenta.DataSource = dt;
            gvDetalleVenta.DataBind();

            decimal subtotal = 0;
            foreach (DataRow row in dt.Rows)
            {
                subtotal += Convert.ToDecimal(row["Total"]);
            }

            decimal isv = subtotal * 0.15m;
            decimal totalPagar = subtotal + isv;

            lblSubtotal.Text = string.Format("L. {0:N2}", subtotal);
            lblISV.Text = string.Format("L. {0:N2}", isv);
            lblTotal.Text = string.Format("L. {0:N2}", totalPagar);
        }

        protected void gvDetalleVenta_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Quitar")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                DataTable dt = (DataTable)Session["Carrito"];
                dt.Rows.RemoveAt(index);
                Session["Carrito"] = dt;
                ActualizarDetalle();
            }
        }

        protected void btnProcesarVenta_Click(object sender, EventArgs e)
        {
            // Validar de nuevo si la caja está iniciada
            if (!ValidarEstadoCaja())
            {
                MostrarMensaje("No se puede procesar la venta porque la caja está cerrada.", "danger");
                return;
            }

            DataTable dt = (DataTable)Session["Carrito"];
            if (dt == null || dt.Rows.Count == 0)
            {
                MostrarMensaje("El carrito de compras está vacío.", "warning");
                return;
            }

            int idCliente = Convert.ToInt32(ddlClientes.SelectedValue);
            if (idCliente == 0)
            {
                idCliente = 1; // ID 1 asignado a Consumidor Final
            }

            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                con.Open();
                SqlTransaction trans = con.BeginTransaction();

                try
                {
                    decimal subtotalVenta = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        subtotalVenta += Convert.ToDecimal(row["Total"]);
                    }
                    decimal isv = subtotalVenta * 0.15m;
                    decimal totalPagar = subtotalVenta + isv;

                    string queryVenta = "INSERT INTO Ventas (IdCliente, Fecha, Total) VALUES (@IdCliente, GETDATE(), @Total); SELECT SCOPE_IDENTITY();";
                    SqlCommand cmdVenta = new SqlCommand(queryVenta, con, trans);
                    cmdVenta.Parameters.AddWithValue("@IdCliente", idCliente);
                    cmdVenta.Parameters.AddWithValue("@Total", totalPagar);

                    int idVenta = Convert.ToInt32(cmdVenta.ExecuteScalar());

                    foreach (DataRow row in dt.Rows)
                    {
                        int idProducto = Convert.ToInt32(row["ID"]);
                        int cantidad = Convert.ToInt32(row["Cantidad"]);
                        decimal precio = Convert.ToDecimal(row["Precio"]);
                        decimal subtotalLinea = Convert.ToDecimal(row["Total"]);

                        string queryDetalle = "INSERT INTO DetalleVenta (IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal) VALUES (@IdVenta, @IdProducto, @Cantidad, @PrecioUnitario, @Subtotal)";
                        SqlCommand cmdDetalle = new SqlCommand(queryDetalle, con, trans);
                        cmdDetalle.Parameters.AddWithValue("@IdVenta", idVenta);
                        cmdDetalle.Parameters.AddWithValue("@IdProducto", idProducto);
                        cmdDetalle.Parameters.AddWithValue("@Cantidad", cantidad);
                        cmdDetalle.Parameters.AddWithValue("@PrecioUnitario", precio);
                        cmdDetalle.Parameters.AddWithValue("@Subtotal", subtotalLinea);
                        cmdDetalle.ExecuteNonQuery();

                        string queryStock = "UPDATE Productos SET Stock = Stock - @Cantidad WHERE IdProducto = @IdProducto";
                        SqlCommand cmdStock = new SqlCommand(queryStock, con, trans);
                        cmdStock.Parameters.AddWithValue("@Cantidad", cantidad);
                        cmdStock.Parameters.AddWithValue("@IdProducto", idProducto);
                        cmdStock.ExecuteNonQuery();
                    }

                    trans.Commit();

                    rptFacturaImpresion.DataSource = dt;
                    rptFacturaImpresion.DataBind();
                    lblFacturaSubtotal.Text = string.Format("L. {0:N2}", subtotalVenta);
                    lblFacturaISV.Text = string.Format("L. {0:N2}", isv);
                    lblFacturaTotal.Text = string.Format("L. {0:N2}", totalPagar);

                    Session["Carrito"] = null;
                    CrearEstructuraCarrito();
                    ActualizarDetalle();
                    CargarProductos();

                    ScriptManager.RegisterStartupScript(this, GetType(), "ImprimirFactura", "abrirEImprimirFactura();", true);
                    MostrarMensaje("Venta procesada y factura emitida con éxito.", "success");
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    MostrarMensaje("Error al procesar la venta: " + ex.Message, "danger");
                }
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            lblMensaje.Text = string.Format("<div class='alert alert-{0} alert-dismissible fade show' role='alert'>" +
                                            "{1}" +
                                            "<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>" +
                                            "</div>", tipo, mensaje);
        }

        protected void btnVolverInicio_Click(object sender, EventArgs e)
        {
            Response.Redirect("Webform2.aspx");
        }
    }
}
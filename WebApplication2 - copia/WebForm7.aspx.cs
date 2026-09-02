using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication2
{
    public partial class WebForm7 : Page
    {
        private readonly string cadenaConexion = ConfigurationManager.ConnectionStrings["EmpresaDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Usuario"] != null)
                {
                    lblUsuario.Text = Session["Usuario"].ToString();
                    CargarEstadoCaja();
                    CargarHistoricoCajas();
                }

                else
                {
                    Response.Redirect("WebForm1.aspx");
                }
                string rol = Session["Rol"] != null ? Session["Rol"].ToString() : "";
                if (rol.Equals("Vendedor", StringComparison.OrdinalIgnoreCase))
                {
                    // Ocultar opciones de la barra de navegación
                    navReportes.Visible = false;
                    navProveedores.Visible = false;
                }
            }
        }

        private void CargarEstadoCaja()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = @"SELECT TOP 1 IdCaja, MontoInicial, VentasTotales, Movimientos, SaldoFinal, Estado 
                                 FROM Caja ORDER BY IdCaja DESC";

                SqlCommand cmd = new SqlCommand(query, con);

                try
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        int idCaja = Convert.ToInt32(dr["IdCaja"]);
                        string estado = dr["Estado"].ToString();
                        decimal inicial = Convert.ToDecimal(dr["MontoInicial"]);
                        decimal ventas = dr["VentasTotales"] != DBNull.Value ? Convert.ToDecimal(dr["VentasTotales"]) : 0;
                        decimal movimientos = dr["Movimientos"] != DBNull.Value ? Convert.ToDecimal(dr["Movimientos"]) : 0;
                        decimal saldoCalculado = inicial + ventas + movimientos;

                        lblMontoInicial.Text = "L. " + inicial.ToString("N2");
                        lblVentasCaja.Text = "L. " + ventas.ToString("N2");
                        lblMovimientosCaja.Text = "L. " + movimientos.ToString("N2");
                        lblSaldoCalculado.Text = "L. " + saldoCalculado.ToString("N2");

                        if (estado == "ABIERTA")
                        {
                            lblEstadoBadge.Text = "ABIERTA";
                            lblEstadoBadge.CssClass = "badge bg-success";
                            btnAbrirCaja.Enabled = false;
                            btnCerrarCaja.Enabled = true;
                            btnRegistrarMovimiento.Enabled = true;
                            CargarMovimientosActuales(idCaja);
                        }
                        else
                        {
                            lblEstadoBadge.Text = "CERRADA";
                            lblEstadoBadge.CssClass = "badge bg-danger";
                            btnAbrirCaja.Enabled = true;
                            btnCerrarCaja.Enabled = false;
                            btnRegistrarMovimiento.Enabled = false;
                            gvMovimientos.DataSource = null;
                            gvMovimientos.DataBind();
                        }
                    }
                    else
                    {
                        lblEstadoBadge.Text = "CERRADA";
                        lblEstadoBadge.CssClass = "badge bg-danger";
                        btnAbrirCaja.Enabled = true;
                        btnCerrarCaja.Enabled = false;
                        btnRegistrarMovimiento.Enabled = false;
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al consultar la caja: " + ex.Message, false);
                }
            }
        }

        private void CargarMovimientosActuales(int idCaja)
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = "SELECT Fecha, Tipo, Concepto, Monto, Usuario FROM CajaMovimientos WHERE IdCaja = @IdCaja ORDER BY IdMovimiento DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@IdCaja", idCaja);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMovimientos.DataSource = dt;
                gvMovimientos.DataBind();
            }
        }

        private void CargarHistoricoCajas()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                string query = @"SELECT IdCaja, Usuario, FechaApertura, FechaCierre, MontoInicial, VentasTotales, 
                                 Movimientos, SaldoFinal, ISNULL(MontoArqueo, 0) AS MontoArqueo, 
                                 ISNULL(Diferencia, 0) AS Diferencia, Estado 
                                 FROM Caja ORDER BY IdCaja DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvHistoricoCaja.DataSource = dt;
                gvHistoricoCaja.DataBind();
            }
        }

        protected void btnAbrirCaja_Click(object sender, EventArgs e)
        {
            if (decimal.TryParse(txtMontoApertura.Text, out decimal montoInicial) && montoInicial >= 0)
            {
                using (SqlConnection con = new SqlConnection(cadenaConexion))
                {
                    string query = @"INSERT INTO Caja (MontoInicial, VentasTotales, Movimientos, SaldoFinal, FechaApertura, Estado, Usuario)
                                     VALUES (@MontoInicial, 0, 0, @MontoInicial, GETDATE(), 'ABIERTA', @Usuario)";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@MontoInicial", montoInicial);
                    cmd.Parameters.AddWithValue("@Usuario", lblUsuario.Text);

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                        MostrarMensaje("Turno de caja abierto exitosamente con L. " + montoInicial.ToString("N2"), true);
                        txtMontoApertura.Text = "";
                        CargarEstadoCaja();
                        CargarHistoricoCajas();
                    }
                    catch (Exception ex)
                    {
                        MostrarMensaje("Error al abrir la caja: " + ex.Message, false);
                    }
                }
            }
            else
            {
                MostrarMensaje("Ingrese un monto inicial de apertura válido.", false);
            }
        }

        protected void btnCerrarCaja_Click(object sender, EventArgs e)
        {
            if (decimal.TryParse(txtArqueoCierre.Text, out decimal arqueo) && arqueo >= 0)
            {
                using (SqlConnection con = new SqlConnection(cadenaConexion))
                {
                    // Obtenemos el saldo esperado
                    string qCalculo = @"SELECT TOP 1 IdCaja, (MontoInicial + ISNULL(VentasTotales,0) + ISNULL(Movimientos,0)) AS SaldoEsperado 
                                        FROM Caja WHERE Estado = 'ABIERTA' ORDER BY IdCaja DESC";

                    SqlCommand cmdCalc = new SqlCommand(qCalculo, con);

                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmdCalc.ExecuteReader();

                        if (dr.Read())
                        {
                            int idCaja = Convert.ToInt32(dr["IdCaja"]);
                            decimal saldoEsperado = Convert.ToDecimal(dr["SaldoEsperado"]);
                            decimal diferencia = arqueo - saldoEsperado;

                            dr.Close();

                            string qUpdate = @"UPDATE Caja 
                                               SET Estado = 'CERRADA', FechaCierre = GETDATE(), 
                                                   MontoArqueo = @Arqueo, Diferencia = @Diferencia, SaldoFinal = @SaldoEsperado
                                               WHERE IdCaja = @IdCaja";

                            SqlCommand cmdUp = new SqlCommand(qUpdate, con);
                            cmdUp.Parameters.AddWithValue("@Arqueo", arqueo);
                            cmdUp.Parameters.AddWithValue("@Diferencia", diferencia);
                            cmdUp.Parameters.AddWithValue("@SaldoEsperado", saldoEsperado);
                            cmdUp.Parameters.AddWithValue("@IdCaja", idCaja);

                            cmdUp.ExecuteNonQuery();

                            string msjDiferencia = diferencia == 0 ? "Cuadre perfecto sin diferencias." :
                                (diferencia > 0 ? "Sobrante de caja: L. " + diferencia.ToString("N2") : "Faltante de caja: L. " + Math.Abs(diferencia).ToString("N2"));

                            MostrarMensaje("Caja cerrada. Arqueo real: L. " + arqueo.ToString("N2") + ". " + msjDiferencia, true);
                            txtArqueoCierre.Text = "";
                            CargarEstadoCaja();
                            CargarHistoricoCajas();
                        }
                    }
                    catch (Exception ex)
                    {
                        MostrarMensaje("Error al realizar arqueo y cierre: " + ex.Message, false);
                    }
                }
            }
            else
            {
                MostrarMensaje("Ingrese el valor físico contado del arqueo para poder cerrar la caja.", false);
            }
        }

        protected void btnRegistrarMovimiento_Click(object sender, EventArgs e)
        {
            if (decimal.TryParse(txtMontoMovimiento.Text, out decimal monto) && monto > 0 && !string.IsNullOrWhiteSpace(txtConcepto.Text))
            {
                decimal valorFinal = ddlTipoMovimiento.SelectedValue == "EGRESO" ? -monto : monto;

                using (SqlConnection con = new SqlConnection(cadenaConexion))
                {
                    con.Open();
                    SqlTransaction trans = con.BeginTransaction();

                    try
                    {
                        // 1. Obtener ID de caja abierta
                        string qCaja = "SELECT TOP 1 IdCaja FROM Caja WHERE Estado = 'ABIERTA' ORDER BY IdCaja DESC";
                        SqlCommand cmdCaja = new SqlCommand(qCaja, con, trans);
                        object res = cmdCaja.ExecuteScalar();

                        if (res != null)
                        {
                            int idCaja = Convert.ToInt32(res);

                            // 2. Insertar movimiento detallado
                            string qMov = @"INSERT INTO CajaMovimientos (IdCaja, Tipo, Concepto, Monto, Fecha, Usuario)
                                            VALUES (@IdCaja, @Tipo, @Concepto, @Monto, GETDATE(), @Usuario)";
                            SqlCommand cmdMov = new SqlCommand(qMov, con, trans);
                            cmdMov.Parameters.AddWithValue("@IdCaja", idCaja);
                            cmdMov.Parameters.AddWithValue("@Tipo", ddlTipoMovimiento.SelectedValue);
                            cmdMov.Parameters.AddWithValue("@Concepto", txtConcepto.Text.Trim());
                            cmdMov.Parameters.AddWithValue("@Monto", monto);
                            cmdMov.Parameters.AddWithValue("@Usuario", lblUsuario.Text);
                            cmdMov.ExecuteNonQuery();

                            // 3. Actualizar totales de caja
                            string qUp = @"UPDATE Caja 
                                           SET Movimientos = ISNULL(Movimientos, 0) + @Valor,
                                               SaldoFinal = MontoInicial + ISNULL(VentasTotales, 0) + (ISNULL(Movimientos, 0) + @Valor)
                                           WHERE IdCaja = @IdCaja";
                            SqlCommand cmdUp = new SqlCommand(qUp, con, trans);
                            cmdUp.Parameters.AddWithValue("@Valor", valorFinal);
                            cmdUp.Parameters.AddWithValue("@IdCaja", idCaja);
                            cmdUp.ExecuteNonQuery();

                            trans.Commit();

                            MostrarMensaje("Movimiento de " + ddlTipoMovimiento.SelectedValue + " registrado con éxito.", true);
                            txtMontoMovimiento.Text = "";
                            txtConcepto.Text = "";
                            CargarEstadoCaja();
                            CargarHistoricoCajas();
                        }
                        else
                        {
                            trans.Rollback();
                            MostrarMensaje("Debe abrir la caja antes de registrar movimientos.", false);
                        }
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        MostrarMensaje("Error en transacción: " + ex.Message, false);
                    }
                }
            }
            else
            {
                MostrarMensaje("Debe proporcionar un monto válido y una justificación/concepto.", false);
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("WebForm1.aspx");
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = esExito ? "alert alert-success d-block fw-semibold mb-3" : "alert alert-danger d-block fw-semibold mb-3";
        }
        protected void txtMontoMovimiento_TextChanged(object sender, EventArgs e)
        {
            // Tu código aquí
        }

        protected void gvHistoricoCaja_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
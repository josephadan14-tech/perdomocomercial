using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace WebApplication2
{
    public partial class WebForm6 : Page
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

                CargarEstadisticasEfectivo();
                CargarTablaFacturas();
                GenerarGraficoVentas();
            }
        }

        private void CargarEstadisticasEfectivo()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        ISNULL(SUM(Total), 0) AS TotalEfectivo,
                        COUNT(IdVenta) AS TotalVentas,
                        ISNULL(AVG(Total), 0) AS PromedioVenta
                    FROM Ventas", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    decimal totalEfectivo = Convert.ToDecimal(dr["TotalEfectivo"]);
                    int totalVentas = Convert.ToInt32(dr["TotalVentas"]);
                    decimal promedio = Convert.ToDecimal(dr["PromedioVenta"]);

                    lblTotalEfectivo.InnerText = "L. " + totalEfectivo.ToString("N2");
                    lblCantidadVentas.InnerText = totalVentas.ToString();
                    lblPromedioVenta.InnerText = "L. " + promedio.ToString("N2");
                }
            }
        }

        private void CargarTablaFacturas()
        {
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        V.IdVenta, 
                        C.Nombre AS Cliente, 
                        V.Fecha, 
                        V.Total 
                    FROM Ventas V
                    INNER JOIN Clientes C ON V.IdCliente = C.IdCliente
                    ORDER BY V.Fecha DESC", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvVentas.DataSource = dt;
                gvVentas.DataBind();
            }
        }

        private void GenerarGraficoVentas()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(cadenaConexion))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 7
                        CONVERT(VARCHAR(10), Fecha, 103) AS FechaCorta,
                        SUM(Total) AS TotalDia
                    FROM Ventas
                    GROUP BY CONVERT(VARCHAR(10), Fecha, 103), CAST(Fecha AS DATE)
                    ORDER BY CAST(Fecha AS DATE) ASC", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            StringBuilder labels = new StringBuilder();
            StringBuilder data = new StringBuilder();

            foreach (DataRow row in dt.Rows)
            {
                labels.Append("'" + row["FechaCorta"].ToString() + "',");
                data.Append(row["TotalDia"].ToString().Replace(",", ".") + ",");
            }

            string chartScript = $@"
            <script>
                document.addEventListener('DOMContentLoaded', function() {{
                    const ctx = document.getElementById('ventasChart').getContext('2d');
                    new Chart(ctx, {{
                        type: 'bar',
                        data: {{
                            labels: [{labels.ToString().TrimEnd(',')}],
                            datasets: [{{
                                label: 'Efectivo Generado (L.)',
                                data: [{data.ToString().TrimEnd(',')}],
                                backgroundColor: '#133a68',
                                borderColor: '#0b2545',
                                borderWidth: 1,
                                borderRadius: 6
                            }}]
                        }},
                        options: {{
                            responsive: true,
                            plugins: {{
                                legend: {{ display: false }}
                            }},
                            scales: {{
                                y: {{ beginAtZero: true }}
                            }}
                        }}
                    }});
                }});
            </script>";

            litChartScript.Text = chartScript;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("WebForm1.aspx");
        }

    }
}
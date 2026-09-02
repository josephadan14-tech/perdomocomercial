using System;
using System.Web.UI;

namespace WebApplication2
{
    public partial class WebForm1 : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string usuario = txtUsuario.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (usuario == "admin" && password == "admin123")
            {
                Session["Usuario"] = usuario;
                Session["Rol"] = "Admin";
                Response.Redirect("WebForm2.aspx");
            }
            else if (usuario == "vendedor1" && password == "vend123")
            {
                Session["Usuario"] = usuario;
                Session["Rol"] = "Vendedor";
                Response.Redirect("WebForm2.aspx");
            }
            else
            {
                MostrarAlerta("Acceso Denegado", "El usuario o la contraseña son incorrectos.", "error");
            }
        }

        private void MostrarAlerta(string titulo, string mensaje, string tipo)
        {
            string script = $@"
                Swal.fire({{
                    icon: '{tipo}',
                    title: '{titulo}',
                    text: '{mensaje}',
                    confirmButtonColor: '#d97706',
                    background: '#f8fafc'
                }});";

            ClientScript.RegisterStartupScript(this.GetType(), "AlertaSweetAlert", script, true);
        }
    }
}
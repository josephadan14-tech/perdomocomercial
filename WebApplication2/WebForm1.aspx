<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication2.WebForm1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Acceso al Sistema - Comercial Perdomo</title>
    
    <!-- Bootstrap 5 CSS & FontAwesome Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <!-- SweetAlert2 CSS & JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-card {
            background-color: #f8fafc;
            border: 1px solid #334155;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.4), 0 8px 10px -6px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .card-header-custom {
            background-color: #1e293b;
            border-bottom: 3px solid #d97706;
            padding: 1.5rem 1.5rem;
        }

        .login-logo {
            max-width: 220px;
            height: auto;
            border-radius: 8px;
            background-color: #ffffff;
            padding: 6px 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.2);
        }

        .form-control-custom {
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            color: #334155;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.2s ease-in-out;
        }

        .form-control-custom:focus {
            border-color: #d97706;
            box-shadow: 0 0 0 0.25rem rgba(217, 119, 6, 0.2);
            background-color: #ffffff;
        }

        .input-group-text-custom {
            background-color: #f1f5f9;
            border: 1px solid #cbd5e1;
            border-right: none;
            color: #64748b;
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        .btn-custom {
            background-color: #d97706;
            color: #ffffff;
            font-weight: 600;
            letter-spacing: 0.5px;
            padding: 0.75rem;
            border: none;
            border-radius: 8px;
            transition: background-color 0.2s ease-in-out;
        }

        .btn-custom:hover {
            background-color: #b45309;
            color: #ffffff;
        }

        .card-footer-custom {
            background-color: #f1f5f9;
            border-top: 1px solid #e2e8f0;
            padding: 1rem;
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center p-3">

    <form id="form1" runat="server" class="w-100" style="max-width: 420px;">
        <div class="card login-card">
            
            <!-- Encabezado con el Logo de Comercial Perdomo -->
            <div class="card-header-custom text-center">
                <div class="mb-3">
                    <img src="img/logo.jpg" alt="Comercial Perdomo" class="login-logo" />
                </div>
                <h5 class="fw-bold text-white mb-1">Acceso al Sistema</h5>
                <p class="small mb-0" style="color: #94a3b8;">Ingrese sus credenciales corporativas</p>
            </div>

            <!-- Cuerpo del Formulario -->
            <div class="card-body p-4">
                
                <!-- Usuario -->
                <div class="mb-3">
                    <asp:Label ID="lblUsuario" runat="server" Text="Usuario" CssClass="form-label fw-semibold text-secondary small"></asp:Label>
                    <div class="input-group">
                        <span class="input-group-text input-group-text-custom"><i class="fa-solid fa-user"></i></span>
                        <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control form-control-custom" placeholder="Ej. admin"></asp:TextBox>
                    </div>
                </div>

                <!-- Contraseña -->
                <div class="mb-4">
                    <asp:Label ID="lblPassword" runat="server" Text="Contraseña" CssClass="form-label fw-semibold text-secondary small"></asp:Label>
                    <div class="input-group">
                        <span class="input-group-text input-group-text-custom"><i class="fa-solid fa-lock"></i></span>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control form-control-custom" placeholder="••••••••"></asp:TextBox>
                    </div>
                </div>

                <!-- Botón de Ingreso -->
                <div class="d-grid mb-2">
                    <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="btn btn-custom shadow-sm" 
                        OnClientClick="return validarCampos();" OnClick="btnLogin_Click" />
                </div>

            </div>

            <!-- Pie de la Tarjeta -->
            <div class="card-footer-custom text-center">
                <span class="text-muted extra-small" style="font-size: 0.8rem; color: #64748b;">
                    <i class="fa-solid fa-circle-info me-1"></i> Módulo de Gestión Interna v2.0
                </span>
            </div>

        </div>
    </form>

    <!-- Script de Validación en JavaScript Puro -->
    <script type="text/javascript">
        function validarCampos() {
            var txtUser = document.getElementById('<%= txtUsuario.ClientID %>');
            var txtPass = document.getElementById('<%= txtPassword.ClientID %>');

            var usuario = txtUser ? txtUser.value.trim() : "";
            var password = txtPass ? txtPass.value.trim() : "";

            if (usuario === "" || password === "") {
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Campos Incompletos',
                        text: 'Por favor, ingrese tanto el usuario como la contraseña.',
                        confirmButtonColor: '#d97706',
                        background: '#f8fafc'
                    });
                } else {
                    alert('Por favor, ingrese tanto el usuario como la contraseña.');
                }
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
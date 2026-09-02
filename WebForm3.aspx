<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm3.aspx.cs" Inherits="WebApplication2.WebForm3" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestión de Clientes - Comercial Perdomo</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body { background-color: #f1f5f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .navbar-custom { background-color: #1e293b; border-bottom: 3px solid #d97706; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); background-color: #ffffff; }
        .card-header-custom { background-color: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 1.25rem 1.5rem; border-top-left-radius: 12px !important; border-top-right-radius: 12px !important; }
        .btn-custom { background-color: #d97706; color: #ffffff; font-weight: 600; border: none; border-radius: 8px; transition: all 0.2s ease-in-out; }
        .btn-custom:hover { background-color: #b45309; color: #ffffff; transform: translateY(-1px); }
        .form-control:focus { border-color: #d97706; box-shadow: 0 0 0 0.2rem rgba(217, 119, 6, 0.2); }
        .table-custom { margin-bottom: 0; }
        .table-custom th { background-color: #1e293b !important; color: #ffffff !important; font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; padding: 1rem; border: none; }
        .table-custom td { padding: 1rem; vertical-align: middle; color: #334155; font-size: 0.9rem; }
        .table-hover tbody tr:hover { background-color: #f8fafc; }
        .stat-card { border-radius: 12px; padding: 1.25rem; color: white; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .stat-bg-amber { background: linear-gradient(135deg, #d97706 0%, #b45309 100%); }
        .stat-bg-slate { background: linear-gradient(135deg, #334155 0%, #1e293b 100%); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- Campo oculto para almacenar el ID del cliente a editar -->
        <asp:HiddenField ID="hfIDCliente" runat="server" Value="0" />

        <!-- Navbar -->
        <nav class="navbar navbar-dark navbar-custom px-4 py-3 mb-4">
            <div class="container-fluid">
                <span class="navbar-brand fw-bold d-flex align-items-center gap-2">
                    <i class="fa-solid fa-users text-warning fs-4"></i>
                    <span>Módulo de Gestión de Clientes</span>
                </span>
                <a href="WebForm2.aspx" class="btn btn-outline-light btn-sm px-3 rounded-3">
                    <i class="fa-solid fa-arrow-left me-1"></i> Volver al Menú
                </a>
            </div>
        </nav>

        <div class="container-fluid px-4 mb-5">
            
            <!-- Stats -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card stat-bg-slate d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-uppercase small fw-semibold text-light opacity-75">Total Registrados</span>
                            <h3 class="fw-bold mb-0 mt-1">
                                <asp:Label ID="lblTotalClientes" runat="server" Text="0"></asp:Label>
                            </h3>
                        </div>
                        <i class="fa-solid fa-user-group fs-1 opacity-50"></i>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-bg-amber d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-uppercase small fw-semibold text-light opacity-75">Estado BD</span>
                            <h3 class="fw-bold mb-0 mt-1" style="font-size: 1.3rem;">Activa / SQL</h3>
                        </div>
                        <i class="fa-solid fa-database fs-1 opacity-50"></i>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                
                <!-- Formulario -->
                <div class="col-lg-4">
                    <div class="card card-custom">
                        <div class="card-header-custom d-flex align-items-center gap-2">
                            <i class="fa-solid fa-user-pen text-warning fs-5"></i>
                            <h5 class="fw-bold mb-0 text-dark">
                                <asp:Label ID="lblTituloFormulario" runat="server" Text="Registrar Cliente"></asp:Label>
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-secondary">Nombre Completo *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-user"></i></span>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej. Juan Pérez"></asp:TextBox>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-secondary">Teléfono</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-phone"></i></span>
                                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="+504 9999-9999"></asp:TextBox>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-secondary">Correo Electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-envelope"></i></span>
                                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" placeholder="cliente@correo.com"></asp:TextBox>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-secondary">Dirección</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-location-dot"></i></span>
                                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Barrio, Colonia, Ciudad..."></asp:TextBox>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Cliente" CssClass="btn btn-custom flex-grow-1 py-2 shadow-sm" OnClick="btnGuardar_Click" />
                                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary py-2" OnClick="btnLimpiar_Click" CausesValidation="false" />
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Tabla (GridView) -->
                <div class="col-lg-8">
                    <div class="card card-custom">
                        
                        <div class="card-header-custom d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div class="d-flex align-items-center gap-2">
                                <i class="fa-solid fa-address-book text-warning fs-5"></i>
                                <h5 class="fw-bold mb-0 text-dark">Directorio de Clientes</h5>
                            </div>

                            <div class="input-group" style="max-width: 300px;">
                                <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                                <input type="text" id="txtBuscador" class="form-control form-control-sm" placeholder="Buscar cliente..." onkeyup="filtrarTabla()" />
                            </div>
                        </div>

                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <asp:GridView ID="gvClientes" runat="server" CssClass="table table-custom table-hover border-0 align-middle" 
                                    AutoGenerateColumns="False" EmptyDataText="No hay clientes registrados en el sistema." OnRowCommand="gvClientes_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="IDCliente" HeaderText="ID" ItemStyle-CssClass="fw-bold text-center" ItemStyle-Width="60px" />
                                        
                                        <asp:TemplateField HeaderText="Cliente">
                                            <ItemTemplate>
                                                <div class="fw-bold text-dark"><%# Eval("Nombre") %></div>
                                                <small class="text-muted"><i class="fa-solid fa-location-dot me-1"></i><%# string.IsNullOrEmpty(Eval("Direccion").ToString()) ? "Sin dirección" : Eval("Direccion") %></small>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Contacto">
                                            <ItemTemplate>
                                                <div><i class="fa-solid fa-phone text-secondary me-1"></i><%# Eval("Telefono") %></div>
                                                <div class="small text-muted"><i class="fa-solid fa-envelope text-secondary me-1"></i><%# Eval("Correo") %></div>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Acciones" ItemStyle-CssClass="text-center" ItemStyle-Width="120px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditar" runat="server" CssClass="btn btn-sm btn-outline-primary border-0 rounded-circle me-1" 
                                                    CommandName="Editar" CommandArgument='<%# Eval("IDCliente") %>' ToolTip="Editar Cliente">
                                                    <i class="fa-solid fa-pen-to-square fs-6"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btn btn-sm btn-outline-danger border-0 rounded-circle" 
                                                    CommandName="Eliminar" CommandArgument='<%# Eval("IDCliente") %>' ToolTip="Eliminar Cliente"
                                                    OnClientClick="return confirm('¿Está seguro de eliminar este cliente?');">
                                                    <i class="fa-solid fa-trash-can fs-6"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>

    </form>

    <script type="text/javascript">
        function filtrarTabla() {
            var input = document.getElementById("txtBuscador");
            if (!input) return;

            var val = (input as HTMLInputElement).value || '';
            var filter = val.toLowerCase();
            
            var grid = document.getElementById("<%= gvClientes.ClientID %>");
            if (!grid) return;

            var rows = grid.getElementsByTagName("tr");

            for (var i = 1; i < rows.length; i++) {
                var fila = rows[i];
                var textoFila = fila.textContent || fila.innerText || "";
                
                if (textoFila.toLowerCase().indexOf(filter) > -1) {
                    fila.style.display = "";
                } else {
                    fila.style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
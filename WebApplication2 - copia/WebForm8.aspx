<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm8.aspx.cs" Inherits="WebApplication2.WebForm8" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Proveedores - Comercial Perdomo</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        :root {
            --sidebar-width: 270px;
            --brand-navy: #0b2545;
            --brand-navy-light: #133a68;
            --brand-gold: #d4af37;
            --bg-body: #f8fafc;
            --card-border: #e2e8f0;
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            color: #334155;
            overflow-x: hidden;
        }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: var(--brand-navy);
            color: #ffffff;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-brand {
            padding: 1.5rem 1rem;
            background-color: #ffffff;
            border-bottom: 3px solid var(--brand-gold);
            display: flex;
            justify-content: center;
        }

        .sidebar-brand img { max-height: 600px; object-fit: contain; width: auto; }

        .sidebar-menu {
            list-style: none;
            padding: 1.5rem 0;
            margin: 0;
            flex-grow: 1;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 0.9rem 1.5rem;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            border-left: 4px solid transparent;
            transition: all 0.2s ease;
        }

        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            color: #ffffff;
            background-color: var(--brand-navy-light);
            border-left-color: var(--brand-gold);
        }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 2rem;
        }

        .top-navbar {
            background-color: #ffffff;
            border-radius: 14px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--card-border);
        }

        .card-custom {
            border: 1px solid var(--card-border);
            border-radius: 14px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
        }

        .form-control:focus {
            border-color: var(--brand-navy-light);
            box-shadow: 0 0 0 0.25rem rgba(19, 58, 104, 0.15);
        }

        .table-custom th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            border-bottom: 2px solid var(--card-border);
        }

        .table-custom td { vertical-align: middle; font-size: 0.9rem; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfIdProveedor" runat="server" Value="0" />

        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="sidebar-brand">
                <a href="WebForm2.aspx">
                    <asp:Image ID="imgLogo" runat="server" ImageUrl="~/img/logo.jpg" AlternateText="Comercial Perdomo" CssClass="img-fluid" />
                </a>
            </div>
            
            <ul class="sidebar-menu">
                <li><a href="WebForm2.aspx"><i class="fa-solid fa-chart-pie"></i><span>Panel Principal</span></a></li>
                <li><a href="WebForm3.aspx"><i class="fa-solid fa-users"></i><span>Clientes</span></a></li>
                <li><a href="WebForm8.aspx" class="active"><i class="fa-solid fa-truck-field"></i><span>Proveedores</span></a></li>
                <li><a href="WebForm4.aspx"><i class="fa-solid fa-boxes-stacked"></i><span>Inventario</span></a></li>
                <li><a href="WebForm5.aspx"><i class="fa-solid fa-cart-shopping"></i><span>Ventas</span></a></li>
                <li><a href="WebForm7.aspx"><i class="fa-solid fa-vault"></i><span>Control de Caja</span></a></li>
                <li><a href="WebForm6.aspx"><i class="fa-solid fa-chart-line"></i><span>Reportes</span></a></li>
            </ul>

            <div class="p-3 border-top border-secondary">
                <asp:LinkButton ID="btnCerrarSesion" runat="server" CssClass="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 rounded-3" OnClick="btnCerrarSesion_Click">
                    <i class="fa-solid fa-right-from-bracket"></i><span>Cerrar Sesión</span>
                </asp:LinkButton>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <div class="top-navbar">
                <div>
                    <h5 class="fw-bold mb-0 text-dark"><i class="fa-solid fa-truck-field text-primary me-2"></i>Gestión de Proveedores</h5>
                    <small class="text-muted">Administración y catálogo de suplidores comerciales</small>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill">
                        <i class="fa-solid fa-user me-1"></i>
                        <asp:Label ID="lblUsuario" runat="server" Text="Usuario"></asp:Label>
                    </span>
                </div>
            </div>

            <!-- FORMULARIO REGISTRO/EDICIÓN -->
            <div class="card card-custom p-4 mb-4">
                <div class="d-flex align-items-center gap-2 mb-3 border-bottom pb-2">
                    <i class="fa-solid fa-building-circle-check text-primary fs-5"></i>
                    <h6 class="fw-bold mb-0 text-dark">Registrar / Modificar Proveedor</h6>
                </div>
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-secondary">Nombre de la Empresa / Marca *</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-building"></i></span>
                            <asp:TextBox ID="txtNombreEmpresa" runat="server" CssClass="form-control" placeholder="Ej: Distribuidora Central S.A."></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-secondary">Persona de Contacto / Asesor</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-user-tie"></i></span>
                            <asp:TextBox ID="txtContacto" runat="server" CssClass="form-control" placeholder="Nombre del representante"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-secondary">Teléfono de Contacto</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-phone"></i></span>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="0000-0000"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-secondary">Correo Electrónico</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-envelope"></i></span>
                            <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" placeholder="ventas@proveedor.com"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-secondary">Dirección Comercial</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted"><i class="fa-solid fa-location-dot"></i></span>
                            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="Ciudad, Dirección"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-12 text-end mt-4">
                        <asp:Button ID="btnLimpiar" runat="server" Text="Cancelar / Limpiar" CssClass="btn btn-outline-secondary px-4 me-2" OnClick="btnLimpiar_Click" />
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar Proveedor" CssClass="btn btn-primary px-4 fw-semibold" OnClick="btnGuardar_Click" />
                    </div>
                </div>
            </div>

            <!-- BUSCADOR Y TABLA -->
            <div class="card card-custom p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <h6 class="fw-bold mb-0 text-dark"><i class="fa-solid fa-list me-2 text-secondary"></i>Directorio de Suplidores</h6>
                    
                    <!-- CAMPO DE BÚSQUEDA -->
                    <div class="input-group" style="max-width: 350px;">
                        <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por empresa o contacto..."></asp:TextBox>
                        <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-primary" OnClick="btnBuscar_Click">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </asp:LinkButton>
                    </div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvProveedores" runat="server" CssClass="table table-hover align-middle table-custom" AutoGenerateColumns="False" DataKeyNames="IdProveedor" OnRowCommand="gvProveedores_RowCommand" EmptyDataText="No se encontraron proveedores.">
                        <Columns>
                            <asp:BoundField DataField="IdProveedor" HeaderText="ID" ItemStyle-Width="60px" ItemStyle-CssClass="fw-bold text-secondary" />
                            <asp:BoundField DataField="NombreEmpresa" HeaderText="Empresa / Proveedor" ItemStyle-CssClass="fw-semibold text-dark" />
                            <asp:BoundField DataField="Contacto" HeaderText="Contacto" />
                            <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                            <asp:BoundField DataField="Correo" HeaderText="Correo" />
                            <asp:BoundField DataField="Direccion" HeaderText="Dirección" />
                            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="120px" ItemStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("IdProveedor") %>' CssClass="btn btn-sm btn-outline-warning me-1" ToolTip="Editar">
                                        <i class="fa-solid fa-pen"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("IdProveedor") %>' CssClass="btn btn-sm btn-outline-danger" ToolTip="Eliminar" OnClientClick="return confirm('¿Está seguro de eliminar este proveedor?');">
                                        <i class="fa-solid fa-trash"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </main>
    </form>
</body>
</html>
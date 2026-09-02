<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm4.aspx.cs" Inherits="WebApplication2.WebForm4" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Inventario | Sistema de Gestión</title>
    
    <!-- Google Fonts & Bootstrap 5 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        :root {
            --sidebar-bg: #0a2240;          /* Azul marino oscuro de fondo */
            --sidebar-active-bg: #153966;  /* Azul más claro para la opción activa */
            --sidebar-hover: #112d52;      /* Hover sutil */
            --accent-yellow: #f1b418;      /* Amarillo oro para la barra divisoria y borde activo */
            --text-color: #d1d5db;
        }

        body {
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            background-color: #f8fafc;
            color: #334155;
            overflow-x: hidden;
            margin: 0;
            padding: 0;
        }

        /* LAYOUT PRINCIPAL */
        .app-container {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR / MENÚ LATERAL */
        .sidebar {
            width: 280px;
            background-color: var(--sidebar-bg);
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
        }

        /* SECCIÓN DEL LOGO (CONTENEDOR BLANCO CON BORDES REDONDEADOS) */
        .sidebar-brand-container {
            background-color: #ffffff;
            padding: 1.25rem 1rem;
            margin: 12px 12px 0 12px;
            border-radius: 8px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .sidebar-brand-container img {
            max-width: 100%;
            height: auto;
            object-fit: contain;
            display: block;
        }

        /* LÍNEA SEPARADORA AMARILLA */
        .yellow-divider {
            height: 4px;
            background-color: var(--accent-yellow);
            width: 100%;
            margin-top: 14px;
            margin-bottom: 0.5rem;
        }

        /* NAVEGACIÓN */
        .sidebar-nav {
            list-style: none;
            padding: 0;
            margin: 0;
            width: 100%;
        }

        .sidebar-item {
            width: 100%;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 16px 24px;
            color: #c2c9d6;
            text-decoration: none;
            font-size: 1.05rem;
            font-weight: 500;
            transition: all 0.2s ease;
            position: relative;
            border-left: 5px solid transparent;
        }

        .sidebar-link i {
            width: 32px;
            font-size: 1.25rem;
            margin-right: 14px;
            text-align: center;
            color: #d1d5db;
        }

        .sidebar-link:hover {
            color: #ffffff;
            background-color: var(--sidebar-hover);
        }

        /* ESTADO ACTIVO (IGUAL A LA IMAGEN) */
        .sidebar-link.active {
            color: #ffffff;
            background-color: var(--sidebar-active-bg);
            border-left-color: var(--accent-yellow);
            font-weight: 600;
        }

        .sidebar-link.active i {
            color: #ffffff;
        }

        /* CONTENIDO PRINCIPAL */
        .main-content {
            flex-grow: 1;
            padding: 2rem;
            background-color: #f8fafc;
            overflow-y: auto;
        }

        /* TARJETAS Y TABLA */
        .card-custom {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            background: #ffffff;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            padding: 0.55rem 0.85rem;
        }

        .table-custom thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            padding: 0.85rem 1rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .table-custom tbody td {
            padding: 0.85rem 1rem;
            vertical-align: middle;
        }

        .img-avatar {
            width: 45px;
            height: 45px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
        }

        .btn-action {
            width: 32px;
            height: 32px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <div class="app-container">
            <!-- MENÚ LATERAL (SIDEBAR) -->
            <aside class="sidebar">
                
                <!-- TARJETA BLANCA PARA EL LOGO -->
                <div class="sidebar-brand-container">
                    <!-- Reemplaza src con la ruta correcta de tu imagen de Comercial Perdomo -->
                    <img src="img/logo.jpg" runat="server" id="imgLogo" alt="Comercial Perdomo" />
                </div>

                <!-- BARRITA SEPARADORA AMARILLA -->
                <div class="yellow-divider"></div>

                <!-- NAVEGACIÓN -->
                <ul class="sidebar-nav">
                    <li class="sidebar-item">
                        <a href="WebForm2.aspx" class="sidebar-link active">
                            <i class="fa-solid fa-chart-pie"></i>
                            <span>Panel Principal</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="WebForm3.aspx" class="sidebar-link">
                            <i class="fa-solid fa-users"></i>
                            <span>Clientes</span>
                        </a>
                    </li>
                    <li id="navProveedores" runat="server" class="sidebar-item">
                        <a href="WebForm8.aspx" class="sidebar-link">
                            <i class="fa-solid fa-truck"></i>
                            <span>Proveedores</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="WebForm4.aspx" class="sidebar-link">
                            <i class="fa-solid fa-boxes-stacked"></i>
                            <span>Inventario</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="WebForm5.aspx" class="sidebar-link">
                            <i class="fa-solid fa-cart-shopping"></i>
                            <span>Ventas</span>
                        </a>
                    </li>
                    <li id="navReportes" runat="server" class="sidebar-item">
                        <a href="WebForm6.aspx" class="sidebar-link">
                            <i class="fa-solid fa-chart-line"></i>
                            <span>Reportes</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="WebForm7.aspx" class="sidebar-link">
                            <i class="fa-solid fa-cash-register"></i>
                            <span>Control de Caja</span>
                        </a>
                    </li>
                </ul>
            </aside>

            <!-- ÁREA DE TRABAJO PRINCIPAL -->
            <main class="main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold text-dark mb-1">Gestión de Inventario</h4>
                        <p class="text-muted small mb-0">Administración general de catálogo y control de productos.</p>
                    </div>
                </div>

                <asp:UpdatePanel ID="upInventario" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>

                        <!-- FORMULARIO DE REGISTRO / EDICIÓN -->
                        <div class="card card-custom p-4 mb-4">
                            <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-pen-to-square text-primary me-2"></i>Gestionar Producto</h6>
                            <asp:HiddenField ID="hfProductoID" runat="server" Value="0" />

                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label fw-medium small text-secondary">Nombre del Producto</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej. Juego de Comedor 6 Sillas" Required="true"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-medium small text-secondary">Categoría</label>
                                    <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label fw-medium small text-secondary">Stock Inicial</label>
                                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" Required="true"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-medium small text-secondary">Precio (L.)</label>
                                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="0.00" Required="true"></asp:TextBox>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-medium small text-secondary">Imagen del Producto</label>
                                    <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-12 text-end mt-3">
                                    <asp:Button ID="btnLimpiar" runat="server" Text="Cancelar" CssClass="btn btn-light px-4 me-2 border" OnClick="btnLimpiar_Click" CausesValidation="false" />
                                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" CssClass="btn btn-primary px-4 shadow-sm" OnClick="btnGuardar_Click" />
                                </div>
                            </div>
                        </div>

                        <!-- TABLA DE CATÁLOGO -->
                        <div class="card card-custom p-4">
                            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-3">
                                <h6 class="fw-bold mb-0 text-dark"><i class="fa-solid fa-list text-primary me-2"></i>Catálogo Registrado</h6>
                                <div class="col-md-4">
                                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control form-control-sm" placeholder="Buscar producto..." AutoPostBack="true" OnTextChanged="txtBuscar_TextChanged"></asp:TextBox>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="False" 
                                    DataKeyNames="ID" CssClass="table table-custom align-middle mb-0" 
                                    GridLines="None" OnRowCommand="gvProductos_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-CssClass="fw-bold text-muted" />
                                        
                                        <asp:TemplateField HeaderText="Imagen" ItemStyle-Width="65px">
                                            <ItemTemplate>
                                                <img src='<%# string.IsNullOrEmpty(Eval("ImagenUrl").ToString()) ? "uploads/default.png" : Eval("ImagenUrl") %>'
                                                     alt="Producto" class="img-avatar" />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="Nombre" HeaderText="Producto" ItemStyle-CssClass="fw-semibold text-dark" />

                                        <asp:BoundField DataField="Categoria" HeaderText="Categoría" ItemStyle-CssClass="text-secondary" />

                                        <asp:TemplateField HeaderText="Stock">
                                            <ItemTemplate>
                                                <span class='<%# Convert.ToInt32(Eval("Stock")) < 5 ? "badge bg-danger-subtle text-danger" : "badge bg-success-subtle text-success" %> px-3 py-1 rounded-pill'>
                                                    <%# Eval("Stock") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="Precio" HeaderText="Precio" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold text-dark" />

                                        <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="90px" ItemStyle-CssClass="text-end">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-action btn-light text-primary border me-1">
                                                    <i class="fa-solid fa-pen"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-action btn-light text-danger border" OnClientClick="return confirm('¿Deseas eliminar este producto?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="text-center py-4 text-muted">
                                            <i class="fa-solid fa-box-open fs-2 mb-2"></i>
                                            <p class="mb-0">No se encontraron productos registrados.</p>
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </div>

                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btnGuardar" />
                    </Triggers>
                </asp:UpdatePanel>
            </main>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
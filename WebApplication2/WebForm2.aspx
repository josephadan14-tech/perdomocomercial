<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="WebApplication2.WebForm2" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Panel Principal - Comercial Perdomo</title>

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

        .hover-card:hover {
            transform: translateY(-4px);
            transition: transform 0.2s ease;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <aside class="sidebar">
            <div class="sidebar-brand">
                <a href="WebForm2.aspx">
                    <asp:Image ID="imgLogo" runat="server" ImageUrl="~/img/logo.jpg" AlternateText="Comercial Perdomo" CssClass="img-fluid" />
                </a>
            </div>
            
            <ul class="sidebar-menu">
                <li><a href="WebForm2.aspx" class="active"><i class="fa-solid fa-chart-pie"></i><span>Panel Principal</span></a></li>
                <li><a href="WebForm3.aspx"><i class="fa-solid fa-users"></i><span>Clientes</span></a></li>

                <li id="navProveedores" runat="server" class="Sidebar-item">
        <a class="nav-link" href="WebForm8.aspx">
            <i class="fa-solid fa-truck-field"></i>
            <span>Proveedores</span>
            </a>

    </li>

                <li><a href="WebForm4.aspx"><i class="fa-solid fa-boxes-stacked"></i><span>Inventario</span></a></li>
                <li><a href="WebForm5.aspx"><i class="fa-solid fa-cart-shopping"></i><span>Ventas</span></a></li>

                <li id="navReportes" runat="server" class="nav-item">
        <a class="nav-link" href="WebForm6.aspx">
            <i class="fa-solid fa-chart-line"></i>
            <span>Reportes</span>
            </a>
    </li>

                <li><a href="WebForm7.aspx"><i class="fa-solid fa-vault"></i><span>Control de Caja</span></a></li>
                  

            </ul>

            <div class="p-3 border-top border-secondary">
                <asp:LinkButton ID="btnCerrarSesion" runat="server" CssClass="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 rounded-3" OnClick="btnCerrarSesion_Click">
                    <i class="fa-solid fa-right-from-bracket"></i><span>Cerrar Sesión</span>
                </asp:LinkButton>
            </div>
        </aside>

        <main class="main-content">
            <div class="top-navbar">
                <div>
                    <h5 class="fw-bold mb-0 text-dark">Panel de Control General</h5>
                    <small class="text-muted">Gestión integral del sistema Comercial Perdomo</small>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill">
                        <i class="fa-solid fa-user me-1"></i>
                        <asp:Label ID="lblUsuario" runat="server" Text="Usuario"></asp:Label>
                    </span>
                </div>
            </div>

            <!-- TARJETAS DE MÉTRICAS -->
            <h6 class="fw-bold text-uppercase text-muted small mb-3">Métricas del Sistema</h6>
           <!-- METRICAS DEL SISTEMA -->
<div class="row g-3 mb-4">
    <!-- CLIENTES -->
    <div class="col-md-3">
        <div class="card card-custom p-3">
            <small class="text-uppercase text-muted fw-bold">Clientes Registrados</small>
            <h2 class="fw-bold my-1">
                <asp:Label ID="lblClientes" runat="server" Text="0"></asp:Label>
            </h2>
            <small class="text-primary"><i class="fa-solid fa-users me-1"></i>Directorio activo</small>
        </div>
    </div>

    <!-- PRODUCTOS -->
    <div class="col-md-3">
        <div class="card card-custom p-3">
            <small class="text-uppercase text-muted fw-bold">Productos en Stock</small>
            <h2 class="fw-bold my-1">
                <asp:Label ID="lblProductos" runat="server" Text="0"></asp:Label>
            </h2>
            <small class="text-warning"><i class="fa-solid fa-boxes-stacked me-1"></i>Catálogo disponible</small>
        </div>
    </div>

    <!-- VENTAS -->
    <div class="col-md-3">
        <div class="card card-custom p-3">
            <small class="text-uppercase text-muted fw-bold">Ventas Emitidas</small>
            <h2 class="fw-bold my-1">
                <asp:Label ID="lblVentas" runat="server" Text="0"></asp:Label>
            </h2>
            <small class="text-info"><i class="fa-solid fa-file-invoice me-1"></i>Facturas procesadas</small>
        </div>
    </div>

    <!-- INGRESOS -->
    <div class="col-md-3">
        <div class="card card-custom p-3 bg-navy text-white" style="background-color: #0b2545;">
            <small class="text-uppercase text-white-50 fw-bold">Ingresos Generados</small>
            <h2 class="fw-bold my-1 text-white">
                L. <asp:Label ID="lblIngresos" runat="server" Text="0.00"></asp:Label>
            </h2>
            <small class="text-white-50"><i class="fa-solid fa-wallet me-1"></i>Efectivo global</small>
        </div>
    </div>
</div>

            <!-- NAVEGACIÓN RÁPIDA -->
            <!-- MÓDULOS DEL SISTEMA -->
<h6 class="fw-bold text-uppercase text-muted mb-3" style="letter-spacing: 0.5px;">Módulos del Sistema</h6>

<div class="row g-3">
    <!-- CLIENTES -->
    <div class="col-12 col-md-4">
        <a href="WebForm3.aspx" class="text-decoration-none">
            <div class="card card-custom p-3 h-100 d-flex flex-row align-items-center gap-3">
                <div class="rounded-3 p-3 text-primary bg-primary-subtle d-flex align-items-center justify-content-center" style="width: 55px; height: 55px; shrink: 0;">
                    <i class="fa-solid fa-users fs-4"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1 text-dark">Clientes</h6>
                    <small class="text-muted">Registro y directorio general.</small>
                </div>
            </div>
        </a>
    </div>

    <!-- INVENTARIO -->
    <div class="col-12 col-md-4">
        <a href="WebForm4.aspx" class="text-decoration-none">
            <div class="card card-custom p-3 h-100 d-flex flex-row align-items-center gap-3">
                <div class="rounded-3 p-3 text-warning bg-warning-subtle d-flex align-items-center justify-content-center" style="width: 55px; height: 55px; shrink: 0;">
                    <i class="fa-solid fa-boxes-stacked fs-4"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1 text-dark">Inventario</h6>
                    <small class="text-muted">Gestión de productos y stock.</small>
                </div>
            </div>
        </a>
    </div>

    <!-- NUEVA FACTURA -->
    <div class="col-12 col-md-4">
        <a href="WebForm5.aspx" class="text-decoration-none">
            <div class="card card-custom p-3 h-100 d-flex flex-row align-items-center gap-3">
                <div class="rounded-3 p-3 text-info bg-info-subtle d-flex align-items-center justify-content-center" style="width: 55px; height: 55px; shrink: 0;">
                    <i class="fa-solid fa-cart-shopping fs-4"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1 text-dark">Nueva Factura</h6>
                    <small class="text-muted">Módulo de ventas e ítems.</small>
                </div>
            </div>
        </a>
    </div>

    <!-- CONTROL DE CAJA -->
    <div class="col-12 col-md-4">
        <a href="WebForm7.aspx" class="text-decoration-none">
            <div class="card card-custom p-3 h-100 d-flex flex-row align-items-center gap-3">
                <div class="rounded-3 p-3 text-danger bg-danger-subtle d-flex align-items-center justify-content-center" style="width: 55px; height: 55px; shrink: 0;">
                    <i class="fa-solid fa-vault fs-4"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1 text-dark">Control de Caja</h6>
                    <small class="text-muted">Apertura, arqueos, cierres e ingresos/egresos.</small>
                </div>
            </div>
        </a>
    </div>

    <!-- REPORTES -->
    <div id="cardReportes" runat="server" class="col-12 col-md-4">
        <a href="WebForm6.aspx" class="text-decoration-none">
            <div class="card card-custom p-3 h-100 d-flex flex-row align-items-center gap-3">
                <div class="rounded-3 p-3 text-success bg-success-subtle d-flex align-items-center justify-content-center" style="width: 55px; height: 55px; shrink: 0;">
                    <i class="fa-solid fa-chart-line fs-4"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1 text-dark">Reportes</h6>
                    <small class="text-muted">Historial general de ventas y facturación.</small>
                </div>
            </div>
        </a>
    </div>

    <!-- PROVEEDORES -->
    <div id="cardProveedores" runat="server" class="col-12 col-md-4">
        <a href="WebForm8.aspx" class="text-decoration-none">
            <div class="card card-custom p-3 h-100 d-flex flex-row align-items-center gap-3">
                <div class="rounded-3 p-3 text-secondary bg-secondary-subtle d-flex align-items-center justify-content-center" style="width: 55px; height: 55px; shrink: 0;">
                    <i class="fa-solid fa-truck-field fs-4"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1 text-dark">Proveedores</h6>
                    <small class="text-muted">Gestión de suplidores y contactos.</small>
                </div>
            </div>
        </a>
    </div>
</div>
            
        </main>
    </form>
</body>
</html>
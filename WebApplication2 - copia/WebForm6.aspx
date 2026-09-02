<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm6.aspx.cs" Inherits="WebApplication2.WebForm6" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Reporte de Ventas - Comercial Perdomo</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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

        .sidebar-brand img { max-height: 600px; width: auto; }

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
            margin-bottom: 1.5rem;
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

        .stat-card {
            padding: 1.5rem;
            border-radius: 14px;
            background: linear-gradient(135deg, #0b2545 0%, #133a68 100%);
            color: #ffffff;
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
                <li><a href="WebForm2.aspx"><i class="fa-solid fa-chart-pie"></i><span>Panel Principal</span></a></li>
                <li><a href="WebForm3.aspx"><i class="fa-solid fa-users"></i><span>Clientes</span></a></li>
                <li><a href="WebForm8.aspx" class="active"><i class="fa-solid fa-truck-field"></i><span>Proveedores</span></a></li>
                <li><a href="WebForm4.aspx"><i class="fa-solid fa-boxes-stacked"></i><span>Inventario</span></a></li>
                <li><a href="WebForm5.aspx"><i class="fa-solid fa-cart-shopping"></i><span>Ventas</span></a></li>
                <li><a href="WebForm7.aspx"><i class="fa-solid fa-vault"></i><span>Control de Caja</span></a></li>
                <li><a href="WebForm6.aspx" class="active"><i class="fa-solid fa-chart-line"></i><span>Reportes</span></a></li>
                

            </ul>

            <div class="p-3 border-top border-secondary">
                <asp:LinkButton ID="btnCerrarSesion" runat="server" CssClass="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 rounded-3" OnClick="btnCerrarSesion_Click">
                    <i class="fa-solid fa-right-from-bracket"></i><span>Cerrar Sesión</span>
                </asp:LinkButton>
            </div>
        </aside>

        <main class="main-content">
            <div class="top-navbar">
                <div class="d-flex align-items-center gap-3">
                    <div class="p-2 bg-success-subtle rounded-3 text-success">
                        <i class="fa-solid fa-chart-line fs-4"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold mb-0 text-dark">Reportes de Facturación y Caja</h5>
                        <small class="text-muted">Arqueo de ingresos y monitoreo histórico de transacciones</small>
                    </div>
                </div>
                <a href="WebForm5.aspx" class="btn btn-primary btn-sm rounded-3 px-3 fw-bold">
                    <i class="fa-solid fa-plus me-1"></i> Nueva Factura
                </a>
            </div>

            <!-- Resumen Tarjetas de Efectivo y Facturas -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <span class="text-white-50 text-uppercase small fw-bold">Efectivo Total Generado</span>
                        <h2 class="fw-bold mt-2 mb-0" runat="server" id="lblTotalEfectivo">L. 0.00</h2>
                        <small class="text-white-50"><i class="fa-solid fa-wallet me-1"></i>Ingresos netos facturados</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-custom p-4">
                        <span class="text-muted text-uppercase small fw-bold">Facturas Emitidas</span>
                        <h2 class="fw-bold text-dark mt-2 mb-0" runat="server" id="lblCantidadVentas">0</h2>
                        <small class="text-success"><i class="fa-solid fa-check-circle me-1"></i>Órdenes completadas</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-custom p-4">
                        <span class="text-muted text-uppercase small fw-bold">Ticket Promedio</span>
                        <h2 class="fw-bold text-dark mt-2 mb-0" runat="server" id="lblPromedioVenta">L. 0.00</h2>
                        <small class="text-muted"><i class="fa-solid fa-calculator me-1"></i>Promedio por transacción</small>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <!-- Gráfico de Ventas por Fecha -->
                <div class="col-lg-7">
                    <div class="card card-custom p-4 h-100">
                        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-chart-column me-2 text-primary"></i>Comportamiento de Ventas</h6>
                        <div>
                            <canvas id="ventasChart" height="150"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Lista de Facturas Recientes -->
                <div class="col-lg-5">
                    <div class="card card-custom p-4 h-100">
                        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-receipt me-2 text-success"></i>Histórico de Facturas</h6>
                        <div class="table-responsive">
                            <asp:GridView ID="gvVentas" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-hover align-middle small" GridLines="None" EmptyDataText="No hay registros de ventas.">
                                <Columns>
                                    <asp:BoundField DataField="IdVenta" HeaderText="# Factura" ItemStyle-Font-Bold="true" />
                                    <asp:BoundField DataField="Cliente" HeaderText="Cliente" />
                                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                                    <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold text-success" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </form>

    <!-- Script para renderizar el gráfico con datos desde C# -->
    <asp:Literal ID="litChartScript" runat="server"></asp:Literal>
</body>
</html>
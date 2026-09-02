<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm7.aspx.cs" Inherits="WebApplication2.WebForm7" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestión de Caja - Comercial Perdomo</title>

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
            top: 0; left: 0;
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
                              <li id="navProveedores" runat="server" class="nav-item">
    <a class="nav-link" href="WebForm8.aspx">Proveedores</a>
</li>
                <li><a href="WebForm4.aspx"><i class="fa-solid fa-boxes-stacked"></i><span>Inventario</span></a></li>
                <li><a href="WebForm5.aspx"><i class="fa-solid fa-cart-shopping"></i><span>Ventas</span></a></li>
                <li><a href="WebForm7.aspx" class="active"><i class="fa-solid fa-vault"></i><span>Control de Caja</span></a></li>
                           <li id="navReportes" runat="server" class="nav-item">
    <a class="nav-link" href="WebForm6.aspx">Reportes</a>
</li>
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
                    <h5 class="fw-bold mb-0 text-dark">Módulo de Control y Cuadre de Caja</h5>
                    <small class="text-muted">Apertura, movimientos de flujo de efectivo y arqueos de turno</small>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill">
                        <i class="fa-solid fa-user me-1"></i>
                        <asp:Label ID="lblUsuario" runat="server" Text="Usuario"></asp:Label>
                    </span>
                </div>
            </div>

            <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mb-3"></asp:Label>

            <!-- RESUMEN DE SALDOS Y ESTADO -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card card-custom p-3 text-white" style="background: linear-gradient(135deg, #0b2545 0%, #133a68 100%);">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-white-50 small fw-bold text-uppercase">Estado Actual</span>
                            <asp:Label ID="lblEstadoBadge" runat="server" CssClass="badge bg-danger">CERRADA</asp:Label>
                        </div>
                        <h3 class="fw-bold text-white my-2">
                            <asp:Label ID="lblSaldoCalculado" runat="server" Text="L. 0.00"></asp:Label>
                        </h3>
                        <small class="text-white-50"><i class="fa-solid fa-wallet me-1"></i>Saldo esperado en caja</small>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-custom p-3">
                        <span class="text-muted small fw-bold text-uppercase">Fondo de Apertura</span>
                        <h4 class="fw-bold text-dark my-2"><asp:Label ID="lblMontoInicial" runat="server" Text="L. 0.00"></asp:Label></h4>
                        <small class="text-primary"><i class="fa-solid fa-lock me-1"></i>Efectivo base</small>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-custom p-3">
                        <span class="text-muted small fw-bold text-uppercase">Ventas del Turno</span>
                        <h4 class="fw-bold text-success my-2"><asp:Label ID="lblVentasCaja" runat="server" Text="L. 0.00"></asp:Label></h4>
                        <small class="text-success"><i class="fa-solid fa-arrow-trend-up me-1"></i>Ingresos por facturación</small>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card card-custom p-3">
                        <span class="text-muted small fw-bold text-uppercase">Balance Entradas/Salidas</span>
                        <h4 class="fw-bold text-info my-2"><asp:Label ID="lblMovimientosCaja" runat="server" Text="L. 0.00"></asp:Label></h4>
                        <small class="text-info"><i class="fa-solid fa-money-bill-transfer me-1"></i>Ajustes manuales</small>
                    </div>
                </div>
            </div>

            <!-- CONTROLES DE ACCIÓN DE CAJA -->
            <div class="row g-4 mb-4">
                <!-- Apertura y Cierre con Arqueo -->
                <div class="col-lg-6">
                    <div class="card card-custom p-4 h-100">
                        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-key me-2 text-warning"></i>Turno de Caja</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Monto Inicial de Apertura (L.)</label>
                                <asp:TextBox ID="txtMontoApertura" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="Ej. 1000.00"></asp:TextBox>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <asp:Button ID="btnAbrirCaja" runat="server" Text="Abrir Caja" CssClass="btn btn-success w-100 fw-semibold" OnClick="btnAbrirCaja_Click" />
                            </div>

                            <hr class="my-3 text-muted" />

                            <div class="col-md-6">
                               <label class="form-label small fw-bold text-secondary">Efectivo Real en Arqueo (L.)</label>
                                <asp:TextBox ID="txtArqueoCierre" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="Conteo de billetes"></asp:TextBox>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <asp:Button ID="btnCerrarCaja" runat="server" Text="Cerrar Turno y Arqueo" CssClass="btn btn-danger w-100 fw-semibold" OnClick="btnCerrarCaja_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Registro Manual de Movimientos (Ingresos Extra / Retiros de Caja) -->
                <div class="col-lg-6">
                    <div class="card card-custom p-4 h-100">
                        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-arrow-right-arrow-left me-2 text-primary"></i>Registrar Movimiento Extraordinario</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Tipo de Operación</label>
                                <asp:DropDownList ID="ddlTipoMovimiento" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Ingreso (+ Dinero extra)" Value="INGRESO"></asp:ListItem>
                                    <asp:ListItem Text="Egreso (- Gastos / Retiros)" Value="EGRESO"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Monto (L.)</label>
                                <asp:TextBox ID="txtMontoMovimiento" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00" OnTextChanged="txtMontoMovimiento_TextChanged"></asp:TextBox>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-secondary">Concepto / Justificación</label>
                                <asp:TextBox ID="txtConcepto" runat="server" CssClass="form-control" placeholder="Ej. Pago de flete, cambio sencillo, etc."></asp:TextBox>
                            </div>
                            <div class="col-12">
                                <asp:Button ID="btnRegistrarMovimiento" runat="server" Text="Guardar Movimiento" CssClass="btn btn-primary w-100 fw-semibold" OnClick="btnRegistrarMovimiento_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TABLA DE MOVIMIENTOS REGISTRADOS -->
            <div class="card card-custom p-3 mb-4">
                <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-list-check me-2 text-primary"></i>Movimientos del Turno Actual</h6>
                <div class="table-responsive">
                    <asp:GridView ID="gvMovimientos" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle small" GridLines="None" EmptyDataText="No hay movimientos registrados en esta sesión.">
                        <Columns>
                            <asp:BoundField DataField="Fecha" HeaderText="Hora/Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                            <asp:BoundField DataField="Tipo" HeaderText="Tipo" ItemStyle-Font-Bold="true" />
                            <asp:BoundField DataField="Concepto" HeaderText="Concepto / Motivo" />
                            <asp:BoundField DataField="Monto" HeaderText="Monto" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold text-end" />
                            <asp:BoundField DataField="Usuario" HeaderText="Usuario" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- HISTÓRICO DE CIERRES DE CAJA Y ARQUEOS -->
            <div class="card card-custom p-3">
                <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-clock-rotate-left me-2 text-secondary"></i>Histórico de Turnos y Arqueos</h6>
                <div class="table-responsive">
                    <asp:GridView ID="gvHistoricoCaja" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover align-middle small" GridLines="None" EmptyDataText="No hay registro de cierres anteriores." OnSelectedIndexChanged="gvHistoricoCaja_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="IdCaja" HeaderText="# Turno" ItemStyle-Font-Bold="true" />
                            <asp:BoundField DataField="Usuario" HeaderText="Cajero" />
                            <asp:BoundField DataField="FechaApertura" HeaderText="Apertura" DataFormatString="{0:dd/MM/yy HH:mm}" />
                            <asp:BoundField DataField="FechaCierre" HeaderText="Cierre" DataFormatString="{0:dd/MM/yy HH:mm}" />
                            <asp:BoundField DataField="MontoInicial" HeaderText="Base" DataFormatString="L. {0:N2}" />
                            <asp:BoundField DataField="VentasTotales" HeaderText="+ Ventas" DataFormatString="L. {0:N2}" />
                            <asp:BoundField DataField="Movimientos" HeaderText="+/- Mov" DataFormatString="L. {0:N2}" />
                            <asp:BoundField DataField="SaldoFinal" HeaderText="Esperado" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold" />
                            <asp:BoundField DataField="MontoArqueo" HeaderText="Real (Arqueo)" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold text-primary" />
                            <asp:BoundField DataField="Diferencia" HeaderText="Diferencia" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold text-danger" />
                            <asp:BoundField DataField="Estado" HeaderText="Estado" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

        </main>
    </form>
</body>
</html>
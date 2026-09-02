<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm5.aspx.cs" Inherits="WebApplication2.WebForm5" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Punto de Venta - Comercial Perdomo</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            background-color: #ffffff;
        }
        .header-title {
            font-weight: 700;
            color: #1e293b;
        }
        .img-preview {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }
        .table-custom th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
        }
        .btn-green {
            background-color: #10b981;
            color: #ffffff;
            font-weight: 600;
        }
        .btn-green:hover {
            background-color: #059669;
            color: #ffffff;
        }

        /* ESTILOS EXCLUSIVOS PARA IMPRESIÓN (TICKET / FACTURA) */
        @media print {
            body * {
                visibility: hidden;
            }
            #areaImpresion, #areaImpresion * {
                visibility: visible;
            }
            #areaImpresion {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <!-- Navbar superior / Encabezado -->
        <div class="container-fluid bg-white py-3 border-bottom mb-4">
            <div class="container d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-3">
                    <div class="bg-primary text-white p-3 rounded-3 fs-4">
                        <i class="bi bi-cart-fill"></i>
                    </div>
                    <div>
                        <h4 class="header-title mb-0">Punto de Venta</h4>
                        <small class="text-muted">Emisión de órdenes de compra y facturación a clientes</small>
                    </div>
                </div>
                <div>
                    <asp:Button ID="btnVolverInicio" runat="server" Text="← Volver al Inicio" CssClass="btn btn-light text-secondary border fw-semibold" OnClick="btnVolverInicio_Click" CauseValidation="false" />
                </div>
            </div>
        </div>

        <div class="container">
            <!-- Alerta de Caja Cerrada -->
            <asp:Panel ID="pnlCajaCerrada" runat="server" Visible="false" CssClass="alert alert-warning d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-4 me-3 text-warning"></i>
                <div>
                    <strong>Caja Cerrada:</strong> Debes aperturar e iniciar la caja antes de poder agregar productos y facturar ventas.
                </div>
            </asp:Panel>

            <!-- Mensajes de alerta generales -->
            <asp:Label ID="lblMensaje" runat="server"></asp:Label>

            <div class="row g-4">
                <!-- COLUMNA IZQUIERDA: CLIENTE Y SELECCIÓN DE PRODUCTOS -->
                <div class="col-lg-7">
                    
                    <!-- Card Datos del Cliente -->
                    <div class="card card-custom p-4 mb-4">
                        <h6 class="fw-bold text-primary mb-3">
                            <i class="bi bi-person-fill me-2"></i>Datos del Cliente
                        </h6>
                        <asp:DropDownList ID="ddlClientes" runat="server" CssClass="form-select form-select-lg"></asp:DropDownList>
                    </div>

                    <!-- Card Agregar Producto -->
                    <div class="card card-custom p-4">
                        <h6 class="fw-bold text-warning mb-3">
                            <i class="bi bi-box-seam-fill me-2"></i>Agregar Producto
                        </h6>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Producto</label>
                            <asp:DropDownList ID="ddlProductos" runat="server" CssClass="form-select form-select-lg" AutoPostBack="true" OnSelectedIndexChanged="ddlProductos_SelectedIndexChanged"></asp:DropDownList>
                        </div>

                        <!-- Card preview producto seleccionado -->
                        <div class="p-3 bg-light rounded-3 d-flex align-items-center gap-3 mb-3 border">
                            <asp:Image ID="imgProductoPreview" runat="server" ImageUrl="uploads/default.png" CssClass="img-preview" />
                            <div>
                                <h6 id="lblNombrePreview" runat="server" class="fw-bold mb-1">Selecciona un producto</h6>
                                <small id="lblStockPreview" runat="server" class="text-muted">Stock disponible: -</small>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <label class="form-label text-muted small fw-bold">Precio Unitario</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">L.</span>
                                    <asp:TextBox ID="txtPrecioUnitario" runat="server" CssClass="form-text-input form-control" ReadOnly="true" Text="0.00"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small fw-bold">Cantidad</label>
                                <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" Text="1"></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button ID="btnAgregarCarrito" runat="server" Text="Agregar al Carrito" CssClass="btn btn-primary btn-lg w-100 fw-bold" OnClick="btnAgregarCarrito_Click" />
                    </div>
                </div>

                <!-- COLUMNA DERECHA: RESUMEN Y DETALLE DE LA FACTURA -->
                <div class="col-lg-5">
                    <div class="card card-custom p-4">
                        <h6 class="fw-bold text-success mb-3">
                            <i class="bi bi-receipt me-2"></i>Detalle de Factura
                        </h6>

                        <!-- Tabla del Carrito de Compras -->
                        <div class="table-responsive mb-3" style="max-height: 280px; overflow-y: auto;">
                            <asp:GridView ID="gvDetalleVenta" runat="server" AutoGenerateColumns="False" CssClass="table table-borderless table-custom align-middle text-center" OnRowCommand="gvDetalleVenta_RowCommand" ShowHeaderWhenEmpty="true">
                                <Columns>
                                    <asp:TemplateField HeaderText="Prod.">
                                        <ItemTemplate>
                                            <img src='<%# Eval("ImagenUrl") %>' style="width: 35px; height: 35px; object-fit: cover; border-radius: 4px;" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Nombre" HeaderText="Descripción" ItemStyle-CssClass="text-start" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Cant." />
                                    <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="L. {0:N2}" ItemStyle-CssClass="fw-bold" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnQuitar" runat="server" CommandName="Quitar" CommandArgument='<%# Container.DataItemIndex %>' CssClass="text-danger border-0 bg-transparent text-decoration-none fw-bold">✕</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="text-center py-3 text-muted small">El carrito está vacío.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>

                        <hr />

                        <!-- Método de Pago -->
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Método de Pago</label>
                            <asp:DropDownList ID="ddlMetodoPago" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Efectivo" Value="Efectivo"></asp:ListItem>
                                <asp:ListItem Text="Tarjeta de Crédito / Débito" Value="Tarjeta"></asp:ListItem>
                                <asp:ListItem Text="Transferencia Bancaria" Value="Transferencia"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="p-3 bg-light rounded-3 mb-3 border">
                            <div class="row text-muted small mb-2">
                                <div class="col-6">Efectivo Recibido</div>
                                <div class="col-6 text-end">Cambio a Entregar</div>
                            </div>
                            <div class="row align-items-center">
                                <div class="col-6">
                                    <asp:TextBox ID="txtEfectivoRecibido" runat="server" CssClass="form-control form-control-sm" Text="0.00"></asp:TextBox>
                                </div>
                                <div class="col-6 text-end fw-bold text-success fs-6">
                                    <asp:Label ID="lblCambio" runat="server" Text="L. 0.00"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <!-- Totales -->
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal:</span>
                            <asp:Label ID="lblSubtotal" runat="server" CssClass="fw-bold text-dark" Text="L. 0.00"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">ISV (15%):</span>
                            <asp:Label ID="lblISV" runat="server" CssClass="fw-bold text-dark" Text="L. 0.00"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between mb-4 fs-5">
                            <span class="fw-bold">Total Pagar:</span>
                            <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold text-success" Text="L. 0.00"></asp:Label>
                        </div>

                        <asp:Button ID="btnProcesarVenta" runat="server" Text="Procesar y Emitir Factura" CssClass="btn btn-green btn-lg w-100 py-3 fs-6" OnClick="btnProcesarVenta_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL / VISTA DE FACTURA DE IMPRESIÓN -->
        <div class="modal fade" id="modalFactura" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body p-4" id="areaImpresion">
                        <div class="text-center mb-3">
                            <h4 class="fw-bold mb-0">COMERCIAL PERDOMO</h4>
                            <small class="text-muted">El Progreso, Yoro, Honduras</small><br />
                            <small class="text-muted">RTN: 05011999123456</small><br />
                            <small class="text-muted">Tel: +504 9999-8888</small>
                            <hr style="border-top: 1px dashed #000;" />
                            <h6 class="fw-bold">FACTURA DE VENTA</h6>
                        </div>

                        <div class="small mb-3">
                            <strong>Fecha:</strong> <span id="facturaFecha"><%= DateTime.Now.ToString("dd/MM/yyyy HH:mm") %></span><br />
                            <strong>Atendido por:</strong> Comercial Perdomo System<br />
                        </div>

                        <table class="table table-sm small mb-3">
                            <thead>
                                <tr>
                                    <th>Cant.</th>
                                    <th>Descripción</th>
                                    <th class="text-end">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptFacturaImpresion" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("Cantidad") %></td>
                                            <td><%# Eval("Nombre") %></td>
                                            <td class="text-end">L. <%# string.Format("{0:N2}", Eval("Total")) %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>

                        <hr style="border-top: 1px dashed #000;" />

                        <div class="d-flex justify-content-between small">
                            <span>Subtotal:</span>
                            <asp:Label ID="lblFacturaSubtotal" runat="server" Text="L. 0.00"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between small">
                            <span>ISV (15%):</span>
                            <asp:Label ID="lblFacturaISV" runat="server" Text="L. 0.00"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between fw-bold fs-6 mt-1">
                            <span>TOTAL:</span>
                            <asp:Label ID="lblFacturaTotal" runat="server" Text="L. 0.00"></asp:Label>
                        </div>

                        <div class="text-center mt-4 pt-2">
                            <small class="fw-bold">¡Gracias por su compra!</small><br />
                            <small class="text-muted">Exija su factura - Es su derecho</small>
                        </div>
                    </div>
                    <div class="modal-footer no-print">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="button" class="btn btn-primary" onclick="window.print();">Imprimir Manualmente</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts de Bootstrap e Impresión -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <script type="text/javascript">
            function abrirEImprimirFactura() {
                var elModal = document.getElementById('modalFactura');
                var myModal = new bootstrap.Modal(elModal);
                myModal.show();

                setTimeout(function () {
                    window.print();
                }, 600);
            }
        </script>
    </form>
</body>
</html>
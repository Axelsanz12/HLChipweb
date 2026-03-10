<%@ Page Title="Panel Admin" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Panel.aspx.cs" Inherits="HLchip.Admin.Panel" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .admin-section {
      min-height: 100vh;
      padding: 90px 48px 80px;
    }
    .admin-header {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 40px;
      padding-bottom: 24px;
      border-bottom: 1px solid rgba(255,255,255,0.07);
    }
    .admin-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2rem;
      text-transform: uppercase;
    }
    .admin-title span { color: #00aaff; }
    .admin-user {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.75rem; color: #6b7280;
      letter-spacing: 0.08em;
    }
    .admin-user strong { color: #00aaff; }
    .btn-logout {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.85rem;
      letter-spacing: 0.08em; text-transform: uppercase;
      background: transparent;
      border: 1px solid rgba(255,30,30,0.3);
      color: #ff6b6b; padding: 8px 18px;
      border-radius: 6px; cursor: pointer;
      transition: all 0.2s; margin-left: 16px;
    }
    .btn-logout:hover { border-color: #ff1e1e; color: #ff1e1e; }
    /* TABS */
    .tabs {
      display: flex; gap: 0;
      border-bottom: 1px solid rgba(255,255,255,0.07);
      margin-bottom: 36px;
    }
    .tab {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.95rem;
      letter-spacing: 0.08em; text-transform: uppercase;
      padding: 14px 28px; cursor: pointer;
      color: #6b7280; border-bottom: 2px solid transparent;
      transition: all 0.2s; background: none; border-top: none;
      border-left: none; border-right: none;
    }
    .tab.active { color: #00aaff; border-bottom-color: #00aaff; }
    .tab:hover { color: #e8ecf0; }
    .tab-content { display: none; }
    .tab-content.active { display: block; }
    /* STATS CARDS */
    .stats-row {
      display: grid; grid-template-columns: repeat(4, 1fr);
      gap: 16px; margin-bottom: 36px;
    }
    .stat-card {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 8px; padding: 24px;
    }
    .stat-card-num {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2.5rem;
      line-height: 1; margin-bottom: 6px;
    }
    .stat-card-num.blue { color: #00aaff; }
    .stat-card-num.green { color: #25D366; }
    .stat-card-num.yellow { color: #febc2e; }
    .stat-card-num.red { color: #ff1e1e; }
    .stat-card-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #6b7280;
      letter-spacing: 0.1em; text-transform: uppercase;
    }
    /* TABLE */
    .admin-table {
      width: 100%; border-collapse: collapse;
    }
    .admin-table th {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #00aaff;
      letter-spacing: 0.1em; text-transform: uppercase;
      padding: 12px 16px; text-align: left;
      border-bottom: 1px solid rgba(255,255,255,0.07);
      background: #0e1118;
    }
    .admin-table td {
      padding: 14px 16px; font-size: 0.88rem;
      color: #e8ecf0; border-bottom: 1px solid rgba(255,255,255,0.04);
    }
    .admin-table tr:hover td { background: rgba(0,170,255,0.03); }
    .badge {
      display: inline-block;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.65rem; padding: 3px 10px;
      border-radius: 100px; letter-spacing: 0.05em;
    }
    .badge-pendiente { background: rgba(254,188,46,0.1); color: #febc2e; border: 1px solid rgba(254,188,46,0.2); }
    .badge-confirmado { background: rgba(37,211,102,0.1); color: #25D366; border: 1px solid rgba(37,211,102,0.2); }
    .badge-cancelado { background: rgba(255,30,30,0.1); color: #ff6b6b; border: 1px solid rgba(255,30,30,0.2); }
    .badge-noleida { background: rgba(0,170,255,0.1); color: #00aaff; border: 1px solid rgba(0,170,255,0.2); }
    .btn-accion {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.78rem;
      letter-spacing: 0.05em; text-transform: uppercase;
      padding: 5px 12px; border-radius: 4px;
      cursor: pointer; border: none; transition: all 0.2s;
      margin-right: 4px;
    }
    .btn-confirmar { background: rgba(37,211,102,0.15); color: #25D366; }
    .btn-confirmar:hover { background: #25D366; color: #000; }
    .btn-cancelar { background: rgba(255,30,30,0.1); color: #ff6b6b; }
    .btn-cancelar:hover { background: #ff1e1e; color: #fff; }
    .empty-state {
      text-align: center; padding: 60px 20px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem; color: #6b7280;
      letter-spacing: 0.08em;
    }
    @media (max-width: 768px) {
      .admin-section { padding: 80px 16px 40px; }
      .stats-row { grid-template-columns: repeat(2, 1fr); }
      .admin-table { font-size: 0.8rem; }
      .admin-table th, .admin-table td { padding: 10px 8px; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-section">

    <!-- HEADER -->
    <div class="admin-header">
      <div>
        <div class="admin-title">Panel <span>Admin</span></div>
        <div class="admin-user">Bienvenido, <strong><asp:Literal ID="litUser" runat="server" /></strong></div>
      </div>
      <asp:Button ID="btnLogout" runat="server" Text="CERRAR SESIÓN" 
          CssClass="btn-logout" OnClick="btnLogout_Click" />
    </div>

    <!-- STATS -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-card-num blue"><asp:Literal ID="litTotalTurnos" runat="server">0</asp:Literal></div>
        <div class="stat-card-label">Turnos totales</div>
      </div>
      <div class="stat-card">
        <div class="stat-card-num yellow"><asp:Literal ID="litPendientes" runat="server">0</asp:Literal></div>
        <div class="stat-card-label">Pendientes</div>
      </div>
      <div class="stat-card">
        <div class="stat-card-num green"><asp:Literal ID="litConfirmados" runat="server">0</asp:Literal></div>
        <div class="stat-card-label">Confirmados</div>
      </div>
      <div class="stat-card">
        <div class="stat-card-num blue"><asp:Literal ID="litConsultas" runat="server">0</asp:Literal></div>
        <div class="stat-card-label">Consultas nuevas</div>
      </div>
    </div>

    <!-- TABS -->
    <div class="tabs">
      <button type="button" class="tab active" onclick="mostrarTab('turnos', this)">Turnos</button>
      <button type="button" class="tab" onclick="mostrarTab('consultas', this)">Consultas</button>
    </div>

    <!-- TAB TURNOS -->
    <div class="tab-content active" id="tab-turnos">
      <asp:UpdatePanel ID="upTurnos" runat="server">
        <ContentTemplate>
          <table class="admin-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Cliente</th>
                <th>Teléfono</th>
                <th>Servicio</th>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Vehículo</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <asp:Repeater ID="rptTurnos" runat="server" OnItemCommand="rptTurnos_ItemCommand">
                <ItemTemplate>
                  <tr>
                    <td><%# Eval("Id") %></td>
                    <td><%# Eval("Nombre") %></td>
                    <td><%# Eval("Telefono") %></td>
                    <td><%# Eval("Servicio") %></td>
                    <td><%# ((DateTime)Eval("FechaTurno")).ToString("dd/MM/yyyy") %></td>
                    <td><%# Eval("HoraTurno") %></td>
                    <td><%# Eval("Vehiculo") %></td>
                    <td>
                      <span class="badge badge-<%# Eval("Estado").ToString().ToLower() %>">
                        <%# Eval("Estado") %>
                      </span>
                    </td>
                    <td>
                      <asp:LinkButton runat="server" CommandName="Confirmar" 
                          CommandArgument='<%# Eval("Id") %>'
                          CssClass="btn-accion btn-confirmar">✓ Confirmar</asp:LinkButton>
                      <asp:LinkButton runat="server" CommandName="Cancelar" 
                          CommandArgument='<%# Eval("Id") %>'
                          CssClass="btn-accion btn-cancelar">✕ Cancelar</asp:LinkButton>
                    </td>
                  </tr>
                </ItemTemplate>
              </asp:Repeater>
            </tbody>
          </table>
          <asp:Panel ID="pnlSinTurnos" runat="server" Visible="false">
            <div class="empty-state">// No hay turnos registrados todavía</div>
          </asp:Panel>
        </ContentTemplate>
      </asp:UpdatePanel>
    </div>

    <!-- TAB CONSULTAS -->
    <div class="tab-content" id="tab-consultas">
      <table class="admin-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Nombre</th>
            <th>Teléfono</th>
            <th>Email</th>
            <th>Mensaje</th>
            <th>Fecha</th>
            <th>Estado</th>
          </tr>
        </thead>
        <tbody>
          <asp:Repeater ID="rptConsultas" runat="server">
            <ItemTemplate>
              <tr>
                <td><%# Eval("Id") %></td>
                <td><%# Eval("Nombre") %></td>
                <td><%# Eval("Telefono") %></td>
                <td><%# Eval("Email") %></td>
                <td><%# Eval("Mensaje") %></td>
                <td><%# ((DateTime)Eval("Fecha")).ToString("dd/MM/yyyy HH:mm") %></td>
                <td>
                  <span class="badge <%# (bool)Eval("Leida") ? "badge-confirmado" : "badge-noleida" %>">
                    <%# (bool)Eval("Leida") ? "Leída" : "Nueva" %>
                  </span>
                </td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
        </tbody>
      </table>
      <asp:Panel ID="pnlSinConsultas" runat="server" Visible="false">
        <div class="empty-state">// No hay consultas todavía</div>
      </asp:Panel>
    </div>

  </div>

  <script>
    function mostrarTab(nombre, el) {
      document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
      document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
      document.getElementById('tab-' + nombre).classList.add('active');
      el.classList.add('active');
    }
  </script>
</asp:Content>
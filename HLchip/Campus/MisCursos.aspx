<%@ Page Title="Mis Cursos" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="MisCursos.aspx.cs" Inherits="HLchip.Campus.MisCursos" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .campus-section { min-height: 100vh; padding: 90px 48px 80px; }
    .campus-header {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 40px; padding-bottom: 24px;
      border-bottom: 1px solid rgba(255,255,255,0.07);
    }
    .campus-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2rem; text-transform: uppercase;
    }
    .campus-title span { color: #00aaff; }
    .campus-user {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.75rem; color: #6b7280; letter-spacing: 0.08em;
    }
    .campus-user strong { color: #00aaff; }
    .btn-salir {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.85rem;
      letter-spacing: 0.08em; text-transform: uppercase;
      background: transparent; border: 1px solid rgba(255,30,30,0.3);
      color: #ff6b6b; padding: 8px 18px; border-radius: 6px;
      cursor: pointer; transition: all 0.2s; margin-left: 16px;
    }
    .btn-salir:hover { border-color: #ff1e1e; color: #ff1e1e; }
    .cursos-grid {
      display: grid; grid-template-columns: repeat(3, 1fr);
      gap: 24px;
    }
    .curso-card {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 10px; overflow: hidden;
      transition: border-color 0.2s;
    }
    .curso-card:hover { border-color: rgba(0,170,255,0.3); }
    .curso-card-body { padding: 24px; }
    .curso-card-nombre {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 1.2rem;
      margin-bottom: 8px;
    }
    .curso-card-desc {
      font-size: 0.85rem; color: #9ca3af;
      margin-bottom: 16px; line-height: 1.5;
    }
    .progreso-bar {
      background: rgba(255,255,255,0.05);
      border-radius: 100px; height: 6px; margin-bottom: 8px;
    }
    .progreso-fill {
      background: #00aaff; height: 6px; border-radius: 100px;
      transition: width 0.3s;
    }
    .progreso-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #6b7280; margin-bottom: 16px;
    }
    .btn-ver {
      display: inline-block;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.85rem;
      letter-spacing: 0.08em; text-transform: uppercase;
      background: #00aaff; color: #000;
      padding: 10px 20px; border-radius: 6px;
      text-decoration: none; transition: background 0.2s;
    }
    .btn-ver:hover { background: #0090dd; color: #000; }
    .empty-state {
      text-align: center; padding: 80px 20px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem; color: #6b7280; letter-spacing: 0.08em;
    }
    @media (max-width: 768px) {
      .campus-section { padding: 80px 16px 40px; }
      .cursos-grid { grid-template-columns: 1fr; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="campus-section">

    <div class="campus-header">
      <div>
        <div class="campus-title">HL<span>Chip</span> Campus</div>
        <div class="campus-user">Bienvenido, <strong><asp:Literal ID="litNombre" runat="server" /></strong></div>
      </div>
      <asp:Button ID="btnSalir" runat="server" Text="CERRAR SESIÓN" 
          CssClass="btn-salir" OnClick="btnSalir_Click" />
    </div>

    <div class="cursos-grid">
      <asp:Repeater ID="rptCursos" runat="server">
        <ItemTemplate>
          <div class="curso-card">
            <div class="cursos-card-body">
              <div class="cursos-card-nombre"><%# Eval("Nombre") %></div>
              <div class="cursos-card-desc"><%# Eval("Descripcion") %></div>
              <div class="progreso-bar">
                <div class="progreso-fill" style="width:<%# Eval("Progreso") %>%"></div>
              </div>
              <div class="progreso-label">Progreso: <%# Eval("Progreso") %>%</div>
              <a href="/Campus/Cursos.aspx?id=<%# Eval("IdCurso") %>" class="btn-ver">Ir al curso→</a>
            </div>
          </div>
        </ItemTemplate>
      </asp:Repeater>
    </div>

    <asp:Panel ID="pnlSinCursos" runat="server" Visible="false">
      <div class="empty-state">// No tenés cursos activos todavía</div>
    </asp:Panel>

  </div>
</asp:Content>
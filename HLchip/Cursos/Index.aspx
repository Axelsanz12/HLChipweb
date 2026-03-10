<%@ Page Title="Cursos" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="HLchip.Cursos.Index" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .cursos-section {
      min-height: 100vh;
      padding: 120px 48px 80px;
    }
    .section-eyebrow {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.72rem; color: #00aaff;
      letter-spacing: 0.2em; text-transform: uppercase;
      margin-bottom: 16px;
      display: flex; align-items: center; gap: 12px;
    }
    .section-eyebrow::before {
      content: ''; width: 20px; height: 2px; background: #00aaff;
    }
    .cursos-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2.5rem, 5vw, 4rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 12px;
    }
    .cursos-title em { font-style: italic; color: #00aaff; }
    .cursos-desc {
      color: #6b7280; font-size: 1rem;
      line-height: 1.75; font-weight: 300;
      margin-bottom: 60px; max-width: 560px;
    }
    /* GRID */
    .cursos-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 24px;
    }
    .curso-card {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 12px;
      overflow: hidden;
      transition: all 0.3s;
      display: flex; flex-direction: column;
    }
    .curso-card:hover {
      border-color: rgba(0,170,255,0.3);
      transform: translateY(-4px);
    }
    .curso-card-header {
      padding: 32px 28px 24px;
      border-bottom: 1px solid rgba(255,255,255,0.05);
      flex: 1;
    }
    .curso-nivel {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.65rem; color: #00aaff;
      letter-spacing: 0.12em; text-transform: uppercase;
      margin-bottom: 12px;
    }
    .curso-nombre {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1.4rem;
      text-transform: uppercase; line-height: 1.1;
      margin-bottom: 14px; color: #fff;
    }
    .curso-desc {
      font-size: 0.85rem; color: #6b7280;
      line-height: 1.6;
    }
    .curso-card-footer {
      padding: 20px 28px;
      display: flex; align-items: center; justify-content: space-between;
    }
    .curso-precio {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1.6rem;
      color: #fff;
    }
    .curso-precio small {
      font-size: 0.75rem; color: #6b7280;
      font-weight: 400; display: block;
      font-family: 'Share Tech Mono', monospace;
      letter-spacing: 0.05em;
    }
    .curso-duracion {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #6b7280;
      letter-spacing: 0.08em;
      display: flex; align-items: center; gap: 6px;
    }
    .btn-ver {
      display: block; width: 100%;
      background: rgba(0,170,255,0.08);
      border: 1px solid rgba(0,170,255,0.2);
      color: #00aaff;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 0.9rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      text-align: center; padding: 14px;
      text-decoration: none;
      transition: all 0.2s;
      margin: 0 28px 28px;
      border-radius: 6px;
      width: calc(100% - 56px);
    }
    .btn-ver:hover {
      background: #00aaff; color: #000;
    }
    .curso-card:first-child .btn-ver {
      background: #00aaff; color: #000; border-color: #00aaff;
    }
    .curso-card:first-child {
      border-color: rgba(0,170,255,0.2);
    }
    @media (max-width: 900px) {
      .cursos-grid { grid-template-columns: 1fr; }
      .cursos-section { padding: 100px 20px 60px; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="cursos-section">
    <div class="section-eyebrow">Formación profesional</div>
    <h1 class="cursos-title">Cursos de<br><em>Chiptuning</em></h1>
    <p class="cursos-desc">
      Aprendé chiptuning con quienes lo practican todos los días. 
      Desde cero hasta nivel profesional, con casos reales y soporte directo.
    </p>

    <div class="cursos-grid">
      <asp:Repeater ID="rptCursos" runat="server">
        <ItemTemplate>
          <div class="curso-card">
            <div class="curso-card-header">
              <div class="curso-nivel">&#9679; <%# Eval("Modalidad") %> — <%# Eval("Duracion") %></div>
              <div class="curso-nombre"><%# Eval("Nombre") %></div>
              <div class="curso-desc"><%# Eval("Descripcion") %></div>
            </div>
            <div class="curso-card-footer">
              <div class="curso-precio">
                <small>Inversión</small>
                $<%# String.Format("{0:N0}", Eval("Precio")) %>
              </div>
              <div class="curso-duracion">&#9201; <%# Eval("Duracion") %></div>
            </div>
            <a href="/Cursos/Detalle.aspx?id=<%# Eval("Id") %>" class="btn-ver">Ver curso →</a>
          </div>
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </div>
</asp:Content>
<%@ Page Title="Detalle Curso" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Detalle.aspx.cs" Inherits="HLchip.Cursos.Detalle" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .detalle-section {
      min-height: 100vh;
      padding: 120px 48px 80px;
      display: grid;
      grid-template-columns: 1.3fr 1fr;
      gap: 80px; align-items: start;
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
    .curso-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2rem, 4vw, 3.5rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 20px;
    }
    .curso-title em { font-style: italic; color: #00aaff; }
    .curso-desc {
      color: #6b7280; font-size: 1rem;
      line-height: 1.75; font-weight: 300;
      margin-bottom: 36px;
    }
    .curso-meta {
      display: flex; gap: 24px; margin-bottom: 40px;
      flex-wrap: wrap;
    }
    .curso-meta-item {
      display: flex; flex-direction: column; gap: 4px;
    }
    .curso-meta-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.65rem; color: #6b7280;
      letter-spacing: 0.1em; text-transform: uppercase;
    }
    .curso-meta-val {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.1rem;
      color: #fff; text-transform: uppercase;
    }
    /* TEMARIO */
    .temario-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.1rem;
      text-transform: uppercase; margin-bottom: 20px;
      color: #fff; letter-spacing: 0.05em;
    }
    .temario-list {
      list-style: none; padding: 0; margin: 0;
    }
    .temario-list li {
      padding: 12px 0;
      border-bottom: 1px solid rgba(255,255,255,0.05);
      font-size: 0.9rem; color: #9ca3af;
      display: flex; align-items: flex-start; gap: 12px;
      line-height: 1.5;
    }
    .temario-list li::before {
      content: '//';
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #00aaff;
      flex-shrink: 0; margin-top: 2px;
    }
    /* FORM INSCRIPCION */
    .inscripcion-form {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 12px; padding: 40px;
      position: sticky; top: 80px;
    }
    .precio-display {
      margin-bottom: 28px;
      padding-bottom: 28px;
      border-bottom: 1px solid rgba(255,255,255,0.07);
    }
    .precio-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #6b7280;
      letter-spacing: 0.1em; text-transform: uppercase;
      margin-bottom: 8px;
    }
    .precio-num {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 3rem;
      line-height: 1; color: #fff;
    }
    .precio-num span {
      font-size: 1.5rem; color: #00aaff;
    }
    .form-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.1rem;
      text-transform: uppercase; margin-bottom: 24px;
      color: #fff;
    }
    .form-group { margin-bottom: 16px; }
    .form-label {
      display: block;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #00aaff;
      letter-spacing: 0.1em; text-transform: uppercase;
      margin-bottom: 8px;
    }
    .form-input {
      width: 100%; background: #050608;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 6px; padding: 13px 16px;
      color: #e8ecf0; font-family: 'Barlow', sans-serif;
      font-size: 0.95rem; transition: border-color 0.2s;
      outline: none;
    }
    .form-input:focus { border-color: #00aaff; }
    .btn-inscribir {
      width: 100%; background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 16px; cursor: pointer;
      transition: all 0.2s; margin-top: 8px;
    }
    .btn-inscribir:hover { background: #0099ee; transform: translateY(-2px); }
    .btn-volver {
      display: inline-flex; align-items: center; gap: 8px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.72rem; color: #6b7280;
      letter-spacing: 0.08em; text-decoration: none;
      margin-bottom: 32px; transition: color 0.2s;
    }
    .btn-volver:hover { color: #00aaff; }
    .msg-ok {
      background: rgba(37,211,102,0.1);
      border: 1px solid rgba(37,211,102,0.3);
      border-radius: 8px; padding: 20px; color: #25D366;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem; letter-spacing: 0.05em;
      margin-top: 16px; line-height: 1.7;
    }
    .not-found {
      text-align: center; padding: 80px 20px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.85rem; color: #6b7280;
    }
    @media (max-width: 900px) {
      .detalle-section { grid-template-columns: 1fr; padding: 100px 20px 60px; gap: 40px; }
      .inscripcion-form { position: static; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

  <asp:Panel ID="pnlCurso" runat="server" Visible="false">
    <div class="detalle-section">

      <!-- IZQUIERDA — DETALLE -->
      <div>
        <a href="/Cursos/Index.aspx" class="btn-volver">← Volver a cursos</a>
        <div class="section-eyebrow">Curso online</div>
        <h1 class="curso-title">
          <asp:Literal ID="litNombre" runat="server" />
        </h1>
        <p class="curso-desc">
          <asp:Literal ID="litDesc" runat="server" />
        </p>
        <div class="curso-meta">
          <div class="curso-meta-item">
            <div class="curso-meta-label">Duración</div>
            <div class="curso-meta-val"><asp:Literal ID="litDuracion" runat="server" /></div>
          </div>
          <div class="curso-meta-item">
            <div class="curso-meta-label">Modalidad</div>
            <div class="curso-meta-val"><asp:Literal ID="litModalidad" runat="server" /></div>
          </div>
        </div>

        <div class="temario-title">// Temario</div>
        <ul class="temario-list">
          <asp:Repeater ID="rptTemario" runat="server">
            <ItemTemplate>
              <li><%# Container.DataItem %></li>
            </ItemTemplate>
          </asp:Repeater>
        </ul>
      </div>

      <!-- DERECHA — INSCRIPCION -->
      <div class="inscripcion-form">
        <div class="precio-display">
          <div class="precio-label">Inversión total</div>
          <div class="precio-num">
            <span>$</span><asp:Literal ID="litPrecio" runat="server" />
          </div>
        </div>

        <div class="form-title">// Quiero inscribirme</div>

        <div class="form-group">
          <label class="form-label">Nombre</label>
          <asp:TextBox ID="txtNombre" runat="server" CssClass="form-input" placeholder="Tu nombre" />
        </div>
        <div class="form-group">
          <label class="form-label">WhatsApp</label>
          <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-input" placeholder="11-XXXXXXXX" />
        </div>
        <div class="form-group">
          <label class="form-label">Email</label>
          <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="tu@email.com" />
        </div>
        <div class="form-group">
          <label class="form-label">Consulta (opcional)</label>
          <asp:TextBox ID="txtConsulta" runat="server" CssClass="form-input" 
              placeholder="¿Tenés alguna pregunta?" TextMode="MultiLine"
              Style="height:70px; resize:vertical;" />
        </div>

        <asp:HiddenField ID="hfIdCurso" runat="server" />

        <asp:Button ID="btnInscribir" runat="server" Text="QUIERO INSCRIBIRME" 
            CssClass="btn-inscribir" OnClick="btnInscribir_Click" />

        <asp:Panel ID="pnlOk" runat="server" Visible="false">
          <div class="msg-ok">
            ✓ ¡Solicitud recibida!<br>
            Te contactamos por WhatsApp a la brevedad para coordinar el pago y el acceso.<br><br>
            <strong>11-23177778</strong>
          </div>
        </asp:Panel>
      </div>

    </div>
  </asp:Panel>

  <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
    <div class="not-found">// Curso no encontrado</div>
  </asp:Panel>

</asp:Content>
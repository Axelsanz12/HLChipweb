<%@ Page Title="Contacto" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="HLchip.Contact" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .contacto-section {
      min-height: 100vh;
      padding: 120px 48px 80px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 80px;
      align-items: start;
    }
    .contact-left {}
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
    .contact-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2.5rem, 5vw, 4rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 20px;
    }
    .contact-title em { font-style: italic; color: #00aaff; }
    .contact-desc {
      color: #6b7280; font-size: 1rem;
      line-height: 1.75; font-weight: 300;
      margin-bottom: 40px;
    }
    .contact-info-item {
      display: flex; align-items: center; gap: 16px;
      padding: 16px 0;
      border-bottom: 1px solid rgba(255,255,255,0.07);
    }
    .contact-info-icon {
      width: 44px; height: 44px;
      background: rgba(0,170,255,0.08);
      border: 1px solid rgba(0,170,255,0.2);
      border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem; flex-shrink: 0;
    }
    .contact-info-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #00aaff;
      letter-spacing: 0.1em; text-transform: uppercase;
      margin-bottom: 4px;
    }
    .contact-info-value {
      font-size: 0.95rem; color: #e8ecf0; font-weight: 500;
    }
    /* FORM */
    .contact-form {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 8px;
      padding: 40px;
    }
    .form-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.4rem;
      text-transform: uppercase; margin-bottom: 28px;
      color: #fff;
    }
    .form-group { margin-bottom: 20px; }
    .form-label {
      display: block;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #00aaff;
      letter-spacing: 0.1em; text-transform: uppercase;
      margin-bottom: 8px;
    }
    .form-input {
      width: 100%;
      background: #050608;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 6px;
      padding: 13px 16px;
      color: #e8ecf0;
      font-family: 'Barlow', sans-serif;
      font-size: 0.95rem;
      transition: border-color 0.2s;
      outline: none;
    }
    .form-input:focus { border-color: #00aaff; }
    .form-textarea {
      width: 100%; height: 120px; resize: vertical;
      background: #050608;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 6px;
      padding: 13px 16px;
      color: #e8ecf0;
      font-family: 'Barlow', sans-serif;
      font-size: 0.95rem;
      transition: border-color 0.2s;
      outline: none;
    }
    .form-textarea:focus { border-color: #00aaff; }
    .btn-enviar {
      width: 100%;
      background: #25D366; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 16px; cursor: pointer;
      transition: all 0.2s; margin-top: 8px;
    }
    .btn-enviar:hover { background: #1fba57; transform: translateY(-2px); }
    .mensaje-ok {
      background: rgba(37,211,102,0.1);
      border: 1px solid rgba(37,211,102,0.3);
      border-radius: 6px; padding: 16px;
      color: #25D366;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.82rem; letter-spacing: 0.05em;
      margin-top: 16px; display: none;
    }
    @media (max-width: 768px) {
      .contacto-section { grid-template-columns: 1fr; padding: 100px 20px 60px; gap: 40px; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="contacto-section">

    <!-- IZQUIERDA -->
    <div class="contact-left">
      <div class="section-eyebrow">Contacto</div>
      <h1 class="contact-title">Hablemos<br>de tu <em>auto</em></h1>
      <p class="contact-desc">
        Completá el formulario o escribinos directo por WhatsApp. 
        Te respondemos rápido con un presupuesto personalizado para tu vehículo.
      </p>
      <div class="contact-info-item">
        <div class="contact-info-icon">&#128172;</div>
        <div>
          <div class="contact-info-label">WhatsApp</div>
          <div class="contact-info-value">11-23177778</div>
        </div>
      </div>
      <div class="contact-info-item">
        <div class="contact-info-icon">&#128247;</div>
        <div>
          <div class="contact-info-label">Instagram</div>
          <div class="contact-info-value">@hlchip.ok</div>
        </div>
      </div>
      <div class="contact-info-item">
        <div class="contact-info-icon">&#128205;</div>
        <div>
          <div class="contact-info-label">Ubicación</div>
          <div class="contact-info-value">Benavídez, Buenos Aires</div>
        </div>
      </div>
    </div>

    <!-- FORMULARIO -->
    <div class="contact-form">
      <div class="form-title">Envianos tu consulta</div>

      <div class="form-group">
        <label class="form-label">Nombre</label>
        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-input" placeholder="Tu nombre completo" />
      </div>
      <div class="form-group">
        <label class="form-label">Teléfono</label>
        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-input" placeholder="Tu número de WhatsApp" />
      </div>
      <div class="form-group">
        <label class="form-label">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="tu@email.com" TextMode="Email" />
      </div>
      <div class="form-group">
        <label class="form-label">Mensaje</label>
        <asp:TextBox ID="txtMensaje" runat="server" CssClass="form-textarea" 
            placeholder="Contanos tu vehículo y qué estás buscando..." TextMode="MultiLine" />
      </div>

      <asp:Button ID="btnEnviar" runat="server" Text="ENVIAR CONSULTA" 
          CssClass="btn-enviar" OnClick="btnEnviar_Click" />

      <asp:Panel ID="pnlOk" runat="server" CssClass="mensaje-ok" style="display:none;">
        ✓ Consulta enviada correctamente. Te contactamos a la brevedad.
      </asp:Panel>
    </div>

  </div>

</asp:Content>
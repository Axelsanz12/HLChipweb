<%@ Page Title="Cursos Presenciales" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Presenciales.aspx.cs" Inherits="HLchip.Cursos.Presenciales" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .presenciales-section {
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
    .presenciales-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2.5rem, 5vw, 4rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 12px;
    }
    .presenciales-title em { font-style: italic; color: #00aaff; }
    .presenciales-desc {
      color: #6b7280; font-size: 1rem;
      line-height: 1.75; font-weight: 300;
      margin-bottom: 60px; max-width: 560px;
    }
    /* CARDS */
    .talleres-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 28px;
    }
    .taller-card {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 12px; overflow: hidden;
      transition: all 0.3s;
    }
    .taller-card:hover {
      border-color: rgba(0,170,255,0.3);
      transform: translateY(-4px);
    }
    .taller-card-body { padding: 32px 28px; }
    .taller-fecha-badge {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(0,170,255,0.08);
      border: 1px solid rgba(0,170,255,0.2);
      border-radius: 4px; padding: 6px 12px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #00aaff;
      letter-spacing: 0.08em; margin-bottom: 20px;
    }
    .taller-nombre {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1.5rem;
      text-transform: uppercase; line-height: 1.1;
      margin-bottom: 12px; color: #fff;
    }
    .taller-desc {
      font-size: 0.88rem; color: #6b7280;
      line-height: 1.6; margin-bottom: 24px;
    }
    .taller-info {
      display: flex; flex-direction: column; gap: 10px;
      margin-bottom: 28px;
    }
    .taller-info-row {
      display: flex; align-items: center; gap: 10px;
      font-size: 0.85rem; color: #9ca3af;
    }
    .taller-info-icon {
      width: 28px; height: 28px; flex-shrink: 0;
      background: rgba(255,255,255,0.04);
      border-radius: 6px;
      display: flex; align-items: center; justify-content: center;
      font-size: 0.85rem;
    }
    .taller-card-footer {
      padding: 20px 28px;
      border-top: 1px solid rgba(255,255,255,0.05);
      display: flex; align-items: center; justify-content: space-between;
    }
    .taller-precio {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1.8rem; color: #fff;
    }
    .taller-precio small {
      display: block; font-size: 0.7rem; color: #6b7280;
      font-family: 'Share Tech Mono', monospace;
      font-weight: 400; letter-spacing: 0.05em;
    }
    .taller-cupos {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #febc2e;
      letter-spacing: 0.08em;
    }
    /* MODAL */
    .modal-overlay {
      position: fixed; inset: 0; z-index: 900;
      background: rgba(0,0,0,0.85);
      display: none; align-items: center; justify-content: center;
      padding: 20px;
    }
    .modal-overlay.open { display: flex; }
    .modal {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 12px; padding: 40px;
      width: 100%; max-width: 480px;
      position: relative;
    }
    .modal-close {
      position: absolute; top: 16px; right: 20px;
      background: none; border: none; color: #6b7280;
      font-size: 1.4rem; cursor: pointer; transition: color 0.2s;
    }
    .modal-close:hover { color: #fff; }
    .modal-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1.4rem;
      text-transform: uppercase; margin-bottom: 6px; color: #fff;
    }
    .modal-curso {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #00aaff;
      letter-spacing: 0.08em; margin-bottom: 28px;
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
      font-size: 0.95rem; transition: border-color 0.2s; outline: none;
    }
    .form-input:focus { border-color: #00aaff; }
    .btn-inscribir {
      width: 100%; background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 16px; cursor: pointer; transition: all 0.2s; margin-top: 8px;
    }
    .btn-inscribir:hover { background: #0099ee; }
    .btn-reservar {
      background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 0.9rem;
      letter-spacing: 0.08em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 10px 22px; cursor: pointer; transition: all 0.2s;
    }
    .btn-reservar:hover { background: #0099ee; transform: translateY(-2px); }
    .msg-ok {
      background: rgba(37,211,102,0.1);
      border: 1px solid rgba(37,211,102,0.3);
      border-radius: 8px; padding: 20px; color: #25D366;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem; letter-spacing: 0.05em;
      margin-top: 16px; line-height: 1.7; display: none;
    }
    @media (max-width: 768px) {
      .presenciales-section { padding: 100px 20px 60px; }
      .talleres-grid { grid-template-columns: 1fr; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="presenciales-section">
    <div class="section-eyebrow">Formación presencial</div>
    <h1 class="presenciales-title">Talleres<br><em>presenciales</em></h1>
    <p class="presenciales-desc">
      Aprendé chiptuning en el taller, con equipos reales y vehículos reales.
      Cupos limitados para garantizar atención personalizada.
    </p>

    <div class="talleres-grid">
      <asp:Repeater ID="rptTalleres" runat="server">
        <ItemTemplate>
          <div class="taller-card">
            <div class="taller-card-body">
              <div class="taller-fecha-badge">
                &#128197; <%# ((DateTime)Eval("Fecha")).ToString("dd/MM/yyyy") %>
                &nbsp;|&nbsp;
                &#9201; <%# Eval("HoraDesde").ToString().Substring(0,5) %> — <%# Eval("HoraHasta").ToString().Substring(0,5) %>
              </div>
              <div class="taller-nombre"><%# Eval("Nombre") %></div>
              <div class="taller-desc"><%# Eval("Descripcion") %></div>
              <div class="taller-info">
                <div class="taller-info-row">
                  <div class="taller-info-icon">&#128205;</div>
                  <%# Eval("Lugar") %>
                </div>
                <div class="taller-info-row">
                  <div class="taller-info-icon">&#128101;</div>
                  <%# Eval("Cupos") %> cupos disponibles
                </div>
              </div>
            </div>
            <div class="taller-card-footer">
              <div class="taller-precio">
                <small>Inversión</small>
                $<%# String.Format("{0:N0}", Eval("Precio")) %>
              </div>
              <button type="button" class="btn-reservar"
                onclick="abrirModal('<%# Eval("Id") %>', '<%# Eval("Nombre") %>')">
                Reservar lugar →
              </button>
            </div>
          </div>
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </div>

  <!-- MODAL -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <button type="button" class="modal-close" onclick="cerrarModal()">✕</button>
      <div class="modal-title">// Reservar lugar</div>
      <div class="modal-curso" id="modalCursoNombre"></div>

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
            placeholder="¿Alguna pregunta?" TextMode="MultiLine"
            Style="height:60px; resize:vertical;" />
      </div>

      <asp:HiddenField ID="hfIdCurso" runat="server" />
      <asp:Button ID="btnInscribir" runat="server" Text="CONFIRMAR RESERVA"
          CssClass="btn-inscribir" OnClick="btnInscribir_Click" />

      <div class="msg-ok" id="msgOk">
        ✓ ¡Reserva recibida!<br>
        Te contactamos por WhatsApp para coordinar el pago y los detalles.<br><br>
        <strong>11-23177778</strong>
      </div>
    </div>
  </div>

  <asp:Panel ID="pnlOk" runat="server" Visible="false">
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('modalOverlay').classList.add('open');
        document.getElementById('msgOk').style.display = 'block';
        document.getElementById('btnInscribir_btn') && (document.getElementById('btnInscribir_btn').style.display = 'none');
      });
    </script>
  </asp:Panel>

  <script>
    function abrirModal(id, nombre) {
      document.getElementById('MainContent_hfIdCurso').value = id;
      document.getElementById('modalCursoNombre').textContent = nombre;
      document.getElementById('modalOverlay').classList.add('open');
    }
    function cerrarModal() {
      document.getElementById('modalOverlay').classList.remove('open');
    }
    document.getElementById('modalOverlay').addEventListener('click', function(e) {
      if (e.target === this) cerrarModal();
    });
  </script>
</asp:Content>
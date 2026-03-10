<%@ Page Title="Pedir Mapa" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="NuevoPedido.aspx.cs" Inherits="HLchip.Mapas.NuevoPedido" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .mapas-section {
      min-height: 100vh;
      padding: 120px 48px 80px;
      display: grid;
      grid-template-columns: 1.2fr 1fr;
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
    .mapas-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2.5rem, 5vw, 4rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 20px;
    }
    .mapas-title em { font-style: italic; color: #00aaff; }
    .mapas-desc {
      color: #6b7280; font-size: 1rem;
      line-height: 1.75; font-weight: 300;
      margin-bottom: 36px;
    }
    .info-cards { display: flex; flex-direction: column; gap: 16px; }
    .info-card {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 8px; padding: 20px 24px;
      display: flex; gap: 16px; align-items: flex-start;
    }
    .info-card-icon {
      width: 40px; height: 40px; flex-shrink: 0;
      background: rgba(0,170,255,0.08);
      border: 1px solid rgba(0,170,255,0.2);
      border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.1rem;
    }
    .info-card-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      text-transform: uppercase; margin-bottom: 4px;
    }
    .info-card-text { font-size: 0.85rem; color: #6b7280; line-height: 1.5; }
    .pedido-form {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 8px; padding: 40px;
      position: sticky; top: 80px;
    }
    .form-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.3rem;
      text-transform: uppercase; margin-bottom: 28px; color: #fff;
    }
    .form-row {
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 16px; margin-bottom: 16px;
    }
    .form-group { margin-bottom: 16px; }
    .form-label {
      display: block;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #00aaff;
      letter-spacing: 0.1em; text-transform: uppercase;
      margin-bottom: 8px;
    }
    .form-input, .form-select {
      width: 100%; background: #050608;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 6px; padding: 13px 16px;
      color: #e8ecf0; font-family: 'Barlow', sans-serif;
      font-size: 0.95rem; transition: border-color 0.2s;
      outline: none; appearance: none;
    }
    .form-input:focus, .form-select:focus { border-color: #00aaff; }
    .form-select option { background: #0e1118; }
    .file-upload {
      width: 100%; background: #050608;
      border: 2px dashed rgba(0,170,255,0.2);
      border-radius: 6px; padding: 24px 16px;
      text-align: center; cursor: pointer;
      transition: all 0.2s;
    }
    .file-upload:hover { border-color: rgba(0,170,255,0.5); }
    .file-upload-text {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.75rem; color: #6b7280;
      letter-spacing: 0.05em; pointer-events: none;
    }
    .file-upload-text span { color: #00aaff; }
    .divisor {
      border: none; border-top: 1px solid rgba(255,255,255,0.07);
      margin: 24px 0;
    }
    .btn-enviar {
      width: 100%; background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 16px; cursor: pointer; transition: all 0.2s;
    }
    .btn-enviar:hover { background: #0099ee; transform: translateY(-2px); }
    .msg-ok {
      background: rgba(37,211,102,0.1);
      border: 1px solid rgba(37,211,102,0.3);
      border-radius: 8px; padding: 20px; color: #25D366;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem; letter-spacing: 0.05em;
      margin-top: 16px; line-height: 1.7;
    }
    @media (max-width: 768px) {
      .mapas-section { grid-template-columns: 1fr; padding: 100px 20px 60px; gap: 40px; }
      .form-row { grid-template-columns: 1fr; }
      .pedido-form { position: static; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="mapas-section">

    <!-- IZQUIERDA -->
    <div>
      <div class="section-eyebrow">Venta de Mapas</div>
      <h1 class="mapas-title">Pedí tu<br><em>mapa</em></h1>
      <p class="mapas-desc">
        Subí tu archivo ECU original y los datos de tu vehículo. 
        Procesamos tu mapa y te lo enviamos listo para cargar.
        Trabajamos con clientes de toda Argentina y el exterior.
      </p>
      <div class="info-cards">
        <div class="info-card">
          <div class="info-card-icon">&#128196;</div>
          <div>
            <div class="info-card-title">Subí tu archivo original</div>
            <div class="info-card-text">Leé tu ECU con Kess, Ktag, PCMFlash u otra herramienta y subí el archivo .bin o .hex</div>
          </div>
        </div>
        <div class="info-card">
          <div class="info-card-icon">&#9201;</div>
          <div>
            <div class="info-card-title">Tiempo de entrega</div>
            <div class="info-card-text">La mayoría de los mapas se entregan en menos de 24 horas. Te avisamos por WhatsApp cuando esté listo.</div>
          </div>
        </div>
        <div class="info-card">
          <div class="info-card-icon">&#128176;</div>
          <div>
            <div class="info-card-title">Precio por consulta</div>
            <div class="info-card-text">El precio varía según el vehículo y el tipo de mapa. Te cotizamos sin cargo antes de procesar.</div>
          </div>
        </div>
        <div class="info-card">
          <div class="info-card-icon">&#127758;</div>
          <div>
            <div class="info-card-title">Todo el mundo</div>
            <div class="info-card-text">Enviamos archivos digitales a cualquier país. Pagos por MercadoPago o transferencia.</div>
          </div>
        </div>
      </div>
    </div>

    <!-- DERECHA — FORMULARIO -->
    <div class="pedido-form">
      <div class="form-title">// Nuevo pedido</div>

      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Nombre</label>
          <asp:TextBox ID="txtNombre" runat="server" CssClass="form-input" placeholder="Tu nombre" />
        </div>
        <div class="form-group">
          <label class="form-label">WhatsApp</label>
          <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-input" placeholder="11-XXXXXXXX" />
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="tu@email.com" />
      </div>

      <hr class="divisor" />

      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Marca</label>
          <asp:DropDownList ID="ddlMarca" runat="server" CssClass="form-select">
          </asp:DropDownList>
        </div>
        <div class="form-group">
          <label class="form-label">Modelo</label>
          <asp:TextBox ID="txtModelo" runat="server" CssClass="form-input" placeholder="Ej: Gol, Kangoo, Hilux..." />
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Año</label>
          <asp:TextBox ID="txtAnio" runat="server" CssClass="form-input" placeholder="2020" />
        </div>
        <div class="form-group">
          <label class="form-label">Motor</label>
          <asp:TextBox ID="txtMotor" runat="server" CssClass="form-input" placeholder="2.0 TDI" />
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Tipo de mapa</label>
        <asp:DropDownList ID="ddlTipoMapa" runat="server" CssClass="form-select">
          <asp:ListItem Value="">-- Seleccioná --</asp:ListItem>
          <asp:ListItem Value="Stage 1 - Potenciación">Stage 1 — Potenciación</asp:ListItem>
          <asp:ListItem Value="EcoTuning">EcoTuning — Ahorro de combustible</asp:ListItem>
          <asp:ListItem Value="Pops & Bangs">Pops &amp; Bangs</asp:ListItem>
          <asp:ListItem Value="EGR OFF">EGR OFF</asp:ListItem>
          <asp:ListItem Value="DPF OFF">DPF OFF</asp:ListItem>
          <asp:ListItem Value="Urea OFF">Urea / AdBlue OFF</asp:ListItem>
          <asp:ListItem Value="Lambda OFF">Lambda OFF</asp:ListItem>
          <asp:ListItem Value="DTC OFF">DTC OFF</asp:ListItem>
        </asp:DropDownList>
      </div>

      <div class="form-group">
        <label class="form-label">Archivo ECU original</label>
        <div class="file-upload" id="uploadBox">
          <div class="file-upload-text">
            &#128196; <span>Hacé click para subir</span> tu archivo .bin / .hex / .ori
          </div>
          <asp:FileUpload ID="fileECU" runat="server" Style="display:none;" />
        </div>
        <div id="fileName" style="font-family:'Share Tech Mono',monospace; font-size:0.72rem; color:#00aaff; margin-top:8px;"></div>
      </div>

      <div class="form-group">
        <label class="form-label">Observaciones</label>
        <asp:TextBox ID="txtObs" runat="server" CssClass="form-input" 
            placeholder="Contanos qué resultado estás buscando..." TextMode="MultiLine" 
            Style="height:80px; resize:vertical;" />
      </div>

      <asp:Button ID="btnEnviar" runat="server" Text="ENVIAR PEDIDO" 
          CssClass="btn-enviar" OnClick="btnEnviar_Click" />

      <asp:Panel ID="pnlOk" runat="server" Visible="false">
        <div class="msg-ok">
          ✓ Pedido recibido correctamente.<br>
          Te contactamos por WhatsApp a la brevedad con la cotización.<br><br>
          <strong>11-23177778</strong>
        </div>
      </asp:Panel>
    </div>
  </div>

  <script>
      document.addEventListener('DOMContentLoaded', function () {
          var uploadBox = document.getElementById('uploadBox');
          var fileInput = uploadBox.querySelector('input[type="file"]');

          uploadBox.addEventListener('click', function () {
              fileInput.click();
          });

          fileInput.addEventListener('change', function () {
              var name = this.files[0] ? this.files[0].name : '';
              document.getElementById('fileName').textContent = name ? '&#128206; ' + name : '';
          });
      });
  </script>
</asp:Content>
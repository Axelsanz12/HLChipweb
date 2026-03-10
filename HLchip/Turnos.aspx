<%@ Page Title="Turnos" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Turnos.aspx.cs" Inherits="HLchip.Turnos" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .turnos-section {
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
    .turnos-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2.5rem, 5vw, 4rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 12px;
    }
    .turnos-title em { font-style: italic; color: #00aaff; }
    .turnos-desc {
      color: #6b7280; font-size: 1rem;
      line-height: 1.75; font-weight: 300;
      margin-bottom: 48px; max-width: 520px;
    }
    /* STEPS */
    .steps {
      display: flex; gap: 0;
      margin-bottom: 48px;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 8px; overflow: hidden;
    }
    .step {
      flex: 1; padding: 16px 20px;
      display: flex; align-items: center; gap: 12px;
      background: #0e1118;
      border-right: 1px solid rgba(255,255,255,0.07);
      opacity: 0.4; transition: all 0.3s;
    }
    .step:last-child { border-right: none; }
    .step.active { opacity: 1; background: #111520; }
    .step.done { opacity: 0.7; }
    .step-num {
      width: 28px; height: 28px;
      border-radius: 50%;
      background: rgba(0,170,255,0.1);
      border: 1px solid rgba(0,170,255,0.3);
      color: #00aaff;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.75rem;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
    }
    .step.active .step-num {
      background: #00aaff; color: #000; border-color: #00aaff;
    }
    .step.done .step-num {
      background: #25D366; color: #000; border-color: #25D366;
    }
    .step-label {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.9rem;
      text-transform: uppercase; letter-spacing: 0.05em;
      color: #e8ecf0;
    }
    /* PANELS */
    .panel {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 8px; padding: 40px;
      display: none;
    }
    .panel.active { display: block; }
    .panel-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.3rem;
      text-transform: uppercase; margin-bottom: 28px;
      color: #fff;
    }
    /* TIPO TRABAJO */
    .tipos-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
    }
    .tipo-card {
      background: #050608;
      border: 2px solid rgba(255,255,255,0.07);
      border-radius: 8px; padding: 24px;
      cursor: pointer; transition: all 0.2s;
      position: relative;
    }
    .tipo-card:hover { border-color: rgba(0,170,255,0.4); }
    .tipo-card.selected {
      border-color: #00aaff;
      background: rgba(0,170,255,0.05);
    }
    .tipo-card.selected::after {
      content: '✓';
      position: absolute; top: 12px; right: 16px;
      color: #00aaff;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.9rem;
    }
    .tipo-nombre {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.1rem;
      text-transform: uppercase; margin-bottom: 6px;
      color: #fff;
    }
    .tipo-duracion {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #00aaff;
      letter-spacing: 0.08em; margin-bottom: 8px;
    }
    .tipo-desc { font-size: 0.85rem; color: #6b7280; line-height: 1.5; }
    /* CALENDARIO */
    .calendario {
      display: grid;
      grid-template-columns: repeat(7, 1fr);
      gap: 8px; margin-bottom: 28px;
    }
    .cal-header {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.65rem; color: #6b7280;
      text-align: center; padding: 8px 0;
      letter-spacing: 0.08em; text-transform: uppercase;
    }
    .cal-day {
      aspect-ratio: 1;
      display: flex; align-items: center; justify-content: center;
      border-radius: 6px;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 1rem;
      cursor: pointer; transition: all 0.2s;
      border: 1px solid transparent;
    }
    .cal-day.empty { cursor: default; }
    .cal-day.disponible {
      background: #050608;
      border-color: rgba(255,255,255,0.07);
      color: #e8ecf0;
    }
    .cal-day.disponible:hover { border-color: #00aaff; color: #00aaff; }
    .cal-day.selected { background: #00aaff; color: #000; border-color: #00aaff; }
    .cal-day.pasado { color: #333; cursor: not-allowed; }
    .cal-day.hoy { border-color: rgba(0,170,255,0.4); color: #00aaff; }
    .cal-nav {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 20px;
    }
    .cal-nav-btn {
      background: #050608; border: 1px solid rgba(255,255,255,0.1);
      color: #e8ecf0; padding: 8px 16px; border-radius: 6px;
      cursor: pointer; font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.9rem; transition: all 0.2s;
    }
    .cal-nav-btn:hover { border-color: #00aaff; color: #00aaff; }
    .cal-mes {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.2rem;
      text-transform: uppercase; letter-spacing: 0.05em;
    }
    /* HORARIOS */
    .horarios-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 10px; margin-top: 20px;
    }
    .horario-btn {
      background: #050608;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 6px; padding: 12px;
      color: #e8ecf0; cursor: pointer;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem; text-align: center;
      transition: all 0.2s;
    }
    .horario-btn:hover { border-color: #00aaff; color: #00aaff; }
    .horario-btn.selected { background: #00aaff; color: #000; border-color: #00aaff; }
    .horario-btn.ocupado { opacity: 0.3; cursor: not-allowed; border-color: transparent; }
    /* FORM DATOS */
    .form-grid {
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .form-group { margin-bottom: 0; }
    .form-group.full { grid-column: 1 / -1; }
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
    /* RESUMEN */
    .resumen {
      background: #050608;
      border: 1px solid rgba(0,170,255,0.2);
      border-radius: 8px; padding: 24px;
      margin-bottom: 24px;
    }
    .resumen-title {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #00aaff;
      letter-spacing: 0.12em; text-transform: uppercase;
      margin-bottom: 16px;
    }
    .resumen-row {
      display: flex; justify-content: space-between;
      padding: 10px 0;
      border-bottom: 1px solid rgba(255,255,255,0.05);
      font-size: 0.9rem;
    }
    .resumen-row:last-child { border-bottom: none; }
    .resumen-key { color: #6b7280; }
    .resumen-val { color: #e8ecf0; font-weight: 500; }
    /* BOTONES NAV */
    .btn-siguiente {
      background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 14px 36px; cursor: pointer;
      transition: all 0.2s; margin-top: 28px;
    }
    .btn-siguiente:hover { background: #0099ee; transform: translateY(-2px); }
    .btn-volver {
      background: transparent;
      border: 1px solid rgba(255,255,255,0.1);
      color: #6b7280;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border-radius: 6px; padding: 13px 28px;
      cursor: pointer; transition: all 0.2s;
      margin-top: 28px; margin-right: 12px;
    }
    .btn-volver:hover { border-color: #00aaff; color: #00aaff; }
    .btn-confirmar {
      background: #25D366; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 14px 36px; cursor: pointer;
      transition: all 0.2s; margin-top: 28px;
    }
    .btn-confirmar:hover { background: #1fba57; transform: translateY(-2px); }
    .msg-ok {
      background: rgba(37,211,102,0.1);
      border: 1px solid rgba(37,211,102,0.3);
      border-radius: 8px; padding: 32px;
      text-align: center; display: none;
    }
    .msg-ok-icon { font-size: 3rem; margin-bottom: 16px; }
    .msg-ok-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2rem;
      text-transform: uppercase; color: #25D366;
      margin-bottom: 12px;
    }
    .msg-ok-text { color: #6b7280; font-size: 0.95rem; line-height: 1.7; }
    @media (max-width: 768px) {
      .turnos-section { padding: 100px 20px 60px; }
      .tipos-grid { grid-template-columns: 1fr; }
      .horarios-grid { grid-template-columns: repeat(3, 1fr); }
      .form-grid { grid-template-columns: 1fr; }
      .steps { flex-wrap: wrap; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="turnos-section">
    <div class="section-eyebrow">Agenda online</div>
    <h1 class="turnos-title">Sacá tu <em>turno</em></h1>
    <p class="turnos-desc">Elegí el servicio, la fecha y el horario que mejor te quede. Te confirmamos por WhatsApp.</p>

    <!-- STEPS -->
    <div class="steps">
      <div class="step active" id="step1"><div class="step-num">1</div><div class="step-label">Servicio</div></div>
      <div class="step" id="step2"><div class="step-num">2</div><div class="step-label">Fecha</div></div>
      <div class="step" id="step3"><div class="step-num">3</div><div class="step-label">Horario</div></div>
      <div class="step" id="step4"><div class="step-num">4</div><div class="step-label">Tus datos</div></div>
    </div>

    <!-- PANEL 1 — TIPO DE TRABAJO -->
    <div class="panel active" id="panel1">
      <div class="panel-title">¿Qué servicio necesitás?</div>
      <div class="tipos-grid">
        <asp:Repeater ID="rptTipos" runat="server">
          <ItemTemplate>
            <div class="tipo-card" onclick="seleccionarTipo(<%# Eval("Id") %>, '<%# Eval("Nombre") %>', <%# Eval("Duracion") %>)" id="tipo_<%# Eval("Id") %>">
              <div class="tipo-nombre"><%# Eval("Nombre") %></div>
              <div class="tipo-duracion">&#9201; <%# Eval("Duracion") %> minutos</div>
              <div class="tipo-desc"><%# Eval("Descripcion") %></div>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
     <button type="button" class="btn-siguiente" onclick="irPanel(2)" id="btnSig1" style="display:none;">Elegir fecha →</button>
    </div>

    <!-- PANEL 2 — CALENDARIO -->
    <div class="panel" id="panel2">
      <div class="panel-title">Elegí una fecha</div>
      <div class="cal-nav">
        <button type="button" class="cal-nav-btn" onclick="cambiarMes(-1)">← Anterior</button>
        <div class="cal-mes" id="calMes"></div>
        <button type="button" class="cal-nav-btn" onclick="cambiarMes(1)">Siguiente →</button>
      </div>
      <div class="calendario" id="calendario"></div>
    <button type="button" class="cal-nav-btn" ... onclick="irPanel(1)">← Volver</button>
    </div>

    <!-- PANEL 3 — HORARIOS -->
    <div class="panel" id="panel3">
      <div class="panel-title" id="panel3Title">Horarios disponibles</div>
      <div class="horarios-grid" id="horariosGrid"></div>
      <button type="button" class="cal-nav-btn" ... onclick="irPanel(2)">← Volver</button>
    </div>

    <!-- PANEL 4 — DATOS -->
    <div class="panel" id="panel4">
      <div class="panel-title">Tus datos</div>
      <div class="resumen" id="resumenTurno"></div>
      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Nombre completo</label>
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
          <label class="form-label">Vehículo</label>
          <asp:TextBox ID="txtVehiculo" runat="server" CssClass="form-input" placeholder="Ej: VW Amarok 2020" />
        </div>
        <div class="form-group full">
          <label class="form-label">Observaciones</label>
          <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-input" placeholder="Contanos algo más sobre tu vehículo..." />
        </div>
      </div>
      <asp:HiddenField ID="hfTipoId" runat="server" />
      <asp:HiddenField ID="hfFecha" runat="server" />
      <asp:HiddenField ID="hfHora" runat="server" />
     <button type="button" class="btn-volver" onclick="irPanel(3)">← Volver</button>
      <asp:Button ID="btnConfirmar" runat="server" Text="CONFIRMAR TURNO" 
          CssClass="btn-confirmar" OnClick="btnConfirmar_Click" />
    </div>

    <!-- CONFIRMACIÓN -->
    <div class="msg-ok" id="msgOk">
      <div class="msg-ok-icon">&#9989;</div>
      <div class="msg-ok-title">¡Turno solicitado!</div>
      <p class="msg-ok-text">
        Recibimos tu solicitud. Te vamos a confirmar el turno por WhatsApp a la brevedad.<br><br>
        <strong>11-23177778</strong>
      </p>
    </div>
  <asp:Panel ID="pnlOk" runat="server" Visible="false">
  <script>
      document.addEventListener('DOMContentLoaded', function () {
          document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
          document.getElementById('msgOk').style.display = 'block';
          document.querySelector('.steps').style.display = 'none';
      });
  </script>
</asp:Panel>

  </div>

  <script>
    let tipoSeleccionado = null;
    let fechaSeleccionada = null;
    let horaSeleccionada = null;
    let mesActual = new Date().getMonth();
    let anioActual = new Date().getFullYear();
    const meses = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
    const dias = ['Dom','Lun','Mar','Mié','Jue','Vie','Sáb'];

    function seleccionarTipo(id, nombre, duracion) {
      tipoSeleccionado = { id, nombre, duracion };
      document.querySelectorAll('.tipo-card').forEach(c => c.classList.remove('selected'));
      document.getElementById('tipo_' + id).classList.add('selected');
      document.getElementById('btnSig1').style.display = 'inline-block';
    }

    function irPanel(n) {
      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
      document.getElementById('panel' + n).classList.add('active');
      document.querySelectorAll('.step').forEach((s, i) => {
        s.classList.remove('active', 'done');
        if (i + 1 < n) s.classList.add('done');
        if (i + 1 === n) s.classList.add('active');
      });
      if (n === 2) renderCalendario();
      if (n === 4) renderResumen();
    }

    function cambiarMes(dir) {
      mesActual += dir;
      if (mesActual > 11) { mesActual = 0; anioActual++; }
      if (mesActual < 0) { mesActual = 11; anioActual--; }
      renderCalendario();
    }

    function renderCalendario() {
      const cal = document.getElementById('calendario');
      document.getElementById('calMes').textContent = meses[mesActual] + ' ' + anioActual;
      cal.innerHTML = '';
      dias.forEach(d => { cal.innerHTML += '<div class="cal-header">' + d + '</div>'; });
      const primer = new Date(anioActual, mesActual, 1).getDay();
      const totalDias = new Date(anioActual, mesActual + 1, 0).getDate();
      const hoy = new Date(); hoy.setHours(0,0,0,0);
      for (let i = 0; i < primer; i++) cal.innerHTML += '<div class="cal-day empty"></div>';
      for (let d = 1; d <= totalDias; d++) {
        const fecha = new Date(anioActual, mesActual, d);
        const diasSemana = fecha.getDay();
        let cls = 'cal-day';
        if (fecha < hoy || diasSemana === 0) { cls += ' pasado'; cal.innerHTML += '<div class="' + cls + '">' + d + '</div>'; continue; }
        if (fecha.getTime() === hoy.getTime()) cls += ' hoy';
        else cls += ' disponible';
        const fechaStr = anioActual + '-' + String(mesActual+1).padStart(2,'0') + '-' + String(d).padStart(2,'0');
        cal.innerHTML += '<div class="' + cls + '" onclick="seleccionarFecha(\'' + fechaStr + '\', this)">' + d + '</div>';
      }
    }

    function seleccionarFecha(fecha, el) {
      if (el.classList.contains('pasado')) return;
      fechaSeleccionada = fecha;
      document.querySelectorAll('.cal-day').forEach(c => c.classList.remove('selected'));
      el.classList.add('selected');
      setTimeout(() => irPanel(3), 300);
      cargarHorarios(fecha);
    }

    function cargarHorarios(fecha) {
      const grid = document.getElementById('horariosGrid');
      const titulo = document.getElementById('panel3Title');
      const partes = fecha.split('-');
      const fechaObj = new Date(partes[0], partes[1]-1, partes[2]);
      const diasSemana = ['Dom','Lun','Mar','Mié','Jue','Vie','Sáb'];
      const mesesCortos = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
      titulo.textContent = 'Horarios — ' + diasSemana[fechaObj.getDay()] + ' ' + fechaObj.getDate() + ' ' + mesesCortos[fechaObj.getMonth()];
      grid.innerHTML = '';
      const horarios = ['09:00','09:30','10:00','10:30','11:00','11:30','12:00','12:30','14:00','14:30','15:00','15:30','16:00','16:30','17:00','17:30'];
      horarios.forEach(h => {
        grid.innerHTML += '<div class="horario-btn" onclick="seleccionarHora(\'' + h + '\', this)">' + h + '</div>';
      });
    }

    function seleccionarHora(hora, el) {
      if (el.classList.contains('ocupado')) return;
      horaSeleccionada = hora;
      document.querySelectorAll('.horario-btn').forEach(b => b.classList.remove('selected'));
      el.classList.add('selected');
      setTimeout(() => irPanel(4), 300);
    }

    function renderResumen() {
      document.getElementById('resumenTurno').innerHTML =
        '<div class="resumen-title">// Resumen del turno</div>' +
        '<div class="resumen-row"><span class="resumen-key">Servicio</span><span class="resumen-val">' + tipoSeleccionado.nombre + '</span></div>' +
        '<div class="resumen-row"><span class="resumen-key">Duración</span><span class="resumen-val">' + tipoSeleccionado.duracion + ' min</span></div>' +
        '<div class="resumen-row"><span class="resumen-key">Fecha</span><span class="resumen-val">' + fechaSeleccionada + '</span></div>' +
        '<div class="resumen-row"><span class="resumen-key">Hora</span><span class="resumen-val">' + horaSeleccionada + '</span></div>';
      document.getElementById('MainContent_hfTipoId').value = tipoSeleccionado.id;
      document.getElementById('MainContent_hfFecha').value = fechaSeleccionada;
      document.getElementById('MainContent_hfHora').value = horaSeleccionada;
    }

    renderCalendario();
  </script>

</asp:Content>
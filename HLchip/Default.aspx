<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HLchip.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    /* HERO */
    .hero {
      min-height: 100vh;
      position: relative;
      display: flex; align-items: center;
      overflow: hidden; padding: 64px 0 0;
    }
    .hero-grid {
      position: absolute; inset: 0;
      background-image:
        linear-gradient(rgba(0,170,255,0.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0,170,255,0.04) 1px, transparent 1px);
      background-size: 60px 60px;
      animation: gridMove 20s linear infinite;
    }
    @keyframes gridMove {
      from { transform: translateY(0); }
      to { transform: translateY(60px); }
    }
    .hero-glow {
      position: absolute; top: 20%; right: 15%;
      width: 500px; height: 500px;
      background: radial-gradient(circle, rgba(0,170,255,0.08) 0%, transparent 65%);
      pointer-events: none;
    }
    .hero-content {
      position: relative; z-index: 2;
      padding: 0 48px; max-width: 820px;
    }
    .hero-tag {
      display: inline-flex; align-items: center; gap: 8px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.78rem; color: #00aaff;
      letter-spacing: 0.12em; text-transform: uppercase;
      margin-bottom: 24px;
    }
    .hero-tag-dot {
      width: 6px; height: 6px; border-radius: 50%;
      background: #ff1e1e;
      animation: pulse 1.5s ease-in-out infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; } 50% { opacity: 0.4; }
    }
    .hero-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(5rem, 12vw, 10rem);
      line-height: 0.88; letter-spacing: -0.02em;
      text-transform: uppercase; margin-bottom: 8px;
    }
    .hero-title .outline {
      color: transparent;
      -webkit-text-stroke: 2px rgba(255,255,255,0.15);
    }
    .hero-title .blue { color: #00aaff; }
    .hero-sub {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700;
      font-size: clamp(1.2rem, 2.5vw, 1.8rem);
      letter-spacing: 0.15em; text-transform: uppercase;
      color: #6b7280; margin-bottom: 28px;
    }
    .hero-desc {
      font-size: 1.05rem; color: #6b7280;
      max-width: 500px; line-height: 1.75;
      font-weight: 300; margin-bottom: 40px;
    }
    .hero-desc strong { color: #e8ecf0; font-weight: 500; }
    .hero-actions { display: flex; gap: 16px; flex-wrap: wrap; }
    .btn-main {
      display: inline-flex; align-items: center; gap: 10px;
      background: #25D366; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      text-decoration: none; padding: 16px 36px;
      border-radius: 4px; transition: all 0.2s;
    }
    .btn-main:hover { background: #1fba57; transform: translateY(-2px); }
    .btn-outline {
      display: inline-flex; align-items: center; gap: 10px;
      border: 2px solid rgba(0,170,255,0.4); color: #00aaff;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      text-decoration: none; padding: 14px 32px;
      border-radius: 4px; transition: all 0.2s;
    }
    .btn-outline:hover { border-color: #00aaff; background: rgba(0,170,255,0.08); }
    /* STATS */
    .stats-bar {
      display: flex;
      border-top: 1px solid rgba(255,255,255,0.07);
      border-bottom: 1px solid rgba(255,255,255,0.07);
      background: rgba(10,12,16,0.8);
    }
    .stat-item {
      flex: 1; padding: 28px 32px;
      border-right: 1px solid rgba(255,255,255,0.07);
    }
    .stat-item:last-child { border-right: none; }
    .stat-num {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2.5rem;
      color: #00aaff; line-height: 1;
    }
    .stat-num span { color: #ff1e1e; }
    .stat-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #6b7280;
      letter-spacing: 0.1em; text-transform: uppercase;
      margin-top: 6px;
    }
    /* SERVICIOS */
    .servicios-section {
      background: #0a0c10;
      border-top: 1px solid rgba(255,255,255,0.07);
      padding: 100px 48px;
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
    .section-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900;
      font-size: clamp(2.5rem, 5vw, 4rem);
      text-transform: uppercase; line-height: 0.95;
      margin-bottom: 16px;
    }
    .section-title em { font-style: italic; color: #00aaff; }
    .section-desc {
      color: #6b7280; font-size: 1rem;
      max-width: 500px; line-height: 1.7;
      font-weight: 300; margin-bottom: 52px;
    }
    .services-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 2px; background: rgba(255,255,255,0.07);
      border: 1px solid rgba(255,255,255,0.07);
    }
    .service-card {
      background: #0e1118; padding: 40px 32px;
      position: relative; overflow: hidden;
      transition: all 0.3s;
    }
    .service-card::before {
      content: '';
      position: absolute; bottom: 0; left: 0; right: 0; height: 2px;
      background: linear-gradient(90deg, #00aaff, #ff1e1e);
      transform: scaleX(0); transform-origin: left;
      transition: transform 0.4s;
    }
    .service-card:hover { background: #111520; }
    .service-card:hover::before { transform: scaleX(1); }
    .service-number {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 4rem;
      color: rgba(0,170,255,0.05);
      position: absolute; top: 16px; right: 24px;
      line-height: 1;
    }
    .service-icon { font-size: 2rem; margin-bottom: 20px; display: block; }
    .service-name {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1.4rem;
      text-transform: uppercase; margin-bottom: 10px; color: #fff;
    }
    .service-desc { font-size: 0.9rem; color: #6b7280; line-height: 1.65; }
    @media (max-width: 768px) {
      .hero-content { padding: 0 20px; }
      .services-grid { grid-template-columns: 1fr; }
      .stats-bar { flex-wrap: wrap; }
      .stat-item { flex: 0 0 50%; }
      .servicios-section { padding: 72px 20px; }
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

  <!-- HERO -->
  <div class="hero">
    <div class="hero-grid"></div>
    <div class="hero-glow"></div>
    <div class="hero-content">
      <div class="hero-tag">
        <div class="hero-tag-dot"></div>
        Benavídez, Buenos Aires — Argentina
      </div>
      <h1 class="hero-title">
        HL<span class="blue">chip</span><br>
        <span class="outline">Potencia</span><br>
        <span class="outline">ción</span>
      </h1>
      <p class="hero-sub">Chiptuning · Reprogramación · Performance</p>
      <p class="hero-desc">
        Aumentamos la <strong>potencia y el torque</strong> de tu vehículo 
        mediante reprogramación electrónica de la ECU. Especialistas en 
        <strong>EGR, DPF, Lambda, Pops&Bangs</strong> y EcoTuning.
      </p>
      <div class="hero-actions">
        <a href="https://wa.me/541123177778" target="_blank" class="btn-main">
          💬 Pedir Presupuesto
        </a>
        <a href="#servicios" class="btn-outline">Ver Servicios</a>
      </div>
    </div>
  </div>

  <!-- STATS -->
  <div class="stats-bar">
    <div class="stat-item">
      <div class="stat-num">10<span>.5K</span></div>
      <div class="stat-label">Seguidores Instagram</div>
    </div>
    <div class="stat-item">
      <div class="stat-num">+<span>30%</span></div>
      <div class="stat-label">Potencia promedio ganada</div>
    </div>
    <div class="stat-item">
      <div class="stat-num">176</div>
      <div class="stat-label">Trabajos publicados</div>
    </div>
    <div class="stat-item">
      <div class="stat-num" style="color:#25D366;">11</div>
      <div class="stat-label">23177778 — WhatsApp</div>
    </div>
  </div>

  <!-- SERVICIOS DESDE BASE DE DATOS -->
  <div class="servicios-section" id="servicios">
    <div class="section-eyebrow">Servicios</div>
    <h2 class="section-title">Lo que <em>hacemos</em></h2>
    <p class="section-desc">Trabajamos sobre la ECU de tu vehículo para liberar el potencial que el fabricante limita por defecto.</p>
    <div class="services-grid">
      <asp:Repeater ID="rptServicios" runat="server">
        <ItemTemplate>
          <div class="service-card">
            <div class="service-number">0<%# Container.ItemIndex + 1 %></div>
            <span class="service-icon"><%# Eval("Icono") %></span>
            <div class="service-name"><%# Eval("Nombre") %></div>
            <p class="service-desc"><%# Eval("Descripcion") %></p>
          </div>
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </div>

</asp:Content>
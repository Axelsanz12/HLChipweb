<%@ Page Title="Curso" Language="C#" MasterPageFile="~/Campus/Campus.Master"
    AutoEventWireup="true" CodeBehind="Curso.aspx.cs" Inherits="HLchip.Campus.Curso" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .curso-section { min-height: 100vh; padding: 90px 48px 80px; position: relative; z-index: 1; }
    .curso-header {
      margin-bottom: 40px; padding-bottom: 24px;
      border-bottom: 1px solid rgba(255,255,255,0.07);
    }
    .back-link {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.72rem; color: #6b7280;
      text-decoration: none; letter-spacing: 0.08em;
      display: inline-block; margin-bottom: 16px;
      transition: color 0.2s;
    }
    .back-link:hover { color: #00aaff; }
    .curso-titulo {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2.2rem; text-transform: uppercase;
    }
    .curso-layout {
      display: grid; grid-template-columns: 1fr 320px;
      gap: 32px; align-items: start;
    }
    /* VIDEO */
    .video-container {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 10px; overflow: hidden;
    }
    .video-wrapper {
      position: relative; padding-top: 56.25%;
      background: #000;
    }
    .video-wrapper iframe {
      position: absolute; top:0; left:0;
      width: 100%; height: 100%; border: none;
    }
    .video-info { padding: 20px 24px; }
    .video-titulo {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 1.3rem; margin-bottom: 6px;
    }
    .video-desc { font-size: 0.85rem; color: #9ca3af; line-height: 1.6; }
    .btn-completar {
      margin-top: 16px;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.85rem;
      letter-spacing: 0.08em; text-transform: uppercase;
      background: transparent; border: 1px solid rgba(0,170,255,0.3);
      color: #00aaff; padding: 10px 20px; border-radius: 6px;
      cursor: pointer; transition: all 0.2s;
    }
    .btn-completar:hover { background: rgba(0,170,255,0.1); }
    .btn-completado {
      background: rgba(0,255,100,0.1);
      border-color: rgba(0,255,100,0.3);
      color: #00ff64;
    }
    /* SIDEBAR */
    .sidebar { display: flex; flex-direction: column; gap: 20px; }
    .sidebar-box {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 10px; overflow: hidden;
    }
    .sidebar-title {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 700; font-size: 0.9rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      padding: 14px 20px;
      border-bottom: 1px solid rgba(255,255,255,0.07);
      color: #6b7280;
    }
    /* LECCIONES */
    .leccion-item {
      padding: 12px 20px;
      border-bottom: 1px solid rgba(255,255,255,0.04);
      cursor: pointer; transition: background 0.2s;
      display: flex; align-items: center; gap: 10px;
    }
    .leccion-item:hover { background: rgba(255,255,255,0.03); }
    .leccion-item.activa { background: rgba(0,170,255,0.08); }
    .leccion-num {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.65rem; color: #6b7280;
      min-width: 20px;
    }
    .leccion-nombre { font-size: 0.85rem; flex: 1; }
    .leccion-check { color: #00ff64; font-size: 0.8rem; }
    /* ARCHIVOS */
    .archivo-item {
      padding: 12px 20px;
      border-bottom: 1px solid rgba(255,255,255,0.04);
      display: flex; align-items: center; gap: 10px;
    }
    .archivo-icon { color: #00aaff; font-size: 0.9rem; }
    .archivo-link {
      font-size: 0.85rem; color: #e8ecf0;
      text-decoration: none; flex: 1;
      transition: color 0.2s;
    }
    .archivo-link:hover { color: #00aaff; }
    .progreso-bar {
      background: rgba(255,255,255,0.05);
      border-radius: 100px; height: 6px; margin: 0 20px 16px;
    }
    .progreso-fill {
      background: #00aaff; height: 6px; border-radius: 100px;
    }
    .progreso-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.68rem; color: #6b7280;
      padding: 12px 20px 0; display: block;
    }
    
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">


  <div class="campus-watermark" id="watermark"></div>

  <div class="curso-section">
    <div class="curso-header">
      <a href="/Campus/MisCursos.aspx" class="back-link">← Volver a mis cursos</a>
      <div class="curso-titulo"><asp:Literal ID="litTitulo" runat="server" /></div>
    </div>

    <div class="curso-layout">

     
      <div>
        <div class="video-container">
          <div class="video-wrapper">
            <asp:Literal ID="litVideo" runat="server" />
           
            <div class="video-watermark" id="videoWatermark"></div>
          </div>
          <div class="video-info">
            <div class="video-titulo"><asp:Literal ID="litLeccionTitulo" runat="server" /></div>
            <div class="video-desc"><asp:Literal ID="litLeccionDesc" runat="server" /></div>
            <asp:Button ID="btnCompletar" runat="server" Text="MARCAR COMO COMPLETADA"
                CssClass="btn-completar" OnClick="btnCompletar_Click" />
            <a href="/Campus/Foro.aspx?curso=<%# CursoId %>" 
               style="display:inline-block;margin-top:12px;font-family:'Share Tech Mono',monospace;font-size:0.75rem;color:#00aaff;">
               💬 Ver foro del curso →
            </a>
          </div>
        </div>
      </div>

      <!-- SIDEBAR -->
      <div class="sidebar">

        <!-- PROGRESO -->
        <div class="sidebar-box">
          <span class="progreso-label">Progreso del curso</span>
          <div class="progreso-bar" style="margin-top:10px;">
            <div class="progreso-fill" style="width:<%# Progreso %>%"></div>
          </div>
        </div>

        <!-- LECCIONES -->
        <div class="sidebar-box">
          <div class="sidebar-title">📚 Lecciones</div>
          <asp:Repeater ID="rptLecciones" runat="server">
            <ItemTemplate>
              <div class="leccion-item <%# (int)Eval("Id") == LeccionActualId ? "activa" : "" %>"
                   onclick="location.href='/Campus/Cursos.aspx?id=<%# CursoId %>&leccion=<%# Eval("Id") %>'">
                <span class="leccion-num"><%# Eval("Orden") %></span>
                <span class="leccion-nombre"><%# Eval("Titulo") %></span>
                <span class="leccion-check"><%# (bool)Eval("Completada") ? "✓" : "" %></span>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>

        <!-- ARCHIVOS -->
        <div class="sidebar-box">
          <div class="sidebar-title">📎 Materiales</div>
          <asp:Repeater ID="rptArchivos" runat="server">
            <ItemTemplate>
              <div class="archivo-item">
                <span class="archivo-icon">⬇</span>
                <a href="/Uploads/Cursos/<%# Eval("Archivo") %>" 
                   class="archivo-link" target="_blank"><%# Eval("Nombre") %></a>
              </div>
            </ItemTemplate>
          </asp:Repeater>
          <asp:Panel ID="pnlSinArchivos" runat="server" Visible="false">
            <div style="padding:16px 20px;font-size:0.8rem;color:#6b7280;">Sin materiales cargados.</div>
          </asp:Panel>
        </div>

      </div>
    </div>
  </div>
</asp:Content>

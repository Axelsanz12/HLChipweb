<%@ Page Title="Foro" Language="C#" MasterPageFile="~/Campus/Campus.Master"
    AutoEventWireup="true" CodeBehind="Foro.aspx.cs" Inherits="HLchip.Campus.Foro" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .foro-resp-admin {
    background: rgba(0,170,255,0.08);
    border-left: 4px solid #00aaff;
    color: #e8ecf0;
    }
    .foro-resp-alumno {
        background: rgba(37,211,102,0.05);
        border-left: 4px solid #25D366;
}
    .foro-section { min-height:100vh; padding:90px 48px 80px; max-width:860px; margin:0 auto; }
    .foro-header { margin-bottom:32px; padding-bottom:20px; border-bottom:1px solid rgba(255,255,255,0.07); }
    .foro-titulo { font-family:'Barlow Condensed',sans-serif; font-weight:900; font-size:2rem; text-transform:uppercase; }
    .foro-titulo span { color:#00aaff; }
    .foro-subtitulo { font-family:'Share Tech Mono',monospace; font-size:0.72rem; color:#6b7280; margin-top:4px; }

    .foro-buscar { margin-bottom:28px; }
    .foro-buscar input {
        width:100%; padding:12px 16px;
        background:#0e1118; border:1px solid rgba(255,255,255,0.08);
        border-radius:8px; color:#e8ecf0; font-size:0.88rem; outline:none;
        box-sizing:border-box; transition:border-color 0.2s;
    }
    .foro-buscar input:focus { border-color:#00aaff; }

    .foro-nueva { 
        background:#0e1118; border:1px solid rgba(0,170,255,0.2);
        border-radius:10px; padding:20px 24px; margin-bottom:28px;
    }
    .foro-nueva-titulo { font-family:'Barlow Condensed',sans-serif; font-weight:700; font-size:0.9rem; letter-spacing:0.1em; text-transform:uppercase; color:#00aaff; margin-bottom:12px; }
    .foro-input {
        width:100%; padding:10px 14px;
        background:#13171f; border:1px solid rgba(255,255,255,0.08);
        border-radius:6px; color:#e8ecf0; font-size:0.85rem;
        resize:none; outline:none; box-sizing:border-box;
        transition:border-color 0.2s; margin-bottom:10px;
    }
    .foro-input:focus { border-color:#00aaff; }
    .btn-preguntar {
        font-family:'Barlow Condensed',sans-serif; font-weight:700; font-size:0.85rem;
        letter-spacing:0.08em; text-transform:uppercase;
        background:#00aaff; color:#000; padding:10px 24px;
        border-radius:6px; border:none; cursor:pointer; transition:background 0.2s;
    }
    .btn-preguntar:hover { background:#0090dd; }

    .foro-lista { display:flex; flex-direction:column; gap:12px; }
    .foro-item {
        background:#0e1118; border:1px solid rgba(255,255,255,0.07);
        border-radius:10px; overflow:hidden;
    }
    .foro-item-header {
        padding:16px 20px; cursor:pointer;
        display:flex; align-items:flex-start; justify-content:space-between; gap:12px;
        transition:background 0.2s;
    }
    .foro-item-header:hover { background:rgba(255,255,255,0.02); }
    .foro-pregunta-texto { font-size:0.9rem; flex:1; line-height:1.5; }
    .foro-meta { font-family:'Share Tech Mono',monospace; font-size:0.65rem; color:#6b7280; margin-top:4px; }
    .foro-badge-resp {
        font-family:'Share Tech Mono',monospace; font-size:0.62rem;
        padding:3px 8px; border-radius:100px; white-space:nowrap;
        background:rgba(37,211,102,0.1); color:#25D366; border:1px solid rgba(37,211,102,0.2);
    }
    .foro-badge-sin {
        font-family:'Share Tech Mono',monospace; font-size:0.62rem;
        padding:3px 8px; border-radius:100px; white-space:nowrap;
        background:rgba(254,188,46,0.1); color:#febc2e; border:1px solid rgba(254,188,46,0.2);
    }
    .foro-respuestas { border-top:1px solid rgba(255,255,255,0.05); }
    .foro-resp-item {
        padding:12px 20px 12px 32px;
        border-bottom:1px solid rgba(255,255,255,0.03);
        font-size:0.84rem; color:#9ca3af; line-height:1.5;
    }
    .foro-resp-admin { background:rgba(0,170,255,0.05); color:#e8ecf0; border-left:2px solid #00aaff; }
    .foro-resp-meta { font-family:'Share Tech Mono',monospace; font-size:0.62rem; color:#6b7280; margin-bottom:4px; }
    .empty-foro { text-align:center; padding:60px 20px; font-family:'Share Tech Mono',monospace; font-size:0.8rem; color:#6b7280; }
    @media (max-width:768px) { .foro-section { padding:80px 16px 40px; } }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="foro-section">

    <div class="foro-header">
        <div class="foro-titulo">Foro — <span><asp:Literal ID="litCursoNombre" runat="server" /></span></div>
        <div class="foro-subtitulo">// Hacé tu pregunta o buscá si ya fue respondida antes</div>
    </div>

    <div class="foro-buscar">
        <input type="text" id="txtBuscar" placeholder="🔍  Buscar pregunta..." oninput="filtrarForo(this.value)" />
    </div>

    <div class="foro-nueva">
        <div class="foro-nueva-titulo">+ Nueva pregunta</div>
        <asp:TextBox ID="txtPregunta" runat="server" CssClass="foro-input" 
            TextMode="MultiLine" Rows="3" placeholder="Escribí tu pregunta..." />
        <asp:Button ID="btnPreguntar" runat="server" Text="ENVIAR PREGUNTA"
            CssClass="btn-preguntar" OnClick="btnPreguntar_Click" />
    </div>

    <div class="foro-lista" id="listaForo">
        <asp:Repeater ID="rptForo" runat="server">
                       <ItemTemplate>
                <div class="foro-item" data-pregunta="<%# Eval("Pregunta").ToString().ToLower() %>">
                    <div class="foro-item-header" onclick="toggleRespuestas(this)">
                        <div>
                            <div class="foro-pregunta-texto"><%# Eval("Pregunta") %></div>
                            <div class="foro-meta"><%# Eval("NombreAlumno") %> · <%# Eval("Fecha", "{0:dd/MM/yyyy HH:mm}") %></div>
                        </div>
                        <span class="<%# (int)Eval("CantRespuestas") > 0 ? "foro-badge-resp" : "foro-badge-sin" %>">
                            <%# (int)Eval("CantRespuestas") > 0 ? Eval("CantRespuestas") + " resp." : "sin responder" %>
                        </span>
                    </div>

                    <!-- Respuestas (anidadas) -->
                    <asp:Repeater ID="rptRespuestas" runat="server" DataSource='<%# Eval("Respuestas") %>'>
                        <HeaderTemplate><div class="foro-respuestas" style="display:none;"></HeaderTemplate>
                        <ItemTemplate>
                            <div class="foro-resp-item <%# (bool)Eval("EsAdmin") ? "foro-resp-admin" : "foro-resp-alumno" %>">
                                <div class="foro-resp-meta">
                                    <%# (bool)Eval("EsAdmin") ? "HLChip Admin" : "Tú" %> · <%# Eval("Fecha", "{0:dd/MM HH:mm}") %>
                                </div>
                                <%# Eval("Respuesta") %>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate></div></FooterTemplate>
                    </asp:Repeater>

                    <!-- Form para responder (AHORA FUERA del repeater de respuestas) -->
                    <div class="foro-responder" style="padding:16px 20px; background:rgba(0,170,255,0.03);">
                        <asp:TextBox ID="txtRespuestaNueva" runat="server" TextMode="MultiLine" Rows="3"
                            placeholder="Escribí tu respuesta..." CssClass="foro-input" />
                        <div style="margin-top:8px; text-align:right;">
                            <asp:Button ID="btnResponderPregunta" runat="server" Text="Responder"
                                CssClass="btn-preguntar" CommandArgument='<%# Eval("Id") %>' OnClick="btnResponderPregunta_Click" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Panel ID="pnlPaginacion" runat="server" Visible="false"
    style="display:flex;align-items:center;justify-content:center;gap:16px;margin-top:24px;">
    <asp:Button ID="btnAnterior" runat="server" Text="← Anterior"
        OnClick="btnAnterior_Click"
        style="font-family:'Share Tech Mono',monospace;font-size:0.75rem;background:transparent;border:1px solid rgba(255,255,255,0.1);color:#6b7280;padding:8px 16px;border-radius:6px;cursor:pointer;" />
    <asp:Literal ID="litPagina" runat="server" />
    <asp:Button ID="btnSiguiente" runat="server" Text="Siguiente →"
        OnClick="btnSiguiente_Click"
        style="font-family:'Share Tech Mono',monospace;font-size:0.75rem;background:transparent;border:1px solid rgba(255,255,255,0.1);color:#6b7280;padding:8px 16px;border-radius:6px;cursor:pointer;" />
</asp:Panel>
    <asp:Panel ID="pnlSinPreguntas" runat="server" Visible="false">
        <div class="empty-foro">// Todavía no hay preguntas — ¡sé el primero!</div>
    </asp:Panel>

</div>

<script>
    function toggleRespuestas(header) {
        var respDiv = header.nextElementSibling;
        if (!respDiv) return;
        respDiv.style.display = respDiv.style.display === 'none' ? 'block' : 'none';
    }
    function filtrarForo(val) {
        var items = document.querySelectorAll('#listaForo .foro-item');
        var q = val.toLowerCase();
        items.forEach(function(item) {
            var texto = item.getAttribute('data-pregunta') || '';
            item.style.display = texto.includes(q) ? '' : 'none';
        });
    }
</script>
</asp:Content>
<%@ Page Title="Confirmar Acceso" Language="C#" MasterPageFile="~/Campus/Campus.Master"
    AutoEventWireup="true" CodeBehind="Confirmar.aspx.cs" Inherits="HLchip.Campus.Confirmar" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .confirmar-section {
        min-height: 100vh; display: flex; align-items: center; justify-content: center;
        padding: 90px 48px 80px;
    }
    .confirmar-box {
        background: #0e1118; border: 1px solid rgba(255,255,255,0.07);
        border-radius: 12px; padding: 48px; text-align: center; max-width: 480px; width: 100%;
    }
    .confirmar-icon { font-size: 3rem; margin-bottom: 20px; }
    .confirmar-titulo {
        font-family: 'Barlow Condensed', sans-serif; font-weight: 900;
        font-size: 1.8rem; text-transform: uppercase; margin-bottom: 12px;
    }
    .confirmar-titulo span { color: #00aaff; }
    .confirmar-msg {
        font-family: 'Share Tech Mono', monospace; font-size: 0.78rem;
        color: #6b7280; line-height: 1.8; margin-bottom: 28px;
    }
    .btn-ir {
        font-family: 'Barlow Condensed', sans-serif; font-weight: 700;
        font-size: 0.95rem; letter-spacing: 0.08em; text-transform: uppercase;
        background: #00aaff; color: #000; padding: 12px 32px;
        border-radius: 6px; text-decoration: none; transition: background 0.2s;
        display: inline-block;
    }
    .btn-ir:hover { background: #0090dd; color: #000; }
    .error { border-color: rgba(255,30,30,0.3); }
    .error .confirmar-titulo span { color: #ff6b6b; }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="confirmar-section">
    <div class="confirmar-box" id="boxConfirmar" runat="server">
        <div class="confirmar-icon"><asp:Literal ID="litIcono" runat="server" /></div>
        <div class="confirmar-titulo"><asp:Literal ID="litTitulo" runat="server" /></div>
        <div class="confirmar-msg"><asp:Literal ID="litMensaje" runat="server" /></div>
        <a href="/Campus/Login.aspx" class="btn-ir">→ Ir al Login</a>
    </div>
</div>
</asp:Content>
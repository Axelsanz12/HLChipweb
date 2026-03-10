<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HLchip.Admin.Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .login-section {
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 64px 20px;
      position: relative;
    }
    .login-section::before {
      content: '';
      position: absolute; inset: 0;
      background-image:
        linear-gradient(rgba(0,170,255,0.03) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0,170,255,0.03) 1px, transparent 1px);
      background-size: 60px 60px;
    }
    .login-card {
      position: relative; z-index: 2;
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 12px;
      padding: 48px 40px;
      width: 100%; max-width: 420px;
    }
    .login-logo {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 2rem;
      color: #fff; text-align: center;
      margin-bottom: 8px;
    }
    .login-logo span { color: #00aaff; }
    .login-sub {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #6b7280;
      text-align: center; letter-spacing: 0.1em;
      text-transform: uppercase; margin-bottom: 36px;
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
      width: 100%; background: #050608;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 6px; padding: 13px 16px;
      color: #e8ecf0; font-family: 'Barlow', sans-serif;
      font-size: 0.95rem; transition: border-color 0.2s; outline: none;
    }
    .form-input:focus { border-color: #00aaff; }
    .btn-login {
      width: 100%; background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 800; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      padding: 15px; cursor: pointer;
      transition: all 0.2s; margin-top: 8px;
    }
    .btn-login:hover { background: #0099ee; transform: translateY(-2px); }
    .msg-error {
      background: rgba(255,30,30,0.1);
      border: 1px solid rgba(255,30,30,0.3);
      border-radius: 6px; padding: 12px 16px;
      color: #ff6b6b;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.78rem; letter-spacing: 0.05em;
      margin-top: 16px; text-align: center;
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="login-section">
    <div class="login-card">
      <div class="login-logo">HL<span>chip</span></div>
      <div class="login-sub">// Panel de administración</div>

      <div class="form-group">
        <label class="form-label">Usuario</label>
        <asp:TextBox ID="txtUser" runat="server" CssClass="form-input" placeholder="admin" />
      </div>
      <div class="form-group">
        <label class="form-label">Contraseña</label>
        <asp:TextBox ID="txtPass" runat="server" CssClass="form-input" 
            placeholder="••••••••" TextMode="Password" />
      </div>

      <asp:Button ID="btnLogin" runat="server" Text="INGRESAR" 
          CssClass="btn-login" OnClick="btnLogin_Click" />

      <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="msg-error">⚠ Usuario o contraseña incorrectos</div>
      </asp:Panel>
    </div>
  </div>
</asp:Content>
<%@ Page Title="Campus HLChip" Language="C#" MasterPageFile="~/Campus/Campus.Master" 
    AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HLchip.Campus.Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .campus-login {
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 100px 20px 60px;
    }
    .login-box {
      background: #0e1118;
      border: 1px solid rgba(255,255,255,0.07);
      border-radius: 12px;
      padding: 48px 40px;
      width: 100%; max-width: 420px;
    }
    .login-logo {
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1.8rem;
      text-transform: uppercase; text-align: center;
      margin-bottom: 8px;
    }
    .login-logo span { color: #00aaff; }
    .login-sub {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.72rem; color: #6b7280;
      text-align: center; letter-spacing: 0.1em;
      text-transform: uppercase; margin-bottom: 36px;
    }
    .form-group { margin-bottom: 20px; }
    .form-label {
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.7rem; color: #6b7280;
      letter-spacing: 0.1em; text-transform: uppercase;
      display: block; margin-bottom: 8px;
    }
    .form-input {
      width: 100%; padding: 12px 16px;
      background: #13171f;
      border: 1px solid rgba(255,255,255,0.08);
      border-radius: 6px; color: #e8ecf0;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.9rem; outline: none;
      box-sizing: border-box;
      transition: border-color 0.2s;
    }
    .form-input:focus { border-color: #00aaff; }
    .btn-login {
      width: 100%; padding: 14px;
      background: #00aaff; color: #000;
      font-family: 'Barlow Condensed', sans-serif;
      font-weight: 900; font-size: 1rem;
      letter-spacing: 0.1em; text-transform: uppercase;
      border: none; border-radius: 6px;
      cursor: pointer; margin-top: 8px;
      transition: background 0.2s;
    }
    .btn-login:hover { background: #0090dd; }
    .error-msg {
      background: rgba(255,30,30,0.1);
      border: 1px solid rgba(255,30,30,0.2);
      color: #ff6b6b; padding: 12px 16px;
      border-radius: 6px; margin-bottom: 20px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.8rem;
    }
    .campus-info {
      text-align: center; margin-top: 24px;
      font-family: 'Share Tech Mono', monospace;
      font-size: 0.72rem; color: #6b7280;
    }
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="campus-login">
    <div class="login-box">
      <div class="login-logo">HL<span>Chip</span> Campus</div>
      <div class="login-sub">// Acceso exclusivo para alumnos</div>

      <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="error-msg">
        <asp:Literal ID="litError" runat="server" />
      </asp:Panel>

      <div class="form-group">
        <label class="form-label">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" 
            TextMode="Email" placeholder="tu@email.com" />
      </div>
      <div class="form-group">
        <label class="form-label">Contraseña</label>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" 
            TextMode="Password" placeholder="••••••••" />
      </div>

      <asp:Button ID="btnLogin" runat="server" Text="INGRESAR AL CAMPUS" 
          CssClass="btn-login" OnClick="btnLogin_Click" />

      <div class="campus-info">
        ¿No tenés acceso? Inscribite a un curso para obtener tus credenciales.
      </div>
    </div>
  </div>
</asp:Content>
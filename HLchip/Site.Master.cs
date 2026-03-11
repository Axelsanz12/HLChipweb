using System;
using System.Web.UI;

namespace HLchip
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool isAdmin = Session["AdminUser"] != null;
            bool isAlumno = Session["AlumnoCampusId"] != null;

            lnkAdmin.Visible = isAdmin;
            lnkSalir.Visible = isAdmin;
            lnkCampusAdmin.Visible = isAdmin;

            // Si es alumno logueado → Mi Campus + Salir
            // Si no está logueado → Campus (va al login)
            // Si es admin → ya tiene su botón Campus
            lnkCampusAlumno.Visible = !isAdmin;
            lnkSalirAlumno.Visible = isAlumno && !isAdmin;
        }

        protected void lnkSalirAlumno_Click(object sender, EventArgs e)
        {
            Session.Remove("AlumnoCampusId");
            Session.Remove("AlumnoCampusNombre");
            Response.Redirect("~/Campus/Login.aspx");
        }
    }
}
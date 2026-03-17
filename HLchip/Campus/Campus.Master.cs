using System;
using System.Web.UI;

namespace HLchip.Campus
{
    public partial class CampusMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AlumnoCampusId"] != null)
            {
                litNavUser.Text = $"<span class='campus-nav-user'>// <span>{Session["AlumnoCampusNombre"]}</span></span>";
            }
        }

        protected void lnkSalir_Click(object sender, EventArgs e)
        {
            Session.Remove("AlumnoCampusId");
            Session.Remove("AlumnoCampusNombre");
            Response.Redirect("~/Campus/Login.aspx");
        }
    }
}
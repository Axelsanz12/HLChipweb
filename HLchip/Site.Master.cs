using System;
using System.Web.UI;

namespace HLchip
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool logueado = Session["AdminUser"] != null;
            lnkAdmin.Visible = logueado;
            lnkSalir.Visible = logueado;
        }
    }
}
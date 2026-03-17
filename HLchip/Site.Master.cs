using System;
using System.Web.UI;

namespace HLchip
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool isAdmin = Session["AdminUser"] != null;
            lnkAdmin.Visible = isAdmin;
            lnkSalir.Visible = isAdmin;
        }
    }
}
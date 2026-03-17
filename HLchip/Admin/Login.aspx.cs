using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace HLchip.Admin
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Si ya está logueado redirigir al panel
            if (Session["AdminUser"] != null)
                Response.Redirect("~/Admin/Panel.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = txtUser.Text.Trim();
            string pass = txtPass.Text.Trim();

            if (string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(pass))
            {
                pnlError.Visible = true;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT Id, Nombre FROM Usuarios 
                                 WHERE Username = @User 
                                 AND Password = @Pass 
                                 AND Activo = 1";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@User", user);
                cmd.Parameters.AddWithValue("@Pass", pass);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["AdminUser"] = dr["Nombre"].ToString();
                    Response.Redirect("~/Admin/Panel.aspx");
                }
                else
                {
                    pnlError.Visible = true;
                }
            }
        }
    }
}
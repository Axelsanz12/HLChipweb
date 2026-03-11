using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.Security;

namespace HLchip.Campus
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AlumnoId"] != null)
                Response.Redirect("~/Campus/MisCursos.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                litError.Text = "Completá todos los campos.";
                pnlError.Visible = true;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT Id, Nombre FROM AlumnosCampus WHERE Email = @Email AND Password = @Password AND Activo = 1", conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["AlumnoId"] = dr["Id"].ToString();
                    Session["AlumnoNombre"] = dr["Nombre"].ToString();
                    Response.Redirect("~/Campus/MisCursos.aspx");
                }
                else
                {
                    litError.Text = "Email o contraseña incorrectos.";
                    pnlError.Visible = true;
                }
            }
        }
    }
}
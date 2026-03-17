using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace HLchip.Campus
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AlumnoCampusId"] != null)
                Response.Redirect("Campus/MisCursos.aspx");
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
                    "SELECT Id, Nombre, Confirmado FROM AlumnosCampus WHERE Email = @Email AND Password = @Password AND Activo = 1", conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    bool confirmado = (bool)dr["Confirmado"];

                    if (!confirmado)
                    {
                        dr.Close();
                        litError.Text = "Todavía no confirmaste tu acceso. Revisá tu email y hacé click en el link de confirmación.";
                        pnlError.Visible = true;
                        return;
                    }

                    Session["AlumnoCampusId"] = dr["Id"].ToString();
                    Session["AlumnoCampusNombre"] = dr["Nombre"].ToString();
                    Response.Redirect("/Campus/MisCursos.aspx");
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

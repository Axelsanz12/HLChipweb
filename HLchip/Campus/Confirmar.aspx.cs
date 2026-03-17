using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace HLchip.Campus
{
    public partial class Confirmar : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"] ?? "";

            if (string.IsNullOrEmpty(token))
            {
                MostrarError("Token inválido", "El link de confirmación no es válido.");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand check = new SqlCommand(
                    "SELECT Id, Confirmado FROM AlumnosCampus WHERE TokenConfirmacion = @Token", conn);
                check.Parameters.AddWithValue("@Token", token);
                SqlDataReader dr = check.ExecuteReader();

                if (!dr.Read())
                {
                    dr.Close();
                    MostrarError("Link inválido", "El link de confirmación no existe o ya fue usado.");
                    return;
                }

                int idAlumno = (int)dr["Id"];
                bool confirmado = (bool)dr["Confirmado"];
                dr.Close();

                if (confirmado)
                {
                    litIcono.Text = "✅";
                    litTitulo.Text = "Ya <span>confirmado</span>";
                    litMensaje.Text = "Tu acceso ya estaba activado. Podés ingresar normalmente.";
                    return;
                }

                // Confirmar acceso
                SqlCommand upd = new SqlCommand(@"
                    UPDATE AlumnosCampus 
                    SET Confirmado = 1, TokenConfirmacion = NULL 
                    WHERE Id = @Id", conn);
                upd.Parameters.AddWithValue("@Id", idAlumno);
                upd.ExecuteNonQuery();

                litIcono.Text = "🎉";
                litTitulo.Text = "Acceso <span>activado</span>";
                litMensaje.Text = "Tu cuenta fue confirmada correctamente. Ya podés ingresar al campus con tu email y contraseña.";
            }
        }

        private void MostrarError(string titulo, string mensaje)
        {
            litIcono.Text = "❌";
            litTitulo.Text = $"<span>{titulo}</span>";
            litMensaje.Text = mensaje;
        }
    }
}
using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace HLchip
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtMensaje.Text))
                return;

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Consultas 
                    (Nombre, Email, Telefono, Mensaje) 
                    VALUES (@Nombre, @Email, @Telefono, @Mensaje)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text.Trim());
                cmd.Parameters.AddWithValue("@Mensaje", txtMensaje.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Limpiar campos
            txtNombre.Text = "";
            txtEmail.Text = "";
            txtTelefono.Text = "";
            txtMensaje.Text = "";

            // Mostrar mensaje de éxito
            pnlOk.Style["display"] = "block";
        }
    }
}
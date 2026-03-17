using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace HLchip.Cursos
{
    public partial class Presenciales : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarTalleres();
        }

        private void CargarTalleres()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT * FROM CursosPresenciales WHERE Activo = 1 ORDER BY Fecha", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptTalleres.DataSource = dt;
                rptTalleres.DataBind();
            }
        }

        protected void btnInscribir_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(hfIdCurso.Value))
                return;

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO InscripcionesPresenciales 
                    (IdCurso, Nombre, Telefono, Email, Consulta, Estado)
                    VALUES 
                    (@IdCurso, @Nombre, @Telefono, @Email, @Consulta, 'Pendiente')";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@IdCurso", int.Parse(hfIdCurso.Value));
                cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Consulta", txtConsulta.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtNombre.Text = txtTelefono.Text = txtEmail.Text = txtConsulta.Text = "";
            CargarTalleres();
            pnlOk.Visible = true;
        }
    }
}
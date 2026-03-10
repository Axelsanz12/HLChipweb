using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace HLchip.Cursos
{
    public partial class Detalle : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                    CargarCurso(id);
                else
                    pnlNotFound.Visible = true;
            }
        }

        private void CargarCurso(int id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT * FROM Cursos WHERE Id = @Id AND Activo = 1", conn);
                da.SelectCommand.Parameters.AddWithValue("@Id", id);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    pnlNotFound.Visible = true;
                    return;
                }

                DataRow r = dt.Rows[0];

                litNombre.Text = r["Nombre"].ToString();
                litDesc.Text = r["Descripcion"].ToString();
                litDuracion.Text = r["Duracion"].ToString();
                litModalidad.Text = r["Modalidad"].ToString();
                litPrecio.Text = String.Format("{0:N0}", r["Precio"]);
                hfIdCurso.Value = id.ToString();

                // Cargar temario — separado por ||
                string temario = r["Temario"].ToString();
                string[] items = temario.Split(new string[] { "||" },
                                 StringSplitOptions.RemoveEmptyEntries);

                rptTemario.DataSource = items;
                rptTemario.DataBind();

                pnlCurso.Visible = true;
            }
        }

        protected void btnInscribir_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text))
                return;

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Inscripciones 
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
            pnlOk.Visible = true;
        }
    }
}
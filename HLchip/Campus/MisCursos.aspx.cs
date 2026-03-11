using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace HLchip.Campus
{
    public partial class MisCursos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AlumnoId"] == null)
                Response.Redirect("~/Campus/Login.aspx");

            litNombre.Text = Session["AlumnoNombre"].ToString();

            if (!IsPostBack)
                CargarCursos();
        }

        private void CargarCursos()
        {
            int idAlumno = int.Parse(Session["AlumnoId"].ToString());
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT ac.IdCurso, c.Nombre, c.Descripcion, ac.Progreso
                    FROM AlumnoCurso ac
                    INNER JOIN Cursos c ON ac.IdCurso = c.Id
                    WHERE ac.IdAlumno = @IdAlumno
                    ORDER BY ac.FechaAcceso DESC", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptCursos.DataSource = dt;
                    rptCursos.DataBind();
                }
                else
                {
                    pnlSinCursos.Visible = true;
                }
            }
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Campus/Login.aspx");
        }
    }
}
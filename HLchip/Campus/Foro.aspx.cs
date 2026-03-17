using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HLchip.Campus
{
    public partial class Foro : Page
    {
        public int CursoId { get; set; }
        private const int PorPagina = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AlumnoCampusId"] == null)
                Response.Redirect("/Campus/Login.aspx");

            CursoId = int.Parse(Request.QueryString["curso"] ?? "0");
            if (CursoId == 0) Response.Redirect("/Campus/MisCursos.aspx");

            if (!IsPostBack)
            {
                ViewState["Pagina"] = 1;
                CargarForo(1);
            }
        }

        private void CargarForo(int pagina)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmdNombre = new SqlCommand(
                    "SELECT Nombre FROM Cursos WHERE Id = @Id", conn);
                cmdNombre.Parameters.AddWithValue("@Id", CursoId);
                litCursoNombre.Text = cmdNombre.ExecuteScalar()?.ToString() ?? "";

                // Total de preguntas
                SqlCommand cmdTotal = new SqlCommand(
                    "SELECT COUNT(*) FROM ForoPreguntas WHERE IdCurso = @IdCurso", conn);
                cmdTotal.Parameters.AddWithValue("@IdCurso", CursoId);
                int total = (int)cmdTotal.ExecuteScalar();

                int totalPaginas = (int)Math.Ceiling((double)total / PorPagina);
                int offset = (pagina - 1) * PorPagina;

                // Paginación controles
                btnAnterior.Visible = pagina > 1;
                btnSiguiente.Visible = pagina < totalPaginas;
                litPagina.Text = $"Página {pagina} de {totalPaginas}";
                pnlPaginacion.Visible = total > PorPagina;

                SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT fp.Id, fp.Pregunta, fp.Fecha,
                           ac.Nombre AS NombreAlumno,
                           (SELECT COUNT(*) FROM ForoRespuestas WHERE IdPregunta = fp.Id) AS CantRespuestas
                    FROM ForoPreguntas fp
                    INNER JOIN AlumnosCampus ac ON fp.IdAlumno = ac.Id
                    WHERE fp.IdCurso = @IdCurso
                    ORDER BY fp.Fecha DESC
                    OFFSET @Offset ROWS FETCH NEXT @PorPagina ROWS ONLY", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdCurso", CursoId);
                da.SelectCommand.Parameters.AddWithValue("@Offset", offset);
                da.SelectCommand.Parameters.AddWithValue("@PorPagina", PorPagina);
                DataTable dtPreguntas = new DataTable();
                da.Fill(dtPreguntas);

                if (dtPreguntas.Rows.Count == 0 && pagina == 1)
                {
                    pnlSinPreguntas.Visible = true;
                    rptForo.Visible = false;
                    return;
                }

                var lista = new List<dynamic>();
                foreach (DataRow row in dtPreguntas.Rows)
                {

                    int idPregunta = int.Parse(row["Id"].ToString());
                    SqlDataAdapter daR = new SqlDataAdapter(@"
                        SELECT fr.Respuesta, fr.EsAdmin, fr.Fecha,
                               ISNULL(ac.Nombre, 'Alumno') AS NombreAlumno
                        FROM ForoRespuestas fr
                        LEFT JOIN AlumnosCampus ac ON fr.IdAlumno = ac.Id
                        WHERE fr.IdPregunta = @Id
                        ORDER BY fr.Fecha", conn);
                    daR.SelectCommand.Parameters.AddWithValue("@Id", idPregunta);
                    DataTable dtR = new DataTable();
                    daR.Fill(dtR);

                    lista.Add(new
                    {
                        Id = idPregunta,
                        Pregunta = row["Pregunta"].ToString(),
                        NombreAlumno = row["NombreAlumno"].ToString(),
                        Fecha = row["Fecha"],
                        CantRespuestas = int.Parse(row["CantRespuestas"].ToString()),
                        Respuestas = dtR
                    });
                }

                rptForo.DataSource = lista;
                rptForo.DataBind();
            }
        }

        protected void btnPreguntar_Click(object sender, EventArgs e)
        {
            string pregunta = txtPregunta.Text.Trim();
            if (string.IsNullOrWhiteSpace(pregunta)) return;

            int idAlumno = int.Parse(Session["AlumnoCampusId"].ToString());
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO ForoPreguntas (IdCurso, IdAlumno, Pregunta, Fecha)
                    VALUES (@IdCurso, @IdAlumno, @Pregunta, GETDATE())", conn);
                cmd.Parameters.AddWithValue("@IdCurso", CursoId);
                cmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
                cmd.Parameters.AddWithValue("@Pregunta", pregunta);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtPregunta.Text = "";
            ViewState["Pagina"] = 1;
            CargarForo(1);
        }

        protected void btnAnterior_Click(object sender, EventArgs e)
        {
            int pagina = (int)ViewState["Pagina"] - 1;
            ViewState["Pagina"] = pagina;
            CargarForo(pagina);
        }

        protected void btnSiguiente_Click(object sender, EventArgs e)
        {
            int pagina = (int)ViewState["Pagina"] + 1;
            ViewState["Pagina"] = pagina;
            CargarForo(pagina);
        }
        protected void btnResponderPregunta_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idPregunta = Convert.ToInt32(btn.CommandArgument);

            RepeaterItem item = (RepeaterItem)btn.NamingContainer;
            TextBox txt = (TextBox)item.FindControl("txtRespuestaNueva");
            string respuesta = txt.Text.Trim();

            if (string.IsNullOrWhiteSpace(respuesta)) return;

            int idAlumno = int.Parse(Session["AlumnoCampusId"].ToString());

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
            INSERT INTO ForoRespuestas (IdPregunta, IdAlumno, Respuesta, EsAdmin, Fecha)
            VALUES (@IdPregunta, @IdAlumno, @Respuesta, 0, GETDATE())", conn);
                cmd.Parameters.AddWithValue("@IdPregunta", idPregunta);
                cmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
                cmd.Parameters.AddWithValue("@Respuesta", respuesta);
                cmd.ExecuteNonQuery();
            }

            txt.Text = "";  // limpiar
            CargarForo((int)ViewState["Pagina"]);  // recargar la página actual
        }
    }
}
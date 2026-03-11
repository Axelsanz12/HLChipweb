using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace HLchip.Campus
{
    public partial class Curso : Page
    {
        public int Progreso { get; set; }
        public int LeccionActualId { get; set; }
        public int CursoId { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AlumnoId"] == null)
                Response.Redirect("~/Campus/Login.aspx");

            CursoId = int.Parse(Request.QueryString["id"] ?? "0");
            if (CursoId == 0) Response.Redirect("~/Campus/MisCursos.aspx");

            int idAlumno = int.Parse(Session["AlumnoId"].ToString());

            if (!IsPostBack)
            {
                CargarCurso(idAlumno);
                CargarLecciones(idAlumno);
                CargarArchivos();
                CargarForo();
                ActualizarProgreso(idAlumno);
            }
        }

        private void CargarCurso(int idAlumno)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT Nombre FROM Cursos WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", CursoId);
                conn.Open();
                object nombre = cmd.ExecuteScalar();
                litTitulo.Text = nombre?.ToString() ?? "";
            }
        }

        private void CargarLecciones(int idAlumno)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT l.Id, l.Titulo, l.Descripcion, l.UrlVideo, l.Orden,
                           ISNULL(pl.Completada, 0) AS Completada
                    FROM Lecciones l
                    LEFT JOIN ProgresoLecciones pl 
                        ON pl.IdLeccion = l.Id AND pl.IdAlumno = @IdAlumno
                    WHERE l.IdCurso = @IdCurso AND l.Activo = 1
                    ORDER BY l.Orden", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdCurso", CursoId);
                da.SelectCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);

                DataTable dt = new DataTable();
                da.Fill(dt);

                // Leccion activa
                int leccionId = int.Parse(Request.QueryString["leccion"] ?? "0");
                if (leccionId == 0 && dt.Rows.Count > 0)
                    leccionId = int.Parse(dt.Rows[0]["Id"].ToString());

                LeccionActualId = leccionId;

                // Cargar video activo
                foreach (DataRow row in dt.Rows)
                {
                    if (int.Parse(row["Id"].ToString()) == leccionId)
                    {
                        litLeccionTitulo.Text = row["Titulo"].ToString();
                        litLeccionDesc.Text = row["Descripcion"].ToString();
                        string url = row["UrlVideo"].ToString();
                        url = ConvertirUrlEmbed(url);
                        litVideo.Text = $"<iframe src='{url}' allowfullscreen></iframe>";

                        bool completada = (bool)row["Completada"];
                        if (completada)
                        {
                            btnCompletar.Text = "✓ COMPLETADA";
                            btnCompletar.CssClass = "btn-completar btn-completado";
                        }
                        break;
                    }
                }

                rptLecciones.DataSource = dt;
                rptLecciones.DataBind();
            }
        }

        private string ConvertirUrlEmbed(string url)
        {
            if (url.Contains("youtube.com/watch?v="))
                return url.Replace("youtube.com/watch?v=", "youtube.com/embed/").Split('&')[0];
            if (url.Contains("youtu.be/"))
                return "https://www.youtube.com/embed/" + url.Split('/')[url.Split('/').Length - 1];
            if (url.Contains("vimeo.com/"))
                return "https://player.vimeo.com/video/" + url.Split('/')[url.Split('/').Length - 1];
            return url;
        }

        private void CargarArchivos()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT Nombre, Archivo FROM ArchivosCurso WHERE IdCurso = @IdCurso ORDER BY Orden", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdCurso", CursoId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptArchivos.DataSource = dt;
                    rptArchivos.DataBind();
                }
                else
                {
                    pnlSinArchivos.Visible = true;
                }
            }
        }

        private void CargarForo()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(@"
                    SELECT fp.Id, fp.Pregunta, fp.Fecha,
                           ac.Nombre AS NombreAlumno
                    FROM ForoPreguntas fp
                    INNER JOIN AlumnosCampus ac ON fp.IdAlumno = ac.Id
                    WHERE fp.IdCurso = @IdCurso
                    ORDER BY fp.Fecha DESC", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdCurso", CursoId);

                DataTable dtPreguntas = new DataTable();
                da.Fill(dtPreguntas);

                // Cargar respuestas para cada pregunta
                var listaPreguntas = new List<dynamic>();
                foreach (DataRow row in dtPreguntas.Rows)
                {
                    int idPregunta = int.Parse(row["Id"].ToString());
                    SqlDataAdapter daR = new SqlDataAdapter(
                        "SELECT Respuesta, EsAdmin FROM ForoRespuestas WHERE IdPregunta = @Id ORDER BY Fecha", conn);
                    daR.SelectCommand.Parameters.AddWithValue("@Id", idPregunta);
                    DataTable dtR = new DataTable();
                    daR.Fill(dtR);

                    listaPreguntas.Add(new
                    {
                        Pregunta = row["Pregunta"].ToString(),
                        NombreAlumno = row["NombreAlumno"].ToString(),
                        Fecha = row["Fecha"],
                        Respuestas = dtR
                    });
                }

                rptForo.DataSource = listaPreguntas;
                rptForo.DataBind();
            }
        }

        private void ActualizarProgreso(int idAlumno)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmdTotal = new SqlCommand(
                    "SELECT COUNT(*) FROM Lecciones WHERE IdCurso = @IdCurso AND Activo = 1", conn);
                cmdTotal.Parameters.AddWithValue("@IdCurso", CursoId);
                int total = (int)cmdTotal.ExecuteScalar();

                SqlCommand cmdComp = new SqlCommand(@"
                    SELECT COUNT(*) FROM ProgresoLecciones pl
                    INNER JOIN Lecciones l ON pl.IdLeccion = l.Id
                    WHERE l.IdCurso = @IdCurso AND pl.IdAlumno = @IdAlumno AND pl.Completada = 1", conn);
                cmdComp.Parameters.AddWithValue("@IdCurso", CursoId);
                cmdComp.Parameters.AddWithValue("@IdAlumno", idAlumno);
                int completadas = (int)cmdComp.ExecuteScalar();

                Progreso = total > 0 ? (completadas * 100 / total) : 0;

                SqlCommand cmdUpdate = new SqlCommand(@"
                    UPDATE AlumnoCurso SET Progreso = @Progreso 
                    WHERE IdAlumno = @IdAlumno AND IdCurso = @IdCurso", conn);
                cmdUpdate.Parameters.AddWithValue("@Progreso", Progreso);
                cmdUpdate.Parameters.AddWithValue("@IdAlumno", idAlumno);
                cmdUpdate.Parameters.AddWithValue("@IdCurso", CursoId);
                cmdUpdate.ExecuteNonQuery();
            }

            DataBind();
        }

        protected void btnCompletar_Click(object sender, EventArgs e)
        {
            int idAlumno = int.Parse(Session["AlumnoId"].ToString());
            int leccionId = LeccionActualId == 0
                ? int.Parse(Request.QueryString["leccion"] ?? "0")
                : LeccionActualId;

            if (leccionId == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand check = new SqlCommand(
                    "SELECT COUNT(*) FROM ProgresoLecciones WHERE IdAlumno = @IdAlumno AND IdLeccion = @IdLeccion", conn);
                check.Parameters.AddWithValue("@IdAlumno", idAlumno);
                check.Parameters.AddWithValue("@IdLeccion", leccionId);
                int existe = (int)check.ExecuteScalar();

                if (existe == 0)
                {
                    SqlCommand ins = new SqlCommand(@"
                        INSERT INTO ProgresoLecciones (IdAlumno, IdLeccion, Completada, FechaCompletado)
                        VALUES (@IdAlumno, @IdLeccion, 1, GETDATE())", conn);
                    ins.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    ins.Parameters.AddWithValue("@IdLeccion", leccionId);
                    ins.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand upd = new SqlCommand(@"
                        UPDATE ProgresoLecciones SET Completada = 1, FechaCompletado = GETDATE()
                        WHERE IdAlumno = @IdAlumno AND IdLeccion = @IdLeccion", conn);
                    upd.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    upd.Parameters.AddWithValue("@IdLeccion", leccionId);
                    upd.ExecuteNonQuery();
                }
            }

            string qs = $"?id={CursoId}&leccion={leccionId}";
            Response.Redirect("~/Campus/Cursos.aspx" + qs);
        }

        protected void btnPreguntar_Click(object sender, EventArgs e)
        {
            string pregunta = txtPregunta.Text.Trim();
            if (string.IsNullOrWhiteSpace(pregunta)) return;

            int idAlumno = int.Parse(Session["AlumnoId"].ToString());
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
            Response.Redirect(Request.RawUrl);
        }
    }
}
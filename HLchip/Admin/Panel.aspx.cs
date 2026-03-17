using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace HLchip.Admin
{
    public partial class Panel : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null)
                Response.Redirect("~/Admin/Login.aspx");
            litUser.Text = Session["AdminUser"].ToString();
            if (!IsPostBack)
            {
                CargarDatos();
                CargarCursosCampus();
                CargarForoAdmin();
            }
            // Mantiene la pestaña Campus activa después de cualquier postback
            ScriptManager.RegisterStartupScript(this, GetType(), "keepCampusTab",
"sessionStorage.setItem('tabActivo','campus');", true);
        }
        private void CargarDatos()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Estadísticas
                SqlCommand cmdStats = new SqlCommand(@"
                    SELECT
                        COUNT(*) AS Total,
                        SUM(CASE WHEN Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
                        SUM(CASE WHEN Estado = 'Confirmado' THEN 1 ELSE 0 END) AS Confirmados
                    FROM Turnos", conn);
                SqlDataReader drStats = cmdStats.ExecuteReader();
                if (drStats.Read())
                {
                    litTotalTurnos.Text = drStats["Total"].ToString();
                    litPendientes.Text = drStats["Pendientes"].ToString();
                    litConfirmados.Text = drStats["Confirmados"].ToString();
                }
                drStats.Close();
                SqlCommand cmdConsultas = new SqlCommand(
                "SELECT COUNT(*) FROM Consultas WHERE Leida = 0", conn);
                litConsultas.Text = cmdConsultas.ExecuteScalar().ToString();
                // Turnos
                SqlDataAdapter daTurnos = new SqlDataAdapter(@"
                    SELECT t.Id, t.Nombre, t.Telefono, t.FechaTurno, t.HoraTurno,
                           tt.Nombre AS Servicio, t.Vehiculo, t.Estado
                    FROM Turnos t
                    INNER JOIN TiposTrabajo tt ON t.IdTipoTrabajo = tt.Id
                    ORDER BY t.FechaTurno ASC, t.HoraTurno ASC", conn);
                DataTable dtTurnos = new DataTable();
                daTurnos.Fill(dtTurnos);
                if (dtTurnos.Rows.Count > 0) { rptTurnos.DataSource = dtTurnos; rptTurnos.DataBind(); }
                else pnlSinTurnos.Visible = true;
                // Mapas
                SqlDataAdapter daMapas = new SqlDataAdapter(@"
                    SELECT p.Id, p.Nombre, p.Telefono,
                           ISNULL(m.Nombre, 'No especificada') AS Marca,
                           p.Motor, p.TipoMapa, p.ArchivoOriginal, p.Estado, p.FechaCreacion
                    FROM PedidosMapas p
                    LEFT JOIN Marcas m ON p.IdMarca = m.Id
                    ORDER BY p.FechaCreacion DESC", conn);
                DataTable dtMapas = new DataTable();
                daMapas.Fill(dtMapas);
                if (dtMapas.Rows.Count > 0) { rptMapas.DataSource = dtMapas; rptMapas.DataBind(); }
                else pnlSinMapas.Visible = true;
                // Inscripciones
                SqlDataAdapter daInscripciones = new SqlDataAdapter(@"
                    SELECT i.Id, i.Nombre, i.Telefono, i.Email,
                           i.IdCurso, c.Nombre AS Curso, i.Consulta,
                           i.Estado, i.MetodoPago,
                           ISNULL(i.ComprobanteTransferencia, '') AS ComprobanteTransferencia,
                           i.FechaCreacion
                    FROM Inscripciones i
                    INNER JOIN Cursos c ON i.IdCurso = c.Id
                    ORDER BY i.FechaCreacion DESC", conn);
                DataTable dtInscripciones = new DataTable();
                daInscripciones.Fill(dtInscripciones);
                if (dtInscripciones.Rows.Count > 0) { rptInscripciones.DataSource = dtInscripciones; rptInscripciones.DataBind(); }
                else pnlSinInscripciones.Visible = true;
                // Presenciales
                SqlDataAdapter daPresenciales = new SqlDataAdapter(@"
                    SELECT i.Id, i.Nombre, i.Telefono, i.Email,
                           c.Nombre AS Taller, c.Fecha AS FechaTaller,
                           i.Consulta, i.Estado, i.FechaCreacion
                    FROM InscripcionesPresenciales i
                    INNER JOIN CursosPresenciales c ON i.IdCurso = c.Id
                    ORDER BY i.FechaCreacion DESC", conn);
                DataTable dtPresenciales = new DataTable();
                daPresenciales.Fill(dtPresenciales);
                if (dtPresenciales.Rows.Count > 0) { rptPresenciales.DataSource = dtPresenciales; rptPresenciales.DataBind(); }
                else pnlSinPresenciales.Visible = true;
                // Consultas
                SqlDataAdapter daConsultas = new SqlDataAdapter(
"SELECT * FROM Consultas ORDER BY Fecha DESC", conn);
                DataTable dtConsultas = new DataTable();
                daConsultas.Fill(dtConsultas);
                if (dtConsultas.Rows.Count > 0) { rptConsultas.DataSource = dtConsultas; rptConsultas.DataBind(); }
                else pnlSinConsultas.Visible = true;
                // Cursos catálogo
                SqlDataAdapter daCursos = new SqlDataAdapter(
"SELECT Id, Nombre, Modalidad, Duracion, Precio, Activo, Orden FROM Cursos ORDER BY Orden", conn);
                DataTable dtCursos = new DataTable();
                daCursos.Fill(dtCursos);
                if (dtCursos.Rows.Count > 0) { rptCursos.DataSource = dtCursos; rptCursos.DataBind(); }
                else pnlSinCursos.Visible = true;
            }
        }
        // ─── CAMPUS ───────────────────────────────────────────
        private void CargarCursosCampus()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                "SELECT Id, Nombre FROM Cursos WHERE Activo = 1 ORDER BY Nombre", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlCursosCampus.DataSource = dt;
                ddlCursosCampus.DataTextField = "Nombre";
                ddlCursosCampus.DataValueField = "Id";
                ddlCursosCampus.DataBind();
                ddlCursosCampus.Items.Insert(0, new ListItem("-- Seleccionar curso --", "0"));
            }
            // Carga inicial de lecciones y materiales
            CargarLeccionesCampus();
            CargarMateriales();
            // CargarForoAdmin(); // descomenta si usás el foro
        }
        private void CargarLeccionesCampus()
        {
            int idCurso;
            if (!int.TryParse(ddlCursosCampus.SelectedValue, out idCurso) || idCurso == 0)
            {
                rptLecciones.DataSource = null;
                rptLecciones.DataBind();
                pnlSinLecciones.Visible = true;
                return;
            }
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                "SELECT Id, Titulo, UrlVideo, Orden, Activo FROM Lecciones WHERE IdCurso = @IdCurso ORDER BY Orden", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdCurso", idCurso);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptLecciones.DataSource = dt;
                rptLecciones.DataBind();
                pnlSinLecciones.Visible = (dt.Rows.Count == 0);
            }
        }
        private void CargarMateriales()
        {
            int idCurso;
            if (!int.TryParse(ddlCursosCampus.SelectedValue, out idCurso) || idCurso == 0)
            {
                rptMateriales.DataSource = null;
                rptMateriales.DataBind();
                pnlSinMateriales.Visible = true;
                return;
            }
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                "SELECT Id, Nombre, Archivo, Orden FROM ArchivosCurso WHERE IdCurso = @IdCurso ORDER BY Orden", conn);
                da.SelectCommand.Parameters.AddWithValue("@IdCurso", idCurso);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptMateriales.DataSource = dt;
                rptMateriales.DataBind();
                pnlSinMateriales.Visible = (dt.Rows.Count == 0);
            }
        }
        private void CargarForoAdmin()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(@"
            SELECT fp.Id, fp.Pregunta, fp.Fecha,
                   ac.Nombre AS NombreAlumno, c.Nombre AS Curso
            FROM ForoPreguntas fp
            INNER JOIN AlumnosCampus ac ON fp.IdAlumno = ac.Id
            INNER JOIN Cursos c ON fp.IdCurso = c.Id
            ORDER BY fp.Fecha DESC", conn); // ← sin filtro "sin respuesta"
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptForoAdmin.DataSource = dt;
                rptForoAdmin.DataBind();
                pnlSinPreguntas.Visible = (dt.Rows.Count == 0);
            }
        }
        protected void btnRefrescarForo_Click(object sender, EventArgs e)
        {
            CargarForoAdmin();
            upForo.Update(); // fuerza refresco solo del foro
        }
        protected void ddlCursosCampus_Changed(object sender, EventArgs e)
        {
            pnlFormLeccion.Visible = false;
            pnlFormMaterial.Visible = false;
            CargarLeccionesCampus();
            CargarMateriales();
            CargarForoAdmin();
            upCampus.Update(); // fuerza la actualización del UpdatePanel
            upForo.Update(); // refresca también el foro
        }
        // ─── LECCIONES ────────────────────────────────────────
        protected void btnNuevaLeccion_Click(object sender, EventArgs e)
        {
            hfIdLeccion.Value = "0";
            litFormLeccionTitulo.Text = "Nueva Lección";
            txtLeccionTitulo.Text = "";
            txtLeccionUrl.Text = "";
            txtLeccionDesc.Text = "";
            txtLeccionOrden.Text = "1";
            pnlFormLeccion.Visible = true;
        }
        protected void btnGuardarLeccion_Click(object sender, EventArgs e)
        {
            int idCurso;
            if (!int.TryParse(ddlCursosCampus.SelectedValue, out idCurso) || idCurso == 0) return;
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                int idLeccion = int.Parse(hfIdLeccion.Value);
                if (idLeccion == 0)
                {
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Lecciones (IdCurso, Titulo, Descripcion, UrlVideo, Orden, Activo)
                        VALUES (@IdCurso, @Titulo, @Desc, @Url, @Orden, 1)", conn);
                    cmd.Parameters.AddWithValue("@IdCurso", idCurso);
                    cmd.Parameters.AddWithValue("@Titulo", txtLeccionTitulo.Text.Trim());
                    cmd.Parameters.AddWithValue("@Desc", txtLeccionDesc.Text.Trim());
                    cmd.Parameters.AddWithValue("@Url", txtLeccionUrl.Text.Trim());
                    cmd.Parameters.AddWithValue("@Orden", int.Parse(txtLeccionOrden.Text.Trim()));
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Lecciones SET Titulo=@Titulo, Descripcion=@Desc,
                               UrlVideo=@Url, Orden=@Orden WHERE Id=@Id", conn);
                    cmd.Parameters.AddWithValue("@Titulo", txtLeccionTitulo.Text.Trim());
                    cmd.Parameters.AddWithValue("@Desc", txtLeccionDesc.Text.Trim());
                    cmd.Parameters.AddWithValue("@Url", txtLeccionUrl.Text.Trim());
                    cmd.Parameters.AddWithValue("@Orden", int.Parse(txtLeccionOrden.Text.Trim()));
                    cmd.Parameters.AddWithValue("@Id", idLeccion);
                    cmd.ExecuteNonQuery();
                }
            }
            pnlFormLeccion.Visible = false;
            CargarLeccionesCampus();
        }
        protected void btnCancelarLeccion_Click(object sender, EventArgs e)
        {
            pnlFormLeccion.Visible = false;
        }
        protected void rptLecciones_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            int id = int.Parse(e.CommandArgument.ToString());
            if (e.CommandName == "EliminarLeccion")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand delProgreso = new SqlCommand(
                    "DELETE FROM ProgresoLecciones WHERE IdLeccion = @Id", conn);
                    delProgreso.Parameters.AddWithValue("@Id", id);
                    delProgreso.ExecuteNonQuery();
                    SqlCommand cmd = new SqlCommand(
                    "DELETE FROM Lecciones WHERE Id = @Id", conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
                CargarLeccionesCampus();
                CargarMateriales();
            }
            else if (e.CommandName == "EditarLeccion")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Lecciones WHERE Id = @Id", conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfIdLeccion.Value = id.ToString();
                        litFormLeccionTitulo.Text = "Editar Lección";
                        txtLeccionTitulo.Text = dr["Titulo"].ToString();
                        txtLeccionUrl.Text = dr["UrlVideo"].ToString();
                        txtLeccionDesc.Text = dr["Descripcion"].ToString();
                        txtLeccionOrden.Text = dr["Orden"].ToString();
                        pnlFormLeccion.Visible = true;
                    }
                }
            }
        }
        // ─── MATERIALES ───────────────────────────────────────
        protected void btnNuevoMaterial_Click(object sender, EventArgs e)
        {
            txtMaterialNombre.Text = "";
            txtMaterialOrden.Text = "1";
            pnlFormMaterial.Visible = true;
        }
        protected void btnGuardarMaterial_Click(object sender, EventArgs e)
        {
            int idCurso;
            if (!int.TryParse(ddlCursosCampus.SelectedValue, out idCurso) || idCurso == 0) return;
            if (!fuMaterial.HasFile) return;
            string carpeta = Server.MapPath("~/Uploads/Cursos/");
            if (!System.IO.Directory.Exists(carpeta)) System.IO.Directory.CreateDirectory(carpeta);
            string ext = System.IO.Path.GetExtension(fuMaterial.FileName);
            string nombreArchivo = $"mat_{DateTime.Now.Ticks}{ext}";
            fuMaterial.SaveAs(carpeta + nombreArchivo);
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO ArchivosCurso (IdCurso, Nombre, Archivo, Orden)
                    VALUES (@IdCurso, @Nombre, @Archivo, @Orden)", conn);
                cmd.Parameters.AddWithValue("@IdCurso", idCurso);
                cmd.Parameters.AddWithValue("@Nombre", txtMaterialNombre.Text.Trim());
                cmd.Parameters.AddWithValue("@Archivo", nombreArchivo);
                cmd.Parameters.AddWithValue("@Orden", int.Parse(txtMaterialOrden.Text.Trim()));
                cmd.ExecuteNonQuery();
            }
            pnlFormMaterial.Visible = false;
            CargarMateriales();
        }
        protected void btnCancelarMaterial_Click(object sender, EventArgs e)
        {
            pnlFormMaterial.Visible = false;
        }
        protected void rptMateriales_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "EliminarMaterial") return;
            int id = int.Parse(e.CommandArgument.ToString());
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand getArchivo = new SqlCommand(
                "SELECT Archivo FROM ArchivosCurso WHERE Id = @Id", conn);
                getArchivo.Parameters.AddWithValue("@Id", id);
                string archivo = getArchivo.ExecuteScalar()?.ToString() ?? "";
                SqlCommand cmd = new SqlCommand(
                "DELETE FROM ArchivosCurso WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
                if (!string.IsNullOrEmpty(archivo))
                {
                    string path = Server.MapPath("~/Uploads/Cursos/" + archivo);
                    if (System.IO.File.Exists(path)) System.IO.File.Delete(path);
                }
            }
            CargarMateriales();
        }
        // ─── INSCRIPCIONES — CONFIRMAR PAGO ──────────────────
        protected void rptInscripciones_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "ConfirmarPago") return;
            string[] args = e.CommandArgument.ToString().Split('|');
            int id = int.Parse(args[0]);
            int idCurso = int.Parse(args[1]);
            string nombre = args[2];
            string email = args[3];
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                "UPDATE Inscripciones SET Estado = 'Confirmado' WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
            }
            HLchip.CampusHelper.HabilitarAccesoCampus(idCurso, nombre, email);
            CargarDatos();
        }
        // ─── FORO ADMIN ───────────────────────────────────────
        protected void rptForoAdmin_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Responder") return;
            int idPregunta = int.Parse(e.CommandArgument.ToString());
            RepeaterItem item = (RepeaterItem)((Control)e.CommandSource).NamingContainer;
            TextBox txtResp = (TextBox)item.FindControl("txtRespuesta");
            string respuesta = txtResp?.Text.Trim() ?? "";
            if (string.IsNullOrWhiteSpace(respuesta)) return;
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
            INSERT INTO ForoRespuestas (IdPregunta, Respuesta, EsAdmin, Fecha)
            VALUES (@IdPregunta, @Respuesta, 1, GETDATE())", conn);
                cmd.Parameters.AddWithValue("@IdPregunta", idPregunta);
                cmd.Parameters.AddWithValue("@Respuesta", respuesta);
                cmd.ExecuteNonQuery();
            }
            txtResp.Text = "";
            CargarForoAdmin();
            upForo.Update(); // refresca solo el foro
        }
        // ─── TURNOS ───────────────────────────────────────────
        protected void rptTurnos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            string estado = e.CommandName == "Confirmar" ? "Confirmado" : "Cancelado";
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                "UPDATE Turnos SET Estado = @Estado WHERE Id = @Id", conn);
                cmd.Parameters.AddWithValue("@Estado", estado);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            CargarDatos();
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Admin/Login.aspx");
        }

    }
}
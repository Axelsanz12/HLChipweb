using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
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
                CargarDatos();
        }

        private void CargarDatos()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Stats turnos
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

                // Stats consultas nuevas
                SqlCommand cmdConsultas = new SqlCommand(
                    "SELECT COUNT(*) FROM Consultas WHERE Leida = 0", conn);
                litConsultas.Text = cmdConsultas.ExecuteScalar().ToString();

                // Cargar turnos
                SqlDataAdapter daTurnos = new SqlDataAdapter(@"
                    SELECT t.Id, t.Nombre, t.Telefono, t.FechaTurno, t.HoraTurno,
                           tt.Nombre AS Servicio, t.Vehiculo, t.Estado
                    FROM Turnos t
                    INNER JOIN TiposTrabajo tt ON t.IdTipoTrabajo = tt.Id
                    ORDER BY t.FechaTurno ASC, t.HoraTurno ASC", conn);

                DataTable dtTurnos = new DataTable();
                daTurnos.Fill(dtTurnos);

                if (dtTurnos.Rows.Count > 0)
                {
                    rptTurnos.DataSource = dtTurnos;
                    rptTurnos.DataBind();
                }
                else
                {
                    pnlSinTurnos.Visible = true;
                }

                // Cargar pedidos de mapas
                SqlDataAdapter daMapas = new SqlDataAdapter(@"
                    SELECT p.Id, p.Nombre, p.Telefono, 
                           ISNULL(m.Nombre, 'No especificada') AS Marca,
                           p.Motor, p.TipoMapa, p.ArchivoOriginal,
                           p.Estado, p.FechaCreacion
                    FROM PedidosMapas p
                    LEFT JOIN Marcas m ON p.IdMarca = m.Id
                    ORDER BY p.FechaCreacion DESC", conn);

                DataTable dtMapas = new DataTable();
                daMapas.Fill(dtMapas);

                if (dtMapas.Rows.Count > 0)
                {
                    rptMapas.DataSource = dtMapas;
                    rptMapas.DataBind();
                }
                else
                {
                    pnlSinMapas.Visible = true;
                }

                // Cargar inscripciones online
                SqlDataAdapter daInscripciones = new SqlDataAdapter(@"
                    SELECT i.Id, i.Nombre, i.Telefono, i.Email,
                           c.Nombre AS Curso, i.Consulta,
                           i.Estado, i.FechaCreacion
                    FROM Inscripciones i
                    INNER JOIN Cursos c ON i.IdCurso = c.Id
                    ORDER BY i.FechaCreacion DESC", conn);

                DataTable dtInscripciones = new DataTable();
                daInscripciones.Fill(dtInscripciones);

                if (dtInscripciones.Rows.Count > 0)
                {
                    rptInscripciones.DataSource = dtInscripciones;
                    rptInscripciones.DataBind();
                }
                else
                {
                    pnlSinInscripciones.Visible = true;
                }

                // Cargar inscripciones presenciales
                SqlDataAdapter daPresenciales = new SqlDataAdapter(@"
                    SELECT i.Id, i.Nombre, i.Telefono, i.Email,
                           c.Nombre AS Taller, c.Fecha AS FechaTaller,
                           i.Consulta, i.Estado, i.FechaCreacion
                    FROM InscripcionesPresenciales i
                    INNER JOIN CursosPresenciales c ON i.IdCurso = c.Id
                    ORDER BY i.FechaCreacion DESC", conn);

                DataTable dtPresenciales = new DataTable();
                daPresenciales.Fill(dtPresenciales);

                if (dtPresenciales.Rows.Count > 0)
                {
                    rptPresenciales.DataSource = dtPresenciales;
                    rptPresenciales.DataBind();
                }
                else
                {
                    pnlSinPresenciales.Visible = true;
                }

                // Cargar consultas
                SqlDataAdapter daConsultas = new SqlDataAdapter(
                    "SELECT * FROM Consultas ORDER BY Fecha DESC", conn);

                DataTable dtConsultas = new DataTable();
                daConsultas.Fill(dtConsultas);

                if (dtConsultas.Rows.Count > 0)
                {
                    rptConsultas.DataSource = dtConsultas;
                    rptConsultas.DataBind();
                }
                else
                {
                    pnlSinConsultas.Visible = true;
                }
            }
        }

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
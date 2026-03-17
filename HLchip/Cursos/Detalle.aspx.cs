using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
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
                if (dt.Rows.Count == 0) { pnlNotFound.Visible = true; return; }

                DataRow r = dt.Rows[0];
                litNombre.Text = r["Nombre"].ToString();
                litDesc.Text = r["Descripcion"].ToString();
                litDuracion.Text = r["Duracion"].ToString();
                litModalidad.Text = r["Modalidad"].ToString();
                litPrecio.Text = String.Format("{0:N0}", r["Precio"]);
                hfIdCurso.Value = id.ToString();

                string temario = r["Temario"].ToString();
                string[] items = temario.Split(new string[] { "||" }, StringSplitOptions.RemoveEmptyEntries);
                rptTemario.DataSource = items;
                rptTemario.DataBind();

                pnlCurso.Visible = true;
            }
        }

        protected void btnInscribir_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text))
                return;

            Session["Inscripcion_Nombre"] = txtNombre.Text.Trim();
            Session["Inscripcion_Telefono"] = txtTelefono.Text.Trim();
            Session["Inscripcion_Email"] = txtEmail.Text.Trim();
            Session["Inscripcion_Consulta"] = txtConsulta.Text.Trim();
            Session["Inscripcion_IdCurso"] = hfIdCurso.Value;
            Session["Inscripcion_Metodo"] = hfMetodoPago.Value;

            pnlFormInscripcion.Visible = false;

            if (hfMetodoPago.Value == "mercadopago")
                pnlMercadoPago.Visible = true;
            else
                pnlTransferencia.Visible = true;
        }

        protected void btnEnviarTransferencia_Click(object sender, EventArgs e)
        {
            string nombre = Session["Inscripcion_Nombre"]?.ToString() ?? "";
            string telefono = Session["Inscripcion_Telefono"]?.ToString() ?? "";
            string email = Session["Inscripcion_Email"]?.ToString() ?? "";
            string consulta = Session["Inscripcion_Consulta"]?.ToString() ?? "";
            int idCurso = int.Parse(Session["Inscripcion_IdCurso"]?.ToString() ?? "0");
            if (idCurso == 0) return;

            // Validar y subir comprobante
            string archivoComprobante = "";
            if (fuComprobante.HasFile)
            {
                string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".pdf" };
                string ext = Path.GetExtension(fuComprobante.FileName).ToLower();
                if (Array.IndexOf(extensionesPermitidas, ext) == -1)
                {
                    litErrorComprobante.Text = "// Solo se permiten archivos JPG, PNG o PDF";
                    litErrorComprobante.Visible = true;
                    pnlTransferencia.Visible = true;
                    return;
                }

                string carpeta = Server.MapPath("~/Uploads/Comprobantes/");
                if (!Directory.Exists(carpeta)) Directory.CreateDirectory(carpeta);
                string nombreArchivo = $"comp_{DateTime.Now.Ticks}{ext}";
                fuComprobante.SaveAs(carpeta + nombreArchivo);
                archivoComprobante = nombreArchivo;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Inscripciones 
                        (IdCurso, Nombre, Telefono, Email, Consulta, Estado, MetodoPago, ComprobanteTransferencia)
                    OUTPUT INSERTED.Id
                    VALUES 
                        (@IdCurso, @Nombre, @Telefono, @Email, @Consulta, 'Pendiente', 'Transferencia', @Comprobante)", conn);
                cmd.Parameters.AddWithValue("@IdCurso", idCurso);
                cmd.Parameters.AddWithValue("@Nombre", nombre);
                cmd.Parameters.AddWithValue("@Telefono", telefono);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Consulta", consulta);
                cmd.Parameters.AddWithValue("@Comprobante", archivoComprobante);
                cmd.ExecuteScalar();
            }

            Session.Remove("Inscripcion_Nombre");
            Session.Remove("Inscripcion_Telefono");
            Session.Remove("Inscripcion_Email");
            Session.Remove("Inscripcion_Consulta");
            Session.Remove("Inscripcion_IdCurso");
            Session.Remove("Inscripcion_Metodo");

            pnlTransferencia.Visible = false;
            pnlOk.Visible = true;
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            pnlMercadoPago.Visible = false;
            pnlTransferencia.Visible = false;
            pnlFormInscripcion.Visible = true;
        }

        public void HabilitarAccesoCampus(int idCurso, string nombre, string email)
        {
            CampusHelper.HabilitarAccesoCampus(idCurso, nombre, email);
        }
    }
}
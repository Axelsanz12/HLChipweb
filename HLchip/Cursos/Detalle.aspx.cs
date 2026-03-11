using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
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

            // Subir comprobante
            string archivoComprobante = "";
            if (fuComprobante.HasFile)
            {
                string carpeta = Server.MapPath("~/Uploads/Comprobantes/");
                if (!Directory.Exists(carpeta)) Directory.CreateDirectory(carpeta);
                string ext = Path.GetExtension(fuComprobante.FileName);
                string nombreArchivo = $"comp_{DateTime.Now.Ticks}{ext}";
                fuComprobante.SaveAs(carpeta + nombreArchivo);
                archivoComprobante = nombreArchivo;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            int idInscripcion = 0;
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
                idInscripcion = (int)cmd.ExecuteScalar();
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
            string password = GenerarPassword();
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand checkAlumno = new SqlCommand(
                    "SELECT Id FROM AlumnosCampus WHERE Email = @Email", conn);
                checkAlumno.Parameters.AddWithValue("@Email", email);
                object alumnoIdObj = checkAlumno.ExecuteScalar();

                int idAlumno;
                if (alumnoIdObj == null)
                {
                    SqlCommand insAlumno = new SqlCommand(@"
                        INSERT INTO AlumnosCampus (Nombre, Email, Password, Activo)
                        OUTPUT INSERTED.Id
                        VALUES (@Nombre, @Email, @Password, 1)", conn);
                    insAlumno.Parameters.AddWithValue("@Nombre", nombre);
                    insAlumno.Parameters.AddWithValue("@Email", email);
                    insAlumno.Parameters.AddWithValue("@Password", password);
                    idAlumno = (int)insAlumno.ExecuteScalar();
                }
                else
                {
                    idAlumno = (int)alumnoIdObj;
                    password = "(tu contraseña anterior)";
                }

                SqlCommand checkCurso = new SqlCommand(@"
                    SELECT COUNT(*) FROM AlumnoCurso 
                    WHERE IdAlumno = @IdAlumno AND IdCurso = @IdCurso", conn);
                checkCurso.Parameters.AddWithValue("@IdAlumno", idAlumno);
                checkCurso.Parameters.AddWithValue("@IdCurso", idCurso);
                int tieneCurso = (int)checkCurso.ExecuteScalar();

                if (tieneCurso == 0)
                {
                    SqlCommand insCurso = new SqlCommand(@"
                        INSERT INTO AlumnoCurso (IdAlumno, IdCurso, Progreso)
                        VALUES (@IdAlumno, @IdCurso, 0)", conn);
                    insCurso.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    insCurso.Parameters.AddWithValue("@IdCurso", idCurso);
                    insCurso.ExecuteNonQuery();
                }
            }

            EnviarEmailAcceso(email, nombre, password);
        }

        private string GenerarPassword()
        {
            const string chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
            var rnd = new Random();
            char[] pass = new char[8];
            for (int i = 0; i < 8; i++)
                pass[i] = chars[rnd.Next(chars.Length)];
            return new string(pass);
        }

        private void EnviarEmailAcceso(string email, string nombre, string password)
        {
            try
            {
                var mail = new System.Net.Mail.MailMessage();
                mail.From = new System.Net.Mail.MailAddress("no-reply@hlchip.com.ar", "HLChip Campus");
                mail.To.Add(email);
                mail.Subject = "Bienvenido al Campus HLChip 🎓";
                mail.IsBodyHtml = true;
                mail.Body = $@"
                <div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto;background:#0e1118;color:#e8ecf0;padding:40px;border-radius:12px;'>
                    <h2 style='color:#00aaff;font-size:1.8rem;margin-bottom:4px;'>HLChip Campus</h2>
                    <p style='color:#6b7280;font-size:0.8rem;margin-bottom:32px;'>// Tu acceso exclusivo</p>
                    <p>Hola <strong>{nombre}</strong>,</p>
                    <p>Tu pago fue confirmado. Ya podés acceder al campus con estas credenciales:</p>
                    <div style='background:#13171f;border:1px solid rgba(255,255,255,0.08);border-radius:8px;padding:24px;margin:24px 0;'>
                        <p style='margin:0 0 8px;'><span style='color:#6b7280;'>Email:</span> <strong>{email}</strong></p>
                        <p style='margin:0;'><span style='color:#6b7280;'>Contraseña:</span> <strong style='color:#00aaff;'>{password}</strong></p>
                    </div>
                    <a href='http://hlchip.com.ar/Campus/Login.aspx' 
                       style='display:inline-block;background:#00aaff;color:#000;padding:14px 28px;border-radius:6px;text-decoration:none;font-weight:bold;'>
                       INGRESAR AL CAMPUS
                    </a>
                    <p style='margin-top:32px;color:#6b7280;font-size:0.8rem;'>HLChip · Chiptuning &amp; Reprogramación ECU</p>
                </div>";

                var smtp = new System.Net.Mail.SmtpClient();
                smtp.Send(mail);
            }
            catch { }
        }
    }
}
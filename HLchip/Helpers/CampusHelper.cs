using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;

namespace HLchip
{
    public static class CampusHelper
    {
        public static void HabilitarAccesoCampus(int idCurso, string nombre, string email)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;
            string password = null;           // Solo se genera si es nuevo
            string token = null;              // No generamos token si confirmamos de inmediato
            bool esNuevo = false;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Verificar si el alumno ya existe
                SqlCommand checkAlumno = new SqlCommand(
                    "SELECT Id, Password FROM AlumnosCampus WHERE Email = @Email", conn);
                checkAlumno.Parameters.AddWithValue("@Email", email);
                using (SqlDataReader dr = checkAlumno.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        // Existe → reutilizamos password existente
                        password = dr["Password"]?.ToString();
                    }
                    else
                    {
                        // Nuevo alumno
                        esNuevo = true;
                        password = GenerarPassword();
                    }
                }

                int idAlumno;

                if (esNuevo)
                {
                    // Insertar nuevo con Confirmado = 1 directamente
                    SqlCommand insAlumno = new SqlCommand(@"
                        INSERT INTO AlumnosCampus 
                        (Nombre, Email, Password, Activo, Confirmado, TokenConfirmacion, FechaCreacion)
                        OUTPUT INSERTED.Id
                        VALUES (@Nombre, @Email, @Password, 1, 1, NULL, GETDATE())", conn);

                    insAlumno.Parameters.AddWithValue("@Nombre", nombre);
                    insAlumno.Parameters.AddWithValue("@Email", email);
                    insAlumno.Parameters.AddWithValue("@Password", password);
                    idAlumno = (int)insAlumno.ExecuteScalar();
                }
                else
                {
                    // Existe → solo confirmar
                    SqlCommand updAlumno = new SqlCommand(
                        "UPDATE AlumnosCampus SET Confirmado = 1, TokenConfirmacion = NULL WHERE Email = @Email", conn);
                    updAlumno.Parameters.AddWithValue("@Email", email);
                    updAlumno.ExecuteNonQuery();

                    // Obtener ID para asignar curso
                    SqlCommand getId = new SqlCommand(
                        "SELECT Id FROM AlumnosCampus WHERE Email = @Email", conn);
                    getId.Parameters.AddWithValue("@Email", email);
                    idAlumno = (int)getId.ExecuteScalar();
                }

                // Asignar curso si no lo tiene
                SqlCommand checkCurso = new SqlCommand(
                    "SELECT COUNT(*) FROM AlumnoCurso WHERE IdAlumno = @IdAlumno AND IdCurso = @IdCurso", conn);
                checkCurso.Parameters.AddWithValue("@IdAlumno", idAlumno);
                checkCurso.Parameters.AddWithValue("@IdCurso", idCurso);
                int tieneCurso = (int)checkCurso.ExecuteScalar();

                if (tieneCurso == 0)
                {
                    SqlCommand cmdDias = new SqlCommand(
                        "SELECT DiasAcceso FROM Cursos WHERE Id = @Id", conn);
                    cmdDias.Parameters.AddWithValue("@Id", idCurso);
                    int diasAcceso = Convert.ToInt32(cmdDias.ExecuteScalar() ?? 30); // fallback 30 días si null

                    SqlCommand insCurso = new SqlCommand(@"
                        INSERT INTO AlumnoCurso 
                        (IdAlumno, IdCurso, FechaAcceso, Progreso, FechaVencimiento)
                        VALUES (@IdAlumno, @IdCurso, GETDATE(), 0, @FechaVencimiento)", conn);

                    insCurso.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    insCurso.Parameters.AddWithValue("@IdCurso", idCurso);
                    insCurso.Parameters.AddWithValue("@FechaVencimiento", DateTime.Now.AddDays(diasAcceso));
                    insCurso.ExecuteNonQuery();
                }
            }

            // Enviar email informativo (ya confirmado)
            EnviarEmailAcceso(email, nombre, password, esNuevo);
        }

        private static string GenerarPassword()
        {
            const string chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
            var rnd = new Random();
            char[] pass = new char[10]; // 10 caracteres para más seguridad
            for (int i = 0; i < 10; i++)
                pass[i] = chars[rnd.Next(chars.Length)];
            return new string(pass);
        }

        private static void EnviarEmailAcceso(string email, string nombre, string password, bool esNuevo)
        {
            try
            {
                string baseUrl = "http://localhost:44363"; // ← CAMBIAR EN PRODUCCIÓN (o usar ConfigurationManager.AppSettings) cuando tengamos hostin
                string loginUrl = $"{baseUrl}/Campus/Login.aspx";

                string cuerpo;
                if (esNuevo)
                {
                    cuerpo = $@"
                        <h2>¡Bienvenido al Campus HLChip, {nombre}!</h2>
                        <p>Tu pago fue confirmado por nuestro equipo. <strong>Tu acceso ya está activo</strong>.</p>
                        <p>Podés ingresar inmediatamente con estas credenciales:</p>
                        <p><strong>Email:</strong> {email}<br/>
                        <strong>Contraseña:</strong> {password}</p>
                        <p style='margin-top:20px;'>
                            <a href='{loginUrl}' style='background:#00aaff;color:#000;padding:12px 24px;border-radius:6px;text-decoration:none;font-weight:bold;'>
                                → Ingresar al Campus ahora
                            </a>
                        </p>
                        <p style='font-size:0.9em;color:#777;margin-top:30px;'>
                            Guardá esta contraseña en un lugar seguro. Podés cambiarla desde tu perfil una vez dentro.
                        </p>";
                }
                else
                {
                    cuerpo = $@"
                        <h2>¡Hola {nombre}!</h2>
                        <p>Tu pago por transferencia fue confirmado.</p>
                        <p>Tu acceso al nuevo curso ya está activo. Ingresá con tu email y contraseña habitual:</p>
                        <p><strong>Email:</strong> {email}</p>
                        <p style='margin-top:20px;'>
                            <a href='{loginUrl}' style='background:#00aaff;color:#000;padding:12px 24px;border-radius:6px;text-decoration:none;font-weight:bold;'>
                                → Ir al Campus
                            </a>
                        </p>";
                }

                var mail = new MailMessage();
                mail.From = new MailAddress("axelsanz614@gmail.com", "HLChip Campus");
                mail.To.Add(email);
                mail.Subject = "HLChip Campus — Acceso Activado";
                mail.Body = cuerpo;
                mail.IsBodyHtml = true;

                var smtp = new SmtpClient();
                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                // Logueo simple (puede mejorarse con un logger real)
                try
                {
                    string logPath = System.Web.Hosting.HostingEnvironment.MapPath("~/App_Data/email_errors.txt");
                    System.IO.File.AppendAllText(logPath, $"{DateTime.Now}: Error enviando email a {email} → {ex.Message}\n{ex.StackTrace}\n\n");
                }
                catch { /* silent fail */ }
            }
        }
    }
}
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace HLchip
{
    public partial class Turnos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarTiposTrabajo();
            }
        }

        private void CargarTiposTrabajo()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Id, Nombre, Duracion, Descripcion FROM TiposTrabajo WHERE Activo = 1";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptTipos.DataSource = dt;
                rptTipos.DataBind();
            }
        }

        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(hfFecha.Value) ||
                string.IsNullOrWhiteSpace(hfHora.Value) ||
                string.IsNullOrWhiteSpace(hfTipoId.Value))
                return;

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Turnos 
                    (Nombre, Telefono, Email, FechaTurno, HoraTurno, 
                     IdTipoTrabajo, Vehiculo, Observaciones, Estado)
                    VALUES 
                    (@Nombre, @Telefono, @Email, @Fecha, @Hora,
                     @TipoId, @Vehiculo, @Observaciones, 'Pendiente')";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Fecha", DateTime.Parse(hfFecha.Value));
                cmd.Parameters.AddWithValue("@Hora", TimeSpan.Parse(hfHora.Value));
                cmd.Parameters.AddWithValue("@TipoId", int.Parse(hfTipoId.Value));
                cmd.Parameters.AddWithValue("@Vehiculo", txtVehiculo.Text.Trim());
                cmd.Parameters.AddWithValue("@Observaciones", txtObservaciones.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            pnlOk.Style["display"] = "block";
        }
    }
}
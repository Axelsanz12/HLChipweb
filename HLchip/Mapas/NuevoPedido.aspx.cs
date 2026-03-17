using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace HLchip.Mapas
{
    public partial class NuevoPedido : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarMarcas();
            }
        }

        private void CargarMarcas()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT Id, Nombre FROM Marcas ORDER BY Nombre", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlMarca.DataSource = dt;
                ddlMarca.DataTextField = "Nombre";
                ddlMarca.DataValueField = "Id";
                ddlMarca.DataBind();
                ddlMarca.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccioná --", "0"));
            }
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                ddlTipoMapa.SelectedValue == "")
                return;

            // Guardar archivo si se subió
            string archivoNombre = "";
            if (fileECU.HasFile)
            {
                string carpeta = Server.MapPath("~/Archivos/ECU/");
                if (!Directory.Exists(carpeta))
                    Directory.CreateDirectory(carpeta);

                string ext = Path.GetExtension(fileECU.FileName);
                archivoNombre = DateTime.Now.Ticks + "_" +
                                txtNombre.Text.Trim().Replace(" ", "_") + ext;
                fileECU.SaveAs(carpeta + archivoNombre);
            }

            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO PedidosMapas 
                    (Nombre, Telefono, Email, IdMarca, Anio, Motor, 
                     TipoMapa, ArchivoOriginal, Observaciones, Estado)
                    VALUES 
                    (@Nombre, @Telefono, @Email, @IdMarca, @Anio, @Motor,
                     @TipoMapa, @Archivo, @Obs, 'Recibido')";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@IdMarca", ddlMarca.SelectedValue == "0" ?
                                            (object)DBNull.Value : int.Parse(ddlMarca.SelectedValue));
                cmd.Parameters.AddWithValue("@Anio", string.IsNullOrWhiteSpace(txtAnio.Text) ?
                                            (object)DBNull.Value : int.Parse(txtAnio.Text));
                cmd.Parameters.AddWithValue("@Motor", txtMotor.Text.Trim());
                cmd.Parameters.AddWithValue("@TipoMapa", ddlTipoMapa.SelectedValue);
                cmd.Parameters.AddWithValue("@Archivo", archivoNombre);
                cmd.Parameters.AddWithValue("@Obs", txtObs.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Limpiar form
            txtNombre.Text = txtTelefono.Text = txtEmail.Text = "";
            txtAnio.Text = txtMotor.Text = txtObs.Text = "";
            ddlTipoMapa.SelectedIndex = 0;
            txtModelo.Text = "";

            pnlOk.Visible = true;
        }
    }
}
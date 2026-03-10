using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace HLchip
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarServicios();
            }
        }

        private void CargarServicios()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Id, Nombre, Descripcion, Icono FROM Servicios WHERE Activo = 1 ORDER BY Orden";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptServicios.DataSource = dt;
                rptServicios.DataBind();
            }
        }
    }
}
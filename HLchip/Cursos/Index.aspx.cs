using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace HLchip.Cursos
{
    public partial class Index : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarCursos();
        }

        private void CargarCursos()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HLChipDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT * FROM Cursos WHERE Activo = 1 ORDER BY Orden", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptCursos.DataSource = dt;
                rptCursos.DataBind();
            }
        }
    }
}
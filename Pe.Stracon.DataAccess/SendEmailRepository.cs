using Pe.Stracon.Models.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace Pe.Stracon.DataAccess
{
    public class SendEmailRepository
    {
        public SendEmailRepository()
        {

        }

        public void SendEmail(EmailMesageDTO email)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conectSGCO"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("USP_NOTIFICACION_BANDEJA_REQUERIMIENTOS", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ASUNTO", SqlDbType.VarChar).Value = email.Asunto;
                    cmd.Parameters.AddWithValue("@TEXTO_NOTIFICAR", SqlDbType.VarChar).Value = email.Texto_Notificar;
                    cmd.Parameters.AddWithValue("@CUENTA_NOTIFICAR", SqlDbType.VarChar).Value = email.Cuenta_Notificar;
                    cmd.Parameters.AddWithValue("@CUENTAS_COPIAS", SqlDbType.VarChar).Value = email.Cuentas_Copias;
                    cmd.Parameters.AddWithValue("@PROFILE_CORREO", SqlDbType.VarChar).Value = email.Profile_Correo;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

}

using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;

namespace Pe.Stracon.DataAccess
{
    public class ValueParameterRepository : Repository<PARAMETRO_VALOR>
    {
        public ValueParameterRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<ParameterValorDTO> GetDataParametros_x_CodParametro(int CodPar)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conectSGCO"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("[DBO].[USP_GET_DATOS_PARAMETROS]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CodigoPar", SqlDbType.Int).Value = CodPar;

                    con.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        var resultados =
                            ((IObjectContextAdapter)_contexto)
                                .ObjectContext
                                .Translate<ParameterValorDTO>(reader)
                                .ToList();

                        reader.NextResult();
                        con.Close();
                        return resultados;
                    }
                }
            }
        }

        public IEnumerable<string> GetParameterValueList() => (from pv in _contexto.PARAMETRO_VALOR
                                                               where pv.CODIGO_PARAMETRO == 56
                                                               && pv.CODIGO_SECCION == 2
                                                               select pv.VALOR).ToList();

        public IEnumerable<string> GetArticleGroupList()
        {
            return (from pv in _contexto.PARAMETRO_VALOR
                    where pv.CODIGO_PARAMETRO == 55 && pv.CODIGO_SECCION == 2
                    select pv.VALOR).ToList();
        }

        public IEnumerable<string> GetUnitMeasureList()
        {
            return (from pv in _contexto.PARAMETRO_VALOR
                    where pv.CODIGO_PARAMETRO == 54 && pv.CODIGO_SECCION == 2
                    select pv.VALOR).ToList();
        }

        public string GetEmailEncargado()
        {
            return (from pv in _contexto.PARAMETRO_VALOR
                    where pv.CODIGO_PARAMETRO == 56
                    && pv.CODIGO_SECCION == 3
                    select pv.VALOR).FirstOrDefault();
        }

        public string GetEmailAceptador()
        {
            return (from pv in _contexto.PARAMETRO_VALOR
                    where pv.CODIGO_PARAMETRO == 56
                    && pv.CODIGO_SECCION == 3
                    select pv.VALOR).FirstOrDefault();
        }

        public void SendEmail(EmailMesageDTO email)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conectSGCO"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("[DBO].[USP_NOTIFICACION_BANDEJA_REQUERIMIENTOS]", con))
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

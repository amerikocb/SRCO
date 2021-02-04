using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.Models.DTO
{
    public class EmailMesageDTO
    {
        public string Asunto { get; set; }
        public string Texto_Notificar { get; set; }
        public string Cuenta_Notificar { get; set; }
        public string Cuentas_Copias { get; set; }
        public string Profile_Correo { get; set; }
    }
}

//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Pe.Stracon.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class PARAMETRO_VALOR
    {
        public int CODIGO_PARAMETRO { get; set; }
        public int CODIGO_SECCION { get; set; }
        public int CODIGO_VALOR { get; set; }
        public string VALOR { get; set; }
        public string ESTADO_REGISTRO { get; set; }
        public string USUARIO_CREACION { get; set; }
        public System.DateTime FECHA_CREACION { get; set; }
        public string TERMINAL_CREACION { get; set; }
        public string USUARIO_MODIFICACION { get; set; }
        public Nullable<System.DateTime> FECHA_MODIFICACION { get; set; }
        public string TERMINAL_MODIFICACION { get; set; }
    }
}

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
    
    public partial class TRABAJADOR
    {
        public System.Guid CODIGO_TRABAJADOR { get; set; }
        public string DOMINIO { get; set; }
        public string CODIGO_IDENTIFICACION { get; set; }
        public string CODIGO_TIPO_DOCUMENTO_IDENTIDAD { get; set; }
        public string NUMERO_DOCUMENTO_IDENTIDAD { get; set; }
        public string APELLIDO_PATERNO { get; set; }
        public string APELLIDO_MATERNO { get; set; }
        public string NOMBRES { get; set; }
        public string NOMBRE_COMPLETO { get; set; }
        public string ORGANIZACION { get; set; }
        public string DEPARTAMENTO { get; set; }
        public string CARGO { get; set; }
        public string TELEFONO_TRABAJO { get; set; }
        public string ANEXO { get; set; }
        public string TELEFONO_MOVIL { get; set; }
        public string TELEFONO_PERSONAL { get; set; }
        public string CORREO_ELECTRONICO { get; set; }
        public bool INDICADOR_TODA_UNIDAD_OPERATIVA { get; set; }
        public Nullable<System.Guid> CODIGO_UNIDAD_OPERATIVA_MATRIZ { get; set; }
        public bool INDICADOR_TIENE_FOTO { get; set; }
        public string ESTADO_REGISTRO { get; set; }
        public string USUARIO_CREACION { get; set; }
        public System.DateTime FECHA_CREACION { get; set; }
        public string TERMINAL_CREACION { get; set; }
        public string USUARIO_MODIFICACION { get; set; }
        public Nullable<System.DateTime> FECHA_MODIFICACION { get; set; }
        public string TERMINAL_MODIFICACION { get; set; }
    }
}

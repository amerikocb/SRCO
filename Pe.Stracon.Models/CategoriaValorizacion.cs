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
    
    public partial class CategoriaValorizacion
    {
        public int Id { get; set; }
        public Nullable<int> IdTipoMaterial { get; set; }
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
    
        public virtual TipoMaterial TipoMaterial { get; set; }
    }
}

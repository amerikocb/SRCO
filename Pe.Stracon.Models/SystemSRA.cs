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
    
    public partial class SystemSRA
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SystemSRA()
        {
            this.Role_System = new HashSet<Role_System>();
        }
    
        public int N_ID_SYSTEM { get; set; }
        public string S_NAME { get; set; }
        public string S_DESCRIPTION { get; set; }
        public string S_STATUS_REGISTER { get; set; }
        public string S_RUTE { get; set; }
        public string S_USER_CREATION { get; set; }
        public Nullable<System.DateTime> D_DATE_CREATION { get; set; }
        public string S_TERMINAL_CREATION { get; set; }
        public string S_USER_MODIFICATION { get; set; }
        public Nullable<System.DateTime> D_DATE_MODIFICATION { get; set; }
        public string S_TERMINAL_MODIFICATION { get; set; }
        public string S_OBSERVATION { get; set; }
        public string S_LANGUAGE { get; set; }
        public Nullable<System.DateTime> D_DATE_TERMINATE_REGISTER { get; set; }
        public string S_TOKEN { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Role_System> Role_System { get; set; }
    }
}

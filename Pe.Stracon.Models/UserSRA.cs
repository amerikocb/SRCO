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
    
    public partial class UserSRA
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public UserSRA()
        {
            this.User_Profile = new HashSet<User_Profile>();
        }
    
        public int ID_USER { get; set; }
        public string S_LAST_NAME { get; set; }
        public string S_LAST_NAME_1 { get; set; }
        public string S_LAST_NAME_2 { get; set; }
        public string S_NAME { get; set; }
        public string S_FULL_NAME { get; set; }
        public string S_LOGIN { get; set; }
        public string S_PASSWORD { get; set; }
        public string S_EMAIL { get; set; }
        public Nullable<System.DateTime> D_DATE_ACTIV_PASSWORD { get; set; }
        public Nullable<bool> S_INDICATOR_CHANGE_PASSWORD { get; set; }
        public Nullable<bool> S_INDICATOR_ASSOCIATED_AD { get; set; }
        public string S_TYPE_IDENTITY_DOCUMENT { get; set; }
        public string S_IP_ACCES_USER { get; set; }
        public string N_NUM_IDENTITY_DOC { get; set; }
        public string S_RED_USER { get; set; }
        public string S_DOMAIN_RED { get; set; }
        public byte[] B_PHOTO_USER { get; set; }
        public byte[] B_DIGITIZED_SIGNATURE { get; set; }
        public string S_STATUS_REGISTER { get; set; }
        public string S_ACCES_TERMINAL { get; set; }
        public string S_DESCRIPTION_REASON_TERMINATE { get; set; }
        public Nullable<System.DateTime> D_DATE_TERMINATE_REGISTER { get; set; }
        public string S_USER_CREATION { get; set; }
        public Nullable<System.DateTime> D_DATE_CREATION { get; set; }
        public string S_TERMINAL_CREATION { get; set; }
        public string S_USER_MODIFICATION { get; set; }
        public Nullable<System.DateTime> D_DATE_MODIFICATION { get; set; }
        public string S_TERMINAL_MODIFICATION { get; set; }
        public string S_OBSERVATION { get; set; }
        public string S_INDICATOR_ASSOCIATED_AD_TEXT { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<User_Profile> User_Profile { get; set; }
    }
}
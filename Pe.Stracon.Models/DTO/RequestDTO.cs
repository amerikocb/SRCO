using System;

namespace Pe.Stracon.Models.DTO
{
    public class RequestDTO
    {
        public int Id { get; set; }
        public string CentroLogistico { get; set; }
        public string Solicitante { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public string Estado { get; set; }
    }
}

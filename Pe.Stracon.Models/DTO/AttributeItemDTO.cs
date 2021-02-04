namespace Pe.Stracon.Models.DTO
{
    public class AttributeItemDTO
    {
        public int Id { get; set; }
        public int? IdAtributo { get; set; }
        public bool? Requerido { get; set; }
        public string AttributeDesc { get; set; }
        public string Valor { get; set; }
    }
}

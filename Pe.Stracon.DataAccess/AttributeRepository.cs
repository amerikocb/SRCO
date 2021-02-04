using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class AttributeRepository: Repository<Atributo>
    {
        public AttributeRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<AttributeItemDTO> GetAttributesList_x_Class(int idClass)
        {
            return (from a in _contexto.Atributo
                    where a.IdClase == idClass
                    select new AttributeItemDTO
                    {
                        IdAtributo = a.Id,
                        Requerido = a.Requerido,
                        AttributeDesc = a.Descripcion
                    }).ToList();
        }
    }
}

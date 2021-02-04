using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class ClaMaterialRepository: Repository<TabClaMaterial>
    {
        public ClaMaterialRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        //public IEnumerable<AttributeDTO> GetAttributeLis_x_Clase(string Clase)
        //{
        //    return (from clm in _contexto.TabClaMaterial
        //            where clm.vNomClase == Clase
        //            select new AttributeDTO
        //            {
        //                Requerido = clm.bObligatorio,
        //                AttributeDesc = clm.vNomAtributo
        //            }).ToList();
        //}
    }
}

using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class MaterialTypeRepository:Repository<TipoMaterial>
    {
        public MaterialTypeRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

    }
}

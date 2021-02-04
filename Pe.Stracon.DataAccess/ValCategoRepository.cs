using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class ValCategoRepository: Repository<CategoriaValorizacion>
    {
        public ValCategoRepository(STRACON_SGCOEntities contexto): base(contexto)
        {

        }

        public IEnumerable<CategoriaValorizacion> getCatVal_x_MaterialType(int IdMatType)
        {
            return _contexto.CategoriaValorizacion.Where(c => c.IdTipoMaterial == IdMatType).OrderByDescending(cv => cv.Descripcion).ToList();
        }
    }
}

using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class ClassRepository: Repository<Clase>
    {
        public ClassRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<Clase> GetClassList_x_IdGroup(int idGroup)
        {
            return _contexto.Clase.Where(c => c.IdGrupo == idGroup).ToList();
        }
    }
}

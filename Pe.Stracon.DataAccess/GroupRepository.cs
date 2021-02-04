using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class GroupRepository: Repository<Grupo>
    {
        public GroupRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<Grupo> GetGroupList_x_IdSegment(int IdSeg)
        {
            return _contexto.Grupo.Where(g => g.IdSegmento == IdSeg).ToList();
        }
    }
}

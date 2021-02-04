using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class SegmentRepository: Repository<Segmento>
    {
        public SegmentRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }
    }
}

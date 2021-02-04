using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class SegmentOnuRepository: Repository<SegmentoONU>
    {
        public SegmentOnuRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public string GetCode_x_Id(int idSeg)
        {
            return _contexto.SegmentoONU.Where(s => s.Id == s.Id).Select(se => se.Codigo).FirstOrDefault();
        }
    }
}

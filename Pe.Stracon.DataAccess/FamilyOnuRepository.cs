using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class FamilyOnuRepository: Repository<FamiliaONU>
    {
        public FamilyOnuRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<FamiliaONU> GetFamilyList_x_IdSegmentOnu(int IdSegOnu)
        {
            return _contexto.FamiliaONU.Where(g => g.IdSegmentoONU == IdSegOnu).ToList();
        }

        public string GetCode_x_Id(int IdFam)
        {
            return _contexto.FamiliaONU.Where(f => f.Id == IdFam).Select(fa => fa.Codigo).FirstOrDefault();
        }
    }
}

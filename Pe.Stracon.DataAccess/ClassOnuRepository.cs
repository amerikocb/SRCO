using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class ClassOnuRepository : Repository<ClaseONU>
    {
        public ClassOnuRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<ClaseONU> GetClassList_x_IdFamily(int idFamily)
        {
            return _contexto.ClaseONU.Where(c => c.IdFamiliaONU == idFamily).ToList();
        }

        public string GetCode_x_Id(int IdCl)
        {
            return _contexto.ClaseONU.Where(c => c.Id == IdCl).Select(cl => cl.Codigo).FirstOrDefault();
        }
    }
}

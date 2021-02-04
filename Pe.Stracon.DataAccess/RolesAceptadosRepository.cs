using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class RolesAceptadosRepository: Repository<RolesAceptados>
    {
        public RolesAceptadosRepository(STRACON_SGCOEntities contexto) : base(contexto) 
        {

        }

        public List<string> GetListAvailableProfiles()
        {
            return (from r in _contexto.RolesAceptados
                    select r.Descripcion).ToList();
        }
    }
}

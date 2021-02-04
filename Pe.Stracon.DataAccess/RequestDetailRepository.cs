using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Pe.Stracon.Models;

namespace Pe.Stracon.DataAccess
{
    public class RequestDetailRepository: Repository<DetalleRequerimiento>
    {
        public RequestDetailRepository(STRACON_SGCOEntities contexto): base(contexto)
        {

        }

        public IEnumerable<DetalleRequerimiento> getDetailRequesList_x_Request(int idR)
        {
            return _contexto.DetalleRequerimiento.Where(r => r.IdRequerimiento == idR).OrderByDescending(rd => rd.Id).ToList();
        }
    }
}

using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Linq;

namespace Pe.Stracon.DataAccess
{
    public class RequestRepository: Repository<Requerimiento>
    {
        public RequestRepository(STRACON_SGCOEntities contexto): base(contexto)
        {

        }

        public IEnumerable<RequestDTO> GetRequestList(List<string> estate)
        {
            return  (from r in _contexto.Requerimiento
                     where estate.Contains(r.Estado)
                    select new RequestDTO
                    {
                        Id = r.Id,
                        CentroLogistico = r.CentroLogistico,
                        Solicitante = r.Solicitante,
                        FechaCreacion = r.FechaCreacion,
                        Estado = r.Estado
                    }).OrderByDescending(r => r.Id).ToList();
        }
    }
}

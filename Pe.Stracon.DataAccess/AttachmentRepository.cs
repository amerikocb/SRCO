using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class AttachmentRepository: Repository<Adjunto>
    {
        public AttachmentRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<Adjunto> getAdjuntos_x_Request(int idR, string filtro)
        {
            return _contexto.Adjunto.Where(a => a.IdRequerimiento == idR && a.Seccion.Contains(filtro)).OrderByDescending(ad => ad.Id).ToList();
        }
    }
}

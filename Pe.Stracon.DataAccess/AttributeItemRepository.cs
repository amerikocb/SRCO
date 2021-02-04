using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pe.Stracon.DataAccess
{
    public class AttributeItemRepository : Repository<ItemAtributo>
    {
        public AttributeItemRepository(STRACON_SGCOEntities contexto) : base(contexto)
        {

        }

        public IEnumerable<AttributeItemDTO> GetAttributeItemList_x_ReqDet(int IdReqDet)
        {
            return (from ia in _contexto.ItemAtributo
                    join a in _contexto.Atributo on ia.IdAtributo equals a.Id
                    where ia.IdDetalleRequerimiento == IdReqDet
                    select new AttributeItemDTO
                    {
                        Id = ia.Id,
                        IdAtributo = ia.IdAtributo,
                        AttributeDesc = a.Descripcion,
                        Valor = ia.Valor,
                        Requerido = a.Requerido
                    }).ToList();
        }

        public int DeleteAttributes_X_ReqDetail(int IdReqDet)
        {
            var ad = _contexto.ItemAtributo.Where(ia => ia.IdDetalleRequerimiento == IdReqDet);
            _contexto.ItemAtributo.RemoveRange(ad);
            return _contexto.SaveChanges();
        }
    }
}

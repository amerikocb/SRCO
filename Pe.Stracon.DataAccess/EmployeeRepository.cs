using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System.Collections.Generic;
using System.Linq;

namespace Pe.Stracon.DataAccess
{
    public class EmployeeRepository : Repository<TRABAJADOR>
    {
        public EmployeeRepository(STRACON_POLITICASEntities contextoPol): base(contextoPol)
        {

        }

        //public IEnumerable<EmployeeDTO> getEmployeesList()
        // {
        //     return (from e in contextoPol.TRABAJADOR
        //             select new EmployeeDTO
        //             {
        //                 Codigo = e.CODIGO_IDENTIFICACION,
        //                 Nombre = e.NOMBRE_COMPLETO
        //             }).ToList();
        // }

        public IEnumerable<string> getEmployeesList()
        {
            return (from e in contextoPol.TRABAJADOR
                    select e.NOMBRE_COMPLETO).ToList();
        }
    }
}

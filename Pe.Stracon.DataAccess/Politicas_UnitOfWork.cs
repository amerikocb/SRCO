using Pe.Stracon.Models;
using System;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Text;

namespace Pe.Stracon.DataAccess
{
    public class Politicas_UnitOfWork : IDisposable
    {
        private STRACON_POLITICASEntities _contextoPol = new STRACON_POLITICASEntities();

        private Boolean disposed = false;

        private readonly EmployeeRepository trabajador;

        public EmployeeRepository Trabajador => this.trabajador ?? new EmployeeRepository(_contextoPol);
        protected virtual void Dispose(Boolean disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _contextoPol.Dispose();
                }
            }
            this.disposed = true;
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

    }
}

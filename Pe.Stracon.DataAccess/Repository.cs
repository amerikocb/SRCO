using Pe.Stracon.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;

namespace Pe.Stracon.DataAccess
{
    public class Repository<T> where T : class
    {
        internal STRACON_SGCOEntities _contexto;
        //internal STRACON_POLITICASEntities _contextoPol;
        internal DbSet<T> dbSet;
        internal STRACON_POLITICASEntities contextoPol;

        public Repository(STRACON_SGCOEntities contexto)
        {
            this._contexto = contexto;
            this.dbSet = this._contexto.Set<T>();
        }

        public Repository(STRACON_POLITICASEntities contextoPol)
        {
            this.contextoPol = contextoPol;
        }

        /// <summary>
        /// Permite leer los registros de la tabla pero con posibilidad de filtrar, ordenar, incluir otras tablas y cant filas
        /// </summary>
        /// <param name="filtrar"></param>
        /// <param name="ordenarPor"></param>
        /// <param name="incluirPropiedades"></param>
        /// <param name="nroFilas">si se ingresa 0 trae todas las filas</param>
        /// <returns></returns>
        public IEnumerable<T> GetList(
            Expression<Func<T, bool>> filtrar = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> ordenarPor = null,
            string incluirPropiedades = "",
            int nroFilas = 0)
        {
            IQueryable<T> query = dbSet;

            if (filtrar != null)
            {
                query = query.Where(filtrar);
            }

            foreach (var includeProperty in incluirPropiedades.Split
                (new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                query = query.Include(incluirPropiedades);
            }

            if (ordenarPor != null)
            {
                query = ordenarPor(query);
            }

            if (nroFilas > 0)
            {
                query = query.Take(nroFilas);
            }

            return query.ToList();

            //if (ordenarPor != null)
            //{
            //    return ordenarPor(query).ToList();
            //}
            //else
            //{
            //    return query.ToList();
            //}
        }

        public T GetById(object id)
        {
            return dbSet.Find(id);
        }

        public virtual void Insert(T entidad)
        {
            dbSet.Add(entidad);
        }

        public void InsertarRango(IEnumerable<T> entidades)
        {
            dbSet.AddRange(entidades);
        }

        public virtual void EliminarPorId(object id)
        {
            T entidadAEliminar = dbSet.Find(id);
            Delete(entidadAEliminar);
        }

        public virtual void Delete(T entidadAEliminar)
        {
            if (_contexto.Entry(entidadAEliminar).State == EntityState.Detached)
            {
                dbSet.Attach(entidadAEliminar);
            }
            dbSet.Remove(entidadAEliminar);
        }

        public void DeleteRange(IEnumerable<T> entidades)
        {
            dbSet.RemoveRange(entidades);
        }

        public virtual void Update(T entidadAActualizar)
        {
            dbSet.Attach(entidadAActualizar);
            _contexto.Entry(entidadAActualizar).State = EntityState.Modified;
        }

        public virtual bool Existe(Expression<Func<T, bool>> filtrar)
        {
            IQueryable<T> query = dbSet;
            return filtrar == null ? false : query.Any(filtrar);
        }
    }
}

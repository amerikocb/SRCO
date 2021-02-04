using Pe.Stracon.Models;
using System;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Text;

namespace Pe.Stracon.DataAccess
{
    public class SGCO_UnitOfWork : IDisposable
    {
        private readonly STRACON_SGCOEntities _contexto = new STRACON_SGCOEntities();
        
        private Boolean disposed = false;

        private readonly RequestRepository request;
        private readonly ValueParameterRepository valueParameter;
        private readonly MaterialTypeRepository materialType;
        private readonly SegmentRepository segment;
        private readonly AttachmentRepository attachment;
        private readonly RequestDetailRepository requestDetail;
        private readonly ValCategoRepository valCatego;
        private readonly GroupRepository group;
        private readonly ClassRepository classr;
        private readonly ClaMaterialRepository claMaterial;
        private readonly AttributeItemRepository attributeItem;
        private readonly AttributeRepository attribute;
        private readonly RolesAceptadosRepository rolesAceptados;
        private readonly SegmentOnuRepository segmentOnu;
        private readonly FamilyOnuRepository familyOnu;
        private readonly ClassOnuRepository classOnu;


        public RequestRepository Requerimiento => this.request ?? new  RequestRepository(_contexto); 
        public ValueParameterRepository ParametroValor => this.valueParameter ?? new ValueParameterRepository(_contexto);
        public MaterialTypeRepository TipoMaterial => this.materialType ?? new MaterialTypeRepository(_contexto);
        public SegmentRepository Segmento => this.segment ?? new SegmentRepository(_contexto);
        public SegmentOnuRepository SegmentoONU => this.segmentOnu ?? new SegmentOnuRepository(_contexto);
        public FamilyOnuRepository FamiliaONU => this.familyOnu ?? new FamilyOnuRepository(_contexto);
        public ClassOnuRepository ClaseONU => this.classOnu ?? new ClassOnuRepository(_contexto);
        public AttachmentRepository Adjunto => this.attachment ?? new AttachmentRepository(_contexto);
        public RequestDetailRepository DetalleRequerimiento => this.requestDetail ?? new RequestDetailRepository(_contexto);
        public ValCategoRepository CategoriaValorizacion => this.valCatego ?? new ValCategoRepository(_contexto);
        public GroupRepository Grupo => this.group ?? new GroupRepository(_contexto);
        public ClassRepository Clase => this.classr ?? new ClassRepository(_contexto);
        public ClaMaterialRepository ClaMaterial => this.claMaterial ?? new ClaMaterialRepository(_contexto);
        public AttributeItemRepository ItemAtributo => this.attributeItem ?? new AttributeItemRepository(_contexto);
        public AttributeRepository Atributo => this.attribute ?? new AttributeRepository(_contexto);
        public RolesAceptadosRepository RolesAceptados => this.rolesAceptados ?? new RolesAceptadosRepository(_contexto);

        protected virtual void Dispose(Boolean disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _contexto.Dispose();
                }
            }
            this.disposed = true;
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public int Grabar()
        {
            try
            {
                return _contexto.SaveChanges();
            }
            catch (DbEntityValidationException ex)
            {
                StringBuilder errores = new StringBuilder();
                foreach (DbEntityValidationResult item in ex.EntityValidationErrors)
                {
                    DbEntityEntry entry = item.Entry;
                    string entityTypeName = entry.Entity.GetType().Name;
                    foreach (DbValidationError subItem in item.ValidationErrors)
                    {
                        string msg = string.Format("Error ocurrido en {0} de {1} mensaje: '{2}'. ",
                            entityTypeName, subItem.PropertyName, subItem.ErrorMessage);
                        errores.AppendLine(msg);
                    }
                    switch (entry.State)
                    {
                        case EntityState.Added:
                            entry.State = EntityState.Detached;
                            break;
                        case EntityState.Modified:
                            entry.State = EntityState.Modified;
                            break;
                        case EntityState.Deleted:
                            entry.State = EntityState.Deleted;
                            break;
                    }
                }
                throw new Exception(errores.ToString());
            }
        }
    }
}

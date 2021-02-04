using DevExpress.Web;
using Pe.Stracon.DataAccess;
using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System;
using System.Collections.Generic;
using System.IO;

public partial class Default : System.Web.UI.Page
{
    string RequestNumber = "";
    List<ValueAttributeAux> atVal = new List<ValueAttributeAux>();
    string statusReq;

    protected void Page_Init(object sender, EventArgs e)
    {
        RequestNumber = Request.QueryString["Id"];
        hfRequestNumber["IdRequestNumber"] = RequestNumber;

        GetSegments.SelectCommand = "SELECT Id, Descripcion FROM Segmento";
        GetGroups.SelectCommand = "SELECT Id, Descripcion FROM Grupo";
        GetClasses.SelectCommand = "SELECT Id, Descripcion FROM Clase";

        if (RequestNumber == "Nuevo")
        {
            using (var db = new Politicas_UnitOfWork())
            {
                cbxSolic.DataSource = db.Trabajador.getEmployeesList();
                cbxSolic.DataBind();
            }
            using (var db = new SGCO_UnitOfWork())
            {
                cbxCentLog.DataSource = db.ParametroValor.GetParameterValueList();
                cbxCentLog.DataBind();
            }
            deFecha.Value = DateTime.Today;
            txtEstado.Value = "Aprobado";
            //txtEstado.Value = "Pendiente";
        }

        if (RequestNumber != null && RequestNumber != "Nuevo")
        {
            using (var db = new Politicas_UnitOfWork())
            {
                cbxSolic.DataSource = db.Trabajador.getEmployeesList();
                cbxSolic.DataBind();
            }
            using (var db = new SGCO_UnitOfWork())
            {
                cbxCentLog.DataSource = db.ParametroValor.GetParameterValueList();
                cbxCentLog.DataBind();

                dgFiles.DataSource = db.Adjunto.getAdjuntos_x_Request(int.Parse(RequestNumber), "");
                dgFiles.DataBind();

                dgRequestDetail.DataSource = db.DetalleRequerimiento.getDetailRequesList_x_Request(int.Parse(RequestNumber));
                dgRequestDetail.DataBind();
            }

            Requerimiento r;
            using (var db = new SGCO_UnitOfWork())
            {
                r = db.Requerimiento.GetById(int.Parse(RequestNumber));
            }
            txtIdReq.Value = r.Id;
            deFecha.Value = r.FechaCreacion;
            txtEstado.Text = r.Estado;
            cbxCentLog.Value = r.CentroLogistico;
            cbxSolic.Value = r.Solicitante;
            dgFiles.ClientVisible = true;
            addFiles.ClientVisible = true;
            lblDetalleReq.ClientVisible = true;
            lblFiles.ClientVisible = true;
            dgRequestDetail.ClientVisible = true;
            lblDetalleReq.ClientVisible = true;
            txtSearchPanel.ClientVisible = true;
            panelBtnAdd.ClientVisible = true;
            deFecha.ClientEnabled = false;

            //Session["statusReq"] = r.Estado;

            //if (r.Estado != "Pendiente")
           if (r.Estado != "Aprobado")
                {
                btnSaveItem.ClientEnabled = false;
                btnSaveRequest.ClientEnabled = false;
                addFiles.Enabled = false;
            }
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserRole"] == null) Response.Redirect("Login.aspx?link=" + System.Web.HttpContext.Current.Request.Url.PathAndQuery);
    }

    protected void dgFiles_CommandButtonInitialize(object sender, DevExpress.Web.Bootstrap.BootstrapGridViewCommandButtonEventArgs e)
    {
        if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.PreviewChanges || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
        {
            e.Visible = false;
        }
    }

    protected void btnSaveRequest_Click(object sender, EventArgs e)
    {
        if (RequestNumber == "Nuevo")
        {
            Requerimiento rn = new Requerimiento
            {
                FechaCreacion = DateTime.Parse(deFecha.Text),
                Solicitante = cbxSolic.Value.ToString(),
                CentroLogistico = cbxCentLog.Value.ToString(),
                Estado = "Aprobado",
                //Estado = "Pendiente",
                CreadoPor = Session["UserName"].ToString()
            };
            using (var db = new SGCO_UnitOfWork())
            {
                db.Requerimiento.Insert(rn);
                db.Grabar();

                //EmailMesageDTO em = new EmailMesageDTO
                //{
                //    Asunto = "Requerimiento de Código Creado",
                //    Texto_Notificar = "Se ha creado un el requerimiento de generación de código n°: " + rn.Id ,
                //    Cuenta_Notificar = db.ParametroValor.GetEmailEncargado(),
                //    Cuentas_Copias = "",
                //    Profile_Correo = "SISTEMA SGC"
                //};
                //db.ParametroValor.SendEmail(em);
            }

            ShowMessages("Requerimiento agregado correctamente");
            Response.Redirect("RequestAddEdit.aspx?Id=" + rn.Id);
        }
        else
        {
            Requerimiento r;
            using (var db = new SGCO_UnitOfWork())
            {
                r = db.Requerimiento.GetById(int.Parse(RequestNumber));
            }
            r.Solicitante = cbxSolic.Text;
            r.FechaCreacion = DateTime.Parse(deFecha.Text);
            r.CentroLogistico = cbxCentLog.Text;
            using (var db = new SGCO_UnitOfWork())
            {
                db.Requerimiento.Update(r);
                db.Grabar();
            }
            ShowMessages("Requerimiento actualizado correctamente");
            Response.Redirect("Request.aspx");
        }

    }

    protected void ShowMessages(string mensaje)
    {
        //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje(" + mensaje + ");</script>");
        lblAlert.Text = mensaje;
        pcAlert.ShowOnPageLoad = true;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("Request.aspx");
    }

    protected void cpDataItem_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        using (var db = new SGCO_UnitOfWork())
        {
            cbxMaterialType.DataSource = db.TipoMaterial.GetList();
            cbxMaterialType.DataBind();

            cbxSegment.DataSource = db.Segmento.GetList();
            cbxSegment.DataBind();

            cbxArticleGroups.DataSource = db.ParametroValor.GetDataParametros_x_CodParametro(55);
            cbxArticleGroups.ValueField = "Valor";
            cbxArticleGroups.TextField = "Descripcion";
            cbxArticleGroups.DataBind();

            cbxMeUnit.DataSource = db.ParametroValor.GetDataParametros_x_CodParametro(54);
            cbxMeUnit.ValueField = "Valor";
            cbxMeUnit.TextField = "Descripcion";
            cbxMeUnit.DataBind();

            cbxSegmentoOnu.DataSource = db.SegmentoONU.GetList();
            cbxSegmentoOnu.DataBind();
        }
        if (e.Parameter == "0")
        {
            dgAttributes.DataSource = null;
            dgAttributes.DataBind();
        }
        else
        {
            using (var db = new SGCO_UnitOfWork())
            {
                DetalleRequerimiento dr = db.DetalleRequerimiento.GetById(int.Parse(e.Parameter));
                cbxMaterialType.Value = dr.IdTipoMaterial;
                cbxSegment.Value = dr.IdSegmento;
                cbxArticleGroups.Value = dr.GrupoArticulo;
                cbxMeUnit.Value = dr.UnidadMedida;
                cbxSegmentoOnu.Value = dr.IdSegmentoOnu;

                cbxValCat.DataSource = db.CategoriaValorizacion.getCatVal_x_MaterialType(dr.IdTipoMaterial);
                cbxValCat.DataBind();

                cbxGroup.DataSource = db.Grupo.GetGroupList_x_IdSegment(dr.IdSegmento);
                cbxGroup.DataBind();

                cbxClass.DataSource = db.Clase.GetClassList_x_IdGroup(dr.IdGrupo);
                cbxClass.DataBind();

                dgAttributes.DataSource = db.ItemAtributo.GetAttributeItemList_x_ReqDet(int.Parse(e.Parameter));
                dgAttributes.DataBind();

                cbxGroupOnu.DataSource = db.FamiliaONU.GetFamilyList_x_IdSegmentOnu(dr.IdSegmentoOnu);
                cbxGroupOnu.DataBind();

                cbxClassOnu.DataSource = db.ClaseONU.GetClassList_x_IdFamily(dr.IdFamiliaOnu);
                cbxClassOnu.DataBind();

                cbxValCat.Value = dr.IdCategoriaValorizacion;
                cbxGroup.Value = dr.IdGrupo;
                cbxClass.Value = dr.IdClase;
                cbxGroupOnu.Value = dr.IdFamiliaOnu;
                cbxClassOnu.Value = dr.IdClaseOnu;
                txtDescripcion.Value = dr.Descripcion;
                txtCodOnu.Text = db.SegmentoONU.GetCode_x_Id(dr.IdSegmentoOnu) + db.FamiliaONU.GetCode_x_Id(dr.IdFamiliaOnu) + db.ClaseONU.GetCode_x_Id(dr.IdFamiliaOnu) + "00";
            }
        }
    }

    protected void cbxValCat_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            cbxValCat.DataSource = db.CategoriaValorizacion.getCatVal_x_MaterialType(int.Parse(e.Parameter));
            cbxValCat.DataBind();
        }

    }

    protected void cbxGroup_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            cbxGroup.DataSource = db.Grupo.GetGroupList_x_IdSegment(int.Parse(e.Parameter));
            cbxGroup.DataBind();
        }
    }

    protected void cbxClass_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            cbxClass.DataSource = db.Clase.GetClassList_x_IdGroup(int.Parse(e.Parameter));
            cbxClass.DataBind();
        }
    }

    protected void cpLoadAtributes_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            dgAttributes.DataSource = db.Atributo.GetAttributesList_x_Class(int.Parse(e.Parameter.ToString()));
            dgAttributes.DataBind();
        }
    }

    protected void cpSaveItems_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        if (string.IsNullOrEmpty(e.Parameter.Split('|')[8])) return;

        var matType = e.Parameter.Split('|')[0];
        var catValo = e.Parameter.Split('|')[1];
        var grpArti = e.Parameter.Split('|')[2];
        var measUni = e.Parameter.Split('|')[3];
        var segment = e.Parameter.Split('|')[4];
        var grouppp = e.Parameter.Split('|')[5];
        var classgr = e.Parameter.Split('|')[6];
        var descrip = e.Parameter.Split('|')[7];
        var idReqDe = e.Parameter.Split('|')[8];
        var segmOnu = e.Parameter.Split('|')[9];
        var famiOnu = e.Parameter.Split('|')[10];
        var clasOnu = e.Parameter.Split('|')[11];


        var em = Session["Attributes"];
        atVal = (List<ValueAttributeAux>)Session["Attributes"];
        ItemAtributo avn = new ItemAtributo();

        var ActualClass = 0;

        try
        {
            DetalleRequerimiento dr;
            if (idReqDe == "0") dr = new DetalleRequerimiento();
            else
            {
                using (var db = new SGCO_UnitOfWork())
                {
                    dr = db.DetalleRequerimiento.GetById(int.Parse(idReqDe));
                }
            }
            ActualClass = dr.IdClase;

            dr.IdRequerimiento = int.Parse(RequestNumber);
            dr.Descripcion = descrip;
            dr.GrupoArticulo = grpArti;
            dr.IdCategoriaValorizacion = int.Parse(catValo);
            dr.IdClase = int.Parse(classgr);
            dr.IdGrupo = int.Parse(grouppp);
            dr.IdSegmento = int.Parse(segment);
            dr.IdTipoMaterial = int.Parse(matType);
            dr.UnidadMedida = measUni;
            dr.IdClaseOnu = int.Parse(clasOnu);
            dr.IdFamiliaOnu = int.Parse(famiOnu);
            dr.IdSegmentoOnu = int.Parse(segmOnu);

            using (var db = new SGCO_UnitOfWork())
            {
                if (idReqDe == "0")
                {
                    db.DetalleRequerimiento.Insert(dr);
                    db.Grabar();

                    foreach (ValueAttributeAux item in atVal)
                    {
                        avn.IdAtributo = item.IdAtributo;
                        avn.Valor = item.Valor;
                        avn.IdDetalleRequerimiento = dr.Id;

                        db.ItemAtributo.Insert(avn);
                        db.Grabar();
                    }
                }
                else
                {
                    if (ActualClass != dr.IdClase)
                    {
                        db.ItemAtributo.DeleteAttributes_X_ReqDetail(int.Parse(idReqDe));
                        foreach (ValueAttributeAux item in atVal)
                        {
                            avn.IdAtributo = item.IdAtributo;
                            avn.Valor = item.Valor;
                            avn.IdDetalleRequerimiento = dr.Id;

                            db.ItemAtributo.Insert(avn);
                            db.Grabar();
                        }
                    }
                    else
                    {
                        foreach (ValueAttributeAux item in atVal)
                        {
                            avn = db.ItemAtributo.GetById(item.Id);
                            avn.Valor = item.Valor;

                            db.ItemAtributo.Update(avn);
                            db.Grabar();
                        }
                    }
                    db.DetalleRequerimiento.Update(dr);
                    db.Grabar();
                }
            }

            Response.RedirectLocation = ("RequestAddEdit.aspx?Id=" + int.Parse(RequestNumber));
        }
        catch (Exception ex)
        {
            cpSaveItems.JSProperties["cpError"] = ex.Message;
        }

    }

    protected void dgAttributes_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
    {
        ASPxGridView gv = (ASPxGridView)(sender);

        foreach (var item in e.UpdateValues)
        {
            ValueAttributeAux av = new ValueAttributeAux
            {
                Id = Convert.ToInt32(item.NewValues["Id"]),
                IdAtributo = Convert.ToInt32(item.NewValues["IdAtributo"]),
                Valor = item.NewValues["Valor"].ToString()
            };
            atVal.Add(av);
            //att = item.NewValues;
        }

        Session["Attributes"] = atVal;
        gv.EndUpdate();
        e.Handled = true;
    }

    protected void cpDeleteDetail_Callback(object sender, CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        Requerimiento r = new Requerimiento();
        using (var db = new SGCO_UnitOfWork())
        {
            r = db.Requerimiento.GetById(int.Parse(RequestNumber));
        }

        if (r.Estado != "Pendiente") cpDeleteDetail.JSProperties["cpMessage"] = "El ítem no puede ser eliminado";
        else
        {
            using (var db = new SGCO_UnitOfWork())
            {
                db.DetalleRequerimiento.Delete(db.DetalleRequerimiento.GetById(int.Parse(e.Parameter)));
                db.Grabar();

                dgRequestDetail.DataSource = db.DetalleRequerimiento.getDetailRequesList_x_Request(int.Parse(RequestNumber));
                dgRequestDetail.DataBind();
            }
            cpDeleteDetail.JSProperties["cpMessage"] = "El ítem ha sido eliminado";
        }

    }

    protected void UploadControl_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
    {
        UploadedFile uploadedFile = e.UploadedFile;
        string fileName = uploadedFile.FileName;
        string resultExtension = Path.GetExtension(fileName);
        string resultFileName = Path.ChangeExtension(Path.GetRandomFileName(), resultExtension);
        string resultFileUrl = "~/Content/Files/" + resultFileName;
        string resultFilePath = MapPath(resultFileUrl);
        uploadedFile.SaveAs(resultFilePath);
        //UploadingUtils.RemoveFileWithDelay(resultFileName, resultFilePath, 5);
        string url = ResolveClientUrl(resultFileUrl);
        var sizeInKilobytes = uploadedFile.ContentLength / 1024;
        string sizeText = sizeInKilobytes.ToString() + " KB";
        using (var db = new SGCO_UnitOfWork())
        {
            Adjunto ad = new Adjunto
            {
                Url = url,
                NombreArchivo = fileName,
                TamanioArchivo = sizeText,
                Seccion = "EDICION_R",
                IdRequerimiento = int.Parse(hfRequestNumber.Get("IdRequestNumber").ToString())
            };

            db.Adjunto.Insert(ad);
            db.Grabar();

            //Attach here SharePoint Methods
        }
        e.CallbackData = fileName + "|" + url + "|" + sizeText;
    }

    protected void cpFiles_Callback(object sender, CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        Requerimiento r = new Requerimiento();
        using (var db = new SGCO_UnitOfWork())
        {
            r = db.Requerimiento.GetById(int.Parse(RequestNumber));
        }

        if (r.Estado != "Pendiente") cpFiles.JSProperties["cpMessage"] = "El elemento no puede ser eliminado";
        else
        {
            using (var db = new SGCO_UnitOfWork())
            {
                db.Adjunto.Delete(db.Adjunto.GetById(int.Parse(e.Parameter)));
                db.Grabar();

                dgFiles.DataSource = db.Adjunto.getAdjuntos_x_Request(int.Parse(RequestNumber), "");
                dgFiles.DataBind();
            }
            cpFiles.JSProperties["cpMessage"] = "El elemento ha sido eliminado";
        }
    }

    protected void cbxGroupOnu_Callback(object sender, CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            cbxGroupOnu.DataSource = db.FamiliaONU.GetFamilyList_x_IdSegmentOnu(int.Parse(e.Parameter));
            cbxGroupOnu.DataBind();
        }
    }

    protected void cbxClassOnu_Callback(object sender, CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            cbxClassOnu.DataSource = db.ClaseONU.GetClassList_x_IdFamily(int.Parse(e.Parameter));
            cbxClassOnu.DataBind();
        }
    }

    protected void cpOnuCodes_Callback(object sender, CallbackEventArgsBase e)
    {
        using (var db = new SGCO_UnitOfWork())
        {
            int opcion = int.Parse(e.Parameter.Split('|')[0]);
            int IdSeg = int.Parse(e.Parameter.Split('|')[1]);
            int IdFam = int.Parse(e.Parameter.Split('|')[2]);
            int IdCla = int.Parse(e.Parameter.Split('|')[3]);
            switch (opcion)
            {
                case 1:
                    txtCodOnu.Text = db.SegmentoONU.GetCode_x_Id(IdSeg);
                    break;
                case 2:
                    txtCodOnu.Text = db.SegmentoONU.GetCode_x_Id(IdSeg) +  db.FamiliaONU.GetCode_x_Id(IdFam);
                    break;
                case 3:
                    txtCodOnu.Text = db.SegmentoONU.GetCode_x_Id(IdSeg) + db.FamiliaONU.GetCode_x_Id(IdFam) + db.ClaseONU.GetCode_x_Id(IdCla) + "00";
                    break;
            }
        }
    }
}
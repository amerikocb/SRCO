using DevExpress.Web;
using Pe.Stracon.DataAccess;
using Pe.Stracon.Models;
using Pe.Stracon.Models.DTO;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public partial class Default : System.Web.UI.Page
{
    //readonly List<PerfilesAceptados> perfiles = new List<string> { "SRCO Administrador", "SRCO Aprobador", "SRCO Aceptador", "SRCO Gestor", "SRCO Consulta" };

    List<string> roles;

    readonly List<string> stateRequest = new List<string> { "Pendiente", "Aprobado", "Rechazado", "Aceptado", "Terminado" };
    protected void Page_Init(object sender, EventArgs e)
    {
        using (var db = new SGCO_UnitOfWork())
        {
            roles = db.RolesAceptados.GetListAvailableProfiles();
        }
        if (Session["UserRole"] == null) Response.Redirect("Login.aspx?link=" + System.Web.HttpContext.Current.Request.Url.PathAndQuery);

        if (!roles.Contains(Session["UserRole"].ToString())) Response.Redirect("Home.aspx?code=401");

        GetLogCenter.SelectCommand = "SELECT VALOR FROM [GRL].[PARAMETRO_VALOR] WHERE CODIGO_PARAMETRO = 56 AND CODIGO_SECCION = 2";
        GetSolic.SelectCommand = "SELECT NOMBRE_COMPLETO FROM [GRL].[TRABAJADOR]";

        if (Session["UserRole"].ToString() == roles[0] || Session["UserRole"].ToString() == roles[3]) btnNewReq.ClientEnabled = true;
        else btnNewReq.ClientEnabled = false;
        //if (Session["UserRole"].ToString() != roles[3]) btnNewReq.ClientEnabled = false;

        loadRequests();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //dgRequest.DataColumns["FechaCreacion"].SettingsHeaderFilter.Mode = GridHeaderFilterMode.DateRangePicker;
        //dgRequest.SettingsPopup.HeaderFilter.Width = 360;
        //dgRequest.SettingsPopup.HeaderFilter.Height = 410;

        if (dgRequest.IsCallback) loadRequests();
        if (dgFiles.IsCallback)
        {
            using (var db = new SGCO_UnitOfWork())
            {
                dgFiles.DataSource = db.Adjunto.getAdjuntos_x_Request(int.Parse(hfRequestNumber.Get("IdRequestNumber").ToString()), "TERMINA_R");
                dgFiles.DataBind();
            }
        }

    }

    protected void loadRequests()
    {
        List<string> filtros = new List<string>();
        switch (Session["UserRole"].ToString())
        {
            case "SRCO Aprobador":
                filtros.Add("Pendiente");
                break;
            case "SRCO Aceptador":
                filtros.Add("Aprobado");
                filtros.Add("Terminado");
                break;
            case "SRCO Gestor":
                filtros.Add("Pendiente");
                filtros.Add("Rechazado");
                break;
            default:
                filtros.Add("Pendiente");
                filtros.Add("Aceptado");
                filtros.Add("Aprobado");
                filtros.Add("Rechazado");
                filtros.Add("Terminado");
                break;
        }
        using (var db = new SGCO_UnitOfWork())
        {
            dgRequest.DataSource = db.Requerimiento.GetRequestList(filtros);
            dgRequest.DataBind();
        }
    }

    protected void dgFiles_CommandButtonInitialize(object sender, DevExpress.Web.Bootstrap.BootstrapGridViewCommandButtonEventArgs e)
    {
        if (e.ButtonType == ColumnCommandButtonType.PreviewChanges || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
        {
            e.Visible = false;
        }
    }

    protected void cpRequestData_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        var opcion = e.Parameter.Split('|')[1];

        using (var db = new Politicas_UnitOfWork())
        {
            cbxSolic.DataSource = db.Trabajador.getEmployeesList();
            cbxSolic.DataBind();
        }
        using (var db = new SGCO_UnitOfWork())
        {
            cbxCentLog.DataSource = db.ParametroValor.GetParameterValueList();
            cbxCentLog.DataBind();

            Requerimiento r = db.Requerimiento.GetById(int.Parse(e.Parameter.Split('|')[0]));

            txtIdReq.Value = r.Id;
            cbxSolic.Value = r.Solicitante;
            cbxCentLog.Value = r.CentroLogistico;
            txtEstado.Value = r.Estado;
            deFecha.Value = r.FechaCreacion;
        }

        deFechaAction.Value = DateTime.Today;
        txtAppBy.Value = Session["UserName"].ToString();
        if (opcion == "ap1")
        {
            lblActionPerson.Value = "Aprobado Por:";
            lblActionDate.Value = "Fecha Aprobación:";

            lblMotiv.ClientVisible = false;
            txtMotivo.ClientVisible = false;

            dgFiles.ClientVisible = false;
            addFiles.ClientVisible = false;
        }
        else if (opcion == "ap2")
        {
            lblActionPerson.Value = "Aceptado Por:";
            lblActionDate.Value = "Fecha Aceptación:";

            lblMotiv.ClientVisible = false;
            txtMotivo.ClientVisible = false;

            dgFiles.ClientVisible = false;
            addFiles.ClientVisible = false;
        }
        else if (opcion == "re")
        {
            lblActionPerson.Value = "Rechazado Por:";
            lblActionDate.Value = "Fecha Rechazo:";

            lblMotiv.ClientVisible = true;
            txtMotivo.ClientVisible = true;

            dgFiles.ClientVisible = false;
            addFiles.ClientVisible = false;
        }
        else
        {
            lblActionPerson.Value = "Terminado Por:";
            lblActionDate.Value = "Fecha Terminac.:";

            lblMotiv.ClientVisible = false;
            txtMotivo.ClientVisible = false;

            lblFiles.ClientVisible = true;
            dgFiles.ClientVisible = true;
            addFiles.ClientVisible = true;
        }
    }


    protected void dgRequest_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
    {
        if (e.ButtonType == ColumnCommandButtonType.PreviewChanges || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
        {
            e.Visible = false;
        }
    }

    protected void btnSaveRequest_Click(object sender, EventArgs e)
    {
        string message = null;
        if (string.IsNullOrEmpty(hfActions.Get("parameterPopup").ToString())) return;
        var current = hfActions.Get("parameterPopup").ToString().Split('|')[0];
        var decide = hfActions.Get("parameterPopup").ToString().Split('|')[1];

        using (var db = new SGCO_UnitOfWork())
        {
            Requerimiento r = db.Requerimiento.GetById(int.Parse(current));
            switch (decide)
            {
                case "ap1":
                    if (r.Estado != "Pendiente") message = "Solamente se puede aprobar un requerimiento con estado Pendiente";
                    else
                    {
                        r.Estado = "Aprobado";
                        r.AprobadoPor = Session["UserName"].ToString();
                        r.FechaAprobacion = DateTime.Now;
                        message = "El Requerimiento ha sido aprobado";

                        EmailMesageDTO em = new EmailMesageDTO
                        {
                            Asunto = "Requerimiento de Código Creado",
                            Texto_Notificar = "El requerimiento de generación de código N°" + current + " ha sido aprobado",
                            Cuenta_Notificar = db.ParametroValor.GetEmailAceptador(),
                            Cuentas_Copias = "",
                            Profile_Correo = "SISTEMA SGC"
                        };
                        db.ParametroValor.SendEmail(em);
                    }
                    break;
                case "ap2":
                    if (r.Estado != "Aprobado") message = "Solamente se puede aceptar un requerimiento con estado Pendiente";
                    else
                    {
                        r.Estado = "Aceptado";
                        r.AceptadoPor = Session["UserName"].ToString();
                        r.FechaAceptacion = DateTime.Now;
                        message = "El Requerimiento ha sido aceptado";
                    }
                    break;
                case "re":
                    if (r.Estado == "Pendiente" || r.Estado == "Aprobado")
                    {
                        r.Estado = "Rechazado";
                        r.RechazadoPor = Session["UserName"].ToString();
                        r.FechaRechazo = DateTime.Today;
                        r.RazonRechazo = txtMotivo.Text;
                        message = "El Requerimiento ha sido rechazado";
                    }
                    else message = "'Solamente se puede rechazar un requerimiento con estado Pendiente o Aprobado'";
                    break;
                case "fi":
                    if (r.Estado != "Aceptado") message = "Solamente se puede finalizar un requerimiento con estado Aceptado";
                    else
                    {
                        r.Estado = "Terminado";
                        r.AprobadoPor = Session["UserName"].ToString();
                        r.FechaAprobacion = DateTime.Today;
                        message = "El Requerimiento ha sido Terminado";

                        STRACON_POLITICASEntities ctx = new STRACON_POLITICASEntities();

                        var emailCrea = ctx.TRABAJADOR.Where(tr => tr.CODIGO_IDENTIFICACION == r.CreadoPor).Select(t => t.CORREO_ELECTRONICO).FirstOrDefault();
                        
                        //ENVIAR MAIL AL USUARIO QUE CREO EL REQ, NOTIFICANDO QUE EL REQ HA SIDO TERMINADO
                        if (emailCrea != null) 
                        {
                            EmailMesageDTO em = new EmailMesageDTO
                            {
                                Asunto = "Requerimiento de Código Terminado",
                                Texto_Notificar = "El requerimiento de generación de código N°" + current + " ha sido terminado",
                                Cuenta_Notificar = emailCrea,
                                Cuentas_Copias = "",
                                Profile_Correo = "SISTEMA SGC"
                            };
                            db.ParametroValor.SendEmail(em);
                        }
                    }
                    break;
            }

            db.Requerimiento.Update(r);
            db.Grabar();

            //if(decide == "ap1")
            //{
               
            //}
        }

        pcAdminRequest.ShowOnPageLoad = false;
        loadRequests();
        ShowMessages(message);
    }

    protected void btnNewReq_Click(object sender, EventArgs e)
    {
        string url = "RequestAddEdit.aspx?Id=Nuevo";
        Response.Redirect(url);
    }

    protected void ShowMessages(string mensaje)
    {
        lblAlert.Text = mensaje;
        pcAlert.ShowOnPageLoad = true;
    }
    protected void dgRequest_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
    {
        dgRequest.JSProperties["cpOperacionesCot"] = null;
        switch (e.ButtonID)
        {
            case "cbEdit":
                Session["btnSaveActions"] = "NoEditing";
                string url = "RequestAddEdit.aspx?Id=" + int.Parse(dgRequest.GetRowValues(e.VisibleIndex, "Id").ToString());
                Response.RedirectLocation = (url);
                break;
            case "cbDelete":
                using (var db = new SGCO_UnitOfWork())
                {
                    Requerimiento r = db.Requerimiento.GetById(int.Parse(dgRequest.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (r.Estado != "Pendiente") ShowMessages("Solamente se puede eliminar un requerimiento con estado Pendiente");
                    else
                    {
                        db.Requerimiento.Delete(r);
                        db.Grabar();
                    }
                }
                loadRequests();
                break;
            case "cbPrint":
                Session["ItemClickeado"] = "Requests";
                string urlr = "Reporte.aspx?Requests=" + int.Parse(dgRequest.GetRowValues(e.VisibleIndex, "Id").ToString());
                Response.Write("<script>window.open('" + urlr + "','_blank');</script>");
                break;
        }
    }

    protected void cpActionsRequests_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        using (var db = new SGCO_UnitOfWork())
        {
            Requerimiento r = db.Requerimiento.GetById(int.Parse(e.Parameter.ToString()));
            if (r.Estado != "Pendiente") cpActionsRequests.JSProperties["cpMessage"] = "Solamente se puede eliminar un requerimiento con estado Pendiente";
            else
            {
                db.Requerimiento.Delete(r);
                db.Grabar();
                cpActionsRequests.JSProperties["cpMessage"] = "El requerimiento ha sido eliminado";
            }
        }
        loadRequests();
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
                Seccion = "TERMINAR_R",
                IdRequerimiento = int.Parse(hfRequestNumber.Get("IdRequestNumber").ToString())
            };

            db.Adjunto.Insert(ad);
            db.Grabar();

            //Insert here SharePoint Methods
        }
        e.CallbackData = fileName + "|" + url + "|" + sizeText;
    }

    protected void dgRequest_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
    {
        //{ "SRCO Administrador", "SRCO Aprobador", "SRCO Aceptador", "SRCO Gestor", "SRCO Consulta" };
        if ((e.ButtonID == "cbEdit" || e.ButtonID == "cbDelete" || e.ButtonID == "cbApprove2" || e.ButtonID == "cbFinish") && Session["UserRole"].ToString() == roles[1]) //Aprobador
        {
            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        }
        else if ((e.ButtonID == "cbEdit" || e.ButtonID == "cbDelete" || e.ButtonID == "cbApprove") && Session["UserRole"].ToString() == roles[2]) //Aceptador
        {
            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        }
        else if ((e.ButtonID == "cbApprove" || e.ButtonID == "cbApprove2" || e.ButtonID == "cbReject" || e.ButtonID == "cbFinish") && Session["UserRole"].ToString() == roles[3]) //Gestor
        {
            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        }
        else if ((e.ButtonID == "cbApprove" || e.ButtonID == "cbApprove2" || e.ButtonID == "cbReject" || e.ButtonID == "cbFinish" || e.ButtonID == "cbEdit" || e.ButtonID == "cbDelete") && Session["UserRole"].ToString() == roles[4]) //Consulta
        {
            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        }
    }

    protected void cpFiles_Callback(object sender, CallbackEventArgsBase e)
    {
        if (string.IsNullOrEmpty(e.Parameter)) return;
        Adjunto ad = new Adjunto();
        using (var db = new SGCO_UnitOfWork())
        {
            ad = db.Adjunto.GetById(int.Parse(e.Parameter));
            db.Adjunto.Delete(ad);
            db.Grabar();

            dgFiles.DataSource = db.Adjunto.getAdjuntos_x_Request(ad.IdRequerimiento, "TERMINAR_R");
            dgFiles.DataBind();
        }
    }


    protected void dgRequest_DataBound(object sender, EventArgs e)
    {
        var column = dgRequest.Columns["Estado"] as GridViewDataComboBoxColumn;
        column.PropertiesComboBox.Items.Clear();
        foreach (var it in stateRequest)
        {
            ListEditItem item = new ListEditItem(it, it);
            column.PropertiesComboBox.Items.Add(item);
        }
    }

    protected void cpOpenReport_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        Session["ItemClickeado"] = "Requerimiento";
        cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?Requests=" + int.Parse(e.Parameter.ToString());
    }
}
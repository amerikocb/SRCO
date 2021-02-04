using Microsoft.Reporting.WebForms;
using System;
using System.Net;
using System.Security.Principal;

public partial class Default : System.Web.UI.Page
{

    protected void Page_Init(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Set the processing mode for the ReportViewer to Remote
            MasterReportStracon.ProcessingMode = ProcessingMode.Remote;


            ServerReport serverReport = MasterReportStracon.ServerReport;
            //string filename = "Reporte";

            // Set the report server URL and report path

            //serverReport.ReportServerUrl = new Uri("http://192.168.0.57:80/ReportServer");
            serverReport.ReportServerUrl = new Uri("http://mordor/ReportServer");
            serverReport.ReportServerCredentials = new MyReportServerCredentials();
            if (Session["ItemClickeado"] != null)
            {
                serverReport.ReportPath = "/SGCO/" + Session["ItemClickeado"].ToString();
                switch (Session["ItemClickeado"].ToString())
                {
                    case "Requerimiento":
                        MasterReportStracon.ShowParameterPrompts = false;
                        MasterReportStracon.AsyncRendering = false;
                        ReportParameter IdRequest = new ReportParameter("Id", int.Parse(Request.QueryString["Requests"].ToString()).ToString());
                        serverReport.SetParameters(IdRequest);
                        RenderizarPDF();
                        break;
                }
            }
        }

    }

    public void RenderizarPDF()
    {
        Warning[] warnings;
        string[] streamIds;
        string mimeType = string.Empty;
        string encoding = string.Empty;
        string extension = string.Empty;

        byte[] bytes = MasterReportStracon.ServerReport.Render(
            "PDF",
            null,
            out mimeType,
            out encoding,
            out extension,
            out streamIds,
            out warnings);


        var ms = new System.IO.MemoryStream(bytes);
        Response.Buffer = true;
        Response.Clear();
        Response.ContentType = mimeType;
        Response.BinaryWrite(ms.ToArray()); // create the file  
        Response.Flush(); // send it to the client to download  
        Response.End();
    }

    [Serializable]
    public sealed class MyReportServerCredentials :
IReportServerCredentials
    {
        public WindowsIdentity ImpersonationUser
        {
            get
            {
                // Use the default Windows user.  Credentials will be
                // provided by the NetworkCredentials property.
                return null;
            }
        }

        public ICredentials NetworkCredentials
        {
            get
            {
                string userName = "jeiner.lopez";
                string password = "M1jH@n1307";
                string domain = "stracon";

                return new NetworkCredential(userName, password, domain);
            }
        }

        public bool GetFormsCredentials(out Cookie authCookie,
                    out string userName, out string password,
                    out string authority)
        {
            authCookie = null;
            userName = null;
            password = null;
            authority = null;

            // Not using form credentials
            return false;
        }
    }
}
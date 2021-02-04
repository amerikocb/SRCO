using DevExpress.Web.Bootstrap;
using System;
using Pe.Stracon.SGCO;

public partial class Default : System.Web.UI.Page
{
    public string un = "";
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Session["UserName"] == null) Response.Redirect("Login.aspx");
        if (!string.IsNullOrEmpty(Request.QueryString["code"])) {
            un = "El rol de usuario (" + Session["UserRole"] + ") no está autorizado para ver el recurso solicitado";
        }
    }
}
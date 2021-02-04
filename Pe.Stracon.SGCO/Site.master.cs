using System;
using System.Linq;

public partial class Site : System.Web.UI.MasterPage
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Session["UserName"] == null || Session["UserRole"] == null)
        {
            Response.RedirectLocation = ("~/Login.aspx?link=" + System.Web.HttpContext.Current.Request.Url.PathAndQuery);
        } else
        {
            //Header.
            //TestControl objTestControl = (TestControl)Page.FindControl("TestControl");
        }
    }
}
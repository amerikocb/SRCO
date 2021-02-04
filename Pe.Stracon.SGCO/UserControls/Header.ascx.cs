using DevExpress.Web;
using System;
using System.Linq;

    public partial class Header : System.Web.UI.UserControl {
    ASPxLabel username;

    protected void lblUserName_Init(object sender, EventArgs e)
    {
        try
        {
            username = (ASPxLabel)sender;
            username.Text = Session["UserName"].ToString();
        }
        catch (Exception)
        {
            Response.RedirectLocation = ("~/Login.aspx?link=" + System.Web.HttpContext.Current.Request.Url.PathAndQuery);
        }
    }
}
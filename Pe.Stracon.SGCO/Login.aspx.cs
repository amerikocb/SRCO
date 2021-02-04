using Pe.Stracon.Models.DTO;
using Pe.Stracon.Models;
using System;
using System.DirectoryServices.AccountManagement;
using System.Web.Configuration;
using System.Linq;
using System.Collections.Generic;

public partial class Login : System.Web.UI.Page
{
    DomUsuarioLogin du = new DomUsuarioLogin();
    dbSRAGyMEntities cntx = new dbSRAGyMEntities();
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    protected void cpValidateUser_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
    {
        //try
        //{
        //    du.Usuario = e.Parameter.Split('|')[0];
        //    du.Password = e.Parameter.Split('|')[1];
        //    string dominio = WebConfigurationManager.AppSettings["dominio"];

        //    PrincipalContext ctx = new PrincipalContext(ContextType.Domain, dominio, du.Usuario, du.Password);

        //    UserPrincipal user = UserPrincipal.FindByIdentity(ctx, du.Usuario);

        //    Session["UserName"] = user.DisplayName;
        //    Session["UserRole"] = getRoleByUserName(du.Usuario);
        //    Response.RedirectLocation = ("Home.aspx");
        //}
        //catch (Exception)
        //{
        //    cpValidateUser.JSProperties["cpError"] = "Usuario o Password Incorrectos";
        //}
        Session["UserRole"] = e.Parameter.Split('|')[0];
        Session["UserName"] = e.Parameter.Split('|')[0];

        Response.RedirectLocation = ("Home.aspx");
    }

    public string getRoleByUserName(string username)
    {
        return (from a in cntx.UserSRA
               join b in cntx.User_Profile on a.ID_USER equals b.N_ID_USER
               join c in cntx.Profile_Role on b.N_ID_PROFILE equals c.N_ID_PROFILE
               join d in cntx.Profile on c.N_ID_PROFILE equals d.N_ID_PROFILE
               join e in cntx.Role on c.N_ID_ROLE equals e.N_ID_ROLE
               join f in cntx.Role_System on e.N_ID_ROLE equals f.N_ID_ROLE
               join g in cntx.SystemSRA on f.N_ID_SYSTEM equals g.N_ID_SYSTEM
               where a.S_LOGIN == username && g.S_NAME == "SRC"
               select e.S_NAME ).First();
    }
}
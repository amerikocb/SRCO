<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
    <title>Login</title>
    <link id="themeLink" runat="server" rel="stylesheet"
        href="Content/light/bootstrap.min.css" />
    <link href="Content/Login.css" rel="stylesheet" type="text/css" />
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
</head>
<body>

    <div class="contenedor-principal-login container-fluid">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="card col-9 col-md-8 col-lg-5 col-xl-4">
                <div class="card-body my-3 my-md-5">
                    <div class="mb-4 d-flex justify-content-center row">
                        <div class="col-10 col-md-12 text-center">
                            <img src="Content/Img/stracon-logo.png" class="img-fluid" />
                        </div>
                    </div>
                    <form id="form1" runat="server">
                        <div class="row d-flex justify-content-center">
                            <div class="input-group m-0 mb-2 col-12 col-md-9">
                                <dx:BootstrapButtonEdit ID="txtUserName" ClientInstanceName="txtUserName" runat="server">
                                    <Buttons>
                                        <dx:BootstrapEditButton IconCssClass="fa fa-user" Position="Left" Enabled="false"/>
                                    </Buttons>
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="loging">
                                        <RequiredField ErrorText="Este campo es requerido" IsRequired="true" />
                                    </ValidationSettings>
                                </dx:BootstrapButtonEdit>
                            </div>
                        </div>
                        <div class="row d-flex justify-content-center">
                            <div class="input-group m-0 col-12 col-md-9">
                                <dx:BootstrapButtonEdit ID="txtPassword" ClientInstanceName="txtPassword" runat="server" Password="true">
                                    <Buttons>
                                        <dx:BootstrapEditButton IconCssClass="fa fa-unlock-alt" Position="Left" Enabled="false" />
                                    </Buttons>
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="loging">
                                        <RequiredField ErrorText="Este campo es requerido" IsRequired="true" />
                                    </ValidationSettings>
                                </dx:BootstrapButtonEdit>
                            </div>
                        </div>
                        <br />
                        <div class="row d-flex justify-content-center">
                            <div class="col-12 col-md-9">
                                <dx:BootstrapButton ID="btnIngresar" runat="server" AutoPostBack="false" Text="Ingresar" ValidationGroup="loging">
                                    <SettingsBootstrap RenderOption="Success" />
                                    <CssClasses Control="btnLogin" />
                                    <ClientSideEvents Click="function(s, e){
                                        if(ASPxClientEdit.ValidateGroup('loging'))
                                         cpValidateUser.PerformCallback(txtUserName.GetValue()+ '|' + txtPassword.GetValue());
                                        }" />
                                </dx:BootstrapButton>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end mt-5">
                            <span class="badge badge-dark p-2">Powered By Qualis</span>
                        </div>

                        <dx:ASPxCallbackPanel ID="cpValidateUser" ClientInstanceName="cpValidateUser" runat="server" Width="200px" OnCallback="cpValidateUser_Callback">
                            <SettingsLoadingPanel Enabled="false" />
                            <ClientSideEvents EndCallback="function(s, e){
                                if(s.cpError != null){
                                    lblAlert.SetText(s.cpError);
                                    pcAlert.Show();
                                    txtUserName.SetText(null);
                                    txtPassword.SetText(null);
                                    delete(s.cpError);
                                    lpProcess.Hide();
                                }
                            }"
                                BeginCallback="function(s, e){lpProcess.Show();}" />
                        </dx:ASPxCallbackPanel>
                        <dx:ASPxLoadingPanel ID="lpProcess" ClientInstanceName="lpProcess" Modal="true" Text="Validando Datos.." Theme="MaterialCompact" runat="server"></dx:ASPxLoadingPanel>

                        <dx:ASPxPopupControl runat="server" ID="pcAlert" ClientInstanceName="pcAlert" HeaderText="STRACON - SRCO" Theme="MaterialCompact">
                            <SettingsAdaptivity Mode="Always" MaxWidth="500px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
                            <ContentCollection>
                                <dx:PopupControlContentControl>
                                    <div class="row">
                                        <div class="col-12">
                                            <i class="fa fa-exclamation-circle mr-2 text-danger" aria-hidden="true"></i><dx:ASPxLabel ID="lblAlert" ClientInstanceName="lblAlert" runat="server" Text="" ForeColor="Red"></dx:ASPxLabel>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 text-right mt-2">
                                            <dx:BootstrapButton ID="btnAceptAlert" runat="server" AutoPostBack="false" Text="Aceptar" ClientInstanceName="btnAceptAlert">
                                                <SettingsBootstrap RenderOption="Info" />
                                                <ClientSideEvents Click="function(s, e){pcAlert.Hide(); txtUserName.SetFocus();}" />
                                            </dx:BootstrapButton>
                                        </div>
                                    </div>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </form>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

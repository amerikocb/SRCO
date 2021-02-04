<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="Home.aspx.cs" Inherits="Default" %>


<%@ Register Src="~/UserControls/Widget.ascx" TagPrefix="demo" TagName="Widget" %>
<%@ Register Src="~/UserControls/WidgetsContainer.ascx" TagPrefix="demo" TagName="WidgetsContainer" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
    <%--<script type="text/javascript" src="Content/dashboard.js" defer></script>--%>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="mainContent">
    <div class="container-fluid">
        <div class="row">
            <p class="col-12 demo-content-title">Bienvenido</p>
        </div>
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="col-12">Bienvenido Señor(a) <strong><%:Session["UserName"]%></strong> al Sistema de Requerimiento de Códigos</div>
                        <div class="col-12 text-danger mt-3"><strong><%:un%></strong></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

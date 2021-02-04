<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="Reporte.aspx.cs" Inherits="Default" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ Register Src="~/UserControls/Widget.ascx" TagPrefix="demo" TagName="Widget" %>
<%@ Register Src="~/UserControls/WidgetsContainer.ascx" TagPrefix="demo" TagName="WidgetsContainer" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="Content/dashboard.js" defer></script>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="mainContent">
    <div class="container">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <rsweb:ReportViewer ID="MasterReportStracon" runat="server" Width="100%" DocumentMapWidth="100%" SizeToReportContent="true"></rsweb:ReportViewer>
    </div>

</asp:Content>

<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Widget.ascx.cs" Inherits="Widget" %>

<div class="col <%=CssClass%> demo-tab-<%=(Index+1) %>">
    <div class="demo-widget-area demo-tab-card card <%=ContentCssClass %>">
        <asp:PlaceHolder ID="WidgetContentControl" runat="server"></asp:PlaceHolder>
    </div>
</div>
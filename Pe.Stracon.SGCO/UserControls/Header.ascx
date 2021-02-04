<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Header" %>

<div class="demo-header-part demo-area-highlight">
    <dx:BootstrapToolbar runat="server" ID="HeaderToolbar" ClientInstanceName="HeaderToolbar">
        <CssClasses Control="demo-header-toolbar p-2 justify-content-end" 
            Item="demo-btn-custom-state active-highlight idle-highlight" />
        <SettingsAdaptivity MinRootItemsCount="4" EnableAutoHideRootItems="true" Enabled="true" />
        <SettingsBootstrap RemoveItemBackgrounds="true" />
        <Items>
            <dx:BootstrapToolbarItem IconCssClass="demo-icon demo-icon-menu" CssClass="rounded-circle shadow show-navigation itemMenuNav" Name="SideNavToggleBtn" GroupName="SideNavToggleBtn"></dx:BootstrapToolbarItem>
            <dx:BootstrapCustomToolbarItem CssClass="itemMenu" AdaptivePriority="1">
                    <Template>
                    <div class="d-flex align-items-center">
                        <img runat="server" src="~/Content/Img/stracon-logo.png" class="imgLogo"/>
                        <span style="font-weight:bold" class="ml-2 d-none d-sm-block">|  SISTEMA DE REQUERIMIENTO DE CÓDIGOS</span>
                    </div>
                </Template>
            </dx:BootstrapCustomToolbarItem>
            <%--<dx:BootstrapCustomToolbarItem AdaptivePriority="1">
                <Template>
                    <div class="d-flex align-items-center">
                        <span class="demo-icon demo-icon-search-toolbar"></span>
                        <dx:BootstrapTextBox runat="server" NullText="Type search text">
                            <CssClasses Control="demo-header-search ml-1" />
                        </dx:BootstrapTextBox>
                    </div>
                </Template>
            </dx:BootstrapCustomToolbarItem>--%>
            <dx:BootstrapToolbarItem  Text="User Settings"
                CssClass="no-icon demo-header-user-info align-items-center border-0 bg-light text-dark itemMenu">
                <TextTemplate>
                    <dx:BootstrapImage runat="server" ImageUrl="~/Content/Icons/demo-user.svg"></dx:BootstrapImage>
                    <dx:ASPxLabel ID="lblUserName" ClientInstanceName="lblUserName" runat="server" CssClass="lblUser" Text="" OnInit="lblUserName_Init"></dx:ASPxLabel>
                </TextTemplate>
                <Items>
                    <%--<dx:BootstrapToolbarMenuItem Name="navigate_profile" Text="Profile" IconCssClass="demo-icon demo-icon-user" />--%>
                    <dx:BootstrapToolbarMenuItem Name="logout" Text="Logout" IconCssClass="demo-icon demo-icon-logout" NavigateUrl="../Login.aspx" />
                </Items>
            </dx:BootstrapToolbarItem>
            <%--<dx:BootstrapToolbarItem Name="show_messages" IconCssClass="demo-icon demo-icon-mail" CssClass="rounded-circle shadow ml-2 demo-item-wb">
                <Badge Text="8" CssClass="demo-badge-floating bg-success text-white" />
            </dx:BootstrapToolbarItem>
            <dx:BootstrapToolbarItem Name="show_notifications" IconCssClass="demo-icon demo-icon-alert" CssClass="rounded-circle shadow ml-2 demo-item-wb">
                <Badge Text="12" CssClass="demo-badge-floating bg-danger text-white" />
            </dx:BootstrapToolbarItem>--%>
            <dx:BootstrapToolbarItem AdaptiveText="Color scheme" IconCssClass="demo-icon demo-icon-settings m-0" CssClass="demo-header-toolbar-settings rounded-circle shadow ml-2">
                <Items>
                    <dx:BootstrapToolbarMenuItem GroupName="theme" Name="theme-light" Text="Light Theme" IconCssClass="demo-icon-light-theme" Checked="true"></dx:BootstrapToolbarMenuItem>
                    <dx:BootstrapToolbarMenuItem GroupName="theme" Name="theme-dark" Text="Dark Theme" IconCssClass="demo-icon-dark-theme"></dx:BootstrapToolbarMenuItem>
                </Items>
            </dx:BootstrapToolbarItem>
        </Items>
    </dx:BootstrapToolbar>
</div>
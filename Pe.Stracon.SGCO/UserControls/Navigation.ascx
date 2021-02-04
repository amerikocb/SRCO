<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Navigation.ascx.cs" Inherits="Navigation" %>

<%--<a href="https://www.devexpress.com/products/try/" target="_blank" class="demo-try-now-link bg-primary text-white">Try it now</a>--%>
<script type="text/javascript">
    function NodeClick(s, e) {
        //alert(e.node.GetParent());
        e.node.SetExpanded(!e.node.GetExpanded());
    }
</script>
<link runat="server" rel="stylesheet" href="Content/SideMenu.css" type="text/css" />


<div id="layoutSidenav">
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <%--<a class="nav-link" href="../AppSRC/Home.aspx">--%>
                    <a class="nav-link" href="../Home.aspx">
                        <div class="sb-nav-link-icon"><i class="material-icons">home</i></div>
                        Inicio
                    </a>
                    <%--<a class="nav-link" href="../AppSRC/Request.aspx">--%>
                    <a class="nav-link" href="../Request.aspx">
                        <div class="sb-nav-link-icon"><i class="material-icons">receipt</i></div>
                        Requerimientos
                    </a>
                    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="material-icons">settings</i></div>
                        Configuración
                               
                        <div class="sb-sidenav-collapse-arrow"><i class="material-icons">arrow_drop_down</i></div>
                    </a>
                    <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="#"><i class="material-icons"></i>Tipo Material</a>
                            <a class="nav-link" href="#"><i class="material-icons"></i>Categorías Val.</a>
                            <a class="nav-link" href="#"><i class="material-icons"></i>Segemento</a>
                            <a class="nav-link" href="#"><i class="material-icons"></i>Grupo</a>
                            <a class="nav-link" href="#"><i class="material-icons"></i>Clase</a>
                            <a class="nav-link" href="#"><i class="material-icons"></i>Atributos Clase</a>
                        </nav>
                    </div>
                  
                </div>
            </div>
        </nav>
    </div>
</div>

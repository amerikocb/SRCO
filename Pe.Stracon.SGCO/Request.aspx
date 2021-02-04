<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="Request.aspx.cs" Inherits="Default" %>


<%@ Register Src="~/UserControls/Widget.ascx" TagPrefix="demo" TagName="Widget" %>
<%@ Register Src="~/UserControls/WidgetsContainer.ascx" TagPrefix="demo" TagName="WidgetsContainer" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
    <script>
        var actionPopupReq;

        function fireClickMainGrid(s, e) {
            switch (e.buttonID) {
                case 'cbEdit':
                    e.processOnServer = true;
                    break;
                case 'cbDelete':
                    //if (dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') === 'Pendiente') {
                    if (dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') === 'Aprobado') {
                        //e.processOnServer = confirm('Está seguro que desea eliminar este elemento?');
                        hfReqId.Set('IdToDelete', dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                        lblConfirm.SetText('¿Está seguro que desea eliminar este elemento?');
                        hfAction.Set('ActionConfirm', 'request');
                        pcShowConfirm.Show();
                    } else {
                        //lblAlert.SetText('Solamente se puede eliminar un requerimiento con estado Pendiente');
                        lblAlert.SetText('Solamente se puede eliminar un requerimiento con estado Aprobado');
                        pcAlert.Show();
                    }
                    break;
                //case 'cbApprove':
                //    if (dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') !== 'Pendiente') {
                //        lblAlert.SetText('Solamente se puede aprobar un requerimiento con estado Pendiente');
                //        pcAlert.Show();
                //    }
                //    else {
                //        hfActions.Set("parameterPopup", dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id') + '|' + 'ap1');
                //        pcAdminRequest.SetHeaderText('Aprobar Requerimiento');
                //        pcAdminRequest.Show();
                //    }
                //    break;
                case 'cbReject':
                    if (dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') == 'Pendiente' || dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') == 'Aprobado') {
                        hfActions.Set("parameterPopup", dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id') + '|' + 're');
                        pcAdminRequest.SetHeaderText('Rechazar Requerimiento');
                        pcAdminRequest.Show();
                    }
                    else {
                        //lblAlert.SetText('Solamente se puede rechazar un requerimiento con estado Pendiente o Aprobado');
                        lblAlert.SetText('Solamente se puede rechazar un requerimiento con estado Aprobado');
                        pcAlert.Show();
                    }
                    break;
                case 'cbApprove2':
                    if (dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') !== 'Aprobado') {
                        lblAlert.SetText('Solamente se puede aceptar un requerimiento con estado Aprobado');
                        pcAlert.Show();
                    }
                    else {
                        hfActions.Set("parameterPopup", dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id') + '|' + 'ap2');
                        pcAdminRequest.SetHeaderText('Aceptar Requerimiento');
                        pcAdminRequest.Show();
                    }
                    break;
                case 'cbFinish':
                    if (dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Estado') !== 'Aceptado') {
                        lblAlert.SetText('Solamente se puede terminar un requerimiento con estado Aceptado');
                        pcAlert.Show();
                    }
                    else {
                        hfRequestNumber.Set("IdRequestNumber", dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                        hfActions.Set("parameterPopup", dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id') + '|' + 'fi');
                        pcAdminRequest.SetHeaderText('Terminar Requerimiento');
                        pcAdminRequest.Show();
                    }
                    break;
                case 'cbPrint':
                    cpOpenReport.PerformCallback(dgRequest.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                    e.processOnServer = false;
                    break;
            }
        }

        function FilesButtonsClick(s, e) {
            if (e.buttonID === 'cbDeleteFile') {
                hfReqId.Set('IdToDelete', dgFiles.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                hfAction.Set('ActionConfirm', 'file');
                lblConfirm.SetText('¿Está seguro que desea eliminar este elemento?');
                pcShowConfirm.Show();
            }
        }

        function addNewReq() {
            btnNewReq.DoClick();
        }

        function onFilesUploadStart(s, e) {
        }
        function onFileUploadComplete(s, e) {
            if (e.callbackData) {
                var fileData = e.callbackData.split('|');
                var fileName = fileData[0],
                    fileUrl = fileData[1],
                    fileSize = fileData[2];
                //dxbsDemo.uploadedFilesContainer.addFile(s, fileName, fileUrl, fileSize);
            }
            dgFiles.Refresh();
        }
    </script>
    <style type="text/css">
        .lab {
            text-align: right;
        }

        @media (max-width: 767px) {
            .lab {
                text-align: left;
            }
        }

        .estateControl {
            background: grey !important;
            font-weight: bold;
            color: white;
        }
    </style>
    <%--<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />--%>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="mainContent">
    <div class="container-fluid">
        <div class="row">
            <p class="col-12 demo-content-title">Bandeja de Requerimientos</p>
        </div>
        <%--<div class="row">
            <div class="col-12 col-md-12">
                <div class="accordion" id="accordionExample" style="width: 100%;">
                    <div class="card" style="width: 100%;">
                        <div class="card-header p-0" id="headingOne">
                            <h2 class="mb-0">
                                <button class="btn d-flex justify-content-left align-content-between btn-block shadow-none" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                    <i class="material-icons mr-2">filter_list</i>Filtros
                                </button>
                            </h2>
                        </div>
                        <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-2 text-right">Centro logistico:</div>
                                    <div class="col-4">
                                        <dx:BootstrapComboBox ID="cbxCentLogMain" runat="server" Width="100%" ClientInstanceName="cbxCentLogMain"></dx:BootstrapComboBox>
                                    </div>
                                    <div class="col-2 text-right">Solicitante:</div>
                                    <div class="col-4">
                                        <dx:BootstrapComboBox ID="cbxSolicMain" runat="server" Width="100%" ClientInstanceName="cbxSolicMain"></dx:BootstrapComboBox>
                                    </div>
                                </div>
                                <div class="row d-flex justify-content-end mt-2">
                                    <div class="col-12 col-md-3">
                                        <dx:BootstrapButton ID="btnClear" runat="server" AutoPostBack="false" Text="Limpiar" Width="100%" ClientInstanceName="btnClear">
                                            <SettingsBootstrap RenderOption="Secondary" />
                                            <ClientSideEvents Click="function(s, e){
                                                e.processOnServer = false;
                                                cbxCentLogMain.SetValue(null);
                                                cbxSolicMain.SetValue(null);
                                                dgRequest.Refresh();
                                              }" />
                                        </dx:BootstrapButton>
                                    </div>
                                    <div class="col-12 col-md-3">
                                        <dx:BootstrapButton ID="btnFilter" runat="server" AutoPostBack="false" Text="Filtrar" Width="100%">
                                            <SettingsBootstrap RenderOption="Success" />
                                            <ClientSideEvents Click="function(s, e){
                                                e.processOnServer = false;
                                                cpLoadRequests.PerformCallback(cbxCentLogMain.GetText() + '|' + cbxSolicMain.GetText());
                                              }" />
                                        </dx:BootstrapButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>--%>
        <div class="row mb-2">
            <div class="col-7 col-md-10">
                <dx:BootstrapTextBox ID="txtSearchPanel" runat="server" Width="100%" NullText="Introduza el texto a buscar..."></dx:BootstrapTextBox>
            </div>
            <div class="col-5 col-md-2">
                <button type="button" id="btnAddRequest" class="btn btn-info d-flex justify-content-center align-content-between btn-block" onclick="addNewReq();"><i class="material-icons mr-1">add</i> Requerimiento</button>
                <dx:ASPxButton runat="server" ID="btnNewReq" ClientInstanceName="btnNewReq" OnClick="btnNewReq_Click" ClientVisible="false"></dx:ASPxButton>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <dx:BootstrapCallbackPanel runat="server" ID="cpActionsRequests" ClientInstanceName="cpActionsRequests" OnCallback="cpActionsRequests_Callback">
                    <ContentCollection>
                        <dx:ContentControl>
                            <dx:ASPxGridView ID="dgRequest" ClientInstanceName="dgRequest" Theme="MaterialCompact" AutoGenerateColumns="false"
                                runat="server" Width="100%" EnableCallBacks="true" KeyFieldName="Id" OnCommandButtonInitialize="dgRequest_CommandButtonInitialize"
                                OnCustomButtonCallback="dgRequest_CustomButtonCallback" OnCustomButtonInitialize="dgRequest_CustomButtonInitialize"
                                OnDataBound="dgRequest_DataBound">
                                <Toolbars>
                                    <dx:GridViewToolbar>
                                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                        <Items>
                                            <dx:GridViewToolbarItem Command="ExportToXlsx" />
                                            <dx:GridViewToolbarItem Command="ExportToCsv" />
                                        </Items>
                                    </dx:GridViewToolbar>
                                </Toolbars>
                                <SettingsSearchPanel CustomEditorID="txtSearchPanel" />
                                <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                                <SettingsBehavior AllowSort="false" />
                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"
                                    AllowHideDataCellsByColumnMinWidth="true">
                                </SettingsAdaptivity>
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image" Caption="Acciones" Width="100">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="cbEdit">
                                                <Image ToolTip="Editar" Url="Content/Img/icons/Editar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                            <dx:GridViewCommandColumnCustomButton ID="cbDelete">
                                                <Image ToolTip="Eliminar" Url="Content/Img/icons/Borrar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                            <dx:GridViewCommandColumnCustomButton ID="cbPrint">
                                                <Image ToolTip="Presentar" Url="Content/Img/icons/Presentar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                            <%--                                        <dx:GridViewCommandColumnCustomButton ID="cbApprove">
                                                <Image ToolTip="Aprobar" Url="Content/Img/icons/Aprobar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>--%>
                                            <dx:GridViewCommandColumnCustomButton ID="cbReject">
                                                <Image ToolTip="Rechazar" Url="Content/Img/icons/Rechazar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                            <dx:GridViewCommandColumnCustomButton ID="cbApprove2">
                                                <Image ToolTip="Aceptar" Url="Content/Img/icons/Aceptar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                            <dx:GridViewCommandColumnCustomButton ID="cbFinish">
                                                <Image ToolTip="Terminar" Url="Content/Img/icons/Terminar.png"></Image>
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" Width="60"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="CentroLogistico" VisibleIndex="2" Width="300" MaxWidth="400">
                                        <PropertiesComboBox ClientInstanceName="cmbLogCent" DataSourceID="GetLogCenter" ValueField="VALOR" TextField="VALOR"></PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="Solicitante" VisibleIndex="3" Width="300" MaxWidth="400">
                                        <PropertiesComboBox ClientInstanceName="cmbSolic" DataSourceID="GetSolic" ValueField="NOMBRE_COMPLETO" TextField="NOMBRE_COMPLETO"></PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataDateColumn FieldName="FechaCreacion" VisibleIndex="4" MaxWidth="80" Settings-AllowHeaderFilter="true">
                                        <SettingsHeaderFilter Mode="DateRangePicker">
                                        </SettingsHeaderFilter>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="Estado" VisibleIndex="5" MaxWidth="80">
                                    </dx:GridViewDataComboBoxColumn>
                                </Columns>
                                <SettingsPager PageSize="10" NumericButtonCount="6" />
                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                <SettingsExport EnableClientSideExportAPI="true"></SettingsExport>
                                <SettingsDataSecurity AllowEdit="false" />
                                <SettingsPopup>
                                    <HeaderFilter Width="360" Height="400">
                                        <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="768"/>
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Styles>
                                    <Cell Wrap="True" />
                                </Styles>
                                <ClientSideEvents CustomButtonClick="fireClickMainGrid" />
                            </dx:ASPxGridView>
                        </dx:ContentControl>
                    </ContentCollection>
                    <ClientSideEvents EndCallback="function(s, e){
                        if(s.cpMessage !== null){
                            lblAlert.SetText(s.cpMessage);
                            pcAlert.Show();
                            delete s.cpMessage;
                        }
                     }" />
                </dx:BootstrapCallbackPanel>

            </div>
        </div>
    </div>
    <dx:BootstrapPopupControl runat="server" ClientInstanceName="pcAdminRequest" ID="pcAdminRequest" ShowHeader="true" CloseAction="CloseButton" HeaderText="" MinWidth="500" MaxWidth="800" CssClasses-Header="popupCtrl">
        <SettingsAdaptivity Mode="Always" VerticalAlign="WindowCenter" FixedHeader="true" />
        <ContentCollection>
            <dx:ContentControl>
                <dx:ASPxHiddenField runat="server" ID="hfActions" ClientInstanceName="hfActions"></dx:ASPxHiddenField>
                <dx:ASPxHiddenField runat="server" ID="hfRequestNumber" ClientInstanceName="hfRequestNumber"></dx:ASPxHiddenField>
                <dx:BootstrapCallbackPanel runat="server" ID="cpRequestData" ClientInstanceName="cpRequestData" OnCallback="cpRequestData_Callback">
                    <ContentCollection>
                        <dx:ContentControl>
                            <div class="container-fluid">
                                <div class="row mb-2">
                                    <div class="col-12 col-md-2 lab">IdReq:</div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapTextBox ID="txtIdReq" runat="server" ClientEnabled="false" Width="100%"></dx:BootstrapTextBox>
                                    </div>
                                    <div class="col-12 col-md-2 lab">Estado:</div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapTextBox ID="txtEstado" runat="server" Width="100%" ClientEnabled="false" CssClasses-Input="estateControl" ClientInstanceName="txtEstado">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                                            </ValidationSettings>
                                        </dx:BootstrapTextBox>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-12 col-md-2 lab">C. Log.:</div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapComboBox ID="cbxCentLog" ClientInstanceName="cbxCentLog" runat="server" Width="100%" DropDownAutoWidth="false" ValueType="System.String" ClientEnabled="false">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                                            </ValidationSettings>
                                        </dx:BootstrapComboBox>
                                    </div>
                                    <div class="col-12 col-md-2 lab">
                                        <dx:ASPxLabel ID="lblActionPerson" runat="server" Text="" Theme="MaterialCompact"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapTextBox ID="txtAppBy" ClientInstanceName="txtAppBy" runat="server" ClientEnabled="false"></dx:BootstrapTextBox>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-12 col-md-2 lab">Solicitante:</div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapComboBox ID="cbxSolic" ClientInstanceName="cbxSolic" runat="server" Width="100%" ValueType="System.String" ClientEnabled="false">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                                            </ValidationSettings>
                                        </dx:BootstrapComboBox>
                                    </div>
                                    <div class="col-12 col-md-2 lab">
                                        <dx:ASPxLabel ID="lblActionDate" runat="server" Text="" Theme="MaterialCompact"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapDateEdit ID="deFechaAction" runat="server" ClientEnabled="false" ClientInstanceName="deFechaAction">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                                            </ValidationSettings>
                                        </dx:BootstrapDateEdit>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-12 col-md-2 lab">Fecha:</div>
                                    <div class="col-12 col-md-4">
                                        <dx:BootstrapDateEdit ID="deFecha" runat="server" ClientEnabled="false" ClientInstanceName="deFecha">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                                            </ValidationSettings>
                                        </dx:BootstrapDateEdit>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-12 col-md-2 lab">
                                        <dx:ASPxLabel ID="lblMotiv" runat="server" Text="Motivo:" Theme="MaterialCompact" ClientVisible="false"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-12 col-md-10">
                                        <dx:BootstrapMemo ID="txtMotivo" ClientInstanceName="txtMotivo" runat="server" Width="100%" ClientVisible="false">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                                            </ValidationSettings>
                                        </dx:BootstrapMemo>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-md-2 lab">
                                        <dx:ASPxLabel ID="lblFiles" runat="server" Text="Archivos" Theme="MaterialCompact" ClientVisible="false"></dx:ASPxLabel>
                                    </div>

                                    <div class="col-12 col-md-10">
                                        <dx:BootstrapUploadControl runat="server" ShowUploadButton="true" ClientInstanceName="addFiles" Width="100%" ClientVisible="false" ID="addFiles" OnFileUploadComplete="UploadControl_FileUploadComplete">
                                            <ClientSideEvents FileUploadComplete="onFileUploadComplete" FilesUploadStart="onFilesUploadStart" />
                                            <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg,.gif,.png, .xlsx, .doc" />
                                            <AdvancedModeSettings EnableMultiSelect="true" EnableFileList="true" />
                                            <BrowseButton SettingsBootstrap-RenderOption="Info"></BrowseButton>
                                            <UploadButton Text="Cargar a Sharepoint" SettingsBootstrap-RenderOption="Link"></UploadButton>
                                            <RemoveButton SettingsBootstrap-RenderOption="Danger"></RemoveButton>
                                        </dx:BootstrapUploadControl>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-md-2"></div>
                                    <div class="col-12 col-md-10">
                                        <dx:ASPxCallbackPanel runat="server" ID="cpFiles" ClientInstanceName="cpFiles" OnCallback="cpFiles_Callback">
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <dx:ASPxGridView ID="dgFiles" ClientInstanceName="dgFiles" runat="server" Width="100%" EnableCallBacks="true" KeyFieldName="Id" Theme="MaterialCompact" ClientVisible="false">
                                                        <Columns>
                                                            <dx:GridViewCommandColumn VisibleIndex="0" ShowNewButtonInHeader="false" Width="50" ButtonRenderMode="Image">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="cbDeleteFile">
                                                                        <Image ToolTip="Eliminar" Url="Content/Img/icons/Borrar.png"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:BootstrapGridViewTextColumn FieldName="Id" Width="50"></dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn FieldName="NombreArchivo"></dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewHyperLinkColumn FieldName="Url" PropertiesHyperLinkEdit-Target="_blank">
                                                            </dx:BootstrapGridViewHyperLinkColumn>
                                                        </Columns>
                                                        <SettingsBehavior AllowSort="false" />
                                                        <SettingsDataSecurity AllowEdit="false" AllowInsert="true" />
                                                        <SettingsEditing Mode="Batch"></SettingsEditing>
                                                        <Settings ShowStatusBar="Hidden" />
                                                        <ClientSideEvents CustomButtonClick="FilesButtonsClick" />
                                                    </dx:ASPxGridView>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                            <ClientSideEvents EndCallback="function(s, e){
                                if(s.cpMessage != null){
                                    lblAlert.SetText(s.cpMessage);
                                    pcAlert.Show();
                                    delete s.cpMessage;
                                }
                                }" />
                                        </dx:ASPxCallbackPanel>
                                    </div>
                                </div>
                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:BootstrapCallbackPanel>
                <div class="text-center mt-2">
                    <dx:BootstrapButton ID="btnSaveRequest" runat="server" AutoPostBack="false" Text="Guardar" ValidationGroup="nReqGroup" OnClick="btnSaveRequest_Click">
                        <SettingsBootstrap RenderOption="Info" />
                        <%--<ClientSideEvents Click="function(s, e){
                            if (txtMotivo.GetText() === '') {
                                alert('Por favor ingrese un motivo');
                                txtMotivo.SetValid(false);
                                e.processOnServer = false;
                            } else e.processOnServer = true;
                         }" />--%>
                    </dx:BootstrapButton>
                    <dx:BootstrapButton ID="BootstrapButton2" runat="server" AutoPostBack="false" Text="Cancelar">
                        <ClientSideEvents Click="function(s, e){e.processOnServer = false; pcAdminRequest.Hide();}" />
                        <SettingsBootstrap RenderOption="Light" />
                    </dx:BootstrapButton>
                </div>
            </dx:ContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){
            txtEstado.SetIsValid(true);
            cbxCentLog.SetIsValid(true);
            cbxSolic.SetIsValid(true);
            deFechaAction.SetIsValid(true);
            deFecha.SetIsValid(true);
            txtMotivo.SetIsValid(true);
            cpRequestData.PerformCallback(hfActions.Get('parameterPopup'));
            }" />
    </dx:BootstrapPopupControl>
    <%-- <asp:ObjectDataSource ID="ResourcesDataSource" runat="server"
        DataObjectTypeName="Pe.Stracon.SGCO.SchedulerResource"
        TypeName="Pe.Stracon.SGCO.ResourceDataSourceHelper"
        SelectMethod="GetItems"></asp:ObjectDataSource>--%>

    <dx:ASPxPopupControl runat="server" ID="pcShowConfirm" ClientInstanceName="pcShowConfirm" HeaderText="STRACON - SGCO" Theme="MaterialCompact">
        <SettingsAdaptivity Mode="Always" MaxWidth="500px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-12">
                        <dx:ASPxHiddenField runat="server" ID="hfAction" ClientInstanceName="hfAction"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hfReqId" ClientInstanceName="hfReqId"></dx:ASPxHiddenField>
                        <dx:ASPxLabel ID="lblConfirm" ClientInstanceName="lblConfirm" runat="server" Text="" Font-Bold="true"></dx:ASPxLabel>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 text-right mt-2">
                        <dx:BootstrapButton ID="btnAceptConfirm" runat="server" AutoPostBack="false" Text="Aceptar" ClientInstanceName="btnAceptConfirm">
                            <SettingsBootstrap RenderOption="Info" />
                            <ClientSideEvents Click="function(s, e){
                                if(hfAction.Get('ActionConfirm') === 'request')
                                    cpActionsRequests.PerformCallback(hfReqId.Get('IdToDelete'));
                                else
                                    cpFiles.PerformCallback(hfReqId.Get('IdToDelete'));
                                pcShowConfirm.Hide();
                            }" />
                        </dx:BootstrapButton>
                        <dx:BootstrapButton ID="btnCancelAlert" runat="server" AutoPostBack="false" Text="Cancelar" ClientInstanceName="btnCancelAlert">
                            <ClientSideEvents Click="function(s, e){e.processOnServer = false; pcShowConfirm.Hide();}" />
                            <SettingsBootstrap RenderOption="Light" />
                        </dx:BootstrapButton>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <%--<ClientSideEvents Shown="function(s, e){setTimeout(function () { pcShowResults.Hide(); }, 3000);}" />--%>
    </dx:ASPxPopupControl>

    <dx:ASPxPopupControl runat="server" ID="pcAlert" ClientInstanceName="pcAlert" HeaderText="STRACON - SRCO" Theme="MaterialCompact">
        <SettingsAdaptivity Mode="Always" MaxWidth="500px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-12">
                        <dx:ASPxLabel ID="lblAlert" ClientInstanceName="lblAlert" runat="server" Text="" Font-Bold="true"></dx:ASPxLabel>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 text-right mt-2">
                        <dx:BootstrapButton ID="btnAceptAlert" runat="server" AutoPostBack="false" Text="Aceptar" ClientInstanceName="btnAceptAlert">
                            <SettingsBootstrap RenderOption="Info" />
                            <ClientSideEvents Click="function(s, e){pcAlert.Hide();}" />
                        </dx:BootstrapButton>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxCallbackPanel runat="server" ID="cpOpenReport" ClientInstanceName="cpOpenReport" OnCallback="cpOpenReport_Callback">
        <SettingsLoadingPanel Enabled="false" />
        <ClientSideEvents EndCallback="function(s, e){
            if(s.cpRedireccion != null)
                window.open(s.cpRedireccion, '_blank');
            delete(s.cpRedireccion)
            }" />
    </dx:ASPxCallbackPanel>

    <asp:SqlDataSource ID="GetLogCenter" runat="server" ConnectionString="<%$ connectionStrings:conectSGCO %>"></asp:SqlDataSource>
    <asp:SqlDataSource ID="GetSolic" runat="server" ConnectionString="<%$ connectionStrings:conectPOLI %>"></asp:SqlDataSource>
</asp:Content>

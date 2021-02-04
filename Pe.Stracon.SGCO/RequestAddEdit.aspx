<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="RequestAddEdit.aspx.cs" Inherits="Default" %>


<%@ Register Src="~/UserControls/Widget.ascx" TagPrefix="demo" TagName="Widget" %>
<%@ Register Src="~/UserControls/WidgetsContainer.ascx" TagPrefix="demo" TagName="WidgetsContainer" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
    <script>
        var actionPopupReq;
        var Valores = [];
        var rowFile;


        function SaveItemClick(s, e) {
            if (ASPxClientEdit.ValidateGroup('itemRequest')) {
                if (dgAttributes.batchEditApi.ValidateRows(true) === true) {
                    dgAttributes.UpdateEdit();
                } else {
                    lblAlert.SetText('Hay algunos atributos obligatorios que no les ha asignado un valor');
                    pcAlert.Show();
                }
            } else {
                lblAlert.SetText('Por favor complete todos los campos obligatorios');
                pcAlert.Show();
            }
        }

        function EndCallbackAtt(s, e) {
            cpSaveItems.PerformCallback(cbxMaterialType.GetValue()
                + '|' + cbxValCat.GetValue()
                + '|' + cbxArticleGroups.GetValue()
                + '|' + cbxMeUnit.GetValue()
                + '|' + cbxSegment.GetValue()
                + '|' + cbxGroup.GetValue()
                + '|' + cbxClass.GetValue()
                + '|' + txtDescripcion.GetText()
                + '|' + hfReqDetNum.Get('IdRequestDet')
                + '|' + cbxSegmentOnu.GetValue()
                + '|' + cbxGroupOnu.GetValue()
                + '|' + cbxClassOnu.GetValue());
        }

        function AttributeFillEnd(s, e) {
            Valores = [];
            if (hfReqDetNum.Get('IdRequestDet') === 0) {
                txtDescripcion.SetValue(null);
                for (var i = 0; i < dgAttributes.GetVisibleRowsOnPage(); i++) {
                    dgAttributes.batchEditApi.SetCellValue(i, 'Valor', '');
                }
            }

            for (var i = 0; i < dgAttributes.GetVisibleRowsOnPage(); i++) {
                Valores.push(dgAttributes.batchEditApi.GetCellValue(i, 'Valor'));
            }

        }

        function endCallbackDataItem(s, e) {
            Valores = [];
            for (var i = 0; i < dgAttributes.GetVisibleRowsOnPage(); i++) {
                Valores.push(dgAttributes.batchEditApi.GetCellValue(i, 'Valor'));
            }
        }

        function fireClickButtonDetail(s, e) {
            if (e.buttonID === 'cbEdit') {
                pcAddItem.Show();
                cpDataItem.PerformCallback(dgRequestDetail.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                hfReqDetNum.Set("IdRequestDet", dgRequestDetail.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
            } else if (e.buttonID === 'cbDelete') {
                hfReqId.Set('IdToDelete', dgRequestDetail.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                hfAction.Set('ActionConfirm', 'item');
                lblConfirm.SetText('¿Está seguro que desea eliminar este elemento?');
                pcShowConfirm.Show();
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
            pcAddItem.Show();
            cpDataItem.PerformCallback(0);
            hfReqDetNum.Set("IdRequestDet", 0);
        }

        function onFilesUploadStart(s, e) {
        }
        function onFileUploadComplete(s, e) {
            if (e.callbackData) {
                var fileData = e.callbackData.split('|');
                var fileName = fileData[0],
                    fileUrl = fileData[1],
                    fileSize = fileData[2];
                console.log(fileName + ' ' + fileUrl + ' ' + fileSize);
                dgFiles.Refresh();
            }
        }

        function OnMaterialTypeChanged(cmbMaterialT) {
            cbxValCat.PerformCallback(cmbMaterialT.GetSelectedItem().value.toString());
        }

        function OnSegmentChanged(cmbSegment) {
            cbxGroup.PerformCallback(cmbSegment.GetSelectedItem().value.toString());
        }

        function OnGroupChanged(cmbGrupo) {
            cbxClass.PerformCallback(cmbGrupo.GetSelectedItem().value.toString());
        }

        function OnSegmentOnuChanged(cmbSegmentOnu) {
            cpOnuCodes.PerformCallback(1 + '|' + cmbSegmentOnu.GetValue() + '|0|0');
            cbxGroupOnu.PerformCallback(cmbSegmentOnu.GetSelectedItem().value.toString());
        }

        function OnGroupOnuChanged(cmbGrupoOnu, IdSegOnu) {
            cpOnuCodes.PerformCallback(2 + '|' + IdSegOnu + '|' + cmbGrupoOnu.GetValue() + '|0');
            cbxClassOnu.PerformCallback(cmbGrupoOnu.GetSelectedItem().value.toString());
        }

        function InicioEdicionGridAttributes(s, e) {
            if (e.focusedColumn.fieldName === 'Requerido' || e.focusedColumn.fieldName === 'AttributeDesc')
                e.cancel = true;
        }

        function FinEdicionGridAttributes(s, e) {
            txtDescripcion.SetValue(null);
            window.setTimeout(function () {
                if (dgAttributes.batchEditApi.GetCellValue(e.visibleIndex, 'Id') === 0 && dgAttributes.batchEditApi.GetCellValue(e.visibleIndex, 'Valor') === null)
                    dgAttributes.batchEditApi.SetCellValue(e.visibleIndex, 'Valor', '');
                Valores[e.visibleIndex] = dgAttributes.batchEditApi.GetCellValue(e.visibleIndex, 'Valor');
                txtDescripcion.SetValue(Valores.filter(Boolean).join(' '));
            }, 5);

        }

        function OnValidationAttributes(s, e) {
            var grid = ASPxClientGridView.Cast(s);
            var Requerido = e.validationInfo[grid.GetColumnByField("Requerido").index];
            var Valor = e.validationInfo[grid.GetColumnByField("Valor").index];
            if (Requerido.value == true && (Valor.value == null || Valor.value == '')) {
                Valor.isValid = false;
                Valor.errorText = "Este campo es requerido";
            }
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

        @media (min-width: 576px) {
            .modal-dialog {
                max-width: 1000px !important;
            }
        }

        .estateControl {
            background: grey !important;
            font-weight: bold;
            color: white;
        }

        .dxgvDataRow_MaterialCompact td.dxgv {
            padding: 10px 5px 9px;
        }

        .dxgvDataRow_MaterialCompact .dxICheckBox_MaterialCompact {
            margin: -3px 10px -1px 6px;
        }

        fieldset.groupbox-border {
            border: 2px solid rgba(0,0,0,.1);
            border-radius: 0.4em;
            padding: 0 1.4em 1.4em 1.4em !important;
            /*margin: 1.2em 1.2em 1.2em 1.2em !important;*/
            -webkit-box-shadow: 0px 0px 0px 0px #000;
            box-shadow: 0px 0px 0px 0px #000;
            width: 100%;
        }

        legend.groupbox-border {
            font-size: 1.2em !important;
            font-weight: bold !important;
            text-align: left !important;
            width: auto;
            padding: 0px 10px 0px 10px;
            border-bottom: none;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="mainContent">
    <dx:ASPxHiddenField runat="server" ID="hfActions" ClientInstanceName="hfActions"></dx:ASPxHiddenField>
    <dx:ASPxHiddenField runat="server" ID="hfRequestNumber" ClientInstanceName="hfRequestNumber"></dx:ASPxHiddenField>
    <div class="container-fluid">
        <div class="card mt-2">
            <div class="card-body">
                <div class="row mb-2">
                    <p class="col-12 demo-content-title">Administración de Requerimientos</p>
                </div>
                <div class="row mb-2">
                    <div class="col-12 col-md-2 lab">IdReq:</div>
                    <div class="col-12 col-md-4">
                        <dx:BootstrapTextBox ID="txtIdReq" runat="server" ClientEnabled="false" Width="100%"></dx:BootstrapTextBox>
                    </div>
                    <div class="col-12 col-md-2 lab">Estado:</div>
                    <div class="col-12 col-md-4">
                        <dx:BootstrapTextBox ID="txtEstado" runat="server" Width="100%" ClientEnabled="false" CssClasses-Input="estateControl">
                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                            </ValidationSettings>
                        </dx:BootstrapTextBox>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-12 col-md-2 lab">Centro Logístico:</div>
                    <div class="col-12 col-md-4">
                        <dx:BootstrapComboBox ID="cbxCentLog" runat="server" Width="100%" DropDownAutoWidth="false" ValueType="System.String">
                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                            </ValidationSettings>
                        </dx:BootstrapComboBox>
                    </div>
                    <div class="col-12 col-md-2 lab">Solicitante:</div>
                    <div class="col-12 col-md-4">
                        <dx:BootstrapComboBox ID="cbxSolic" runat="server" Width="100%" ValueType="System.String" DropDownAutoWidth="false">
                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                            </ValidationSettings>
                        </dx:BootstrapComboBox>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-12 col-md-2 lab">Fecha:</div>
                    <div class="col-12 col-md-4">
                        <dx:BootstrapDateEdit ID="deFecha" runat="server" ClientEnabled="false">
                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="nReqGroup">
                                <RequiredField IsRequired="true" ErrorText="Este Campo es Requerido" />
                            </ValidationSettings>
                        </dx:BootstrapDateEdit>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 col-md-2 lab">
                        <dx:ASPxLabel ID="lblFiles" runat="server" Text="Archivos" Theme="MaterialCompact" ClientVisible="false"></dx:ASPxLabel>
                    </div>

                    <div class="col-12 col-md-10">
                        <dx:BootstrapUploadControl runat="server" ID="addFiles" ShowUploadButton="true" ClientInstanceName="addFiles" Width="100%"
                            ClientVisible="false" OnFileUploadComplete="UploadControl_FileUploadComplete">
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
                                            <dx:BootstrapGridViewTextColumn FieldName="Seccion" Caption="Categoría"></dx:BootstrapGridViewTextColumn>
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
                <div class="col-12 text-left mb-2 mt-2">
                    <dx:ASPxLabel ID="lblDetalleReq" runat="server" Theme="MaterialCompact" Text="Detalle Requerimiento" ClientVisible="false" Font-Bold="true"></dx:ASPxLabel>
                </div>
                <div class="row mb-2 mt-3">
                    <div class="col-7 col-md-10">
                        <dx:BootstrapTextBox ID="txtSearchPanel" runat="server" Width="100%" NullText="Introduza el texto a buscar..." ClientVisible="false"></dx:BootstrapTextBox>
                    </div>
                    <div class="col-5 col-md-2">
                        <dx:ASPxPanel ID="panelBtnAdd" runat="server" Width="100%" ClientVisible="false">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <button type="button" id="btnAddRequest" class="btn btn-info d-flex justify-content-center align-content-between btn-block" onclick="addNewReq();"><i class="material-icons mr-1">add</i> Ítem</button>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxPanel>

                        <%--<dx:ASPxButton runat="server" ID="btnNewReq" ClientInstanceName="btnNewReq" OnClick="btnNewReq_Click" ClientVisible="false"></dx:ASPxButton>--%>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <dx:ASPxCallbackPanel runat="server" ID="cpDeleteDetail" ClientInstanceName="cpDeleteDetail" Theme="MaterialCompact" OnCallback="cpDeleteDetail_Callback">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="dgRequestDetail" ClientInstanceName="dgRequestDetail" Theme="MaterialCompact" AutoGenerateColumns="false"
                                        runat="server" Width="100%" EnableCallBacks="true" KeyFieldName="Id" ClientVisible="false">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px"></HeaderFilter>
                                        </SettingsPopup>

                                        <SettingsSearchPanel CustomEditorID="txtSearchPanel" />
                                        <Settings ShowFilterRow="true" ShowStatusBar="Hidden" />
                                        <SettingsBehavior AllowSort="false" />
                                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"
                                            AllowHideDataCellsByColumnMinWidth="true">
                                        </SettingsAdaptivity>
                                        <Columns>
                                            <dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image">
                                                <CustomButtons>
                                                    <dx:GridViewCommandColumnCustomButton ID="cbEdit">
                                                        <Image ToolTip="Editar" Url="Content/Img/icons/Editar.png"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                    <dx:GridViewCommandColumnCustomButton ID="cbDelete">
                                                        <Image ToolTip="Eliminar" Url="Content/Img/icons/Borrar.png"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                </CustomButtons>
                                            </dx:GridViewCommandColumn>
                                            <dx:GridViewDataTextColumn FieldName="Id" Caption="N° Item" VisibleIndex="1" Width="50"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="IdSegmento" Caption="Segmento" VisibleIndex="3">
                                                <PropertiesComboBox ClientInstanceName="cmbSeg" DataSourceID="GetSegments" ValueField="Id" TextField="Descripcion"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="IdGrupo" Caption="Grupo" VisibleIndex="4">
                                                <PropertiesComboBox ClientInstanceName="cmbGro" DataSourceID="GetGroups" ValueField="Id" TextField="Descripcion"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="IdClase" Caption="Clase" VisibleIndex="5">
                                                <PropertiesComboBox ClientInstanceName="cmbCla" DataSourceID="GetClasses" ValueField="Id" TextField="Descripcion"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <SettingsPager PageSize="5" NumericButtonCount="6" />
                                        <SettingsEditing Mode="Batch"></SettingsEditing>
                                        <SettingsDataSecurity AllowEdit="false" />
                                        <Styles>
                                            <Cell Wrap="True" />
                                        </Styles>
                                        <ClientSideEvents CustomButtonClick="fireClickButtonDetail" />
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
                <div class="row">
                    <div class="text-center mt-4 col-12">
                        <dx:BootstrapButton ID="btnSaveRequest" runat="server" AutoPostBack="false" Text="Guardar" ValidationGroup="nReqGroup" OnClick="btnSaveRequest_Click">
                            <SettingsBootstrap RenderOption="Info" />
                        </dx:BootstrapButton>
                        <dx:BootstrapButton ID="btnCancel" runat="server" AutoPostBack="false" Text="Cancelar" OnClick="btnCancel_Click">
                            <SettingsBootstrap RenderOption="Light" />
                        </dx:BootstrapButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <dx:BootstrapPopupControl runat="server" ID="pcAddItem" ClientInstanceName="pcAddItem" HeaderText="Administrar Ítems"
        Width="950" MaxWidth="1100px" CloseAction="CloseButton" Modal="true">
        <SettingsAdaptivity Mode="Always" VerticalAlign="WindowCenter"
            FixedHeader="true" FixedFooter="true" />
        <ContentCollection>
            <dx:ContentControl>
                <dx:ASPxHiddenField runat="server" ClientInstanceName="hfReqDetNum" ID="hfReqDetNum"></dx:ASPxHiddenField>
                <dx:BootstrapCallbackPanel runat="server" ID="cpDataItem" ClientInstanceName="cpDataItem" OnCallback="cpDataItem_Callback">
                    <ContentCollection>
                        <dx:ContentControl>
                            <dx:BootstrapCallbackPanel runat="server" ID="cpSaveItems" ClientInstanceName="cpSaveItems" OnCallback="cpSaveItems_Callback" SettingsLoadingPanel-Text="Guardando Detalle del Requerimiento">
                                <ContentCollection>
                                    <dx:ContentControl>
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group col-12">
                                                        <label for="exampleInputEmail1">Tipo Material</label>
                                                        <dx:BootstrapComboBox ID="cbxMaterialType" ClientInstanceName="cbxMaterialType" DropDownAutoWidth="false" runat="server" Width="100%" TextField="Descripcion" ValueField="Id" ValueType="System.Int32">
                                                            <ClientSideEvents SelectedIndexChanged="function(s, e){OnMaterialTypeChanged(s);}" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                            </ValidationSettings>
                                                        </dx:BootstrapComboBox>
                                                    </div>
                                                    <div class="form-group col-12">
                                                        <label for="exampleInputEmail1">Categoría de Valorización</label>
                                                        <dx:BootstrapComboBox ID="cbxValCat" ClientInstanceName="cbxValCat" DropDownAutoWidth="false" runat="server" Width="100%" OnCallback="cbxValCat_Callback" ValueField="Id" TextField="Descripcion" ValueType="System.Int32">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                            </ValidationSettings>
                                                        </dx:BootstrapComboBox>
                                                    </div>
                                                    <div class="form-group col-12">
                                                        <label for="exampleInputEmail1">Grupo de Artículos</label>
                                                        <dx:BootstrapComboBox ID="cbxArticleGroups" ClientInstanceName="cbxArticleGroups" DropDownAutoWidth="false" runat="server" Width="100%">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                            </ValidationSettings>
                                                        </dx:BootstrapComboBox>
                                                    </div>
                                                    <div class="form-group col-12">
                                                        <label for="exampleInputEmail1">Unidad de Medida</label>
                                                        <dx:BootstrapComboBox ID="cbxMeUnit" ClientInstanceName="cbxMeUnit" DropDownAutoWidth="false" runat="server" Width="100%">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                            </ValidationSettings>
                                                        </dx:BootstrapComboBox>
                                                    </div>
                                                </div>
                                                <div class="col-12 col-md-8">
                                                    <div class="row">
                                                        <div class="col-12 col-md-6">
                                                            <div class="form-group col-12">
                                                                <label for="exampleInputEmail1">Segmento</label>
                                                                <dx:BootstrapComboBox ID="cbxSegment" ClientInstanceName="cbxSegment" DropDownAutoWidth="false" runat="server" Width="100%" TextField="Descripcion" ValueField="Id" ValueType="System.Int32">
                                                                    <ClientSideEvents SelectedIndexChanged="function(s, e){OnSegmentChanged(s);}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                        <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                                    </ValidationSettings>
                                                                </dx:BootstrapComboBox>
                                                            </div>
                                                            <div class="form-group col-12">
                                                                <label for="exampleInputEmail1">Grupo</label>
                                                                <dx:BootstrapComboBox ID="cbxGroup" ClientInstanceName="cbxGroup" DropDownAutoWidth="false" runat="server" Width="100%" OnCallback="cbxGroup_Callback" ValueField="Id" TextField="Descripcion" ValueType="System.Int32">
                                                                    <ClientSideEvents SelectedIndexChanged="function(s, e){OnGroupChanged(s);}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                        <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                                    </ValidationSettings>
                                                                </dx:BootstrapComboBox>
                                                            </div>
                                                            <div class="form-group col-12">
                                                                <label for="exampleInputEmail1">Clase</label>
                                                                <dx:BootstrapComboBox ID="cbxClass" ClientInstanceName="cbxClass" DropDownAutoWidth="false" runat="server" Width="100%" OnCallback="cbxClass_Callback" ValueField="Id" TextField="Descripcion" ValueType="System.Int32">
                                                                    <ClientSideEvents SelectedIndexChanged="function(s, e){dgAttributes.CancelEdit(); cpLoadAtributes.PerformCallback(s.GetValue());}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                        <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                                    </ValidationSettings>
                                                                </dx:BootstrapComboBox>
                                                            </div>
                                                        </div>
                                                        <div class="col-12 col-md-6">
                                                            <div class="form-group col-12">
                                                                <label for="exampleInputEmail1">Atributos</label>
                                                                <dx:BootstrapCallbackPanel runat="server" ID="cpLoadAtributes" ClientInstanceName="cpLoadAtributes" OnCallback="cpLoadAtributes_Callback">
                                                                    <ContentCollection>
                                                                        <dx:ContentControl>
                                                                            <dx:ASPxGridView ID="dgAttributes" runat="server" ClientInstanceName="dgAttributes" Theme="MaterialCompact" Width="100%" KeyFieldName="Id;IdAtributo" OnBatchUpdate="dgAttributes_BatchUpdate">
                                                                                <%--<SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"
                                                                                    AllowHideDataCellsByColumnMinWidth="true">
                                                                                </SettingsAdaptivity>--%>
                                                                                <SettingsLoadingPanel Text="Procesando Atributos" />
                                                                                <Columns>
                                                                                    <dx:BootstrapGridViewTextColumn FieldName="Id" Caption="" MaxWidth="1"></dx:BootstrapGridViewTextColumn>
                                                                                    <dx:BootstrapGridViewTextColumn FieldName="IdAtributo" Caption="" MaxWidth="1"></dx:BootstrapGridViewTextColumn>
                                                                                    <dx:BootstrapGridViewCheckColumn FieldName="Requerido" Width="40" Caption="R*"></dx:BootstrapGridViewCheckColumn>
                                                                                    <dx:BootstrapGridViewTextColumn FieldName="AttributeDesc" Caption="Atributo" MaxWidth="170"></dx:BootstrapGridViewTextColumn>
                                                                                    <dx:BootstrapGridViewTextColumn FieldName="Valor"></dx:BootstrapGridViewTextColumn>
                                                                                </Columns>
                                                                                <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click" BatchEditSettings-KeepChangesOnCallbacks="False" BatchEditSettings-ShowConfirmOnLosingChanges="false"></SettingsEditing>
                                                                                <Settings ShowStatusBar="Hidden" VerticalScrollBarMode="Auto" VerticalScrollableHeight="240" />
                                                                                <SettingsDataSecurity AllowEdit="true" />
                                                                                <SettingsBehavior AllowSort="false" />
                                                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                <Styles>
                                                                                    <Cell Wrap="True" />
                                                                                </Styles>
                                                                                <ClientSideEvents BatchEditStartEditing="InicioEdicionGridAttributes" BatchEditEndEditing="FinEdicionGridAttributes" BatchEditRowValidating="OnValidationAttributes" EndCallback="EndCallbackAtt" />
                                                                            </dx:ASPxGridView>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                    <ClientSideEvents EndCallback="AttributeFillEnd" />
                                                                </dx:BootstrapCallbackPanel>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12">
                                                    <div class="form-group col-12">
                                                        <fieldset class="groupbox-border">
                                                            <legend class="groupbox-border">CLASIFICADOR ONU</legend>
                                                            <div class="control-group">
                                                                <div class="row">
                                                                    <div class="form-group col-12 col-md-4">
                                                                        <label for="exampleInputEmail1">Segmento</label>
                                                                        <dx:BootstrapComboBox ID="cbxSegmentoOnu" ClientInstanceName="cbxSegmentOnu" DropDownAutoWidth="false" runat="server" Width="100%" TextField="Descripcion" ValueField="Id" ValueType="System.Int32">
                                                                            <ClientSideEvents SelectedIndexChanged="function(s, e){OnSegmentOnuChanged(s);}" />
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                                            </ValidationSettings>
                                                                        </dx:BootstrapComboBox>
                                                                    </div>
                                                                    <div class="form-group col-12 col-md-4">
                                                                        <label for="exampleInputEmail1">Grupo</label>
                                                                        <dx:BootstrapComboBox ID="cbxGroupOnu" ClientInstanceName="cbxGroupOnu" DropDownAutoWidth="false" runat="server" Width="100%" ValueField="Id" TextField="Descripcion" ValueType="System.Int32" OnCallback="cbxGroupOnu_Callback">
                                                                            <ClientSideEvents SelectedIndexChanged="function(s, e){OnGroupOnuChanged(s, cbxSegmentOnu.GetValue());}" />
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                                            </ValidationSettings>
                                                                        </dx:BootstrapComboBox>
                                                                    </div>
                                                                    <div class="form-group col-12 col-md-4">
                                                                        <label for="exampleInputEmail1">Clase</label>
                                                                        <dx:BootstrapComboBox ID="cbxClassOnu" ClientInstanceName="cbxClassOnu" DropDownAutoWidth="false" runat="server" Width="100%" ValueField="Id" TextField="Descripcion" ValueType="System.Int32" OnCallback="cbxClassOnu_Callback">
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="itemRequest">
                                                                                <RequiredField IsRequired="true" ErrorText="Este campo es requerido" />
                                                                            </ValidationSettings>
                                                                            <ClientSideEvents SelectedIndexChanged="function(s, e){
                                                                                cpOnuCodes.PerformCallback(3 + '|' + cbxSegmentOnu.GetValue() + '|' + cbxGroupOnu.GetValue() + '|' + s.GetValue());
                                                                                }" />
                                                                        </dx:BootstrapComboBox>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12">
                                                                        <dx:BootstrapCallbackPanel runat="server" ID="cpOnuCodes" ClientInstanceName="cpOnuCodes" OnCallback="cpOnuCodes_Callback" Width="100%">
                                                                            <ContentCollection>
                                                                                <dx:ContentControl>
                                                                                    <div class="row">
                                                                                        <div class="form-group col-12">
                                                                                            <label for="exampleInputEmail1">Código ONU:</label>
                                                                                            <dx:BootstrapTextBox ID="txtCodOnu" ClientInstanceName="txtCodOnu" runat="server" Width="100%" ClientEnabled="false"></dx:BootstrapTextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                </dx:ContentControl>
                                                                            </ContentCollection>
                                                                        </dx:BootstrapCallbackPanel>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group col-12">
                                                    <div class="col-12">
                                                        <label>Descripción</label>
                                                        <dx:BootstrapTextBox ID="txtDescripcion" ClientInstanceName="txtDescripcion" runat="server" Width="100%" ClientEnabled="false"></dx:BootstrapTextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="text-center mt-2 col-12">
                                                    <dx:BootstrapButton ID="btnSaveItem" runat="server" AutoPostBack="false" Text="Guardar" ValidationGroup="itemRequest">
                                                        <SettingsBootstrap RenderOption="Info" />
                                                        <ClientSideEvents Click="SaveItemClick" />
                                                    </dx:BootstrapButton>
                                                    <dx:BootstrapButton ID="btnCancelItem" runat="server" AutoPostBack="false" Text="Cancelar">
                                                        <ClientSideEvents Click="function(s, e){dgAttributes.CancelEdit(); pcAddItem.Hide();}" />
                                                        <SettingsBootstrap RenderOption="Light" />
                                                    </dx:BootstrapButton>
                                                </div>
                                            </div>
                                        </div>
                                    </dx:ContentControl>
                                </ContentCollection>
                                <ClientSideEvents EndCallback="function(s, e){
                                    if(s.cpError !== null && s.cpError !== undefined) {
                                        lblAlert.SetText(s.cpError);
                                        pcAlert.Show();
                                        delete s.cpDetailNumber;
                                    } else pcAddItem.Hide();
                                 }" />
                            </dx:BootstrapCallbackPanel>
                        </dx:ContentControl>
                    </ContentCollection>
                    <ClientSideEvents EndCallback="endCallbackDataItem" />
                </dx:BootstrapCallbackPanel>
            </dx:ContentControl>
        </ContentCollection>
    </dx:BootstrapPopupControl>

    <dx:ASPxPopupControl runat="server" ID="pcShowConfirm" ClientInstanceName="pcShowConfirm" HeaderText="STRACON - SRCO" Theme="MaterialCompact">
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
                                if(hfAction.Get('ActionConfirm') === 'item')
                                    cpDeleteDetail.PerformCallback(hfReqId.Get('IdToDelete'));
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

    <asp:SqlDataSource ID="GetSegments" runat="server" ConnectionString="<%$ connectionStrings:conectSGCO %>"></asp:SqlDataSource>
    <asp:SqlDataSource ID="GetGroups" runat="server" ConnectionString="<%$ connectionStrings:conectSGCO %>"></asp:SqlDataSource>
    <asp:SqlDataSource ID="GetClasses" runat="server" ConnectionString="<%$ connectionStrings:conectSGCO %>"></asp:SqlDataSource>
</asp:Content>

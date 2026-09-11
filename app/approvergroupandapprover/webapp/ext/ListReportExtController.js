sap.ui.define(
  ['sap/ui/core/mvc/ControllerExtension', 'sap/m/MessageBox'],
  function (ControllerExtension, MessageBox) {
    'use strict';

    // ------------------------------------------------------------------
    // Internal helper – fetches the endpoint and saves the xlsx response
    // ------------------------------------------------------------------

    return {
      // return ControllerExtension.extend("project1.ext.ListReportExtController", {

      // ------------------------------------------------------------------
      // Download as Identifier (main menu button action)
      // ------------------------------------------------------------------
      onDownloadApprover: function () {
        const urlPrefix = this.getModel().sServiceUrl.startsWith('/') ? '/' : '';
        window.open(
          urlPrefix + "odata/v4/spreadsheet/Spreadsheet(entity='Approver')/content",
          '_self'
        );
      },

      // ------------------------------------------------------------------
      // Download as Approval Steps (secondary menu item)
      // ------------------------------------------------------------------
      onDownloadApproverGroup: function (oEvent, SelectedContext) {
        const urlPrefix = this.getModel().sServiceUrl.startsWith('/') ? '/' : '';
        window.open(
          urlPrefix + "odata/v4/spreadsheet/Spreadsheet(entity='ApproverGroup')/content",
          '_self'
        );
      },
      onDownloadApproverGroupOverView: function (oEvent, SelectedContext) {
        const urlPrefix = this.getModel().sServiceUrl.startsWith('/') ? '/' : '';
        window.open(
          urlPrefix + "odata/v4/spreadsheet/Spreadsheet(entity='ApproverGroupOverview')/content",
          '_self'
        );
      },
    };
    // });
  }
);

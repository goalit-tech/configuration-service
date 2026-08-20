sap.ui.define(["sap/ui/core/mvc/ControllerExtension", "sap/m/MessageBox"], function (
    ControllerExtension,
    MessageBox
) {
    "use strict";

    // ------------------------------------------------------------------
    // Internal helper – fetches the endpoint and saves the xlsx response
    // ------------------------------------------------------------------
    function _triggerDownload(url, filename) {
        debugger
        fetch(url)
            .then(function (response) {
                if (!response.ok) {
                    return response.json().then(function (body) {
                        throw new Error(body.error || "Download failed");
                    });
                }
                return response.blob();
            })
            .then(function (blob) {
                var objectUrl = URL.createObjectURL(blob);
                var link = document.createElement("a");
                link.href = objectUrl;
                link.download = filename;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                URL.revokeObjectURL(objectUrl);
            })
            .catch(function (err) {
                MessageBox.error("Download failed: " + err.message);
            });
    }

    return {
        // return ControllerExtension.extend("project1.ext.ListReportExtController", {

        // ------------------------------------------------------------------
        // Download as Identifier (main menu button action)
        // ------------------------------------------------------------------
        onDownloadIdentifiers: function () {
            _triggerDownload("/download/identifiers", "identifiers.xlsx");
        },

        // ------------------------------------------------------------------
        // Download as Approval Steps (secondary menu item)
        // ------------------------------------------------------------------
        onDownloadApprovalSteps: function (oEvent, SelectedContext) {
            _triggerDownload("/download/approvalsteps", "approvalsteps.xlsx");
        }
    }
    // });
});

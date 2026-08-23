sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/demo/approvergroups/test/integration/pages/ApproverGroupList",
	"com/demo/approvergroups/test/integration/pages/ApproverGroupObjectPage"
], function (JourneyRunner, ApproverGroupList, ApproverGroupObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/demo/approvergroups') + '/test/flp.html#app-preview',
        pages: {
			onTheApproverGroupList: ApproverGroupList,
			onTheApproverGroupObjectPage: ApproverGroupObjectPage
        },
        async: true
    });

    return runner;
});


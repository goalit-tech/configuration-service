sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/siemens/ind/approvergroupandapprover/test/integration/pages/ApproverGroupList.gen",
	"com/siemens/ind/approvergroupandapprover/test/integration/pages/ApproverGroupObjectPage.gen"
], function (JourneyRunner, ApproverGroupListGenerated, ApproverGroupObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/siemens/ind/approvergroupandapprover') + '/test/flp.html#app-preview',
        pages: {
			onTheApproverGroupListGenerated: ApproverGroupListGenerated,
			onTheApproverGroupObjectPageGenerated: ApproverGroupObjectPageGenerated
        },
        async: true
    });

    return runner;
});


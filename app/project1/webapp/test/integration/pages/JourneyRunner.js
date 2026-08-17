sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/ConstantConfigList",
	"project1/test/integration/pages/ConstantConfigObjectPage"
], function (JourneyRunner, ConstantConfigList, ConstantConfigObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheConstantConfigList: ConstantConfigList,
			onTheConstantConfigObjectPage: ConstantConfigObjectPage
        },
        async: true
    });

    return runner;
});


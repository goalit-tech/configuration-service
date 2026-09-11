namespace com.siemens.ind.configurationScope;

using {
    cuid,
    managed
} from '@sap/cds/common';

using {com.siemens.ind.configurationscope.approverAndGroup as approver} from './approver';
using {com.siemens.ind.common as datamodel} from './datamodel';


entity ConfigurationScope : cuid, managed {
    CompanyCode     : String;
    PurchasingOrg   : String;
    Plant           : String;
    IsActive        : Boolean;
    BusinessPurpose : Association to datamodel.BusinessPurposes;
    Identifiers     : Composition of many Identifier
                          on Identifiers.ConfigurationScope = $self;
    ApprovalStep    : Composition of many ApprovalStep
                          on ApprovalStep.ConfigurationScope = $self;

}

entity Identifier : cuid, managed {
    ConfigurationScope : Association to ConfigurationScope;
    Identifier         : String;
    Value              : String;
    IsActive           : Boolean;

}

entity ApprovalStep : cuid, managed {
    ConfigurationScope        : Association to ConfigurationScope;
    DocumentCategory          : Association to datamodel.PurchasingDocumentTypeCode;
    MaterialGroup             : String;
    ProcessType               : String;
    AccountAssignmentCategory : String;
    SpecialLogic              : String;
    SATApproverAmount         : SATApproverAmount;
    Step                      : String;
    Sequence                  : Integer;
    NotificationGroup         : String;
    NotificationValue         : String;
    NotificationCurrency      : String;
    IsActive                  : Boolean;
    ApproverGroup             : Association to many StepApproverGroups
                                    on ApproverGroup.ApprovalStep = $self;
    StepApprovers             : Composition of many StepApprover
                                    on StepApprovers.ApprovalStep = $self;
}

type SATApproverAmount {
    lowAmount  : Decimal(15, 2);
    highAmount : Decimal(15, 2);
}

entity StepApprover : cuid, managed {
    ApprovalStep : Association to ApprovalStep;
    Approver     : Association to approver.Approver;
}

entity StepApproverGroups : cuid, managed {
    ApprovalStep  : Association to ApprovalStep;
    ApproverGroup : Association to approver.ApproverGroup;
}

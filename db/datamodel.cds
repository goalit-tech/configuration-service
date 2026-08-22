namespace com.simple;

using {
    cuid,
    managed
} from '@sap/cds/common';


/**
 * Header data for a configuration, grouping related configuration items.
 */
entity ConfigurationScope : cuid, managed {
    /** Purchasing organization code. */
    CompanyCode   : String;
    /** Purchasing organization code. */
    PurchasingOrg : String;
    /** Purchasing organization code. */
    Plant         : String;
    /** Type of the configuration. */
    IsActive      : Boolean;
    /** Configuration items belonging to this header. */
    Identifiers   : Composition of many Identifier
                        on Identifiers.ConfigurationScope = $self;
    ApprovalStep  : Composition of many ApprovalStep
                        on ApprovalStep.ConfigurationScope = $self;
}

/**
 * A single configuration item belonging to a configuration header.
 */
entity Identifier : cuid, managed {
    /** Header this item belongs to. */
    ConfigurationScope : Association to ConfigurationScope;
    /** Unique identifier of the item. */
    Identifier         : String;
    /** Value of the item. */
    Value              : String;
    /** Type of the configuration. */
    IsActive           : Boolean;

}


/**
 * Approval step rule derived from the PR Steps decision table (e.g. PR_Steps_Non_Prod).
 * Each row is one rule: a set of matching criteria plus the resulting approval step.
 */
entity ApprovalStep : cuid, managed {
    /** Header this rule belongs to. */
    ConfigurationScope        : Association to ConfigurationScope;
    /** Purchasing organization criterion. */
    PurchasingOrg             : String;
    /** Company code criterion. */
    CompanyCode               : String;
    /** Business purpose criterion. */
    BusinessPurpose           : String;
    /** Plant criterion. */
    Plant                     : String;
    /** Material group criterion. */
    MaterialGroup             : String;
    /** Process type criterion (e.g. Freetext, Limit). */
    ProcessType               : String;
    /** Account assignment category criterion. */
    AccountAssignmentCategory : String;
    /** Additional special logic criterion (e.g. NoVendor, EventError). */
    SpecialLogic              : String;
    SATApproverAmount         : SATApproverAmount;
    /** Name of the resulting approval step. */
    Step                      : String;
    /** Sequence/order of the step within the approval flow. */
    Sequence                  : Integer;
    /** Group to notify for this step. */
    NotificationGroup         : String;
    /** Value threshold that triggers a notification. */
    NotificationValue         : String;
    /** Currency of the notification value threshold. */
    NotificationCurrency      : String;
    /** Indicates whether the rule is active. */
    IsActive                  : Boolean;
    ApproverGroup             : Association to many StepApproverGroups
                                    on ApproverGroup.ApprovalStep = $self;
    // ApproverGroup             : Association to ApproverGroup;
    StepApprovers             : Composition of many StepApprover
                                    on StepApprovers.ApprovalStep = $self;
}

type SATApproverAmount {
    lowAmount  : Decimal(15, 2);
    highAmount : Decimal(15, 2);
}

entity Approver : managed {
    key GID      : String;
        email    : String;
        IsActive : Boolean;
}

/** Master data: a named, reusable group of approvers. */
entity ApproverGroup : managed {
    key GroupName   : String;
        Description : String;
        IsActive    : Boolean;
        Members     : Composition of many ApproverGroupMember
                          on Members.ApproverGroup = $self;
}

/** Thin link: which Approver belongs to which ApproverGroup. */
entity ApproverGroupMember : cuid, managed {
    ApproverGroup : Association to ApproverGroup;
    Approver      : Association to Approver;
}

/** Thin link: which Approver is assigned directly to a step (no group). */
entity StepApprover : cuid, managed {
    ApprovalStep : Association to ApprovalStep;
    Approver     : Association to Approver;
}

entity StepApproverGroups : cuid, managed {
    ApprovalStep  : Association to ApprovalStep;
    ApproverGroup : Association to ApproverGroup;
}


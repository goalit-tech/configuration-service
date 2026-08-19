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

    Approvers                 : Composition of many ApproverGroupMember
                                    on Approvers.ApprovalStep = $self;
}

type SATApproverAmount {
    lowAmount  : Decimal(15, 2);
    highAmount : Decimal(15, 2);
}

entity ApproverGroupMember : cuid, managed {
    /** Approver group mapping this member belongs to. */
    ApprovalStep : Association to ApprovalStep;
    /** Global ID of the approver. */
    GID          : String;
}

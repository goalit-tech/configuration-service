using {com.simple as db} from '../db/datamodel';

service ConfigService {

    @odata.draft.enabled
    entity ConfigurationScope  as projection on db.ConfigurationScope;

    entity Identifier          as projection on db.Identifier;

    entity ApprovalStep        as projection on db.ApprovalStep;

    entity ApproverGroupMember as projection on db.ApproverGroupMember;


    entity IdentifierDownloadView    as
        select from Identifier {
            key ID,
                ConfigurationScope.CompanyCode   as CompanyCode,
                ConfigurationScope.PurchasingOrg as PurchasingOrg,
                ConfigurationScope.Plant         as Plant,
                ConfigurationScope.IsActive      as ScopeIsActive,
                Identifier                       as IdentifierCode,
                Value,
                IsActive
        };

    /**
     * Flat view for Excel download: ConfigurationScope + ApprovalStep +
     * ApproverGroupMember fields denormalised (one row per approver member).
     */
    @readonly
    entity ApprovalStepDownloadView  as
        select from ApproverGroupMember {
            key ID,
                ApprovalStep.ConfigurationScope.CompanyCode          as CompanyCode,
                ApprovalStep.ConfigurationScope.PurchasingOrg        as PurchasingOrg,
                ApprovalStep.ConfigurationScope.Plant                 as Plant,
                ApprovalStep.Step,
                ApprovalStep.Sequence,
                ApprovalStep.BusinessPurpose,
                ApprovalStep.MaterialGroup,
                ApprovalStep.ProcessType,
                ApprovalStep.AccountAssignmentCategory,
                ApprovalStep.SpecialLogic,
                ApprovalStep.SATApproverAmount.lowAmount             as LowAmount,
                ApprovalStep.SATApproverAmount.highAmount            as HighAmount,
                ApprovalStep.NotificationGroup,
                ApprovalStep.NotificationValue,
                ApprovalStep.NotificationCurrency,
                ApprovalStep.IsActive                                as StepIsActive,
                GID                                                  as ApproverGID
        };
}

using {com.simple as db} from '../db/datamodel';

service ConfigService {

    @odata.draft.enabled
    entity ConfigurationScope            as projection on db.ConfigurationScope;

    entity Identifier                    as projection on db.Identifier;

    entity ApprovalStep                  as projection on db.ApprovalStep;

    entity ApproverGroupMember           as projection on db.ApproverGroupMember;

    @odata.draft.enabled
    entity ApproverGroup                 as projection on db.ApproverGroup;

    @odata.draft.enabled
    entity Approver                      as projection on db.Approver;


    entity IdentifierDownloadView        as
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


    @readonly
    entity ApprovalStepDownloadView      as
            select from ApprovalStep as step
            left join ConfigurationScope as scope
                on scope.ID = step.ConfigurationScope.ID
            left join db.StepApproverGroups as stepGroup
                on stepGroup.ApprovalStep.ID = step.ID
            left join ApproverGroup as grp
                on grp.GroupName = stepGroup.ApproverGroup.GroupName
            left join ApproverGroupMember as member
                on member.ApproverGroup.GroupName = grp.GroupName
            left join db.Approver as groupApprover
                on groupApprover.GID = member.Approver.GID
            {
                key member.ID                         as ID,
                    scope.CompanyCode                 as CompanyCode,
                    scope.PurchasingOrg               as PurchasingOrg,
                    scope.Plant                       as Plant,
                    step.Step,
                    step.Sequence,
                    step.BusinessPurpose,
                    step.MaterialGroup,
                    step.ProcessType,
                    step.AccountAssignmentCategory,
                    step.SpecialLogic,
                    step.SATApproverAmount.lowAmount  as LowAmount,
                    step.SATApproverAmount.highAmount as HighAmount,
                    step.NotificationGroup,
                    step.NotificationValue,
                    step.NotificationCurrency,
                    step.IsActive                     as StepIsActive,
                    grp.GroupName                     as ApproverGroupName,
                    groupApprover.GID                 as ApproverGID,
                    false                             as IsDirectApprover : Boolean
            }

        union all

            select from ApprovalStep as step
            left join ConfigurationScope as scope
                on scope.ID = step.ConfigurationScope.ID
            left join db.StepApprover as stepApprover
                on stepApprover.ApprovalStep.ID = step.ID
            left join db.Approver as directApprover
                on directApprover.GID = stepApprover.Approver.GID
            {
                key stepApprover.ID                   as ID,
                    scope.CompanyCode                 as CompanyCode,
                    scope.PurchasingOrg               as PurchasingOrg,
                    scope.Plant                       as Plant,
                    step.Step,
                    step.Sequence,
                    step.BusinessPurpose,
                    step.MaterialGroup,
                    step.ProcessType,
                    step.AccountAssignmentCategory,
                    step.SpecialLogic,
                    step.SATApproverAmount.lowAmount  as LowAmount,
                    step.SATApproverAmount.highAmount as HighAmount,
                    step.NotificationGroup,
                    step.NotificationValue,
                    step.NotificationCurrency,
                    step.IsActive                     as StepIsActive,
                    null                              as ApproverGroupName : String,
                    directApprover.GID                as ApproverGID,
                    true                              as IsDirectApprover  : Boolean
            };


    @readonly
    entity ApprovalStepDownloadViewAssoc as
            select from ApprovalStep {
                key ApproverGroup.ApproverGroup.Members.ID           as ID,
                    ConfigurationScope.CompanyCode                   as CompanyCode,
                    ConfigurationScope.PurchasingOrg                 as PurchasingOrg,
                    ConfigurationScope.Plant                         as Plant,
                    Step,
                    Sequence,
                    BusinessPurpose,
                    MaterialGroup,
                    ProcessType,
                    AccountAssignmentCategory,
                    SpecialLogic,
                    SATApproverAmount.lowAmount                      as LowAmount,
                    SATApproverAmount.highAmount                     as HighAmount,
                    NotificationGroup,
                    NotificationValue,
                    NotificationCurrency,
                    IsActive                                         as StepIsActive,
                    ApproverGroup.ApproverGroup.GroupName            as ApproverGroupName,
                    ApproverGroup.ApproverGroup.Members.Approver.GID as ApproverGID,
                    false                                            as IsDirectApprover : Boolean
            }

        union all

            select from ApprovalStep {
                key StepApprovers.ID                 as ID,
                    ConfigurationScope.CompanyCode   as CompanyCode,
                    ConfigurationScope.PurchasingOrg as PurchasingOrg,
                    ConfigurationScope.Plant         as Plant,
                    Step,
                    Sequence,
                    BusinessPurpose,
                    MaterialGroup,
                    ProcessType,
                    AccountAssignmentCategory,
                    SpecialLogic,
                    SATApproverAmount.lowAmount      as LowAmount,
                    SATApproverAmount.highAmount     as HighAmount,
                    NotificationGroup,
                    NotificationValue,
                    NotificationCurrency,
                    IsActive                         as StepIsActive,
                    null                             as ApproverGroupName : String,
                    StepApprovers.Approver.GID       as ApproverGID,
                    true                             as IsDirectApprover  : Boolean
            };
}

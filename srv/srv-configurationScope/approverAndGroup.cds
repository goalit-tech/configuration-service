using {com.siemens.ind.configurationscope as configurationScopeModel} from '../../db/configurationScope';

// @requires: [
//     'authenticated-user',
//     'system-user'
// ]
service ApproverAndGroupService {

    @odata.draft.enabled
    entity ApproverGroup         as projection on configurationScopeModel.approverAndGroup.ApproverGroup;

    @odata.draft.enabled
    entity Approver              as projection on configurationScopeModel.approverAndGroup.Approver;

    entity ApproverGroupMember   as projection on configurationScopeModel.approverAndGroup.ApproverGroupMember;

    /** Flattened, read-only view: every approver group together with its members and their approver details. */
    @readonly
    entity ApproverGroupOverview as
        select from ApproverGroupMember {
            key ID                             as ID,
                ApproverGroup.ID               as ApproverGroup_ID,
                ApproverGroup.GroupName        as GroupName,
                ApproverGroup.Description      as GroupDescription,
                ApproverGroup.IsActive         as GroupIsActive,
                Approver.ID                    as Approver_ID,
                Approver.GID                   as ApproverGID,
                Approver.Email                 as ApproverEmail,
                Approver.IsActive              as ApproverIsActive,
                Approver.IsNotificationEnabled as ApproverIsNotificationEnabled,
                Email                          as MemberEmail,
                IsNotificationEnabled          as MemberIsNotificationEnabled,
                IsActive                       as MemberIsActive
        };

}

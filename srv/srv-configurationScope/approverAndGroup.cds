using {com.siemens.ind.configurationscope as configurationScopeModel} from '../../db/configurationScope';

// @requires: [
//     'authenticated-user',
//     'system-user'
// ]
service ApproverAndGroupService {

    @odata.draft.enabled
    entity ApproverGroup       as projection on configurationScopeModel.approverAndGroup.ApproverGroup;

    @odata.draft.enabled
    entity Approver            as projection on configurationScopeModel.approverAndGroup.Approver;

    entity ApproverGroupMember as projection on configurationScopeModel.approverAndGroup.ApproverGroupMember;

}

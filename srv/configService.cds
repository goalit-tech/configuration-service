using {com.simple as db} from '../db/datamodel';

service ConfigService {

    @odata.draft.enabled
    entity ConfigurationScope as projection on db.ConfigurationScope;
    entity Identifier as projection on db.Identifier;
    entity ApprovalStep as projection on db.ApprovalStep;
    // @odata.draft.enabled
    entity ApproverGroupMember as projection on db.ApproverGroupMember;
    
   
}

using {com.simple as db} from '../db/datamodel';

service ConfigService {
    entity ConstantConfig      as projection on db.ConstantConfig;

    // @odata.draft.enabled
    // entity Identifiers            as
    //     projection on db.ConstantConfig {
    //         ID,
    //         purchasingOrg,
    //         Identifier,
    //         value,
    //     }

    // @odata.draft.enabled
    // entity ConstantConfigDistinct as
    //     select from db.ConstantConfig
    //     mixin {
    //         Identifiers : Association to many Identifiers
    //                           on Identifiers.purchasingOrg = purchasingOrg;
    //     }
    //     into {
    //         ID,
    //         purchasingOrg,
    //         type,
    //         IsActive,
    //         Identifiers
    //     }
    //     group by
    //         purchasingOrg;
    
    @odata.draft.enabled
    entity ConfigurationHeader as projection on db.ConfigurationHeader;

    entity ConfigurationItem   as projection on db.ConfigurationItem;

    // @readonly
    // @cds.redirection.target
    // entity ConfigurationView   as projection on db.ConfigurationView;
}

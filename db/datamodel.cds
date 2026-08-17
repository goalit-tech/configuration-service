namespace com.simple;

using {
    cuid,
    managed
} from '@sap/cds/common';

entity ConstantConfig : cuid, managed {
    purchasingOrg : String;
    Identifier    : String;
    value         : String;
    IsActive      : Boolean;
    type          : String;
}


entity ConfigurationHeader : cuid, managed {
    purchasingOrg : String;
    type          : String;
    IsActive      : Boolean;
    Items         : Composition of many ConfigurationItem
                        on Items.header = $self;
}

entity ConfigurationItem : cuid, managed {
    header     : Association to ConfigurationHeader;
    Identifier : String;
    value      : String;
}

entity ConfigurationView as
    select from ConfigurationItem {
        key ID,
        header,
        header.purchasingOrg as Porg,
        header.IsActive      as IsActive,
        header.type          as Type,
        Identifier,
        value
    } group by header.purchasingOrg;

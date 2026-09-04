namespace com.siemens.ind.common;

using {
    cuid,
    managed
} from '@sap/cds/common';

entity BusinessPurposes :cuid, managed {
    BusinessPurpose : String;
    Description     : String;
    IsActive        : Boolean;
    
}
entity PurchasingDocumentTypeCode:cuid, managed {
    DocumentCategory : String;
    Description      : String;
    IsActive         : Boolean;

}
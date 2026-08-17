using ConfigService as service from '../../srv/configService';

annotate service.ConfigurationHeader with @(
    UI.FieldGroup #ConfigurationHeader: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'purchasingOrg',
                Value: purchasingOrg,
            },
            {
                $Type: 'UI.DataField',
                Label: 'IsActive',
                Value: IsActive,
            },
            {
                $Type: 'UI.DataField',
                Label: 'IsActive',
                Value: IsActive,
            }
        ],
    },
    UI.Facets                         : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#ConfigurationHeader',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Identifiers',
            ID    : 'Identifiers',
            Target: 'Items/@UI.LineItem#Items',
        },
    ],
    UI.LineItem                       : [
        {
            $Type: 'UI.DataField',
            Label: 'purchasingOrg',
            Value: purchasingOrg,
        },
        {
            $Type: 'UI.DataField',
            Label: 'IsActive',
            Value: IsActive,
        },
        {
            $Type: 'UI.DataField',
            Label: 'type',
            Value: type,
        },
    ],
    UI.SelectionFields                : [
        purchasingOrg,
        type,
        IsActive,
    ],
);

annotate service.ConfigurationView with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'Purchasing Org',
        Value: Porg,
    },
    {
        $Type: 'UI.DataField',
        Label: 'IsActive',
        Value: IsActive,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Type',
        Value: Type,
    },
]);

annotate service.ConfigurationView with @(UI.LineItem #Items: [
    {
        $Type: 'UI.DataField',
        Label: 'Identifier',
        Value: Identifier,
    },
    {
        $Type: 'UI.DataField',
        Label: 'value',
        Value: value,
    },
]);

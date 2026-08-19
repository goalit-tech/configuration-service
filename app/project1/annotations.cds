using ConfigService as service from '../../srv/configService';

annotate service.ConfigurationScope with @(
    UI.FieldGroup #ConfigurationHeader: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Company Code',
                Value: CompanyCode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Purchasing Org',
                Value: PurchasingOrg,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Plant',
                Value: Plant,
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
            Target: 'Identifiers/@UI.LineItem#Identifiers',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Approver Steps',
            ID    : 'ApproverSteps',
            Target: 'ApprovalStep/@UI.LineItem#ApproverSteps',
        },
    ],
    UI.LineItem                       : [
        {
            $Type: 'UI.DataField',
            Label: 'Company Code',
            Value: CompanyCode,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Purchasing Org',
            Value: PurchasingOrg,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Plant',
            Value: Plant,
        },
        {
            $Type: 'UI.DataField',
            Label: 'IsActive',
            Value: IsActive,
        }
    ],
    UI.SelectionFields                : [
        CompanyCode,
        PurchasingOrg,
        Plant,
        IsActive,
    ],
);

annotate service.Identifier with @(UI.LineItem #Identifiers: [
    {
        $Type: 'UI.DataField',
        Label: 'Identifier',
        Value: Identifier,
    },
    {
        $Type: 'UI.DataField',
        Label: 'value',
        Value: Value,
    },
    {
        $Type: 'UI.DataField',
        Label: 'IsActive',
        Value: IsActive,
    },
]);

annotate service.ApprovalStep with @(
    UI.LineItem #ApproverSteps       : [
        {
            $Type: 'UI.DataField',
            Label: 'Step',
            Value: Step,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Sequence',
            Value: Sequence,
        },
        {
            $Type: 'UI.DataField',
            Label: 'IsActive',
            Value: IsActive,
        },


    ],
    UI.FieldGroup #ApproverStepHeader: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Step',
                Value: Step,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Sequence',
                Value: Sequence,
            },
            {
                $Type: 'UI.DataField',
                Label: 'IsActive',
                Value: IsActive,
            },
        ],
    },
    UI.Facets                        : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ApprovalStepGeneralInformation',
            Label : 'General Information',
            Target: '@UI.FieldGroup#ApproverStepHeader',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Approvers',
            ID    : 'ApproverMembers',
            Target: 'Approvers/@UI.LineItem#ApproverMembers',
        },
    ]
);

annotate service.ApproverGroupMember with @(UI.LineItem #ApproverMembers: [
    {
        $Type: 'UI.DataField',
        Label: 'GID',
        Value: GID,
    },
    {
        $Type: 'UI.DataField',
        Label: 'IsActive',
        Value: IsActive,
    },
], );

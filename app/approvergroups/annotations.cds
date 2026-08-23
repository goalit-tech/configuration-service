using ConfigService as service from '../../srv/configService';

annotate service.ApproverGroup with @(
    UI.SelectionFields                        : [GroupName],
    UI.FieldGroup #GeneratedGroup             : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'GroupName',
                Value: GroupName,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Description',
                Value: Description,
            },
            {
                $Type: 'UI.DataField',
                Label: 'IsActive',
                Value: IsActive,
            },
        ],
    },
    UI.Facets                                 : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AssignedApprovers',
            Label : 'Assigned Approvers',
            Target: 'Members/@UI.LineItem',
        },
    ],
    UI.LineItem                               : [
        {
            $Type: 'UI.DataField',
            Label: 'GroupName',
            Value: GroupName,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Description',
            Value: Description,
        },
        {
            $Type: 'UI.DataField',
            Label: 'IsActive',
            Value: IsActive,
        },
    ],
    UI.SelectionPresentationVariant #tableView: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [

            ],
        },
        Text               : 'Approver Groups',
    },
);

annotate service.ApproverGroupMember with @(
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Label: 'Approver GID',
            Value: Approver_GID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email',
            Value: Approver.email,
        },
    ],
);

annotate service.Approver with @(
    UI.SelectionFields                        : [GID],
    UI.LineItem #tableView                    : [
        {
            $Type: 'UI.DataField',
            Label: 'Gid',
            Value: GID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email',
            Value: email,
        },
    ],
    UI.SelectionPresentationVariant #tableView: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [],
        },
        Text               : 'Approver',
    },
);

// annotate service.ApproverGroupView with @(
//     UI.SelectionFields                        : [GroupName],
//     UI.LineItem                               : [
//         {
//             $Type: 'UI.DataField',
//             Label: 'GroupName',
//             Value: GroupName,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Description',
//             Value: Description,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'IsActive',
//             Value: IsActive,
//         },
//     ],
//     UI.SelectionPresentationVariant #tableView: {
//         $Type              : 'UI.SelectionPresentationVariantType',
//         PresentationVariant: {
//             $Type         : 'UI.PresentationVariantType',
//             Visualizations: ['@UI.LineItem'],
//         },
//         SelectionVariant   : {
//             $Type        : 'UI.SelectionVariantType',
//             SelectOptions: [],
//         },
//         Text               : 'Approver Groups',
//     },
// );

// annotate service.ApproverView with @(
//     UI.SelectionFields                        : [GID],
//     UI.LineItem                               : [
//         {
//             $Type: 'UI.DataField',
//             Label: 'GID',
//             Value: GID,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Email',
//             Value: email,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'IsActive',
//             Value: IsActive,
//         },
//     ],
//     UI.SelectionPresentationVariant #tableView: {
//         $Type              : 'UI.SelectionPresentationVariantType',
//         PresentationVariant: {
//             $Type         : 'UI.PresentationVariantType',
//             Visualizations: ['@UI.LineItem'],
//         },
//         SelectionVariant   : {
//             $Type        : 'UI.SelectionVariantType',
//             SelectOptions: [],
//         },
//         Text               : 'Approvers',
//     },
// );

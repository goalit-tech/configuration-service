using ApproverAndGroupService as service from '../../srv/srv-configurationScope/approverAndGroup';

annotate service.ApproverGroup with @(
    UI.HeaderInfo                             : {
        TypeName      : 'Approver Group',
        TypeNamePlural: 'Approver Groups',
        Title         : {
            $Type: 'UI.DataField',
            Value: GroupName,
        },
    },
    UI.SelectionFields                        : [
        GroupName,
        Members.Approver.GID
    ],
    UI.FieldGroup #ApproverGroupGeneral       : {
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
            ID    : 'ApproverGroupGenreralFacet',
            Label : 'General Information',
            Target: '@UI.FieldGroup#ApproverGroupGeneral',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AssignedApproversFacet',
            Label : 'Assigned Approvers',
            Target: 'Members/@UI.LineItem#ApproverMemberLineItem',
        },
    ],
    UI.LineItem #ApproverGroupLineItem        : [
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
    UI.SelectionPresentationVariant #TableView: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#ApproverGroupLineItem'],
        },
        SelectOptions      : [],
        Text               : 'Approver Group'
    }
);

annotate service.ApproverGroup with @() {
    GroupName @(
        Common.Label: 'Group Name',
        mandatory   : true
    );
    IsActive  @(
        Common.Label: 'Is Active',
        default     : true
    )

}


annotate service.Approver with @(
    UI.HeaderInfo                             : {
        TypeName      : 'Approver',
        TypeNamePlural: 'Approvers',
        Title         : {
            $Type: 'UI.DataField',
            Value: GID,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: Email,
        },
    },
    UI.SelectionFields                        : [GID],
    UI.FieldGroup #ApproverFiledGroup         : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'GID',
                Value: GID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Email',
                Value: Email,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Notification Enabled',
                Value: IsNotificationEnabled,
            },
            {
                $Type: 'UI.DataField',
                Label: 'IsActive',
                Value: IsActive,
            },
        ],
    },
    UI.Facets                                 : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet1',
        Label : 'General Information',
        Target: '@UI.FieldGroup#ApproverFiledGroup',
    }, ],
    UI.LineItem #ApproverLineItem             : [
        {
            $Type: 'UI.DataField',
            Label: 'GID',
            Value: GID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email',
            Value: Email,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Notification Enabled',
            Value: IsNotificationEnabled,
        },
        {
            $Type: 'UI.DataField',
            Label: 'IsActive',
            Value: IsActive,
        },
    ],
    UI.SelectionPresentationVariant #TableView: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#ApproverLineItem',
            ],
        },
        Text               : 'Approver',
    }
);

annotate service.ApproverGroupMember with @(Common.SideEffects #ApproverChanged: {
    $Type           : 'Common.SideEffectsType',
    SourceProperties: [Approver_ID],
    TargetEntities  : [Approver],
    TargetProperties: [
        Approver,
        Email,
        IsActive,
        IsNotificationEnabled,
        IsApproverLocked,
        IsApproverLockedState,
        Approver.Email,
        Approver.IsNotificationEnabled,
        Approver.IsActive,
    ],
});

annotate service.ApproverGroupMember with {
    IsApproverLocked      @UI.Hidden          : true;
    IsApproverLockedState @UI.Hidden          : true;
    Email                 @Common.FieldControl: IsApproverLockedState;
    IsNotificationEnabled @Common.FieldControl: IsApproverLockedState;
    IsActive              @Common.FieldControl: IsApproverLockedState;
}

annotate service.Approver with {
    GID @(
        Common.Label                   : 'Approver GID',
        Common.Text                    : (GID),
        Common.Text.@UI.TextArrangement: #TextOnly,
    );
};

annotate service.ApproverGroupMember with {
    Approver @(Common: {
        Text                    : Approver.GID,
        TextArrangement         : #TextOnly,
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Approver',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Approver_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'GID',
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: Email,
                    ValueListProperty: 'Email',
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: IsNotificationEnabled,
                    ValueListProperty: 'IsNotificationEnabled',
                }
            ],
            Label         : 'Approver',
        },
        ValueListWithFixedValues: false,
    });
};

annotate service.ApproverGroupMember with @(UI.LineItem #ApproverMemberLineItem : [
    {
        $Type: 'UI.DataField',
        Label: 'Approver GID',
        Value: Approver_ID,
    },
    {
        $Type                  : 'UI.DataField',
        Label                  : 'Approver Email',
        Value                  : Email,
        ![@Common.FieldControl]: IsApproverLockedState
    },
    {
        $Type                : 'UI.DataField',
        Label                : 'Notification Enabled',
        Value                : IsNotificationEnabled,
        @Common.FieldControl : (IsApproverLocked ? #ReadOnly : #Optional)
    },
    {
        $Type                : 'UI.DataField',
        Label                : 'IsActive',
        Value                : IsActive,
        @Common.FieldControl : (IsApproverLocked ? #ReadOnly : #Optional)
    },
]);

annotate service.ApproverGroupMember with @Common: {SideEffects #ApproverGIDIsSelected: {
    SourceProperties: ['Approver_ID'],
    TargetProperties: [
        'Email',
        'IsNotificationEnabled',
        'IsActive',
        'IsApproverLocked',
        'IsApproverLockedState'
    ],
}, }

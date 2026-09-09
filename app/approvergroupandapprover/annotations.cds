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

annotate service.ApproverGroup with {
    ID        @UI.Hidden: true;
    GroupName @(
        Common.Label                   : 'Group Name',
        mandatory                      : true,
        assert.format                  : '^[a-zA-Z0-9_]+$',
        assert.format.message          : 'Group Name must be alphanumeric, underscores are allowed',
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'ApproverGroup',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: GroupName,
                    ValueListProperty: 'GroupName',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Description',
                }
            ],
            Label         : 'Group Name',
        },
        Common.ValueListWithFixedValues: false,
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
        IsApproverGidSelectedState,
        Approver.Email,
        Approver.IsNotificationEnabled,
        Approver.IsActive,
    ],
});

annotate service.ApproverGroupMember with {
    // IsApproverLocked      @UI.Hidden          : true;
    IsApproverGidSelectedState @UI.Hidden          : true;
    Email                      @(
        Common.FieldControl  : IsApproverGidSelectedState,
        assert.format        : '^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$',
        assert.format.message: 'Enter a valid email'
    );
    IsNotificationEnabled      @Common.FieldControl: IsApproverGidSelectedState;
    IsActive                   @Common.FieldControl: IsApproverGidSelectedState;
}

annotate service.Approver with {
    ID    @UI.Hidden: true;
    GID   @(
        Common.Label                   : 'Approver GID',
        // Common.Text                    : (GID),
        // Common.Text.@UI.TextArrangement: #TextOnly,
        assert.format                  : '^[Zz][a-zA-Z0-9]+$',
        assert.format.message          : 'GID must start with Z and contain only alphanumeric characters',
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Approver',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: GID,
                    ValueListProperty: 'GID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Email',
                },
            ],
            Label         : 'Approver',
        },
        Common.ValueListWithFixedValues: false,
    );
    Email @(
        assert.format        : '^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$',
        assert.format.message: 'Enter a valid email'
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

annotate service.ApproverGroupMember with @(UI.LineItem #ApproverMemberLineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'Approver GID',
        Value: Approver_ID,
    },
    {
        $Type                  : 'UI.DataField',
        Label                  : 'Approver Email',
        Value                  : Email,
        ![@Common.FieldControl]: IsApproverGidSelectedState
    },
    {
        $Type                  : 'UI.DataField',
        Label                  : 'Notification Enabled',
        Value                  : IsNotificationEnabled,
        ![@Common.FieldControl]: IsApproverGidSelectedState
    },
    {
        $Type                  : 'UI.DataField',
        Label                  : 'IsActive',
        Value                  : IsActive,
        ![@Common.FieldControl]: IsApproverGidSelectedState
    },
]);

annotate service.ApproverGroupMember with @Common: {SideEffects #ApproverGIDIsSelected: {
    SourceProperties: ['Approver_ID'],
    TargetProperties: [
        'Email',
        'IsNotificationEnabled',
        'IsActive',
        'IsApproverGidSelectedState'
    ],
}, };

annotate service.ApproverGroupOverview with {
    Approver_ID      @UI.Hidden: true;
    ApproverGroup_ID @UI.Hidden: true;
    ID               @UI.Hidden: true;
}

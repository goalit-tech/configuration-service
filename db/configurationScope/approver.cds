namespace com.siemens.ind.configurationscope.approverAndGroup;

using {
    cuid,
    managed
} from '@sap/cds/common';

@assert.unique: {
    UniqueGID  : [GID],
    UniqueEmail: [Email]
}


entity Approver : cuid, managed {
    GID                   : String;
    Email                 : String;
    IsNotificationEnabled : Boolean default true;
    IsActive              : Boolean default true;
}

/** Master data: a named, reusable group of approvers. */
@assert.unique: {UniqueGroups: [GroupName]}
entity ApproverGroup : cuid, managed {
    GroupName   : String @mandatory;
    Description : String;
    IsActive    : Boolean default true;
    Members     : Composition of many ApproverGroupMember
                      on Members.ApproverGroup = $self;
}

/** Thin link: which Approver belongs to which ApproverGroup. */
@assert.unique: {
    UniqueApproverInGroup: [
        ApproverGroup,
        Approver
    ],
    UniqueEmailInGroup   : [
        ApproverGroup,
        Email
    ]
}
type FieldControlState : String enum {
    Optional = '#Optional';
    ReadOnly = '#ReadOnly';
}

entity ApproverGroupMember : cuid, managed {
    ApproverGroup                 : Association to ApproverGroup;
    Approver                      : Association to Approver;
    Email                         : String;
    IsNotificationEnabled         : Boolean default false;
    IsActive                      : Boolean default true;
    virtual IsApproverLocked      : Boolean;
    virtual IsApproverLockedState : Integer default 3;
}

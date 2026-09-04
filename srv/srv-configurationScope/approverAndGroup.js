import cds from '@sap/cds';


class ApproverAndGroups extends cds.ApplicationService {
    async init() {
        this.FIELD_CONTROL = { ReadOnly: 1, Optional: 3, Mandatory: 7 };
        const { Approver, ApproverGroup, ApproverGroupMember } = this.entities;
        this.Approver = Approver;
        this.ApproverGroup = ApproverGroup;
        this.ApproverGroupMember = ApproverGroupMember;
        this.ApproverGroupMemberDrafts = ApproverGroupMember?.drafts;
        this.LOCKED_MEMBER_FIELDS = ['Email', 'IsNotificationEnabled', 'IsActive'];

        this._registerForBeforeNew();
        this._registerForBeforeCreate();
        this._registerForBeforeUpdate();
        this._registerForBeforePatch();
        this._registerForBeforeRead();
        this._registerForAfterRead();
        return super.init();
    }
    _registerForBeforeNew() {
        if (this.Approver?.drafts) {
            this.before('NEW', this.Approver.drafts, async (req) => {
                this.setDraftDefaults(req);
            });
        }

        if (this.ApproverGroup?.drafts) {
            this.before('NEW', this.ApproverGroup.drafts, async (req) => {
                this.setDraftDefaults(req);
            });
        }
    };
    _registerForBeforeCreate() {
        this.before('CREATE', this.ApproverGroupMember, async (req) => {
            await this.syncApproverDetails(req);
            await this.validateUniqueMemberInGroup(req);
            // await this.rejectLockedMemberEdits(req);
        });
      
    }
    _registerForBeforeUpdate() {
        this.before('UPDATE', this.ApproverGroupMember, async (req) => {
            await this.syncApproverDetails(req);
            await this.validateUniqueMemberInGroup(req);
            await this.rejectLockedMemberEdits(req);
        });
    }
    _registerForBeforePatch() {
        if (!this.ApproverGroupMemberDrafts) {
            return;
        }

        this.before('PATCH', this.ApproverGroupMemberDrafts, async (req) => {
            await this.rejectLockedMemberEdits(req);
            await this.syncApproverDetails(req);
            await this.validateUniqueMemberInGroup(req);
            await this.syncMemberLockState(req);
        });
    }
    _registerForBeforeRead() {
        this.before('READ', this.ApproverGroupMember, async (req) => {
            this.ensureMemberLockStateColumns(req);
        });

        if (this.ApproverGroupMemberDrafts) {
            this.before('READ', this.ApproverGroupMemberDrafts, async (req) => {
                this.ensureMemberLockStateColumns(req);
            });
        }
    }
    _registerForAfterRead() {
        this.after('READ', this.ApproverGroupMember, async (data) => {
            await this.syncMemberLockState(data);
        });

        if (this.ApproverGroupMemberDrafts) {
            this.after('READ', this.ApproverGroupMemberDrafts, async (data) => {
                await this.syncMemberLockState(data);
            });
        }
    }
    async syncApproverDetails(req) {
        if (!req.data.Approver_ID) {
            return;
        }

        const approver = await SELECT.one
            .from(this.Approver)
            .columns('Email', 'IsNotificationEnabled', 'IsActive')
            .where({ ID: req.data.Approver_ID });

        if (!approver) {
            req.reject(400, 'Selected approver was not found.');
            return;
        }

        req.data.Email = approver.Email;
        req.data.IsNotificationEnabled = approver.IsNotificationEnabled;
        req.data.IsActive = approver.IsActive;
        req.data.IsApproverLocked = true;
        req.data.IsApproverLockedState = this.FIELD_CONTROL.ReadOnly;
    };
    async validateUniqueMemberInGroup(req) {
        const persistedMember = await this.getPersistedMember(req);
        const member = { ...persistedMember, ...req.data };

        if (!member.ApproverGroup_ID) {
            return;
        }

        const memberTarget = this.getMemberQueryTarget(req);

        if (member.Approver_ID) {
            const duplicateApprover = await SELECT.one.from(memberTarget).columns('ID').where({
                ApproverGroup_ID: member.ApproverGroup_ID,
                Approver_ID: member.Approver_ID,
            });

            if (duplicateApprover && duplicateApprover.ID !== member.ID) {
                req.reject(409, 'Selected approver already exists in this approver group.');
                return;
            }
        }

        if (!member.Email) {
            return;
        }

        const duplicateEmail = await SELECT.one.from(memberTarget).columns('ID').where({
            ApproverGroup_ID: member.ApproverGroup_ID,
            Email: member.Email,
        });

        if (duplicateEmail && duplicateEmail.ID !== member.ID) {
            req.reject(409, 'This email already exists in this approver group.');
        }
    };
    async rejectLockedMemberEdits(req) {
        if (!req.data?.ID || Object.prototype.hasOwnProperty.call(req.data, 'Approver_ID')) {
            return;
        }

        const currentMember = await SELECT.one
            .from(this.getMemberQueryTarget(req))
            .columns('Approver_ID')
            .where({ ID: req.data.ID });

        if (!currentMember?.Approver_ID) {
            return;
        }

        const touchedLockedField = this.LOCKED_MEMBER_FIELDS.some((field) =>
            Object.prototype.hasOwnProperty.call(req.data, field)
        );

        if (touchedLockedField) {
            req.reject(
                400,
                'Email, Notification Enabled, and Active are managed by the selected approver and cannot be edited on an existing member row.'
            );
        }
    };
    async syncMemberLockState(data) {
        if (!data) {
            return;
        }

        const applyLockState = (row) => {
            if (!row) {
                return;
            }

            row.IsApproverLocked = !!row.Approver_ID;
            row.IsApproverLockedState = row.Approver_ID ? this.FIELD_CONTROL.ReadOnly : this.FIELD_CONTROL.Optional;
        };

        Array.isArray(data) ? data.forEach(applyLockState) : applyLockState(data);
    };
    ensureMemberLockStateColumns(req) {
        const columns = req.query?.SELECT?.columns;

        if (!Array.isArray(columns)) {
            return;
        }

        const hasColumn = (name) =>
            columns.some((col) => col === '*' || (col?.ref?.length === 1 && col.ref[0] === name));

        if (!hasColumn('Approver_ID')) {
            columns.push({ ref: ['Approver_ID'] });
        }

        if (!hasColumn('IsApproverLocked')) {
            columns.push({ ref: ['IsApproverLocked'] });
        }

        if (!hasColumn('IsApproverLockedState')) {
            columns.push({ ref: ['IsApproverLockedState'] });
        }
    };
    async getPersistedMember(req) {
        if (!req.data?.ID) {
            return null;
        }

        return SELECT.one
            .from(this.getMemberQueryTarget(req))
            .columns('ID', 'ApproverGroup_ID', 'Approver_ID', 'Email')
            .where({ ID: req.data.ID });
    };

    getMemberQueryTarget(req) {
        if (req.target?.name?.endsWith('.drafts') && this.ApproverGroupMemberDrafts) {
            return this.ApproverGroupMemberDrafts;
        }

        return this.ApproverGroupMember;
    };
    setDraftDefaults(req) {
        req.data.IsActive ??= true;
    };

}
export default ApproverAndGroups;

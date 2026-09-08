import cds from "@sap/cds";

class ApproverAndGroups extends cds.ApplicationService {
  async init() {
    this.FIELD_CONTROL = { ReadOnly: 1, Optional: 3, Mandatory: 7 };
    const { Approver, ApproverGroup, ApproverGroupMember } = this.entities;
    
    this.after("READ", ApproverGroupMember, async (data) => {
      await this.syncMemberLockState(data);
    });
    this.after("READ", ApproverGroupMember?.drafts, async (data) => {
      await this.syncMemberLockState(data);
    });
    this.before("NEW", Approver.drafts, async (req) => {
      this.setDraftDefaults(req);
    });
    this.before("NEW", ApproverGroup.drafts, async (req) => {
      this.setDraftDefaults(req);
    });
    return super.init();
  }
  async syncMemberLockState(data) {
    if (!data) {
      return;
    }

    const applyLockState = (row) => {
      if (!row) {
        return;
      }

      const isLocked = !!(row.Approver_ID || row.Approver?.GID);
      // row.IsApproverLocked = isLocked;
      row.IsApproverLockedState = isLocked
        ? this.FIELD_CONTROL.ReadOnly
        : this.FIELD_CONTROL.Optional;
    };

    Array.isArray(data) ? data.forEach(applyLockState) : applyLockState(data);
  }
  setDraftDefaults(req) {
    req.data.IsActive ??= true;
  }
}
export default ApproverAndGroups;

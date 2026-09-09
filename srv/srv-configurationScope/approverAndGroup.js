import cds from "@sap/cds";

class ApproverAndGroups extends cds.ApplicationService {
  async init() {
    this.FIELD_CONTROL = { ReadOnly: 1, Optional: 3, Mandatory: 7 };
    const { Approver, ApproverGroup, ApproverGroupMember } = this.entities;

    this.after("READ", ApproverGroupMember, async (data) => {
      await this.updateApproverGIDSelectionState(data);
    });
    this.after("READ", ApproverGroupMember?.drafts, async (data) => {
      await this.updateApproverGIDSelectionState(data);
      // await this.updateApproverGroupMemberField(data);
    });
    this.before("PATCH", ApproverGroupMember?.drafts, async (req) => {
      await this.resetApproverGroupMemberFields(req);
    });
    this.before("NEW", Approver.drafts, async (req) => {
      this.setDraftDefaults(req);
    });
    this.before("NEW", ApproverGroup.drafts, async (req) => {
      this.setDraftDefaults(req);
    });
    return super.init();
  }
  async updateApproverGIDSelectionState(data) {
    const rows = [data].flat().filter(Boolean);
    rows.forEach((row) => {
      row.IsApproverGidSelectedState =
        row.Approver_ID || row.Approver?.GID
          ? this.FIELD_CONTROL.ReadOnly
          : this.FIELD_CONTROL.Optional;
    });
  }
  setDraftDefaults(req) {
    req.data.IsActive ??= true;
  }
  async resetApproverGroupMemberFields(req) {
    // clear dependent fields when the selected approver is removed from the row
    const approverCleared =
      ("Approver_ID" in req.data && !req.data.Approver_ID) ||
      ("Approver" in req.data && !req.data.Approver);
    if (approverCleared) {
      req.data.Email = null;
      req.data.IsNotificationEnabled = false;
      req.data.IsActive = true;
    }
  }
  // async updateApproverGroupMemberField(req) {
  //   console.log(req)
  // }
}
export default ApproverAndGroups;

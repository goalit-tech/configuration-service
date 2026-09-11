import cds from "@sap/cds";

const { SELECT, UPDATE } = cds.ql;

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
      await this.validateUniqueEmailInGroup(req);
    });
    this.before("CREATE", ApproverGroupMember?.drafts, async (req) => {
      await this.validateUniqueEmailInGroup(req);
    });
    this.before("NEW", Approver.drafts, async (req) => {
      this.setDraftDefaults(req);
    });
    this.before("NEW", ApproverGroup.drafts, async (req) => {
      this.setDraftDefaults(req);
    });
    this.before(["CREATE", "PATCH"], Approver.drafts, async (req) => {
      await this.validateUniqueApproverFields(req);
    });
    this.before(["CREATE", "PATCH"], ApproverGroup.drafts, async (req) => {
      await this.validateUniqueApproverGroupFields(req);
    });
    this.before("DELETE", Approver, async (req) => {
      await this.validateApproverNotInUse(req);
    });
    this.after("SAVE", Approver, async (data, req) => {
      await this.syncApproverGroupMemberActiveState(req?.data);
      await this.syncApproverGroupMemberNotificationState(req?.data);
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
  async validateUniqueApproverGroupFields(req) {
    const groupName = req.data.GroupName?.trim();
    if (!groupName) return;
    const { ApproverGroup } = this.entities;
    const rowID = req.data.ID ?? req.params?.at(-1)?.ID;
    const siblings = [
      ...(await SELECT.from(ApproverGroup.drafts)),
      ...(await SELECT.from(ApproverGroup)),
    ];
    if (groupName) {
      const isDuplicategroupName = siblings.some(
        (row) =>
          row.ID !== rowID &&
          row.GroupName?.trim().toLowerCase() === groupName.toLowerCase(),
      );
      if (isDuplicategroupName) {
        req.error(
          400,
          `groupName "${groupName}" is already added, please add another group name.`,
          "in/GroupName",
        );
      }
    }
  }
  async validateUniqueApproverFields(req) {
    const gid = req.data.GID?.trim();
    const email = req.data.Email?.trim();
    if (!gid && !email) return;

    const { Approver } = this.entities;
    const rowID = req.data.ID ?? req.params?.at(-1)?.ID;

    const siblings = [
      ...(await SELECT.from(Approver.drafts)),
      ...(await SELECT.from(Approver)),
    ];

    if (gid) {
      const isDuplicateGID = siblings.some(
        (row) =>
          row.ID !== rowID &&
          row.GID?.trim().toLowerCase() === gid.toLowerCase(),
      );
      if (isDuplicateGID) {
        req.error(
          400,
          `GID "${gid}" is already added, please add another GID.`,
          "in/GID",
        );
      }
    }
    if (email) {
      const isDuplicateEmail = siblings.some(
        (row) =>
          row.ID !== rowID &&
          row.Email?.trim().toLowerCase() === email.toLowerCase(),
      );
      if (isDuplicateEmail) {
        req.error(
          400,
          `Email "${email}" is already added, please add another Email.`,
          "in/Email",
        );
      }
    }
  }
  async validateApproverNotInUse(req) {
    const approverID = req.data.ID ?? req.params?.at(-1)?.ID;
    if (!approverID) return;

    const { ApproverGroupMember } = this.entities;

    const isUsed =
      (await SELECT.one
        .from(ApproverGroupMember)
        .where({ Approver_ID: approverID })) ??
      (await SELECT.one
        .from(ApproverGroupMember.drafts)
        .where({ Approver_ID: approverID }));

    if (isUsed) {
      req.error(
        400,
        `This approver is already used by an Approver Group Member and cannot be deleted.`,
      );
    }
  }
  async syncApproverGroupMemberActiveState(data) {
    const rows = [data].flat().filter(Boolean);
    const { ApproverGroupMember } = this.entities;

    for (const row of rows) {
      if (row.ID == null || row.IsActive == null) continue;

      await UPDATE(ApproverGroupMember)
        .set({ IsActive: row.IsActive })
        .where({ Approver_ID: row.ID });
      await UPDATE(ApproverGroupMember.drafts)
        .set({ IsActive: row.IsActive })
        .where({ Approver_ID: row.ID });
    }
  }
  async syncApproverGroupMemberNotificationState(data) {
    const rows = [data].flat().filter(Boolean);
    const { ApproverGroupMember } = this.entities;

    for (const row of rows) {
      if (row.ID == null || row.IsNotificationEnabled == null) continue;

      await UPDATE(ApproverGroupMember)
        .set({ IsNotificationEnabled: row.IsNotificationEnabled })
        .where({ Approver_ID: row.ID });
      await UPDATE(ApproverGroupMember.drafts)
        .set({ IsNotificationEnabled: row.IsNotificationEnabled })
        .where({ Approver_ID: row.ID });
    }
  }
  async validateUniqueEmailInGroup(req) {
    const email = req.data.Email?.trim();
    if (!email) return;

    const { ApproverGroupMember } = this.entities;
    const rowID = req.data.ID ?? req.params?.at(-1)?.ID;

    let approverGroupID = req.data.ApproverGroup_ID;
    if (!approverGroupID && rowID) {
      const existing =
        (await SELECT.one
          .from(ApproverGroupMember.drafts)
          .where({ ID: rowID })) ??
        (await SELECT.one.from(ApproverGroupMember).where({ ID: rowID }));
      approverGroupID = existing?.ApproverGroup_ID;
    }
    if (!approverGroupID) return;

    const siblings = [
      ...(await SELECT.from(ApproverGroupMember.drafts).where({
        ApproverGroup_ID: approverGroupID,
      })),
      ...(await SELECT.from(ApproverGroupMember).where({
        ApproverGroup_ID: approverGroupID,
      })),
    ];
    const isDuplicate = siblings.some(
      (row) =>
        row.ID !== rowID &&
        row.Email?.trim().toLowerCase() === email.toLowerCase(),
    );

    if (isDuplicate) {
      req.error(
        400,
        `Email "${email}" is already used by another member in this group.`,
        "in/Email",
      );
    }
  }
}
export default ApproverAndGroups;

import cds from '@sap/cds';
import XLSX from 'xlsx';

// ---------------------------------------------------------------------------
// Service class
// ---------------------------------------------------------------------------
class ConfigService extends cds.ApplicationService {
    async init() {
        const app = cds.app;

        // -----------------------------------------------------------------
        // Custom download endpoints – bypass OData, read flat CDS views
        // -----------------------------------------------------------------

        app.get('/download/identifiers', async (_req, res) => {
            try {
                const db     = await cds.connect.to('db');
                const entity = cds.model.definitions['ConfigService.IdentifierDownloadView'];
                const data   = await db.run(SELECT.from(entity));

                const ws = XLSX.utils.json_to_sheet(data);
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, 'Identifiers');
                const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });

                res.set('Content-Type',
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                res.set('Content-Disposition',
                    'attachment; filename="identifiers.xlsx"');
                res.end(buffer);
            } catch (err) {
                res.status(500).json({ error: err.message });
            }
        });

        app.get('/download/approvalsteps', async (_req, res) => {
            try {
                const db     = await cds.connect.to('db');
                const entity = cds.model.definitions['ConfigService.ApprovalStepDownloadView'];
                const data   = await db.run(SELECT.from(entity));

                const ws = XLSX.utils.json_to_sheet(data);
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, 'ApprovalSteps');
                const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });

                res.set('Content-Type',
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                res.set('Content-Disposition',
                    'attachment; filename="approvalsteps.xlsx"');
                res.end(buffer);
            } catch (err) {
                res.status(500).json({ error: err.message });
            }
        });

        // -----------------------------------------------------------------
        // CAP actions – download flat views as Excel workbooks
        // -----------------------------------------------------------------

        this.on('downloadIdentifiers', async (req) => {
            const db     = await cds.connect.to('db');
            const entity = cds.model.definitions['ConfigService.IdentifierDownloadView'];
            const data   = await db.run(SELECT.from(entity));

            const ws = XLSX.utils.json_to_sheet(data);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, 'Identifiers');
            const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });

            const res = req._.res;
            res.set('Content-Type',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            res.set('Content-Disposition',
                'attachment; filename="identifiers.xlsx"');
            res.end(buffer);
        });

        this.on('downloadApprovalSteps', async (req) => {
            const db     = await cds.connect.to('db');
            const entity = cds.model.definitions['ConfigService.ApprovalStepDownloadView'];
            const data   = await db.run(SELECT.from(entity));

            const ws = XLSX.utils.json_to_sheet(data);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, 'ApprovalSteps');
            const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });

            const res = req._.res;
            res.set('Content-Type',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            res.set('Content-Disposition',
                'attachment; filename="approvalsteps.xlsx"');
            res.end(buffer);
        });

        return super.init();
    }
}

export default { ConfigService };
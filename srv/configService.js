import cds from '@sap/cds';
import XLSX from 'xlsx';

// ---------------------------------------------------------------------------
// Custom download endpoints – bypass OData, read the flat CDS views directly
// ---------------------------------------------------------------------------
cds.on('bootstrap', (app) => {

    /**
     * GET /download/identifiers
     * Reads IdentifierDownloadView and streams an xlsx workbook.
     */
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

    /**
     * GET /download/approvalsteps
     * Reads ApprovalStepDownloadView and streams an xlsx workbook.
     */
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
});

// ---------------------------------------------------------------------------
// Service class
// ---------------------------------------------------------------------------
class ConfigService extends cds.ApplicationService {
    async init() {
        // this.on('READ', 'ConfigurationScope', async (req) => {
        //     // Implement your custom logic here
        //     console.log('READ ConfigurationScope request received:', req);
        // });
        // this.after('READ', 'ConfigurationScope', async (data, req) => {
        //     // Implement your custom logic here
        //     console.log('After READ ConfigurationScope request data:', data);
        //     console.log('After READ ConfigurationScope request:', req);
        // });
        return super.init();
    }
}

export default { ConfigService };
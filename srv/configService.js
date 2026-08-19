import cds from '@sap/cds';

class ConfigService extends cds.ApplicationService {
     async init() {
        this.on('READ', 'ConfigurationScope', async (req) => {
            // Implement your custom logic here
            console.log('READ ConfigurationScope request received:', req);
        });
        this.after('READ', 'ConfigurationScope', async (data,req) => {
            // Implement your custom logic here
            console.log('After READ ConfigurationScope request data:', data);
            console.log('After READ ConfigurationScope request:', req);
        });

     }

}

export default { ConfigService };
service SpreadsheetService {
    @cds.persistence.skip
    entity Spreadsheet {
        key entity  : String;

            content : LargeBinary @Core.MediaType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
}

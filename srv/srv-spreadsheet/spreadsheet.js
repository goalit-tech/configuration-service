const cds = global.cds || require("@sap/cds");
import sheetutils from "./lib/sheetutils.js";
import { utils, write } from "xlsx";
import { Readable } from "stream";
//const XLSX = require('xlsx');
//const SheetHandler = require('./utils/SheetHandler');
//const Parser = require('./utils/Parser');
//const { PassThrough } = require('stream');

export default class SpreadsheetService extends cds.ApplicationService {
  init() {
    const { Spreadsheet } = this.entities;
    this.on("READ", Spreadsheet, async (req) => {
      // Create a sample worksheet
      const requestEntity = req.params[0].entity;
      const entity = this.resolveEntity(requestEntity);
      entity || req.error(500, `Entity '${requestEntity}' not found`);
      var columns = await sheetutils.getEntityFields(entity);
      var columnArray = [];
      Object.keys(columns).forEach((column, index) => {
        columnArray.push(columns[column]);
      });
      var worksheet = utils.aoa_to_sheet([columnArray]);
      const workbook = utils.book_new();

      utils.book_append_sheet(workbook, worksheet, requestEntity);
      const buffer = write(workbook, { type: "buffer", bookType: "xlsx" });
      var stream = new Readable();
      stream.push(buffer);
      stream.push(null);

      req.res.setHeader(
        "Content-Type",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      );
      req.res.setHeader(
        "Content-Disposition",
        `attachment; filename=${requestEntity}.xlsx`,
      );
      return {
        value: stream,
      };
    });

    this.on("UPDATE", Spreadsheet, async (req) => {
      const contentType = req.headers && req.headers["content-type"];
      console.log(contentType);
      const requestEntity = req.params[0].entity;
      console.log(`Request received with content type:,${contentType}`);
      console.log(`Entity:${requestEntity}`);
      const entity = this.resolveEntity(requestEntity);
      entity || req.error(500, `Entity '${requestEntity}' not found`);

      let content = req.data.content;

      //parse the spreadsheet data into json
      let sheetData = {};
      try {
        sheetData = await sheetutils.parseSheet(content);
        if (Object.keys(sheetData.headers).length === 0) {
          req.error(500, `Spreadsheet does not have any column!`);
        }
      } catch (error) {
        req.error(500, `Failed to process data: ${error.message}`);
      }

      //compare the columns of the spreadsheet with the entity
      try {
        console.log("Comparing columns...");
        await sheetutils.compareColumns(entity, sheetData);
        console.log("Columns matched successfully");
        //insert the data into the entity
        console.log(`Sheet header: ${JSON.stringify(sheetData.headers)}`);
        console.log(`Sheet data: ${JSON.stringify(sheetData.data)}`);
        if (sheetData.data.length > 0) {
          console.log(
            `Inserting ${sheetData.data.length} rows into ${entity.name}`,
          );
          const result = await cds.db.run(
            INSERT(sheetData.data).into(entity.name),
          );
          //TODO Check result for inserted entities. In case of ENTITY_ALREADY_EXISTS error,
          //report the rows that were not inserted.
          //Currently it throws error and does not perform partial insert.
          //UPSERT may be used instead but it should return the rows that are not inserted.
          console.log("Import completed successfully");
          //req.error(204, `${sheetData.data.length} records uploaded successfully!`);
          req.info({
            code: "000",
            message: `${sheetData.data.length} records uploaded successfully!`,
            target: "",
            status: 200,
          });
        } else {
          req.warn(204, `No data found in the spreadsheet to insert!`);
        }
      } catch (error) {
        req.error(500, `Failed to insert data: ${error.message}`);
      }
    });
    return super.init();
  }

  // cds.entities() only keys entities by their fully-qualified name, so also
  // match by the short/local name (e.g. 'ApproverGroupOverview') as passed by clients
  resolveEntity(name) {
    // let entityFound = cds.entities()[name];
    // if (entityFound) {
    //   return entityFound;
    // } else {
    const defs = cds.model.definitions;
    return (
      defs[name] ??
      Object.values(defs).find(
        (d) => d.kind === "entity" && d.name.endsWith(`.${name}`),
      )
    );
    // }
  }
}

import { read } from "xlsx";

export default class sheetutils {
  static getEntityFields = async (entity) => {
    let entityFields = [];
    Object.keys(entity.elements).forEach((element) => {
      const entityField = entity.elements[element];
      if (entityField["@readonly"]) return;
      if (entityField.type === "cds.Association") return;
      if (entityField.key) return;
      if (element.includes('_ID')) return;
      entityFields.push(element);
    });
    return entityFields;
  };
  static compareColumns = async (entity, sheetData) => {
    let entityFields = await sheetutils.getEntityFields(entity);
    /*
    Object.keys(entity.elements).forEach((element) => {
      const entityField = entity.elements[element];
      if (entityField['@readonly']) return;
      if (entityField.type === 'cds.Association') return; 
      entityFields.push(element);
      //console.log(`${element} - ${entityField.type} - ${entityField['@readonly']}`);
    });
    */
    Object.keys(sheetData.headers).forEach((header, index) => {
      if (sheetData.headers[header] !== entityFields[index]) {
        throw Error(
          `Header '${sheetData.headers[header]}' does not match entity field '${entityFields[index]}'`,
        );
      }
    });
    return true;
  };
  static parseSheet = async (content) => {
    console.log("Parsing the sheet...");
    const chunks = [];

    await new Promise((resolve, reject) => {
      content.on("data", (chunk) => {
        chunks.push(chunk);
      });

      content.on("end", () => {
        resolve();
      });

      content.on("error", (err) => {
        console.error("Error reading content stream:", err);
        reject(err);
      });
    });
    const contentBuffer = Buffer.concat(chunks);
    const spreadSheet = read(contentBuffer, {
      type: "buffer",
      cellNF: true,
      cellDates: true,
      cellText: true,
      cellFormula: true,
    });
    (spreadSheet &&
      spreadSheet.SheetNames &&
      spreadSheet.SheetNames.length > 0) ||
      req.error(400, `Error reading the Spreadsheet!`);
    console.log(`Received ${spreadSheet.SheetNames.length} sheets!`);
    if (spreadSheet.SheetNames.length > 1) {
      console.log(`Processing the first sheet only!`);
    }
    const sheet = spreadSheet.Sheets[spreadSheet.SheetNames[0]];

    var headers = {};
    var data = [];
    for (const z in sheet) {
      if (z[0] === "!") continue;
      //parse out the column, row, and value
      var col = z.substring(0, 1);
      var row = parseInt(z.substring(1));
      var value = sheet[z].v;

      //store header names
      if (row == 1) {
        headers[col] = value;
        continue;
      }

      if (!data[row]) data[row] = {};
      data[row][headers[col]] = value;
    }
    //drop those first two rows which are empty
    data.shift();
    data.shift();
    return {
      headers: headers,
      data: data,
    };
  };
};

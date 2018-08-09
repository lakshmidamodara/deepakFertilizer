const PythonShell = require('python-shell');
//var PE = require('./process_excel/');
const fs = require('fs');

const options = {
    mode: 'text',
    pythonPath: 'D:/anaconda3/python.exe',
    scriptPath: 'd:/anaconda3/kumar/cct/'
};

/**/
var pyshell = new PythonShell('df_text_reader.py', options);
pyshell.on('message', function (message) {
    // received a message sent from the Python script (a simple "print" statement)
    console.log(message);
  });
/**/
//debugger;
var data = fs.readFileSync('df_baseline.xer','utf8',(err, contents)=>{
    console.log(contents);
   });
//PE.processExcel(data);
pyshell.send(data)
//Lakshmi TODO: needs to return parsing error codes
/*
separate error codes for the following conditions:
1) Invalid JSON
2) Unexpected field value
3) Database field validation error (length is too long)
4) Business rule failure (adding an existing activity)
5) Unknown error type
Also please provide location of the error (line number in the input file or row in spreadsheet)
*/

  // end the input stream and allow the process to exit
pyshell.end(function (err,code,signal) {
  if (err) {
   console.log(err);
   throw err;
   }
   console.log('The exit code was: ' + code);
   console.log('The exit signal was: ' + signal);
   console.log('finished');
   console.log('finished');
 });


/* View the structure of a given JSON file */
const cmdl=require('./utils');
const path=require('path');

if (cmdl.args()==0) {
  console.log('Usage: viewjson filename');
  process.exit(1);
}

const obj=require(path.resolve(cmdl.arg(1)));
cmdl.inspect(obj);

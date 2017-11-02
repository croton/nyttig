/* View the structure of a given JSON file */
var cmdl=require('./utils');

if (cmdl.args()==0) {
  console.log('Usage: viewjson filename');
  process.exit(1);
}

var fn=cmdl.arg(1);
var obj=require(fn);
cmdl.inspect(obj);

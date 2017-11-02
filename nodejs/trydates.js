// trydates
var cmdl=require('./utils');

if (cmdl.args()==0 || cmdl.arg(1)==='-?') {
  console.log('Usage: trydates datestring');
  process.exit(1);
}

var fmt=cmdl.arg(1);

try {
  var d = new Date(fmt);
  console.log('Create date with format '+fmt);
  console.log(' year  -> '+d.getFullYear());
  console.log(' month -> '+d.getMonth());
  console.log(' date  -> '+d.getDate());
  console.log(' ISO   -> '+d.toISOString());
} catch (e) {
  console.log('Ooops! '+e.message)
}

var lastxmas = new Date(new Date().getFullYear()-1, 11, 25);
console.log('Create date as Xmas last year');
console.log(' year  -> '+lastxmas.getFullYear());
console.log(' month -> '+lastxmas.getMonth());
console.log(' date  -> '+lastxmas.getDate());
console.log(' ISO   -> '+lastxmas.toISOString());


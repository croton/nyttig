/* utils - a package of general functions. */
const path=require('path');
const fs = require('fs');

function args() { return process.argv.length-2; }
function arg(i) {
  if (i<0 || i>=process.argv.length-1) return '';
  return process.argv[i+1];
}
function argsf() { return process.argv.length; }
function argf(i) {
  // include arg 1 as running script
  if (i<0 || i>=process.argv.length) return '';
  return process.argv[i];
}

function survey(obj) {
  if (obj instanceof Array) {
    for (var i=0, len=obj.length; i<len || i<3; i++) { console.log(' '+obj[i]); }
  } else if (obj instanceof Object) {
    var ctr=0
    for (var key in obj) {
      ctr++;
      console.log(' '+ctr+') '+key+'='+obj[key]);
    } // loop over obj
    if (ctr==0) console.log(' '+obj);
  } else {
    console.log(' '+obj);
  } // NOT an array OR object
}

function inspect(obj, level) {
  if (!level) {
    console.log(Array.isArray(obj)?'Array of '+obj.length:'Object');
    var level=1;
  }
  var indent=this.copies(' ',level);
  var chd=null;
  if (Array.isArray(obj)) {
    for (var i=0, len=obj.length; i<len; i++) {
      chd=obj[i];
      console.log(indent+i+'] '+valueDescription(chd));
      if (chd instanceof Object) this.inspect(chd,level+1);
    }
  } else if (obj instanceof Object) {
    var ctr=0
    for (var key in obj) {
      ctr++;
      chd=obj[key];
      console.log(indent+key+'='+valueDescription(chd));
      if (chd instanceof Object) this.inspect(chd,level+1);
    } // loop over obj
    if (ctr==0) console.log(indent+'empty '+obj);
  } else {
    console.log(indent+obj);
  } // NOT an array OR object
}

function valueDescription(obj) {
  if (Array.isArray(obj)) return 'Array of '+obj.length;
  else if (obj instanceof Object) return 'Object';
  else return obj;
}

function copies(str, idx) {
  if (!idx || idx>100) return str;
  var newstr='';
  for (var i=1; i<=idx; i=i+1) { newstr=newstr+str; }
  return newstr;
}

function word(str, index) {
  if (!str) return '';
  var parts = str.split(' ');
  if (parts.length==0) return '';
  for (var i=0, len=parts.length; i<len; i++) {
    if (i==(index-1)) return parts[i];
  }
  return '';
}

function save(filename, data, noLineBreaks = false) {
  const strData = (noLineBreaks ? JSON.stringify(data) : JSON.stringify(data, null, 2));
  fs.writeFile(filename, strData, 'utf8', function (err) {
    if (err) {
      console.log('An error occured while writing JSON Object to File.');
      return console.log(err);
    }
    console.log(`JSON file has been saved: ${filename}`);
  });
}

function o2s(obj) { return JSON.stringify(obj, null, 2); }

module.exports = {
  arg: arg,
  args: args,
  argf: argf,
  argsf: argsf,
  survey: survey,
  inspect: inspect,
  copies: copies,
  word: word,
  save: save,
  o2s: o2s
};
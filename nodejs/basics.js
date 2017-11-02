// basics
var cmdl=require('./utils');

if (cmdl.arg(1)=='-?') {
  console.log('Usage: basics ');
  process.exit(1);
}

var idx=cmdl.arg(1);
if (!(idx && !isNaN(idx))) idx=1;
console.log('You entered '+idx);

var xo = {name: 'trout'};
console.log('xo.name', xo.name);
console.log('xo["name"]', xo['name']);

console.log('xo.fish', xo.fish);
console.log('xo["fish"]?', (xo['fish'] ? 'a fish':'no fish property defined'));
console.log('xo.hasOwnProperty("fish")?', (xo.hasOwnProperty('fish') ? 'a fish':'no fish property defined'));

xo.fish = null;
console.log('xo.fish', xo.fish);
console.log('xo["fish"]?', (xo['fish'] ? 'a fish':'no fish property defined'));
console.log('xo.hasOwnProperty("fish")?', (xo.hasOwnProperty('fish') ? 'a fish':'no fish property defined'));

xo.fish = undefined;
console.log('xo.fish', xo.fish);
console.log('xo["fish"]?', (xo['fish'] ? 'a fish':'no fish property defined'));
console.log('xo.hasOwnProperty("fish")?', (xo.hasOwnProperty('fish') ? 'a fish':'no fish property defined'));

validateProperty(xo, 'squidget');
xo.squidget='';     // empty string
validateProperty(xo, 'squidget');
xo.squidget=' ';    // a single space
validateProperty(xo, 'squidget');
xo.squidget='   ';  // a string of 3 spaces
validateProperty(xo, 'squidget');

var mySingleton = (function (obj) {
  var instance = obj;
  function getInstance() {
    if (!instance) instance={};
    return instance;
  }
  return { get: getInstance };
})(idx);

xo.fish={id:'golden trout'};
var myarr = ['20', 10, xo.fish];
for (var i=1; i<=3; i=i+1) {
  myarr.push(mySingleton.get());
}
console.log('Len array', myarr.length);
console.log('Element '+idx, myarr[idx]);
console.log("Let's replace this item with today's date...");
myarr[idx]=new Date();

show(myarr);
console.log('xo.fish', xo.fish);
console.log('singleton', mySingleton.get());

/* ------------------------------- Functions -------------------------------- */
function show(arr) {
  var item;
  for (var i=0, len=myarr.length; i<len; i++) {
    item=myarr[i];
    console.log(' '+i+'->'+(item instanceof Object) ? JSON.stringify(item):item);
  }
}

function validateProperty(obj, prop) {
  var obj_string=JSON.stringify(obj);
  console.log('*** Does '+obj_string+' have property "'+prop+'"?', obj[prop], '***');
  console.log('obj["prop"]?', (obj[prop] ? 'Yes':'No property '+prop+' defined'));
  console.log('obj.hasOwnProperty("prop")?', (obj.hasOwnProperty(prop) ? 'Yes':'No property '+prop+' defined'));
}

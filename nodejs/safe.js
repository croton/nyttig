// safe
var cmdl=require('./utils');

if (cmdl.args()==0) {
  console.log('safe -- Safe access to properties of an object');
  console.log('Usage: safe propertyname [no-match-returns-string]');
  process.exit(1);
}

function safe(obj, prop, useString) {
  var sadpath = (useString ? '':null);
  if (!(obj && prop)) return sadpath;
  else if (!(prop in obj)) return sadpath;
  return obj[prop];
}

var myobj = {
  name: 'gijoe',
  missions: [
    'mow lawn',
    'play futbol',
    'haul trash',
  ],
  id: 7363
};
var myobj2 = null;
var prop=cmdl.arg(1);
console.log('You entered '+prop);

try {
  var testvals = [prop, '', ' ', 'blah', null, undefined, 0];
  var val=null;
  // Test properties against object
  console.log('Try properties on "myobj"');
  cmdl.inspect(myobj);
  for (var i=0, len=testvals.length; i<len; i++) {
    val=safe(myobj, testvals[i], cmdl.args()>1);
    console.log('  Value of property "'+testvals[i]+'": '+val);
    // if (!val) throw new Error('Oops no value?');
  }
  // Test properties against null object
  console.log('Try properties on null object');
  for (var i=0, len=testvals.length; i<len; i++) {
    val=safe(myobj2, testvals[i], cmdl.args()>1);
    console.log('  Value of property "'+testvals[i]+'": '+val);
  }
} catch (e) {
  console.log(e.message);
}

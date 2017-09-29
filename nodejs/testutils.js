var utils=require('./utils');

/* --------------------------- Test arg functions --------------------------- */
var jsonfile=utils.arg(1);
console.log('Arg 1 to this module is '+jsonfile);
console.log('Arg 2 to this module is '+utils.arg(2));
console.log('Arg 3 to this module is '+utils.arg(3));
console.log('Arg 4 to this module is '+utils.arg(4));
console.log('Argf 4 to this module is '+utils.argf(4));
console.log('Total from argsf(): '+utils.argsf());
console.log('Total from args(): '+utils.args());

/* ----------------------- Test survey() and inspect() -----------------------*/
console.log('survey() a date...');
utils.survey(new Date());

console.log('survey() a number...');
utils.survey(73);

console.log('survey() a string...');
utils.survey('73 owls');

var myobj={id:1, name:'Odonata', type:'Dragonfly', tags:['flying','insects','pond life'], pattern:{id:'zug bug', comp:'peacock herl'}};
var myarray=[17, 2.5, 'three', myobj, 100, 200, 300];

console.log('survey() myobj...');
utils.survey(myobj);

console.log('Inspect() myobj...');
utils.inspect(myobj);

console.log('survey myarray...');
utils.survey(myarray);

// Try inspecting an object from json
if (jsonfile!='') {
  try {
    var jso=require('./'+jsonfile);
    console.log('Inspect json by utils.inspect() on '+jsonfile);
    utils.inspect(jso);
    console.log('Inspect by console.dir()');
    console.dir(jso);
  }
  catch (e) { console.log('Oops! '+e.message); }
  // if (jso==null) console.log('Sorry invalid json file: '+jsonfile); else { }
}

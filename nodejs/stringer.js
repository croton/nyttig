// stringer
var cmdl=require('./utils');

if (cmdl.args()==0) {
  console.log('Usage: stringer ');
  process.exit(1);
}

// var fn=cmdl.arg(1);
// console.log('You entered '+fn);

console.log(stringer('A brand new string thing!').print());
var str = stringer('Args at init');
console.log('My stringer:', str.print());
str.add('blue xmas');
str.add('orange peels');
str.insert('Start here --> ');
str.add(' a back-swimmer is a bug');
console.log(str.print());
console.log(str.print(true));

// Use alternate short-cut syntax
var str2 = stringer('To further describe and annotate,').a('the likelihood of development').a('assistance adds explicit performance limits').p();
console.log(str2);

// Now clear a stringer and add new data
str.x().a('Start from scratch').a(175).a(new Date());
console.log('first stringer: ', str.p());

/* ----------- Functions ------------ */
function stringer(args) {
  var lines = [];
  if (args) lines.push(args);

  function print(nospace) {
    if (nospace) return lines.join('');
    else         return lines.join(' ');
  }
  function add(arg) { lines.push(arg); }
  function insert(arg) { lines.unshift(arg); }
  function a(arg) { lines.push(arg); return this; }
  function i(arg) { lines.unshift(arg); return this; }
  function clear(arg) { lines.length = 0; return this; }
  return {
    print: print,
    p: print,
    add: a,
    a: a,
    insert: i,
    i: i,
    clear: clear,
    x: clear
  };
}

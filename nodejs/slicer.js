// slicer
var cmdl=require('./utils');

if (cmdl.arg(1)==='-?') {
  console.log('slicer -- test the slice() function');
  console.log('Usage: slicer [start][len]');
  process.exit(1);
}

var insects = ['damselfly', 'dragonfly', 'mayfly', 'caddisflies', 'stoneflies', 'grasshoppers', 'crickets'];
insects.first = 0;
insects.last = insects.length-1;
cmdl.inspect(insects);
console.log('First, last='+[insects.first, insects.last]);

var idx=new Number(cmdl.arg(1));
var endidx=new Number(cmdl.arg(2));
console.log('Slicing '+[idx,endidx]);

try {
  var sliced = insects.slice(idx, endidx);
  console.log('New set: '+sliced);
}
catch (e) {
  console.log(e.message)
}


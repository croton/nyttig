// inherit
var cmdl=require('./utils');

if (cmdl.arg(1)=='-?') {
  console.log('Usage: inherit ');
  process.exit(1);
}

var index=cmdl.arg(1);
if (index==2) {
  experiment02();
} else if (index==3) {
  experiment03();
} else {
  experiment01();
}

/* -------------------------- Start of Experiments -------------------------- */
function experiment01() {
  function Person(name) {
    this.name=name;
  }

  Person.prototype.category='Resident';
  Person.prototype.greet=function() {
    console.log('Hi I am '+this.name+', defined in Person.prototype.greet->', this);
  }

  var booh = (function () {
    var name='Boo!';
    return {
      greet: function() {
        console.log('Our name is '+name);
      }
    };
  })();

  var johnny = new Person('Johnny Darter');
  console.log('Johnny is called '+johnny.name+' and is a '+typeof johnny);
  console.log('Johnny prototype->', johnny.prototype);
  console.log('Johnny constructor->', johnny.constructor);
  console.log('Johnny constructor prototype->', johnny.constructor.prototype);
  johnny.greet();
  booh.greet();
  console.log('Type of booh: '+(typeof booh));
  console.log('Prototype of booh.greet: ', booh.greet.prototype);
  booh.greet.prototype=Person.prototype;
  console.log('Prototype changed, of booh.greet: ', booh.greet.prototype);
  booh.greet.prototype=new Person();
  console.log('Prototype changed, of booh.greet: ', booh.greet.prototype);
  booh.greet();
  var oddity = new booh.greet('I am strange indeed, but not really');
  console.log('oddity has been created from booh.greet(), after it had its prototype altered:', oddity);
  console.log('oddity.category='+oddity.category);
  oddity.greet();
}

function experiment02() {
  var person = {type: 'person'};
  var alien = {type: 'alien'};
  var gordy = {};
  console.log('Type of person:', person.type);
  console.log('Type of alien:', alien.type);
  console.log('Type of gordy:', gordy.type);

  gordy.__proto__ = alien;
  console.log('Type of gordy, p=alien:', gordy.type);

  gordy.prototype = person;
  console.log('Type of gordy, p=person 1:', gordy.type);

  gordy.prototype = person.prototype;
  console.log('Type of gordy, p=person 2:', gordy.type);

  gordy.__proto__ = person;
  console.log('Type of gordy, p=person 3:', gordy.type);
}

function experiment03() {
  function mySuperClass(name) {
    var core = {
      createdOn: new Date(),
      greet: function() {
        console.log('Hi, my name is '+name);
      },
    };

    function confer(source) {
      for (var key in core) {
        if (!source.hasOwnProperty(key)) source[key]=core[key];
      }
      return source;
    }
    return { 'confer': confer };
  }

  var plain = (function (name) {
    return {
      toString: function() {
        return 'I am plain; my name is '+name;
      }
    };
  })('Zane');

  var plainAlso = (function (name) {
    return {
      greet: function() {
        console.log('Huah ka lua!');
      },
      toString: function() {
        return 'I am plain; my name is '+name;
      }
    };
  })('Jane');

  var plainToo = (function (name) {
    return {
      sneaky: function() {
        console.log('Aha!');
        this.greet();  // try calling greet(), not this.greet()
      },
      toString: function() {
        return 'I am plain; my name is '+name;
      }
    };
  })('Train');

  console.log('A plain object-> '+plain);
  if (plain.greet) {
    plain.greet();
  } else {
    console.log('Plain object has no greet function!');
  }
  console.log('A plain object-> '+plainAlso);
  if (plainAlso.greet) { plainAlso.greet(); }
  else { console.log('Plain object has no greet function!'); }
  console.log('A plain object-> '+plainToo);
  if (plainToo.greet) plainToo.greet();
  else console.log('Plain object has no greet function!');

  mySuperClass('plain no more').confer(plain);
  mySuperClass('duper').confer(plainAlso);
  mySuperClass('superDuper').confer(plainToo);

  console.log('Enhanced object created on '+plain.createdOn);
  console.log('json->'+JSON.stringify(plain));
  plain.greet();
  plainAlso.greet();
  plainToo.greet();
  plainToo.sneaky();

  function newGreet() {
    console.log('This is a new greet function!');
    // this.greet();
  }
  plainToo.greet=newGreet;
  plainToo.greet();
  plainToo.sneaky();

}

function experiment04() {
  function mySuperClass(name) {
    var core = {
      setName: function(n) {
        if (n) name=n;
      },
      greet: function() {
        console.log('Hi, my name is '+name);
      },
    };

    function confer(source) {
      for (var key in core) {
        if (!source.hasOwnProperty(key)) source[key]=core[key];
      }
      return source;
    }
    return { 'confer': confer };
  }

}

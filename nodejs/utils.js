module.exports=(function () {
  function valueDescription(obj) {
    if (Array.isArray(obj)) return 'Array of '+obj.length;
    else if (obj instanceof Object) return 'Object';
    else return obj;
  }

  return {
    argf:function(i) {
      // include arg 1 as running script
      if (i<0 || i>=process.argv.length) return '';
      return process.argv[i];
    },
    arg:function(i) {
      if (i<0 || i>=process.argv.length-1) return '';
      return process.argv[i+1];
    },
    argsf:function() { return process.argv.length; },
    args:function() { return process.argv.length-2; },
    // Inspect an object non-recursively
    survey:function(obj) {
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
    },
    // Inspect an object recursively
    inspect:function(obj,level) {
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
    },
    copies:function(str,idx) {
      if (!idx || idx>100) return str;
      var newstr='';
      for (var i=1; i<=idx; i=i+1) { newstr=newstr+str; }
      return newstr;
    },
    word: function(str,index) {
      if (!str) return '';
      var parts = str.split(' ');
      if (parts.length==0) return '';
      for (var i=0, len=parts.length; i<len; i++) {
        if (i==(index-1)) return parts[i];
      }
      return '';
    },
    leftword: function(str,index) {
      if (!str) return str;
      var parts = str.split(' ');
      if (parts.length<2) return str;
      if (index<1 || index>(parts.length+1)) return str;
      parts.splice(index);
      return parts.join(' ');
    },
    printr:function(obj) {
      if (Array.isArray(obj)) for (var i=0, len=obj.length; i<len; i++) console.log(i+') '+obj[i]);
      else console.log(obj);
    }
  };
})();

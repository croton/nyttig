-- create spy
spyOn(updateService, 'getUpdate').and.returnValue(someValue);

-- overwrite a spy
updateService.getUpdate = jasmine.createSpy().and.returnValue(etc)
or
updateService.getUpdate = jasmine.createSpy('notreal', function(){}).and.returnValue();
or
updateService.getUpdate.and.returnValue(yourNewRV);


 var deferred = $q.defer();
 deferred.resolve( data1 );

 var getUpdateSpy = spyOn(updateService, 'getUpdate').and.returnValue(deferred.promise);

 var newDeferred = $q.defer();
 newDeferred.resolve( data2 );

 getUpdateSpy.and.returnValue(newDeferred.promise);

/* ------- Refactor ------- */
function resolveResult(result) {
 var deferred = $q.defer();
 deferred.resolve(result);
 return deferred.promise;
}

var getUpdateSpy = spyOn(updateService, 'getUpdate').and.returnValue(resolveResult(data1));
getUpdateSpy.and.returnValue(resolveResult(data2));

/* -------------------------------- Promises -------------------------------- */
$q(resolver)
  example ...
  function resolve() { }
  function reject() { }
  var myPromise = $q(function(resolve, reject) {
    if (Ok) {
      resolve('My resolved result');
    } else {
      reject('The reason for this rejection');
    }
  });

  function myAsyncFunc(args) {
    return myPromise;
  }

  var myOtherPromise = myAsyncFunc('my arguments here');
  myOtherPromise.then(function(response) {
    console.log('Received response', response);
  }, function(error) {
    console.log('Failed; reason is', error);
  });

// Create a Deferred object which represents a task which will finish in the future
// Using $q.defer() is just another flavour, and the original implementation, of $q() as a Promise constructor.
var task2beDone = $q.defer();

var newPromise = myPromise.then(function(response) {
  return response;
}, function(reason) {
  return $q.reject(reason);
});


// Using $q.all()
function promiseX() {
  var deferred = $q.defer();
  ajaxCall.then(function(response) {
    deferred.resolve(response);
  }, function(error) {
    deferred.reject(error);
  });
  return deferred.promise;
}

var promises = {
 a: promiseA(),
 b: promiseB(),
 c: promiseC()
};

$q.all(promises).then(function(response) {
  console.log('from A', response.a);
  console.log('from B', response.b);
  complete();
});


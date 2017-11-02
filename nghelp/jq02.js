angular.module('jq02', []).directive('jq02Tag', [jq02Tag]);

function jq02Ctrl() {
  var ctrl = this;
  ctrl.$onInit = function() {
    ctrl.myTextValue = 'somesing';
    var src=document.getElementById(ctrl.dependsOn);
    console.log('Controller init: '+[ctrl.dependsOn, (src===null)]);
  };
  ctrl.greet = function () {
    console.log('jq02Ctrl says Hi!');
  };
  ctrl.qry = function() {
    var src=document.getElementById(ctrl.dependsOn);
    console.log('depends on '+ctrl.dependsOn);
  };
}

function jq02Tag() {
  return {
    restrict: 'E',
    scope: {},
    bindToController: {
      dependsOn: '<'
    },
    /*
    link: function(scope, element, attrs) {
      console.log('scope', scope);
      console.log('element', element);
      console.log('attrs', attrs);
      if ('dependsOn' in attrs) console.log('This element depends on '+attrs.dependsOn);
      var eventsource = angular.element('#'+attrs.dependsOn);
      if (eventsource) {
        console.log('Event source Ok');
        eventsource.on('change',  function(){
          console.log('I have changed. this=', this);
        });
      }
      else console.log('No element by id #'+attrs.dependsOn);
    },
    */
    controller: [jq02Ctrl],
    controllerAs: 'ctrl',
    template: '<h4>Why hello!</h4><button id="mybtn" ng-click="ctrl.qry()">Greeting</button'
  };
}

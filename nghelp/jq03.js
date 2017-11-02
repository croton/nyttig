angular.module('jq03', []).directive('cjp', [cjp]);

function jq03Ctrl() {
  var ctrl = this;
  ctrl.$onInit = function() {
    ctrl.field1value = 'somesing';
    ctrl.field2value = 'blah';
    console.log('Controller init!');
  };
  ctrl.qryBlank = function () {
    console.log('qryBlank: field1 '+ctrl.field1value);
    return (ctrl.field1value==='');
  };
  ctrl.qry = function() {
    console.log('qry: model values '+[ctrl.field1value, ctrl.field2value]);
  };
  ctrl.check = function() {
    if (ctrl.field1value==='') console.log('check: Blank value! Disable field2');
    else console.log('check: field1 is not blank OK!');
  };
}

function cjp() {
  return {
    restrict: 'E',
    scope: {},
    bindToController: {
      id: '<',
      dependsOn: '<'
    },
    controller: [jq03Ctrl],
    controllerAs: 'ctrl',
    template: '<input type="text" id="field1" ng-model="ctrl.field1value" >'+
              '<input type="text" id="field2" ng-model="ctrl.field2value" ng-disabled="ctrl.qryBlank()">'+
              '<button id="field3" ng-click="ctrl.qry()">Go</button>'
  };
}
// ng-change="ctrl.check()"

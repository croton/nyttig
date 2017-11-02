(function() {
  'use strict';

  angular.module('fooz', []).directive('foozComponent', [foozComponent]);

  function foozCtrl($attrs, $scope) {
    var ctrl = this;
    ctrl.other = $attrs.dependsOn;
    ctrl.disableChild = false;
    ctrl.$onInit = function() {
      console.log('fooz depends on '+ctrl.other);
      var child=document.getElementById('comp81');
      var primary=document.getElementById(ctrl.other);
      primary.onclick= function(){
        console.log('ctrl: Clicked on', this, ctrl.other);
      }
      primary.onchange= function(){
        console.log('ctrl: Changed', this.value);
      }
      primary.addEventListener('input', function(){
        var newvalue = this.value;
        console.log('Howdy a change!', this.value, newvalue, [(newvalue===''), ctrl.disableChild]);
        ctrl.setField(newvalue);
      });
      console.log('ctrl: linked comps', primary, child);
    };
    ctrl.qry = function() {
      console.log('ctrl.qry()');
    };
    ctrl.setField = function(somevalue) {
      $scope.$apply( function(){
        ctrl.disableChild=(somevalue==='');
        console.log('Disable child element?', ctrl.disableChild);
      });
    };
  }

  function foozComponent() {
    return {
      restrict: 'E',
      scope: {},
      bindToController: {
        id: '<',
        dependsOn: '<'
      },
      link: function(scope, element, attrs) {
        console.log('1st child', element.children()[0].id);
        var child=document.getElementById(element.children()[0].id);
        var primary=document.getElementById(attrs.dependsOn);
        primary.onclick=function(evt) { console.log('Primary clicked:', evt); };
        primary.onchange=function(evt) { console.log('Primary changed:', evt); };
        console.log('linked comps', primary, child);
        console.log('link() args', element, attrs);
      },
      controller: ['$attrs', '$scope', foozCtrl],
      controllerAs: 'ctrl',
      template: 'Dependant <input type"text" id="comp81" ng-disabled="ctrl.disableChild" /> {{ctrl.disableChild}}'
    };
  }
})();

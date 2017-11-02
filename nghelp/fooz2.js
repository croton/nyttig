(function() {
  'use strict';

  angular.module('fooz2', []).directive('fooz2Component', [fooz2Component]);

  function fooz2Ctrl($attrs, $scope) {
    var ctrl = this;
    var other = $attrs.dependsOn;
    ctrl.disableChild = false;
    ctrl.$onInit = function() {
      console.log('fooz2 depends on '+other);
      var child=document.getElementById('comp81');
      var primary=document.getElementById(other);
      primary.onclick= function(){
        console.log('ctrl: Clicked on', this, other);
      }
      primary.addEventListener('input', function(){
        // var newvalue = this.value;
        ctrl.setField(this.value);
      });
      // console.log('ctrl: linked comps', primary, child);
    };
    ctrl.setField = function(somevalue) {
      $scope.$apply( function(){
        ctrl.disableChild=(somevalue==='');
        console.log('Disable child element?', ctrl.disableChild);
      });
    };
  }

  function fooz2Component() {
    return {
      restrict: 'E',
      scope: {},
      bindToController: {
        id: '<',
        dependsOn: '<'
      },
      link: function(scope, element, attrs) {
        var child=document.getElementById(element.children()[0].id);
        var primary=document.getElementById(attrs.dependsOn);
        primary.onclick=function(evt) { console.log('Primary clicked:', evt); };
        primary.onchange=function(evt) { console.log('Primary changed:', evt); };
      },
      controller: ['$attrs', '$scope', fooz2Ctrl],
      controllerAs: 'ctrl',
      template: 'Dependant <input type"text" id="comp81" ng-disabled="ctrl.disableChild" /> {{ctrl.disableChild}}'
    };
  }
})();

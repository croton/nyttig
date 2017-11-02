(function() {
  'use strict';

  angular.module('fooz3', []).directive('fooz3Component', [fooz3Component]);

  function fooz3Ctrl() {
    var ctrl = this;
    ctrl.disableChild = false;
    ctrl.$onInit = function() {
      console.log('Hi');
      ctrl.disableWhenBlank('comp77', 'childComp');
    };

    ctrl.disableWhenBlank = function(primary, dependant) {
      var origin=document.getElementById(primary);
      var responder=document.getElementById(dependant);
      origin.addEventListener('input', function(){
        responder.disabled = (this.value==='');
        console.log(this.id+' enabling/disabling '+responder.id, responder.disabled);
      });

    };
  }

  function fooz3Component() {
    return {
      restrict: 'E',
      scope: {},
      link: function(scope, element, attrs) {
        var primary=document.getElementById(attrs.dependsOn);
        var child=document.getElementById(element.children()[0].id);
/*
        primary.addEventListener('input', function(){
          child.disabled = (this.value==='');
          console.log(this.id+' enabling/disabling '+child.id, child.disabled);
        });
*/
      },
      controller: [fooz3Ctrl],
      controllerAs: 'ctrl',
      template: 'Dependant <input type"text" id="childComp" /> {{ctrl.disableChild}}'
    };
  }
})();

angular.module('jq01', []).
/*
controller('jq01Controller', function jq01Controller() {
  var ctrl = this;
  ctrl.greet = function () { console.log('jq01Controller says HI!'); };
})
*/
directive('cjpSimple', function() {
  var linkfn = function(scope, element, attrs) {
    var animateRight = function() {
      angular.element(this).animate({left:'+=50'});
    };
    var animateDown = function() {
      angular.element(this).animate({top:'+=50'});
    };
    angular.element('#one').on('click', animateDown);
    angular.element('#two').on('click', animateRight);
  };

  return {
    restrict: 'E',
    // link: linkfn
    transclude: true,
    template: '<h4>Howdy this cjpSimple, or cjp-simple tag</h4><div ng-transclude></div>'
  };
});
;

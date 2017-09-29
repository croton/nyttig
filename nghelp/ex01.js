angular.module('ex1', []).controller('ex1Controller', function ex1Controller() {
  var ctrl = this;
  ctrl.tabdata = [
    {id:1, name:'Tricorythodes', type:'Crawler'},
    {id:2, name:'Potamanthus', type:'Burrower'},
    {id:3, name:'Paraleptophlebia', type:'Pronggilled'},
    {id:4, name:'Baetis', type:'Armored'},
    {id:5, name:'Caenis', type:'Squaregilled'},
    {id:6, name:'Ephemerella', type:'Crawler'},
    {id:7, name:'Drunella', type:'Crawler'},
    {id:8, name:'Ephemera', type:'Burrower'},
    {id:9, name:'Hexagenia', type:'Burrower'},
    {id:10, name:'Epeorus', type:'Flathead'},
    {id:11, name:'Siphlonurus', type:'Minnowlike'},
    {id:12, name:'Stenonema', type:'Flathead'},
    {id:13, name:'Cloeon', type:'Minnowlike'},
    {id:14, name:'Isonychia', type:'Swimmer'},
    {id:15, name:'Heptagenia', type:'Flathead'}
  ];
  ctrl.greet = function () {
    console.log('ex1Controller says Hi at '+new Date());
  };
})
.directive('simpleStatic', function() {
  return {
    restrict: 'E',
    template: '<h3><i>simpleStatic: A simple directive!</i></h3>'
  };
})
.directive('simpleSub', function() {
  return {
    restrict: 'E',
    transclude: true,
    template: '<h3>simpleSub</h3><p>This text is part of the template</p><p ng-transclude></p>'
  };
})
.directive('subTwo', function() {
  return {
    restrict: 'E',
    transclude: {
      myCustom: '?myCustom'
    },
    template: '<h3>subTwo</h3><p>The following are the directives used thus far:</p><div ng-transclude="myCustom"></div>'
  };
})
.directive('multiSub', function() {
  return {
    restrict: 'E',
    transclude: {
      myHead: '?myHead',
      myBody: '?myBody',
      myFoot: '?myFoot'
    },
    template: '<h3>multiSub</h3><h4 ng-transclude="myHead"></h4><p ng-transclude="myBody">' +
              '</p><hr/><p ng-transclude="myFoot"></p>'
  };
})
.directive('attrReader', function() {
  return {
    restrict: 'E',
    bindToController: {
      fooz: '@'
    },
    controller: function() {},
    controllerAs: 'ctrl',
    template: '<p>Value of attribute fooz: {{ctrl.fooz}}</p>'

  };
})
// Alternate implementation of attribute-reading directive
.directive('readerTwo', function() {
  return {
    restrict: 'E',
    scope: {},
    link: function(scope, elem, attrs) {
      scope.fooz=attrs.fooz;
    },
    template: '<p>Value of attribute fooz: <i>{{fooz}}</i></p>'
  };
});

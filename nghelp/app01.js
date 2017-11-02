var app=angular.module('app01',[]);
app.controller('SimpleController', function ($scope){
  $scope.fish=[ 
    {name:'brook trout', genus:'Salvelinus'},
    {name:'arctic char', genus:'Salvelinus'},
    {name:'rainbow trout', genus:'Onchorhyncus'},
    {name:'northern pike', genus:'Esox'},
    {name:'bluegill', genus:'Lepomis'}
  ];
}
);

var app = angular.module('myApp', ['ngCookies']);
app.controller('SignupCtrl', function($scope, $http, $cookies) {
  $scope.showContent = 'loading';
  $scope.showAuth = true;
  $scope.arrayFirst = "";
  $scope.arraySecond = "";
  $scope.analyseResult = [];
  function primaryAuth(){
    $http.post('/sign_in', { user: { primary: 'true'}}).then(function(response){
      $scope.showContent = response.data.hadAuth == true ? 'content' : 'signup';
    });
  };
  primaryAuth();
  $scope.signUp = function(){
    $scope.errors = '';
    if ($scope.user != null){
      $http.post('/users', { user: { email: $scope.user.email, password: $scope.user.password } }).
      then(callbackSignFunction);
    }
    else{
      $scope.errors = 'All fields must be filled';
    }
  };
  $scope.signIn = function(){
    $scope.errors = '';
    if ($scope.user != null){
      $http.post('/sign_in', { user: { email: $scope.user.email, password: $scope.user.password } }).
      then(callbackSignFunction);
    }
    else{
      $scope.errors = 'All fields must be filled';
    }
  };
  $scope.signOut = function(){
    $scope.errors = '';
    $http.delete('/users', { user: { token: $cookies.get('token')}}).then(callbackSignOutFunction);
  };
  $scope.toggleSign = function(){
    $scope.showAuth = !$scope.showAuth;
    if($scope.showAuth){
      $scope.showContent = 'signup';
    }
    else{
      $scope.showContent = 'signin'
    }
  };
  $scope.calculateBasic = function(){
    $http.post('/calculate', {dataset: {set1: stringToArray($scope.arrayFirst)}}).then(callbackAnalyseFunction)
  }
  $scope.calculateCorellation = function(){
    $http.post('/correlate', {dataset: {set1: stringToArray($scope.arrayFirst), set2: stringToArray($scope.arraySecond)}}).then(callbackAnalyseFunction)
  }
  function stringToArray(str){
    return str.split(",");
  }
  function callbackAnalyseFunction(response) {
    if (response.status == 200){
      $scope.analyseResult = response.data.answer;
    }else{
      $scope.errors = response.data.errors + " - " + response.status;
    }
  }
  function callbackSignFunction(response) {
    if (response.data.id != 0) {
      $scope.showContent = 'content';
    } else {
      $scope.errors = response.data.errors;
    }
    $scope.user.email = '';
    $scope.user.password = '';
  };
  function callbackSignOutFunction(response){
    if(response.status == 200){
      $scope.showContent = 'signin';
    };
  };
});

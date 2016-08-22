var app = angular.module('myApp', ['ngCookies']);
app.controller('SignupCtrl', function($scope, $http, $cookies) {
  $scope.showContent = 'loading';
  $scope.showAuth = true;
  $scope.isBasic = true;
  $scope.arrayFirst = "";
  $scope.arraySecond = "";
  $scope.analyseResult = [];
  $scope.errors = [];

  function primaryAuth(){
    $http.put('/sign_in_primary', { user: { primary: 'true'}}).then(function(response){
      $scope.showContent = response.data.hadAuth == true ? 'content' : 'signup';
    });
  };

  primaryAuth();

  $scope.signUp = function(){
    $scope.errors.login = '';
    if ($scope.user != null){
      $http.post('/users', { user: { email: $scope.user.email, password: $scope.user.password } }).
      then(successCallbackSignFunction, errorCallbackSignFunction);
    }
    else{
      $scope.errors.login = 'All fields must be filled';
    }
  };

  $scope.signIn = function(){
    $scope.errors.login = '';
    $scope.errors.correlation = '';
    if ($scope.user != null){
      $http.put('/sign_in', { user: { email: $scope.user.email, password: $scope.user.password } }).
      then(successCallbackSignFunction, errorCallbackSignFunction );
    }
    else{
      $scope.errors.login = 'All fields must be filled';
    }
  };

  $scope.signOut = function(){
    $scope.errors.login = '';
    $http.delete('/users', { user: { token: $cookies.get('token')}}).then(successCallbackSignOutFunction);
  };

  $scope.calculateBasic = function(){
    $scope.errors.analysis = '';
    $http.post('/calculate', {dataset: {set1: stringToArray($scope.arrayFirst)}})
    .then(successCallbackAnalyseFunction, errorCallbackAnalyseFunction)
  };

  $scope.calculateCorellation = function(){
    $http.post('/correlate', {dataset: {set1: stringToArray($scope.arrayFirst), set2: stringToArray($scope.arraySecond)}})
    .then(successCallbackAnalyseFunction, errorCallbackAnalyseFunction)
  };

  function stringToArray(str){
    return str.split(",");
  };

  $scope.showAuthTab = function(){
    return $scope.showContent == 'signup' || $scope.showContent == 'signin'
  }

  

  $scope.toggleSign = function(){
    $scope.showAuth = !$scope.showAuth;
    if($scope.showAuth){
      $scope.showContent = 'signup';
    }
    else{
      $scope.showContent = 'signin'
    }
  };

  $scope.toggleOperation = function(){
    $scope.isBasic = !$scope.isBasic;
  };

  function successCallbackSignFunction(response){
    $scope.showContent = 'content';
    $scope.user.email = '';
    $scope.user.password = '';
  };

  function errorCallbackSignFunction(response){
    $scope.errors.login = response.data.error;
  }

  function successCallbackSignOutFunction(response){
    $scope.showContent = 'signin';
  };

  function successCallbackAnalyseFunction(response){
    $scope.analyseResult = response.data.answer;
  };

  function errorCallbackAnalyseFunction(response){
    $scope.errors.analysis = response.data.error;
    $scope.errors.correlation = response.data.error;
  };
});

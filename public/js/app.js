var app = angular.module('myApp', ['ngCookies']);
app.controller('SignupCtrl', function($scope, $http, $cookies) {
  $scope.showContent = 'signup';
  $scope.showAuth = true;
  function primaryAuth(){
    $http.post('/sign_in', { user: { primary: 'true'}}).then(function(response){
      $scope.showContent = response.data.hadAuth == true ? 'content' : 'signup';
    });
  };
  primaryAuth();
  $scope.signUp = function(){
    $scope.errors = '';
    if ($scope.newUser != null){
      $http.post('/users', { user: { email: $scope.newUser.email, password: $scope.newUser.password } }).
      then(callbackAddFunction);
    }
    else{
      $scope.errors = 'All fields must be filled';
    }
  };
  $scope.signIn = function(){
    $scope.errors = '';
    if ($scope.user != null){
      $http.post('/sign_in', { user: { email: $scope.user.email, password: $scope.user.password } }).
      then(callbackSignInFunction);
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
  function callbackAddFunction(response) {
    if (response.data.id != 0) {
      $scope.showContent = 'content';
    } else {
      $scope.errors = response.data.errors;
    }
    $scope.newUser.email = '';
    $scope.newUser.password = '';
  };
  function callbackSignInFunction(response) {
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

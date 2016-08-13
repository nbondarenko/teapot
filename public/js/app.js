var app = angular.module('myApp', []);
app.controller('SignupCtrl', function($scope, $http) {
  $scope.showContent = false;
  $scope.showAuth = true;
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
      then(callbackAddFunction);
    }
    else{
      $scope.errors = 'All fields must be filled';
    }
  };
  $scope.toggleSign = function(){
    $scope.showAuth = !$scope.showAuth;
  };
  function callbackAddFunction(response) {
    if (response.data.id != 0) {
      $scope.showContent = true;
    } else {
      $scope.errors = response.data.errors;
    }
    $scope.user.email = '';
    $scope.user.password = '';
  };
});

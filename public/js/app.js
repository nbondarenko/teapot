var app = angular.module('myApp', []);
app.controller('SignupCtrl', function($scope, $http) {
  $scope.showContent = false
  $scope.signUp = function(){
    $scope.errors = '';
    $http.post('/users', { user: { email: $scope.newUser.email, password: $scope.newUser.password } }).
    then(callbackAddFunction);
  }
  function callbackAddFunction(response) {
    if (response.data.id != 0) {
      $scope.showContent = true;
    } else {
      $scope.errors = response.data.errors;
    }
    $scope.newUser.email = '';
    $scope.newUser.password = '';
  };
});

var app = angular.module('myApp', []);
var query  =  "SELECT a.ticker,a.comp_name,sector,industry FROM tickermaster a, report b where b.report_flag = 'SSR' and b.ticker_id = a.ticker_id order by val desc";
app.controller('customersCtrl', function($scope, $http) {
   alert($scope.value);
   $scope.myFunc = function() {
   $http.get("http://www.tickerlick.com:8081/getticker?q="+query)
   .success(function (data,status,headers,config) {$scope.names = data;});
   }
});

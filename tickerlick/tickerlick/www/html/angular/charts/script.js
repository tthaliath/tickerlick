google.load('visualization', '1', {
  packages: ['corechart']
});

google.setOnLoadCallback(function() {
  angular.bootstrap(document.body, ['MyApp']);
});

angular.module('MyApp', ['ui.bootstrap']).
  controller('MyCtrl1', ['$scope','$http',
    function($scope,$http) {
      $http.get('../wp-content/themes/ang/json.php').success(function(data
) {
        var data1 = new google.visualization.DataTable();
        data1.addColumn('string', 'year/mon');
        data1.addColumn('number', 'avarage');
        for(i = 0 ; i < data.length;i++) {
          var ym = data[i]["updateday"].substr(0,4) + "/" + data[i]["updateday"]
.substr(5,2);
          data1.addRow([ym, parseFloat(data[i]["sum(price)\/count(price)"])]);
        };
        var options = {
          'title':'Sample Title',
          'height':300
        };
        var chart = new google.visualization.LineChart(document.getElementById('
chart_div1'));
        var formatter = new google.visualization.NumberFormat(
          {fractionDigits: 2}
        );
        formatter.format(data1, 1);
        chart.draw(data1, options);
      });
    }
  ]);

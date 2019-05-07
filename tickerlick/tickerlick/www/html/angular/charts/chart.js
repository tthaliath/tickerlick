google.load('visualization', '1', {
  packages: ['corechart']
});

google.setOnLoadCallback(function() {
  angular.bootstrap(document.body, ['MyApp']);
});

angular.module('MyApp', ['ui.bootstrap']).
  controller('MyCtrl1', ['$scope','$http',
    function($scope,$http) {
      alert('dddddddd');
      $http.get('http://www.tickerlick.com:8081/getticker?q=1').success(function(data
) {
        var data1 = new google.visualization.DataTable();
        data1.addColumn('number', 'Price');
        data1.addColumn('number', 'dma_200');
        data1.addColumn('number', 'dma_50');
        data1.addColumn('number', 'dma_10');
        for(i = 0 ; i < data.length;i++) {
          var rtq = data[i]["rtq"];
          var dma_200 = data[i]["dma_200"]; 
          var dma_50 = data[i]["dma_50"];
          var dma_10 = data[i]["dma_10"];
          data1.addRow([rtq,dma_200,dma_50,dma_10]);
        };
        var options = {
        chart: {
          title: 'AAPL MACD Intra Day',
          subtitle: 'in millions of dollars (USD)'
        },
        width: 900,
        height: 500,
        axes: {
          x: {
            0: {side: 'top'}
          }
        }
      };
        var chart = new google.visualization.LineChart(document.getElementById('chart_div1'));
        var formatter = new google.visualization.NumberFormat(
          {fractionDigits: 2}
        );
        formatter.format(data1, 1);
        chart.draw(data1, options);
        alert('dddddddd');
      });
    }
  ]);

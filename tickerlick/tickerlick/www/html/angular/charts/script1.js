google.load('visualization', '1', {
  packages: ['corechart']
});

google.setOnLoadCallback(function() {
  angular.bootstrap(document.body, ['MyApp']);
});

angular.module('MyApp', ['ui.bootstrap']).
  controller('MyCtrl1', ['$scope',
    function($scope) {
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Topping');
      data.addColumn('number', 'Slices');
      data.addRows([
        ['Mushrooms', 3],
        ['Onions', 1],
        ['Olives', 1],
        ['Zucchini', 1],
        ['Pepperoni', 2]
      ]);
      var options = {'title':'How Much Pizza I Ate Last Night',
                 'width':400,
                 'height':300};
      var chart = new google.visualization.PieChart(document.getElementById('chart_div1'));
      chart.draw(data, options);
    }
  ]);

google.load('visualization', '1', {
  packages: ['corechart']
});

google.setOnLoadCallback(function() {
  angular.bootstrap(document.body, ['demoGraph']);
});

var app = angular.module('demoGraph', []);
var controller = app.controller('graphCtrl', graphController);

function graphController($scope) {
    var data = google.visualization.arrayToDataTable([
      ['Color', 'Wavelength (nm)'],
      ['Violet', 450],
      ['Blue', 495],
      ['Green', 570],
      ['Yellow', 590],
      ['Orange', 620],
      ['Red', 750]
    ]);

    var view = new google.visualization.DataView(data);
    var options = {
      title: 'Visible spectrum wavelength',
      width: 600,
      height: 400,
      bar: { groupWidth: '95%' },
      legend: { position: 'none' },
      hAxis: { title: 'Color' },
      vAxis: { title: 'Wavelength (nm)' }
    };

    var chart = new google.visualization.ColumnChart(document.getElementById('spectrum'));
    chart.draw(view, options);
}

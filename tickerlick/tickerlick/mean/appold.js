require('./api/data/db.js');
var express = require('express');
var app = express();
var path = require('path');
var bodyParser = require('body-parser');
var routes = require('./api/routes');
require('./instantHello');
var goodbye = require('./talk/goodbye');
var question = require('./talk/question');
var talk = require('./talk');
talk.intro();
talk.hello("tttttt");
var name = "Everyone";
console.log("hello" + name);
var answer = question.ask("what is in a life");
console.log(answer);
goodbye();
app.set('port',3000);
app.use(function(req, res, next){
  console.log(req.method,req.url);
  next();

});
app.use(express.static(path.join(__dirname,'public')));
app.use(bodyParser.urlencoded({extended : false }));
app.use('/api', routes);
app.get('/json', function(req,res) {
   console.log('get json');
    res
      .status(200)
      .json({ "jsondata" : true });
  }); 

app.get('/file', function(req,res) {
   console.log('get file');
    res
      .status(200)
      .sendFile(path.join(__dirname,'app.js'));
  });
var server = app.listen(app.get('port'), function() {
var port = server.address().port;
console.log('listening at port 3000');
}
);


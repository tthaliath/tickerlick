var fs = require('fs');
var onFileLoad = function(err,file) {
     console.log('got file');
};
console.log('go for file');
fs.readFile('readFileSync.js', onFileLoad) 

console.log('app continus');

var filename = "index.js";
var hello = function(name) {
    console.log("hello "+name);
};

var intro = function(name) {
    console.log("i am a node called " + filename);
};

module.exports = {
     hello : hello,
     intro : intro
};

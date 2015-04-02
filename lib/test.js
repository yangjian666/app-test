var Emitter = require('events').EventEmitter;
var util = require('util');
var connect = require('connect');
var jade = require('jade');
var path = require('path');
//var ware    = require('./ware');


var Test = function(options) {
  // body...
  console.log("Test construct function");
  //ware({name : "ware start ^"});
  //this.middleware();
  //var tp = this.middleware();//返回的是一个函数

  //tp(req, res, null);
  //connect().use(connect.static(__dirname + '/static'));
  //var ware = process.honeycomb.ware;


};

util.inherits(Test, Emitter);

Test.prototype.middleware = function() {
  var $this = this;
  return function(req, res, next) {
    var res1 = $this.buildHtml(req);
    console.log(res1)
    return res.end(res1);
  };
};

Test.prototype.getProperty = function(obj) {
  var res = '';
  for (var i in obj) {
    res += i + ': ' + typeof(obj[i]) + ';';
  }
  return res;
}

Test.prototype.buildHtml = function(obj) {
  // body...
  // var html = '<html>\
  //   <head></head>\
  //   <body>\
  //     console.log(' + obj.toString() + ');\
  //   </body>\
  // </html>';
  var html = jade.renderFile(path.join(__dirname, '../jade/test.jade'));
  console.log(html)
  return html;
}

module.exports = function(options) {
  return new Test(options);
};
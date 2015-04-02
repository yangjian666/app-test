/**
 * Created by lanjian on 15/4/1.
 */

var http        = require('http');
var fs          = require('fs');
var url         = require('url');
var path        = require('path');
var queryString = require('querystring');
var util        = require('util');
var fileObj     = require('./node_modules/file');



http.createServer(function (req, res) {

	var urlInfo = url.parse(req.url);
  var file = '.' + urlInfo.pathname;

	if('/' === urlInfo.pathname){

		new fileObj({
			'file' : './index.html',
			'fs' : fs,
			'res' : res
		});

		return;

	}

	fs.exists(file, function(exist){
		if(exist){
      var opt = {
				'file' : file,
				'fs' : fs,
				'res' : res
			};

			new fileObj(opt);

		}else{

			res.writeHead(404, {});
			res.end('file not found');

		}
	});


  console.log(urlInfo);

/*
  var hello = new hellow();
	hello.setName('hi, test!');
	hello.sayHello();
	*/
}).listen(1337, '127.0.0.1');

console.log('Server running at http://127.0.0.1:1337/');
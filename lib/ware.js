
var ware = function(options){
	this.str = typeof(options) === 'string' ? options : options.name;
	this.str && console.log(this.str);
	console.log("ware construct function");
}

ware.prototype.md5 = function(){

}


ware.prototype.middleware = function(){
	return function(req, res, next){
		console.log('the wares middleware');
		//next();
		return res.end('ware is running');
	}
}

module.exports = function(options){
	return new ware(options);
}
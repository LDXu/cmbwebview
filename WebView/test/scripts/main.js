
require.config({
        baseUrl: 'scripts/'
    }
)


var dt = new Date();
dt.setSeconds(dt.getSeconds() + 60);
document.cookie = "";
var cookiesEnabled = document.cookie.indexOf("cookietest=") != -1;
if(!cookiesEnabled) {
    //没有启用cookie
    alert("没有启用cookie ");
} else{
    //已经启用cookie
    alert("已经启用cookie ");
}

require(['zepto'], function ($) {
	var exports = {};
	exports.init = function(){
        this.bindUI();
    };
    exports.bindUI = function(){
        var that = this;
        $('.cookie_set').on('click',function(){
            var key = $('.ipt_key4set').val();
            var val = $('.ipt_val4set').val();
            if(key && val){
                that.setCookie(key,val,24,"/");
                $('.result').show();
            } else {
                alert('cookie 键或值不能为空！');
                $('.result').hide();
            }
        });
        $('.cookie_get').on('click',function(){
            var key = $('.ipt_key4get').val();
            if(key){
                var val = that.getCookie(key);
                $('textarea').html(val?val:'很抱歉，没有值！');
            } else {
                alert('cookie 键不能为空！');
            }
        });
    };
//    exports.getCookie = function(name){
//        return document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"))==null ? null : decodeURIComponent(RegExp.$2);
//    };
    exports.getCookie =function(name) {
        var name = escape(name);
        //读cookie属性，这将返回文档的所有cookie
        var allcookies = document.cookie;
        //查找名为name的cookie的开始位置
        name += "=";
        var pos = allcookies.indexOf(name);
        //如果找到了具有该名字的cookie，那么提取并使用它的值
        if (pos != -1) {                                             //如果pos值为-1则说明搜索"version="失败
            var start = pos + name.length;                  //cookie值开始的位置
            var end = allcookies.indexOf(";", start);        //从cookie值开始的位置起搜索第一个";"的位置,即cookie值结尾的位置
            if (end == -1) end = allcookies.length;        //如果end值为-1说明cookie列表里只有一个cookie
            var value = allcookies.substring(start, end); //提取cookie的值
            return unescape(value);                           //对它解码
        }
        else return "";                               //搜索失败，返回空字符串
    }
//    exports.setCookie = function(c_name,value){
//        var exdate=new Date();
//        exdate.setDate(exdate.getDate());
//        exdate.setHours(exdate.getHours());
//        exdate.setMinutes(exdate.getMinutes()+2);
//        exdate.setSeconds(0);
//        document.cookie=c_name+ "=" + escape(value) + ";expires="+exdate.toGMTString();
//    };
exports.setCookie = function (name, value, hours, path) {
        var name = escape(name);
        var value = escape(value);
        var expires = new Date();
        expires.setTime(expires.getTime() + hours * 3600000);
        path = path == "" ? "" : ";path=" + path;
        _expires = (typeof hours) == "string" ? "" : ";expires=" + expires.toUTCString();
        document.cookie = name + "=" + value + _expires + path;
    }
	exports.init();
	return exports;
    
});
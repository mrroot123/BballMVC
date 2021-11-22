mainhub.js

function callAll(jsfiles) {
   var src = document.createElement("script");
   src.setAttribute("type", "text/javascript");
   src.setAttribute("src", jsfiles);
   document.getElementsByTagName("head")[0].appendChild(src);
}
callAll("your/path/to/a/jsfile1.js");
callAll("your/path/to/a/jsfile2.js");
callAll("your/path/to/a/jsfile3.js");
//
then all you have to call is the mainhub.js on your header

 //  < script type = "text/javascript" src = "your/path/mainhub.js" ></script >
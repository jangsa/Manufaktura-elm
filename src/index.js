'use strict';

require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./elm/Main.elm');
var mountNode = document.getElementById('root');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
var app = Elm.Main.embed(mountNode);

/*
app.ports.readFile.subscribe(function (id) {
 var node = document.getElementById(id);

 if (node === null) return;

 var file = node.files[0];
 var reader = new FileReader();

 reader.onload = (function(event) {
   var base64encoded = event.target.result;
   var portData = {
     base64Body : base64encoded,
     filename : file.name
   };

   app.ports.receiveFile.send(portData);
 });

 reader.readAsDataURL(file);
});
*/


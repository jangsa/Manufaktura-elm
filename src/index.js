'use strict';

require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./elm/Main.elm');
var mountNode = document.getElementById('root');

var app = Elm.Main.embed(mountNode);

app.ports.fileDragged.subscribe(function (index) {

  var elementID = "dropfield-" + index;
  var element = document.getElementById(elementID);

  if (element === null) return;

  element.addEventListener("drop", function(event) {

    event.preventDefault();
    event.stopPropagation();

    var files = event.dataTransfer.files;
    var base64files = [];

    for(var i = 0; i < files.length; i++) {

      (function(file) {

        var reader = new FileReader();

        reader.onload = (function(event) {
          var base64body = event.target.result;

          base64files.push ({
            name : file.name,
            body : base64body
          });

          if(base64files.length == files.length)
            app.ports.fileLoaded.send({ index : index, base64files : base64files });
        });
  
        reader.readAsDataURL(file);

      })(files[i]);

    }

  });

});


'use strict';


var _jangsa$manufaktura$Native_FileSupporter = function () {

  function subscribeFileDropOn (elementID, options, model) {

    if(!model.loaded) {
//      console.log("attached");
      var element = document.getElementById(elementID);
  
      element.addEventListener("drop", function(event) {
  
        if (options.preventDefault) event.preventDefault();
        if (options.stopPropagation) event.stopPropagation();
  
        var files = event.dataTransfer.files;
  
        // todo: return List (FileName, Base64)
	console.log("uploaded!");
      });
    }

//    console.log("loaded -> true!");
    model.loaded = true;

    return model;
  }

  return {
    subscribeFileDropOn : F3(subscribeFileDropOn)
  }
}();



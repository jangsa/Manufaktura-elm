'use strict';


var _jangsa$manufaktura$Native_FileSupporter = function () {

  function plus1 (v) {
    return v + 1;
  }

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
    plus1 : plus1,
    subscribeFileDropOn : F3(subscribeFileDropOn)
  }
}();



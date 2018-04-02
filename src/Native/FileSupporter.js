'use strict';


var _jangsa$manufaktura$Native_FileSupporter = function () {

  function subscribeFileDropOn (index, options, jobState) {

    // todo: make "loaded" attached to JobState so that each dropfield can be set listener

    if (!jobState.loaded) {

      var elementID = "dropfield-" + index;
      var element = document.getElementById(elementID);

      element.addEventListener("drop", function(event) {

        if (options.preventDefault) event.preventDefault();
        if (options.stopPropagation) event.stopPropagation();

        var files = event.dataTransfer.files;
	var reader = new FileReader();

	reader.onload = (function(event) {
	  var base64body = event.target.result;

	  var base64File = {
	    filename : files[0].name,
	    base64body : base64body
	  };

          jobState.uploadingFiles.push(base64File);
	  console.log(jobState.uploadingFiles);
	});

	reader.readAsDataURL(files[0]);
	console.log(app);
      });
    }

    jobState.loaded = true;

    return jobState;
  }

  return {
    subscribeFileDropOn : F3(subscribeFileDropOn)
  }
}();



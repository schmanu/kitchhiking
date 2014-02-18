
function initPopovers(){
  $("a[data-toggle=popover]")
        .popover()
        .click(function(e) {
          e.preventDefault()
         });
  $('.dropdown-toggle').dropdown()

}

function allowDrop(event){
  event.preventDefault();
}



function dropImageIntoSpan(e, controller, action){
  e.preventDefault();
  var dt    = e.dataTransfer;
  var files = dt.files;
  if(files.length>1)
    toggleAlert('You can only upload one image');
  else if(files.length==1)
  {
    var file = files[0];
    var reader = new FileReader();
    var target = e.target;
    $(target)[0].files = files;
    reader.readAsDataURL(file);

    addEventHandler(reader, 'loadend', function(e, f) {
      var bin = this.result;
      target.style.backgroundImage= "url("+bin+")";
      target.innerText="";
      if(controller == "dinners" && action == "create") {
        postDinnerPicture(bin, file);
      }
      else
        if(controller == "hikers" && action == "edit") {
          postHikerAvatar(bin, file);
        }
    });

  }
  return false;
}

function postHikerAvatar(bin, file) {
    $.post("/hikers/edit",
    {
      hiker: {
        avatar: encodeURIComponent(bin),
        original_filename: file.name,
        content_type: file.type,
        id: $("#hiker_id")[0].value,
      }
    }, function(data) { ajaxPostCreateCallback(data);
     });  
}

function postDinnerPicture(bin, file) {
    $.post("/dinners/create",
    {
      dinner: {
        picture: encodeURIComponent(bin),
        original_filename: file.name,
        content_type: file.type,
        id: $("#dinner_id")[0].value,
      }
    }, function(data) { ajaxPostCreateCallback(data);
     });  
}

function updateRequestState(id, new_state) {
  $.post("/requests/update_state",
  {
    request: {
      id: id,
      state: new_state
    }
  }, function(data) { ajaxPostCreateCallback(data);
  });
}

function ajaxPostCreateCallback(response) {
  if(response.status == 201) {
    toggleAlert(response.message, "success");
  }
  else {
    toggleAlert("The image could not be uploaded", "error");
  }
}


function toggleAlert(message, type){
  if(type == 'undefined')
    type = 'error';

  var $newalert = $("<div class='alert alert-"+type+"' />");
  $newalert.append($("<button class='close' data-dismiss='alert'>x</button>"));
  $newalert.append($("<strong>"+message+"</strong>"));
  $(".alert-container").append($newalert);
}

function initDateTimePickers() {
  $(function() {
    $('.datetimepicker').datetimepicker({
      language: 'en',
      pickSeconds: false,
      maskInput: true
    });
  });

  $(function() {
    $('.datepicker').datetimepicker({
      language: 'en',
      pickTime: false,

      maskInput: true
    });
  });
}

function addEventHandler(obj, evt, handler) {
    if(obj.addEventListener) {
        // W3C method
        obj.addEventListener(evt, handler, false);
    } else if(obj.attachEvent) {
        // IE method.
        obj.attachEvent('on'+evt, handler);
    } else {
        // Old school method.
        obj['on'+evt] = handler;
    }
}

function answerRequest(id, accept) {
  if(accept) {
    updateRequestState(id, "accepted");
    $("#request_"+id).css("background-color", "rgba(0,255,0,0.2)");
  } else {
      updateRequestState(id, "declined");
        $("#request_"+id).css("background-color", "rgba(255,0,0,0.2)");

  }
  $("#request_"+id).find(".notification-options").css("display", "none");
}

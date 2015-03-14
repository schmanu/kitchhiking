
function initPopovers(){
  $("a[data-toggle=popover]")
        .popover()
        .click(function(e) {
          e.preventDefault()
         });
  $('.dropdown-toggle').dropdown()

}

function initTabs(){
  $('#dinner_detail_tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  })
}

function initSwitches(){
  $('.switch').bootstrapSwitch();

  //Initialize View Mode switches
  $('#view_mode_switch').on('switchChange', switchMode);
}

function switchMode(e, data) {
  var $element = $(data.el),
  value = data.value;

  //switch state:
  if(value) {
    //try to save all editable values and show ajax load gif
    saveEditableForm();

 
  } else {
    //switch all editables to edit mode
    //wrap long values in textareas
    var emptyTextArea = $("<textarea />");
    $(".editable.longvalue").each(function() {
      var editable = $(this);
      var innerText = editable.text().trim();
      var width = editable.width()-20;
      var height = editable.height()+10;
      editable.text("");
      newTextarea = emptyTextArea.clone();
      newTextarea.text(innerText);
      newTextarea.width(width);
      newTextarea.height(height);
      editable.append(newTextarea);
    });

    //Make contenteditable for short values
    $(".editable.shortvalue").each(function() {
      var editable = $(this);
      editable.attr("contenteditable", "true");
    });
    

  }
}

function ajaxSaveFormCallback(response) {
  if(response.status == 201) {
    toggleAlert(response.message, "success");
   //switch all editables to view mode on callback
    $(".editable.longvalue").each(function() {
      var editable = $(this);
      var innerText = editable.children().val().trim();
      editable.children().remove();
      editable.text(innerText);  
    });

    //remove contenteditable for short values
    $(".editable.shortvalue").each(function() {
      var editable = $(this);
      editable.attr("contenteditable", "false");
    });
  }
  else {
    toggleAlert("Error while saving changes.", "error");
  }
  $("#ajax-loader").hide();
  
}

function saveEditableForm() {
  //Collect Form Data and Values
  $("#ajax-loader").show();
  var form = $(".editable-form");
  var controller = form.attr("controller");
  var action = form.attr("action");
  var id = form.attr("oid");
  var objectmodel = form.attr("objectmodel");

  var jsonValues = {};
  var innerobj = {};
  innerobj["id"] = id;
    $(".editable.longvalue").each(function() {
      var editable = $(this);
      var innerText = editable.children().val().trim();
      var data = editable.attr("data");
      innerobj[data] = innerText;
    });

    $(".editable.shortvalue").each(function() {
      var editable = $(this);
      var innerText = editable.text().trim();
      var data = editable.attr("data");
      innerobj[data] = innerText;
    });

    jsonValues[objectmodel] = innerobj;

    $.post("/"+controller+"/"+action, jsonValues, ajaxSaveFormCallback);
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

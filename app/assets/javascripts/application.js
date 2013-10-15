// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  startDNDListening();
  if ($(".user-button").length !== 0) {
    startLoggedInListening();
  } else {
    startLoggedOutListening();
  }




  $("#new-image").on("submit", function (event) {
    $(this).children(":submit").attr("disabled", true);
  })

  $('#new-image :file').bind('change', function() {
    if (this.files[0].size > 1048576) {
      showFileTooBig();
      var input = $('#new-image :file');
      var newInput = input.clone(true);
      input.replaceWith(newInput);
    }
  });

  $(".image-list").on("ajax:success", ".image-square", function(event, data) {
    showImage(data);
  })

  $(".sidebar-image-list-item").on("ajax:success", "a", function(event, data) {
    showImage(data);
  })

  $(".transparent-background.show").on("click", function() {
    hideOverlay($(".show-page-holder"));
  })

  if ($(".flash-notice p").html() !== "") {
    $(".flash-notice").slideDown("slow", function() {
      setTimeout(function() {
        $(".flash-notice").slideToggle("slow");
      }, 2000);
    });
  }
})

function showImage(data) {
  $target = $(".nested-show-page").html(data);
  $(".show-page-holder").height($(window).height());
  showOverlay($target, $(".show-page-holder"));
}

function showOverlay($target, $parent) {
  $("body").addClass("noscroll")
  $target.show();
  $parent.children(".transparent-background").show();
  $parent.fadeTo(120, 1);
  $(window).on('resize', function() {
    console.log("firing, new height: ", $(window).height())
    $parent.height($(window).height());
  })
}

function hideOverlay($parent) {
  $parent.fadeTo(120, 0, function() {
    $parent.hide().children().hide();
    $("body").removeClass("noscroll")
  });
  $(window).off("resize");
}

function startLoggedInListening() {
  $("body").on("ajax:success", ".upvote-form", function(event, data) {
    $(this).closest(".vote-box").replaceWith(data);
  })

  $("body").on("ajax:success", ".downvote-form", function(event, data) {
    $(this).closest(".vote-box").replaceWith(data);
  })

  $("body").on("ajax:success", ".comment-list .comment-reply", function(event, data) {
    $(this).on("click.disable", function (event) { event.preventDefault(); return false;});
    $(this).after(data);
  })

  $("body").on("ajax:success", ".comment-list .comment-form", function(event, data) {
    $li = $("<li></li>").html(data)
    $(this).closest('li').children('ul').prepend($li);
    $(this).siblings(".comment-reply").off("click.disable");
    $(this).remove()
  })

  $(".content").on("ajax:success", ".comment-form", function(event, data) {
    $li = $("<li></li>").html(data)
    $(".comment-list").prepend($li);
    $(this).remove();
  })

  $("body").on("ajax:success", ".nested-show-page > .comment-form", function(event, data) {
    $li = $("<li></li>").html(data)
    $(".comment-list").prepend($li);
    $(this).remove();
  })
}

function startLoggedOutListening() {
  $(".login-button").on("click", "a", function(event) {
    event.preventDefault();
    showOverlay($(".login-page"), $(".login-overlay"));
  });

  $(".signup-button").on("click", "a", function(event) {
    event.preventDefault();
    showOverlay($(".signup-page"), $(".login-overlay"));
  });

  $(".signup-link").on("click", function(event) {
    event.preventDefault();
    $(".login-page").hide();
    $(".signup-page").show();
  })

  $(".transparent-background.login").on("click", function() {
    hideOverlay($(".login-overlay"));
  })

  $("body").on("ajax:success", ".login-form", function(event, data) {
    $(".top-bar").replaceWith(data);
    startLoggedInListening();
    hideOverlay($(".login-overlay"));
  })

  $("body").on("ajax:success", ".new_user", function(event, data) {
    $(".top-bar").replaceWith(data);
    startLoggedInListening();
    hideOverlay($(".login-overlay"));
  })

  $("body").on("ajax:error", ".login-form", function(event, data) {
    $(this).parent().replaceWith(data.responseText);
  })

  $("body").on("ajax:error", ".new_user", function(event, data) {
    $(this).parent().replaceWith(data.responseText);
  })

  $("body").on("ajax:error", function(event, data) {
    if (data.status === 401) {
      console.log('here');
      $(".login-button a").trigger("click");
    }
  })
}

function startDNDListening() {
  var dropbox = document.getElementById("body");
  var dropmask = document.getElementById("dropmask")
  dropmask.addEventListener("dragleave", dragExit, false);
  dropbox.addEventListener("dragover", dragOver, false);
  dropbox.addEventListener("drop", drop, false);
}

function dragExit(event) {
  event.stopPropagation();
  event.preventDefault();
  $(".droppable").removeClass("showing");
  $("#dropmask").removeClass("showing");
}

function dragOver(event) {
  event.stopPropagation();
  event.preventDefault();
  if (!$(".droppable").hasClass("showing")) {
    $(".droppable").addClass("showing")
    $("#dropmask").addClass("showing")
  }
}
function drop(event) {
  event.stopPropagation();
  event.preventDefault();

  $(".droppable div p").html("Uploading image...");

  var files = event.dataTransfer.files;

  if (files.length == 1) {
    handleFiles(files);
  }
}

function handleFiles(files) {
  var file = files[0];
  if (file.size < 1048576) {
    uploadFile(file);
  } else {
    showFileTooBig();
  }
}

function showFileTooBig() {
  $(".droppable").addClass("showing")
  $(".droppable").addClass("error")
  $(".droppable div p").html("File size must be under 1 MB");

  setTimeout(function () {
    $(".droppable").removeClass("showing");
    $("#dropmask").removeClass("showing");
    $(".droppable").removeClass("error");
    $(".droppable div p").html("Drop file anywhere to upload.")
  }, 3000)
}

function uploadFile(file) {
  var formData = new FormData();
  formData.append("image", file);
  formData.append("dropped", true);
  console.log(formData)
  $.ajax({
    url: '/images',
    data: formData,
    dataType: "json",
    processData: false,
    contentType: false,
    type: "POST",
    success: function(data) {
      if (data["user_id"]) {
        window.location = "/images/" + data["id"] + "/edit";
      } else {
        window.location = "/images/" + data["id"] + "/edit?authorization_token=" + data["authorization_token"];
      }
    }
  })
}

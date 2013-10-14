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

  $(".login-button").on("click", "a", function(event) {
    event.preventDefault();
    $(this).parent().toggleClass("show-login");
  });
  $(".signup-button").on("click", "a", function(event) {
    event.preventDefault();
    $(this).parent().toggleClass("show-signup");
  });

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

  $("body").on ("ajax:success", ".login-form", function(event, data) {
    console.log("data");
    $(".top-bar").replaceWith(data);
  })

  $("body").on("ajax:success", ".upvote-form", function(event, data) {
    $(this).closest(".vote-box").replaceWith(data);
  })

  $("body").on("ajax:success", ".downvote-form", function(event, data) {
    $(this).closest(".vote-box").replaceWith(data);
  })

  $(".image-list").on("ajax:success", ".image-square", function(event, data) {
    window.scrollTo(0, 0);
    $(".nested-show-page").html(data);
    $(".show-page-holder").fadeTo("slow", 1);
    $(".transparent-background").fadeTo("slow", 1);
  })
  $(".transparent-background").on("click", function() {
    $(".show-page-holder").hide("slow");
    $(".transparent-background").hide(1);
    $(".nested-show-page").html("");
  })

  if ($(".flash-notice p").html() !== "") {
    $(".flash-notice").slideDown("slow", function() {
      setTimeout(function() {
        $(".flash-notice").slideToggle("slow");
      }, 2000);
    });
  }
})

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

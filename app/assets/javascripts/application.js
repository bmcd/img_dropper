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

  $(".comment-list").on("ajax:success", ".comment-reply", function(event, data) {
    $(this).on("click.disable", function (event) { event.preventDefault(); return false;});
    $(this).after(data);
  })
  $(".comment-list").on("ajax:success", ".comment-form", function(event, data) {
    $li = $("<li></li>").html(data)
    $(this).closest('li').children('ul').prepend($li);
    $(this).siblings(".comment-reply").off("click.disable");
    $(this).remove()
  })
  $(".content .comment-form").on("ajax:success", function(event, data) {
    $li = $("<li></li>").html(data)
    $(".comment-list").prepend($li);
    $(this).remove();
  })

  $(".content").on("ajax:success", ".upvote-form", function(event, data) {
    $(this).closest(".vote-box").replaceWith(data);
  })
  $(".content").on("ajax:success", ".downvote-form", function(event, data) {
    $(this).closest(".vote-box").replaceWith(data);
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
  uploadFile(file);
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

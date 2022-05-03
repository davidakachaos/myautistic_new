---
layout: single
title: Get in touch!
lang: en
ref: contact
---
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<p>Do you need someone to explain what autism actually means? Or maybe you want to know more about neurodiversity and all its different forms? It's an honour for me to be able to do something for you!</p>
<p>Please contact me using the form below. Of course I can also be contacted via the various social media, but sometimes it is easier to contact me directly.</p>
<p>I aim to respond to your message within a reasonable time. Thank you for taking the time to write me a message!</p>

<form class="ui form" id="my-form" action="https://formspree.io/xwkblaje" method="POST">
  <div class="field">
    <label>Name:</label>
    <input type="text" name="name" placeholder="Your name..." />
  </div>
  <div class="field">
    <label>Email address:</label>
    <input type="email" name="email" placeholder="Your email address..." />
  </div>
  <div class="field">
    <label>Message:</label>
    <textarea rows="5" name="message" placeholder="Your message..."></textarea>
  </div>
  <div id="my-form-status" style="display: none;" class="ui message">
    <div class="header"></div>
    <p></p>
  </div>
  <input type="hidden" name="_subject" value="New submission!" />
  <input type="text" name="_gotcha" />
  <div class="g-recaptcha" data-sitekey="6Le3aOkUAAAAAK_vTtS6xMkOe46zsPf2j4I_p8_K"></div>
  <button class="ui button" id="my-form-button">Send!</button>
  <p ></p>
</form>

<!-- Place this script at the end of the body tag -->

<script>
  window.addEventListener("DOMContentLoaded", function() {

    // get the form elements defined in your form HTML above

    var form = document.getElementById("my-form");
    var button = document.getElementById("my-form-button");
    var status = document.getElementById("my-form-status");

    // Success and Error functions for after the form is submitted

    function success() {
      form.reset();
      button.style = "display: none ";
      // status.innerHTML = "Bedankt voor uw bericht!";
      $('#my-form-status').addClass('success');
      $('#my-form-status div.header').text('Thanks!');
      $('#my-form-status p').text('Thank you for your message!');
      $('#my-form-status').show();

    }

    function error() {
      // status.innerHTML = "Oops! Er was een probleem bij het versturen.";
      $('#my-form-status').addClass('error');
      $('#my-form-status div.header').text('Oops!');
      $('#my-form-status p').text('There was a problem sending your message!');
      $('#my-form-status').show();
    }

    // handle the form submission event

    form.addEventListener("submit", function(ev) {
      ev.preventDefault();
      $('my-form').addClass('loading');
      var data = new FormData(form);
      ajax(form.method, form.action, data, success, error);
    });
  });

  // helper function for sending an AJAX request

  function ajax(method, url, data, success, error) {
    var xhr = new XMLHttpRequest();
    xhr.open(method, url);
    xhr.setRequestHeader("Accept", "application/json");
    xhr.onreadystatechange = function() {
      if (xhr.readyState !== XMLHttpRequest.DONE) return;
      if (xhr.status === 200) {
        success(xhr.response, xhr.responseType);
        $('my-form').removeClass('loading');
      } else {
        error(xhr.status, xhr.response, xhr.responseType);
        $('my-form').removeClass('loading');
      }
    };
    xhr.send(data);
  }
</script>

(function() {
  console.log("i'm the content script");

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    console.log('This is the content script. link has been added');
    if (request.action === 'added_link') {
      return alert('Link Added');
    }
  });

}).call(this);

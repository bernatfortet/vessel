(function() {
  console.log("i'm the content script");

  chrome.runtime.sendMessage({
    greeting: "hello"
  }, function(response) {
    return console.log(response.farewell);
  });

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    console.log(sender.tab ? "from a content script:" + sender.tab.url : "from the extension");
    if (request.greeting === "hello") {
      return sendResponse({
        farewell: "goodbye"
      });
    }
  });

}).call(this);

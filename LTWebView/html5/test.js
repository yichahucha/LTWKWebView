
function testbutton() {
    //js调用oc
    window.webkit.messageHandlers.calloc.postMessage('oc方法被调用');
}

function calljs(text) {
    //oc调js
    window.alert(text);
    return text;
}


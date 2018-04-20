
function testbutton() 
{
    //调用oc
    window.alert('调用test');
    window.webkit.messageHandlers.test.postMessage('我是参数');
}

function callJs(text)
{
    //oc调我
    window.alert(text);
    return text;
}

function test2button()
{
    window.alert('调用test2');
    window.webkit.messageHandlers.test2.postMessage('我也是参数');
}

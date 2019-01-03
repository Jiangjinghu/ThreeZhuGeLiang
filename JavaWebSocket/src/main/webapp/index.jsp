<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" pageEncoding="UTF-8" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
	<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="ueditor/lang/zh-cn/zh-cn.js"></script>
	<style type="text/css">

		div {
			width: 100%;
			text-align: center;
		}

		#editor{
			width: 80%;
			margin-left: auto;
			margin-right: auto;
		}

		#save,#download{
			margin-top: 10px;
			margin-bottom: 10px;
		}

		#btns,#btns1{
			visibility: hidden;
		}
	</style>
</head>
<body>
<div>文件:<input id="filename" type="text">
	<button onclick="openfile()" id="filenameB">打开</button>
</div>

<div>
	<form action="" method="">
		<button id="download"  onclick="saveWord()">下载</button>
		<button  id ="save" onclick="saveWord()">保存</button>
		<div id="editor" type="text/plain" style="width:1024px;height:500px;"></div>
	</form>
</div>


<div id="btns">
	<div>
		<button onclick="getAllHtml()">获得整个html的内容</button>
		<button onclick="getContent()">获得内容</button>
		<button onclick="setContent()">写入内容</button>
		<button onclick="setContent(true)">追加内容</button>
		<button onclick="getContentTxt()">获得纯文本</button>
		<button onclick="getPlainTxt()">获得带格式的纯文本</button>
		<button onclick="hasContent()">判断是否有内容</button>
		<button onclick="setFocus()">使编辑器获得焦点</button>
		<button onmousedown="isFocus(event)">编辑器是否获得焦点</button>
		<button onmousedown="setblur(event)">编辑器失去焦点</button>

	</div>
	<div>
		<button onclick="getText()">获得当前选中的文本</button>
		<button onclick="insertHtml()">插入给定的内容</button>
		<button id="enable" onclick="setEnabled()">可以编辑</button>
		<button onclick="setDisabled()">不可编辑</button>
		<button onclick=" UE.getEditor('editor').setHide()">隐藏编辑器</button>
		<button onclick=" UE.getEditor('editor').setShow()">显示编辑器</button>
		<button onclick=" UE.getEditor('editor').setHeight(400)">设置高度为400默认关闭了自动长高</button>
	</div>

	<div>
		<button onclick="getLocalData()">获取草稿箱内容</button>
		<button onclick="clearLocalData()">清空草稿箱</button>
	</div>

</div>


<div id="btns1">
	<button onclick="createEditor()">
		创建编辑器
	</button>
	<button onclick="deleteEditor()">
		删除编辑器
	</button>
</div>

<script type="text/javascript">
    var websocket = null;
    var fileName = null;
    var myword="";
    var ue = UE.getEditor('editor');

    if ('WebSocket' in window) {
        websocket = new WebSocket("ws://localhost:8080/JavaWebSocket/websocket");
    } else {
        alert('当前浏览器 Not support websocket')
    }

    //----
    function isFocus(e) {
        alert(UE.getEditor('editor').isFocus());
        UE.dom.domUtils.preventDefault(e)
    }

    function setblur(e) {
        UE.getEditor('editor').blur();
        UE.dom.domUtils.preventDefault(e)
    }

    function insertHtml() {
        var value = prompt('插入html代码', '');
        //value="sss";
        UE.getEditor('editor').execCommand('insertHtml', value)
    }

    function createEditor() {
        enableBtn();
        UE.getEditor('editor');
    }

    function getAllHtml() {
        alert(UE.getEditor('editor').getAllHtml())
    }

    function getContent() {
        var arr = [];
        arr.push("使用editor.getContent()方法可以获得编辑器的内容");
        arr.push("内容为：");
        arr.push(UE.getEditor('editor').getContent());
        alert(arr.join("\n"));
    }

    function getPlainTxt() {
        var arr = [];
        arr.push("使用editor.getPlainTxt()方法可以获得编辑器的带格式的纯文本内容");
        arr.push("内容为：");
        arr.push(UE.getEditor('editor').getPlainTxt());
        alert(arr.join('\n'))


    }

    function setContent(isAppendTo) {
        var arr = [];
        arr.push("使用editor.setContent('欢迎使用ueditor')方法可以设置编辑器的内容");
        UE.getEditor('editor').setContent(myword, isAppendTo);
        alert(arr.join("\n"));
    }

    function setDisabled() {
        UE.getEditor('editor').setDisabled('fullscreen');
        disableBtn("enable");
    }

    function setEnabled() {
        UE.getEditor('editor').setEnabled();
        enableBtn();
    }

    function getText() {
        //当你点击按钮时编辑区域已经失去了焦点，如果直接用getText将不会得到内容，所以要在选回来，然后取得内容
        var range = UE.getEditor('editor').selection.getRange();
        range.select();
        var txt = UE.getEditor('editor').selection.getText();
        alert(txt)
    }

    function getContentTxt() {
        var arr = [];
        arr.push("使用editor.getContentTxt()方法可以获得编辑器的纯文本内容");
        arr.push("编辑器的纯文本内容为：");
        arr.push(UE.getEditor('editor').getContentTxt());
        alert(arr.join("\n"));
    }

    function hasContent() {
        var arr = [];
        arr.push("使用editor.hasContents()方法判断编辑器里是否有内容");
        arr.push("判断结果为：");
        arr.push(UE.getEditor('editor').hasContents());
        alert(arr.join("\n"));
    }

    function setFocus() {
        UE.getEditor('editor').focus();
    }

    function deleteEditor() {
        disableBtn();
        UE.getEditor('editor').destroy();
    }

    function disableBtn(str) {
        var div = document.getElementById('btns');
        var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
        for (var i = 0, btn; btn = btns[i++];) {
            if (btn.id == str) {
                UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
            } else {
                btn.setAttribute("disabled", "true");
            }
        }
    }

    function enableBtn() {
        var div = document.getElementById('btns');
        var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
        for (var i = 0, btn; btn = btns[i++];) {
            UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
        }
    }

    function getLocalData() {
        alert(UE.getEditor('editor').execCommand("getlocaldata"));
    }

    function clearLocalData() {
        UE.getEditor('editor').execCommand("clearlocaldata");
        alert("已清空草稿箱")
    }
    //-----

    //打开文件
    function openfile() {

        fileName = document.getElementById('filename').value;
        if (fileName == "") {
            alert("请先输入文件名");
        }
        else{
            document.getElementById('filename').readOnly = true;
            document.getElementById('filenameB').disabled=true;
            websocket.send("0/"+fileName);
        }
    }
    function saveWord() {
        myword=UE.getEditor('editor').getPlainTxt();
        websocket.send("1/"+fileName+"/"+myword);
    }

    websocket.onerror = function () {

    };

    websocket.onopen = function () {
    }

    websocket.onmessage = function (event) {
        //分隔字符串
        var strs= new Array();
        strs=event.data.split("/");

        if(strs[0]==="0"){
            myword=strs[1];
            UE.getEditor('editor').setContent(myword);
        }
        if(strs[0]==="1"){
            if(strs[1]==="0") alert("保存失败!");
            else alert("保存成功!");
		}
    }

    websocket.onclose = function () {

    }

    window.onbeforeunload = function () {
        closeWebSocket();
    }



    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

   //下载
    document.querySelector('#download').addEventListener('click', saveFile);

    function fakeClick(obj) {
        var ev = document.createEvent("MouseEvents");
        ev.initMouseEvent("click", true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        obj.dispatchEvent(ev);
    }

    function exportRaw(name, data) {
        var urlObject = window.URL || window.webkitURL || window;
        var export_blob = new Blob([data]);
        var save_link = document.createElementNS("http://www.w3.org/1999/xhtml", "a")
        save_link.href = urlObject.createObjectURL(export_blob);
        save_link.download = name;
        fakeClick(save_link);
    }

    function saveFile(){
        exportRaw(fileName+'.txt', myword);
    }

</script>
</body>

</html>
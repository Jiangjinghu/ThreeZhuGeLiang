package me.gacl.websocket;

import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.util.*;

@ServerEndpoint("/websocket")
public class WebSocketTest {

	private static int onlineCount = 0;
    private static MySqlServ myData=new MySqlServ();
	private static CopyOnWriteArraySet<WebSocketTest> webSocketSet = new CopyOnWriteArraySet<WebSocketTest>();
	private Session session;

	@OnOpen
	public void onOpen(Session session){
		this.session = session;
		webSocketSet.add(this);     //加入set中
		addOnlineCount();           //在线数加1
		System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
	}


	@OnClose
	public void onClose(){
		webSocketSet.remove(this);  //从set中删除
		subOnlineCount();           //在线数减1
		System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
	}

	@OnMessage
	public void onMessage(String message, Session session) {
		System.out.println("来自客户端的消息:" + message);
		//群发消息
        //分隔message
        StringTokenizer token=new StringTokenizer(message,"/");
        //0是打开文件
        String cmd=token.nextToken();
        String fileName=token.nextToken();
        System.out.println("cmd:" + cmd);
        System.out.println("fileName:" + fileName);
        if(cmd.equals("0")) {
            try {
                openFile(fileName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        //1是写入数据库
        if(cmd.equals("1")) {
            String content=token.nextToken();
            try {
                saveFile(fileName+"/"+content);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


	}


	@OnError
	public void onError(Session session, Throwable error){
		System.out.println("发生错误");
		error.printStackTrace();
	}


	public void sendMessage(String message) throws IOException{
		this.session.getBasicRemote().sendText(message);
        System.out.println("服务器发送："+message);
	}
    public void openFile(String fileName) throws IOException{
            //查询数据库
        String content=myData.Open(fileName);
            //然后写入String
        sendMessage("0/"+content);
    }
    public void saveFile(String message) throws IOException{
        //保存
        boolean r=myData.Save(message);
        if(r==true) sendMessage("1/1");
        else sendMessage("1/0");
    }

	public static synchronized int getOnlineCount() {
		return onlineCount;
	}

	public static synchronized void addOnlineCount() {
		WebSocketTest.onlineCount++;
	}

	public static synchronized void subOnlineCount() {
		WebSocketTest.onlineCount--;
	}
}

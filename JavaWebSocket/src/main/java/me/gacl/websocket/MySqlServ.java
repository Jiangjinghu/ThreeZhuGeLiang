package me.gacl.websocket;

import java.sql.*;
import java.util.*;

public class MySqlServ {
    public  Connection connection = null;
    // 传递sql语句
    private Statement stt;
    // 结果集
    private ResultSet set;

    //构造函数
    public  MySqlServ(){
        try {
            //加载驱动类
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://" + "rm-uf6q2p25low9r65zsfo.sqlserver.rds.aliyuncs.com:3433" + ";DatabaseName=" + "MyData";
            connection = DriverManager.getConnection(url, "jiang", "jiang123A");
            if(connection!=null){
                System.out.println("连接数据库成功");
                stt = connection.createStatement();
            }else{
                System.out.println("连接数据库失败");
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    //打开文件
    public String Open(String fileName){
        String content=null;
        try {
            String Sql = "select * from word where fileName = '"+fileName+"'";
            System.out.println(Sql);
            set = stt.executeQuery(Sql);
            //为空时 插入
            //不为空时 读取内容
            if(set.next()){
                content=set.getString(2);
            }else{
                String Sql1 = "insert into word (fileName) values('"+fileName+"')";
                System.out.println(Sql1);
                stt.executeQuery(Sql1);
                content=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return content;
    }

    //打开文件
    public boolean Save(String message){
        StringTokenizer token=new StringTokenizer(message,"/");
        String fileName=token.nextToken();
        String content=token.nextToken();
        boolean r=false;
        try {
            String Sql ="update word set content='"+content+"' where fileName = '"+fileName+"'";
            System.out.println(Sql);
            stt.executeQuery(Sql);
            r=true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return r;
    }
}

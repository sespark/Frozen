#include "login.h"
#include <QObject>
#include <string>

using std::string;

// 创建数据库和user表
Login::Login(QObject *parent):
    QObject(parent)
{
    usrtableFlag=false;

    database = QSqlDatabase::addDatabase("QSQLITE");   //creat database
    database.setDatabaseName("userInfo.db");           //set database name


    //打开数据库
    if(!database.open())
    {
        qDebug()<<database.lastError();
    }
    else
    {
        qDebug() <<"login-constructor : open seccess";
        QSqlQuery sql_query;        //改变量必须在成功打开数据库后定义才有效


        // user表是否存在
        //        usrtableFlag = sql_query.prepare("select count(*) from sqlite_master where type = 'table' and name='user'");
        sql_query.prepare("select count(*) from sqlite_master where type = 'table'");
        QString tablename;
        if(sql_query.exec()){
            while(sql_query.next()){
                tablename = sql_query.value(0).toString();
                if(tablename == "user"){
                    usrtableFlag = true;
                    break;
                }
            }
        }



        //不存在则创建一个user表
        if(usrtableFlag==false)
        {
            sql_query.prepare("create table user(id int primary key, passwd varchar(30), name varchar(30), userPassLevelNumber int)");
            if(!sql_query.exec())
            {
                qDebug()<<sql_query.lastError();
            }
            else
            {
                qDebug() <<"login-constructor: table 'user' created!";
            }
        }else{
            qDebug() << "login-constructor: table 'user' is already exist";
        }
    }
}


void Login::login_clicked(QString text)
{
    if(m_nameFlag==false)   //用户名是否相匹配
    {
        //用户名错误
        qDebug() <<"the enter user name invalid";
    }
    else
    {
        if(usr_passwd != text)   // 密码是否相匹配
        {
            //密码错误
            m_passwdFlag = false;
            emit passwdFlagChanged();
            qDebug() <<"the enter passwd not match";
        }
        else
        {
            //用户名和密码均正确
            m_passwdFlag = true;
            m_isLogIn = true;
            m_logining = true;
            emit isloginChanged();
            emit loginingChanged();
        }
    }
}

//id,passwd,name,passLevelNumber,history
void Login::getUserInfo(QString name)
{
    QSqlQuery sql_query;        //改变量必须在成功打开数据库后定义才有效

    //    int id;
    //    QString pass;
    //    QString name;
    //    QString userp;

    //查询部分数据(name)
    qDebug() <<"select * from user where name=?";
    qDebug() << name;
    if(!sql_query.exec("select * from user where name='"+name+"'"))   // 在表user中查询是否已经有该用户
    {
        qDebug() <<sql_query.lastError();
        m_nameFlag=false;
        emit nameFlagChanged();
    }
    else
    {
        if(sql_query.next())
        {
            usr_id = sql_query.value(0).toInt();
            usr_passwd = sql_query.value(1).toString();
            user_name = sql_query.value(2).toString();
            //            usr_email = sql_query.value(3).toString();
            m_userPassLevelNumber = sql_query.value(3).toInt();
            //            usr_history = sql_query.value(4).toInt();

            qDebug() << QString("id=%1    passwd=%2     name=%3   userPassLevelNumber=%4").arg(usr_id).arg(usr_passwd).arg(user_name).arg(m_userPassLevelNumber);
            if(user_name==name){
                m_nameFlag=true;
                qDebug()<<"user is exist: ";
                qDebug() << m_nameFlag;
            }else{
                qDebug()<<"user is not exist: ";
                m_nameFlag = false;
            }

            emit userIDChanged();
            emit userPasswordChanged();
            emit userNameChanged();
            emit userPassLevelNumberChanged();
            emit nameFlagChanged();
        }else{
            m_nameFlag = false;
            emit nameFlagChanged();
        }
    }
    if(!m_nameFlag){
        qDebug()<<"user is not exist: ";
    }
}

//register
void Login::addUserPassLevelNumber()
{

    QSqlQuery sql_query;        //改变量必须在成功打开数据库后定义才有效

    //查询部分数据(name)
    qDebug() << "select * from user where name=?";
    QString str = "update user set userPassLevelNumber = ? where name='"+user_name+"'";
    sql_query.prepare(str);
    sql_query.bindValue(0,m_userPassLevelNumber+1);
    if(!sql_query.exec())
    {
        qDebug()<<sql_query.lastError();
    }else{
        m_userPassLevelNumber++;
        qDebug() << "======================================addUserPassLevelNumber : updata userPassLevelNumber success";
        qDebug() << m_userPassLevelNumber;
        emit userPassLevelNumberChanged();
    }
}

//void Login::setUsername(QString name)
//{
//    user_name = name;//QString::fromStdString(name);
//    emit userNameChanged();
//}

//void Login::setUserpassWord(QString pw)
//{
//    usr_passwd = pw;//QString::fromStdString(pw);
//    emit userPasswordChanged();
//}



//注册输入完成，用户点击OK键
void Login::okBtn_clicked(QString pw1,QString pw2,QString Name)
{
    int newId=max_id+1;
    QString newpasswd=NULL;
    QString newname=NULL;
    int userPassLevelNumber = 0;

    if(pw1==""||pw2=="")
    {
        m_passwdFlag=false;
        emit passwdFlagChanged();
    }
    else if(pw1 == pw2)    //两次密码相同
    {
        m_passwdFlag=true;
        emit passwdFlagChanged();
        qDebug() << "password right";
    }
    else
    {
        qDebug() <<"passwd invalible";
        m_passwdFlag=false;
        emit passwdFlagChanged();
    }


    //以下为数据库的操作
    QSqlQuery sql_query;


    //查询最大id,设置ID
    max_id = 0;
    sql_query.prepare("select max(id) from user");
    if(!sql_query.exec())
    {
        qDebug()<<sql_query.lastError();
    }
    else
    {
        if(sql_query.next())    //检索结果中的下一个数据
        {
            max_id = sql_query.value(0).toInt();
            qDebug() <<"creatable max id: ";
            qDebug() <<max_id+1;
        }
    }

    // 列出数据库中存在的所有账户
    sql_query.prepare("select name from user");
    if(!sql_query.exec())
    {
        qDebug()<<sql_query.lastError();
    }
    else
    {
        while(sql_query.next())
        {
            QString name = sql_query.value(0).toString();
            qDebug()<<QString("name=%1").arg(name);
        }
    }

    // 将可用的用户名赋值给变量newname
    if(m_nameFlag == false && Name !=""){
        newname = Name;
    }

    //名字可用，将信息插入user表中
    if(m_nameFlag == false && m_passwdFlag){
        // 设置ID
        newId=max_id+1;
        if(m_nameFlag==false){
            newname=Name;
        }
        if(m_passwdFlag==true){
            newpasswd=pw1;
        }


        //插入数据
        QString str = "insert into user(id,passwd,name,userPassLevelNumber) values(?,?,?,?)";
        sql_query.prepare(str);
        sql_query.addBindValue(newId);
        sql_query.addBindValue(newpasswd);
        sql_query.addBindValue(newname);
        sql_query.addBindValue(userPassLevelNumber);


        //执行前面准备好的操作
        if(!sql_query.exec())
        {
            m_registerSuccess = false;
            emit registerSuccessChanged();
            qDebug()<<sql_query.lastError();
        }
        else
        {
            qDebug() <<"inserted!";
            m_registerSuccess = true;
            emit registerSuccessChanged();
        }
    }else{
        m_registerSuccess = false;
        emit registerSuccessChanged();
    }
}

void Login::receivedb()
{
    qDebug()<<"userInfo database open";
    database1=database;
    if(!database1.isOpen())
    {
        if(!database1.open())
        {
            qDebug()<<database1.lastError();
            qFatal("failed to connect.") ;
            return;
        }
    }
}

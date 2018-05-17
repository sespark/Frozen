#include "login.h"
#include <QObject>

Login::Login(QObject *parent):
    QObject(parent)
{
    usrtableFlag=false;
    rectableFlag = false;

    database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName("database.db");


    //打开数据库
    if(!database.open())
    {
        qDebug()<<database.lastError();
        qFatal("failed to connect.") ;
    }
    else
    {
        qDebug()<<"open seccess";
        QSqlQuery sql_query;        //改变量必须在成功打开数据库后定义才有效
        sql_query.prepare(select_table);
        if(!sql_query.exec())
        {
            qDebug()<<sql_query.lastError();
        }
        else
        {
            QString tableName;
            while(sql_query.next())
            {
                tableName = sql_query.value(0).toString();
                qDebug()<<tableName;
                if(tableName.compare("user"))
                {
                    usrtableFlag=false;
                    qDebug()<<"user table is not exist";
                }
                else
                {
                    usrtableFlag=true;
                    qDebug()<<"user table is exist";
                }

                if(tableName.compare("record"))
                {
                    rectableFlag=false;
                    qDebug()<<"record table is not exist";
                }
                else
                {
                    rectableFlag=true;
                    qDebug()<<"record table is exist";
                }
            }
        }

        if(usrtableFlag==false)
        {
            sql_query.prepare(create_sql);
            if(!sql_query.exec())
            {
                qDebug()<<sql_query.lastError();
            }
            else
            {
                qDebug()<<"table created!";
            }
        }

        //database.close();
        if (rectableFlag == false){
            sql_query.prepare(create_sql1);
            if(!sql_query.exec())
            {
                qDebug()<<sql_query.lastError();
            }
            else
            {
                qDebug()<<"table created!";
            }
        }
    }
}

void Login::register_clicked()
{
    //QApplication b();
    //    Register r(this);
    //    this->hide();
    //    r.show();
    //    emit transmitdb(database);
    //    m_register.receivedb(database);
    //    r.exec();
    //    this->close();
}

void Login::login_clicked(QString text)
{
    if(matchFlag==false)
    {
        //用户名错误
        qDebug()<<"name invalid";
    }
    else
    {
        if(usr_passwd != text)
        {
            //密码错误
            qDebug()<<"passwd not match";
        }
        else
        {
            //用户名和密码均正确
            m_logIn = true;
            emit isloginChanged();
        }
    }
}

//chatid,passwd,name,email,history
void Login::getUserInfo(QString name)
{

    QSqlQuery sql_query;        //改变量必须在成功打开数据库后定义才有效

    //查询部分数据(name)

    QString tempstring="select * from user where name='"+name+"'";
    qDebug()<<tempstring;
    if(!sql_query.exec(tempstring))
    {
        qDebug()<<sql_query.lastError();
        matchFlag=false;
    }
    else
    {
        while(sql_query.next())
        {
            usr_id = sql_query.value(0).toInt();
            usr_passwd = sql_query.value(1).toString();
            usr_name = sql_query.value(2).toString();
            //            usr_email = sql_query.value(3).toString();
            m_userPassLevelNumber = sql_query.value(3).toInt();
            usr_history = sql_query.value(4).toInt();

            qDebug()<<QString("chatid=%1    passwd=%2     name=%3   userPassLevelNumber=%4  history=%5").arg(usr_id).arg(usr_passwd).arg(usr_name).arg(m_userPassLevelNumber).arg(usr_history);

        }
        if(usr_name==name)  matchFlag=true;
        else                matchFlag=false;
    }

    qDebug()<<matchFlag;


}

void Login::addPassLevelNumber()
{
    if(!database.open())
    {
        qDebug()<<database.lastError();
        qFatal("failed to connect.") ;
    }

    QSqlQuery sql_query;
    QString name;
    QString tempstring="UPDATE user set userPassLevelNumber = ? where name='"+user_name+"'";
//    QString tempstring="select userPassLevelNUmber from user where name = '"+user_name+"'";

    qDebug() << "pass a new level,userPassLevekNumber++";
    if(!sql_query.exec(update_sql))
    {
        qDebug()<<sql_query.lastError();
    }
    else{
        while(sql_query.next()){
            name = sql_query.value(0).toString();
            if(name == user_name){
                sql_query.bindValue(4,++m_userPassLevelNumber);
                qDebug()<<QString("chatid=%1    passwd=%2     name=%3   userPassLevelNumber=%4  history=%5").arg(usr_id).arg(usr_passwd).arg(usr_name).arg(m_userPassLevelNumber).arg(usr_history);

            }
        }
    }
}

//register

//注册输入完成，用户点击OK键
void Login::okBtn_clicked(QString pw1,QString pw2,QString Name)
{
    bool nameFlag=false;    //用户名有效标志
    bool passwdFlag=false;  //密码有效标志
    int newchatid=max_id+1;
    QString newpasswd=NULL;
    QString newname=NULL;
    int userPassLevelNumber = 0;
    //    QString newemail=ui->emailLineEdit->text();

    if(pw1==""||pw2=="")
    {
        passwdFlag=false;
    }
    else if(pw1 == pw2)    //两次密码相同
    {
        //newpasswd=ui->passwd1LineEdit->text();
        passwdFlag=true;
        qDebug() << "password right";
    }
    else
    {
        qDebug()<<"passwd err";
        passwdFlag=false;
        //return;
    }

    //以下为数据库的操作
    QSqlQuery sql_query;

    //查询最大id
    max_id = 0;
    sql_query.prepare(select_max_sql);
    if(!sql_query.exec())
    {
        qDebug()<<sql_query.lastError();
    }
    else
    {
        while(sql_query.next())    //检索结果中的下一个数据
        {
            max_id = sql_query.value(0).toInt();
            qDebug()<<QString("max chatid:%1").arg(max_id);
        }
    }


    //查询部分数据(name)
    if(!sql_query.exec(select_sql))
    {
        qDebug()<<sql_query.lastError();
    }
    else
    {
        while(1)
        {
            if(sql_query.next())    //name有数据
            {
                QString name = sql_query.value(0).toString();
                qDebug()<<QString("name=%1").arg(name);

                if(Name==name)    //用户名已经存在
                {
                    qDebug()<<"name existed";
                    nameFlag=false;
                    break;
                }
                else
                {
                    newname=Name;
                    nameFlag=true;
                }
            }
            else
            {       //name列为空
                nameFlag=true;
                break;
            }
        }
    }

    // 设置ID
    newchatid=max_id+1;
    if(nameFlag==true){
        newname=Name;
        m_registerSuccess = true;
    }
    else{
        m_registerSuccess = false;
        return;
    }
    if(passwdFlag==true){
        m_registerSuccess = true;
        newpasswd=pw1;
    }
    else{
        m_registerSuccess = false;
        return;
    }

    //插入数据
//    sql_query.prepare("insert into user(id,passed,name,userPassLevelNumber,history)"
//                      "values(:id,:passwd,:name,:userPassLevelNumber,history)");

//    sql_query.bindValue(":id",newchatid);
//    sql_query.bindValue(":passwd",newpasswd);
//    sql_query.bindValue(":name",newname);
//    sql_query.bindValue(":userPassLevelNumber",userPassLevelNumber);
//    sql_query.bindValue(":history",0);

    sql_query.prepare(insert_sql);
    sql_query.addBindValue(newchatid);              //chatid
    sql_query.addBindValue(newpasswd);              //passwd
    sql_query.addBindValue(newname);                //name
    sql_query.addBindValue(userPassLevelNumber);    //userPassLevelNumber
    //    sql_query.addBindValue(newemail);               //email
    sql_query.addBindValue(0);                      //history

    if(!sql_query.exec())
    {
        qDebug()<<sql_query.lastError();
    }
    else
    {
        qDebug()<<"inserted!";
    }

}

void Login::receivedb()
{
    qDebug()<<"received db";
    database1=database;
    if(!database1.isOpen())

    {
        if(!database1.open())
        {
            qDebug()<<database1.lastError();
            qFatal("failed to connect.") ;
            return;
        }
        else
        {
        }
    }

}

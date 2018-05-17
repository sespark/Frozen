#ifndef LOGIN_H
#define LOGIN_H

//#include "register.h"

#include <QObject>
#include <QtSql>

class Login : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool loginClicked READ loginClicked WRITE setLoginClicked NOTIFY loginClickedChanged)   //登录按钮是否点击变量
    Q_PROPERTY(bool registerClicked READ registerClicked WRITE setRegisterClicked NOTIFY registerClickedChanged)
    // 注册按钮是否点击变量
    Q_PROPERTY(QString userPassword READ userPassword WRITE setUserPassword NOTIFY userPasswordChanged)

    // 存放assword的变量
    Q_PROPERTY(bool isLogin READ isLogin WRITE setIsLogin NOTIFY isloginChanged)
    Q_PROPERTY(int userID READ userID WRITE setUserID NOTIFY userIDChanged)


    Q_PROPERTY(QString userName READ userName  NOTIFY userNameChanged)
    Q_PROPERTY(int userPassLevelNumber READ userPassLevelNumber WRITE setUserPassLevelNumber NOTIFY userPassLevelNumberChanged)

    //register
    Q_PROPERTY(bool oKClicked READ oKClicked WRITE setOKClicked NOTIFY oKClickedChanged)
    Q_PROPERTY(bool registerSuccess READ registerSuccess WRITE setRegisterSuccess NOTIFY registerSuccessChanged)

public:
    explicit Login(QObject *parent = nullptr);

    QString usr_name;
    //    bool m_logIn = false;

    //method
    //    Q_INVOKABLE void login();
    Q_INVOKABLE void register_clicked(); //注册按键槽函数
    Q_INVOKABLE void login_clicked(QString text);    //登录按键槽函数
    Q_INVOKABLE void getUserInfo(QString name);
    Q_INVOKABLE void receivedb();
    Q_INVOKABLE void okBtn_clicked(QString pw1, QString pw2,QString name);
    Q_INVOKABLE void addPassLevelNumber();

    //setting
    Q_INVOKABLE void setLoginClicked(bool l){m_loginClicked = l;loginClickedChanged();}
    Q_INVOKABLE void setRegisterClicked(bool r){m_registerClicked = r;registerClickedChanged();}
    Q_INVOKABLE void setUserPassword(QString p){usr_passwd = p;userPasswordChanged();}
    Q_INVOKABLE void setIsLogin(bool l){m_logIn = l;emit isloginChanged();}
    Q_INVOKABLE void setUserID(int id){usr_id = id;emit userIDChanged();}

    Q_INVOKABLE void setUserPassLevelNumber(int number){m_userPassLevelNumber = number;emit userPassLevelNumberChanged();}

    Q_INVOKABLE void setOKClicked(bool l){m_oKClicked = l;emit oKClicked();}
    Q_INVOKABLE void setRegisterSuccess(bool s){m_registerSuccess = s;emit registerSuccessChanged();}


    //getting
    Q_INVOKABLE bool loginClicked(){return m_loginClicked;}
    Q_INVOKABLE bool registerClicked(){return m_registerClicked;}
    Q_INVOKABLE QString userPassword(){return usr_passwd;}
    Q_INVOKABLE bool isLogin(){return m_logIn;}
    Q_INVOKABLE int userID(){return usr_id;}

    Q_INVOKABLE QString userName(){return usr_name;}
    Q_INVOKABLE int userPassLevelNumber(){return m_userPassLevelNumber;}

    Q_INVOKABLE bool oKClicked(){return m_oKClicked;}
    Q_INVOKABLE bool registerSuccess(){return m_registerSuccess;}

signals:
//    void transmitdb(QSqlDatabase db);
    void loginClickedChanged();
    void registerClickedChanged();
    void userPasswordChanged();
    void isloginChanged();
    void userNameChanged();
    void userIDChanged();
    void oKClickedChanged();
    void registerSuccessChanged();
    void userPassLevelNumberChanged();
    //private slots:
    //    void register_clicked();    //注册按键槽函数
    //    void getUserInfo(QString name);
    //    void login_clicked();   //登录按键槽函数

private:
    //register
    bool tableFlag;
    int max_id;
    bool m_oKClicked = false;
    QSqlDatabase database1;
    bool m_registerSuccess = false;
    //QSqlQuery类提供执行和操作的SQL语句的方法。
    //可以用来执行DML（数据操作语言）语句，如SELECT、INSERT、UPDATE、DELETE，
    //以及DDL（数据定义语言）语句，例如CREATE TABLE。
    //也可以用来执行那些不是标准的SQL的数据库特定的命令。


    //login
    QSqlDatabase database;
    bool usrtableFlag;
    bool rectableFlag;
    bool m_loginClicked = false;
    bool m_registerClicked = false;
    //    int m_userPassword;
    bool m_logIn = false;
//    Register m_register = new Register;

    int usr_id;
    QString usr_passwd;

    QString user_name;
    int m_userPassLevelNumber;

    //    QString usr_email;
    int usr_history;
    bool matchFlag;

    QString select_table = "select tbl_name name from sqlite_master where type = 'table'";
    QString create_sql = "create table user (chatid int primary key, passwd varchar(30), name varchar(30), userPassLevelNumber int,history int)";
    QString create_sql1 = "create table record (name varchar(30), record varchar(512))";
    QString select_max_sql = "select max(chatid) from user";
    QString insert_sql = "insert into user values (?,?,?,?,?)";
    QString update_sql = "update user set userPassLevelNumber = :userPassLevelNumber where chatid = :chatid";
    QString select_sql = "select name from user";
    //QString select_all_sql = "select * from user";
    //QString delete_sql = "delete from user where chatid = ?";
    //QString clear_sql = "delete from user";

    QString select_nameInfo = "selcet * from user wher name=";


};

#endif // LOGIN_H

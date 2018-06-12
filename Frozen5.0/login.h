#ifndef LOGIN_H
#define LOGIN_H

//#include "register.h"

#include <QObject>
#include <QtSql>
#include <string>

using std::string;

class Login : public QObject
{
    Q_OBJECT
    // 注册按钮是否点击变量
    Q_PROPERTY(QString userPassword READ userPassword WRITE setUserPassword NOTIFY userPasswordChanged)
    // 存放usr_passwd的变量
    Q_PROPERTY(bool isLogin READ isLogin WRITE setIsLogin NOTIFY isloginChanged)
    // 存放usr_id的变量
    Q_PROPERTY(int userID READ userID WRITE setUserID NOTIFY userIDChanged)
    // 存放user_name的变量
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    // 存放m_userPassLeveNumber的变量
    Q_PROPERTY(int userPassLevelNumber READ userPassLevelNumber WRITE setUserPassLevelNumber NOTIFY userPassLevelNumberChanged)

    //register
    // 存放m_nameFlag的变量
    Q_PROPERTY(bool nameFlag READ nameFlag WRITE setNameFlag NOTIFY nameFlagChanged)
    //存放m_passwdFlag的变量
    Q_PROPERTY(bool passwdFlag READ passwdFlag WRITE setPasswdFlag NOTIFY passwdFlagChanged)
    //存放m_registerSuccess的变量
    Q_PROPERTY(bool registerSuccess READ registerSuccess WRITE setRegisterSuccess NOTIFY registerSuccessChanged)
    //存放m_logining的变量
    Q_PROPERTY(bool logining READ logining WRITE setLogining NOTIFY loginingChanged)

public:
    explicit Login(QObject *parent = nullptr);

    //    bool m_logIn = false;

    //method
    Q_INVOKABLE void login_clicked(QString text);    //登录按键函数
    Q_INVOKABLE void getUserInfo(QString name);
    Q_INVOKABLE void receivedb();
    Q_INVOKABLE void okBtn_clicked(QString pw1, QString pw2,QString name);
    Q_INVOKABLE void addUserPassLevelNumber();

    //setting Method
//    Q_INVOKABLE void setUsername(QString name);
//    Q_INVOKABLE void setUserpassWord(QString pw);


    //setting
    Q_INVOKABLE void setUserPassword(QString p){usr_passwd = p;userPasswordChanged();}
    Q_INVOKABLE void setUserID(int id){usr_id = id;emit userIDChanged();}
    Q_INVOKABLE void setUserName(QString name){user_name = name;emit userNameChanged();}
    Q_INVOKABLE void setUserPassLevelNumber(int number){m_userPassLevelNumber = number;emit userPassLevelNumberChanged();}

    Q_INVOKABLE void setIsLogin(bool l){m_isLogIn = l;emit isloginChanged();}
    Q_INVOKABLE void setNameFlag(bool l){m_nameFlag = l;emit nameFlagChanged();}
    Q_INVOKABLE void setPasswdFlag(bool l){m_passwdFlag = l;emit passwdFlagChanged();}
    Q_INVOKABLE void setLogining(bool l){m_logining = l;emit loginingChanged();}
    Q_INVOKABLE void setRegisterSuccess(bool l){m_registerSuccess = l;emit registerSuccessChanged();}

    //getting
    Q_INVOKABLE QString userPassword(){return usr_passwd;}
    Q_INVOKABLE bool isLogin(){return m_isLogIn;}
    Q_INVOKABLE int userID(){return usr_id;}
    Q_INVOKABLE QString userName(){return user_name;}
    Q_INVOKABLE int userPassLevelNumber(){return m_userPassLevelNumber;}
    Q_INVOKABLE bool registerSuccess(){return m_registerSuccess;}
    Q_INVOKABLE bool nameFlag(){return m_nameFlag;}
    Q_INVOKABLE bool passwdFlag(){return m_passwdFlag;}
    Q_INVOKABLE bool logining(){return m_logining;}

signals:
    void userPasswordChanged();
    void isloginChanged();
    void userNameChanged();
    void userIDChanged();
    void userPassLevelNumberChanged();
    void nameFlagChanged();
    void passwdFlagChanged();
    void loginingChanged();
    void registerSuccessChanged();

private:
    //register
    bool tableFlag;
    int max_id;
    QSqlDatabase database1;


    //QSqlQuery类提供执行和操作的SQL语句的方法。
    //可以用来执行DML（数据操作语言）语句，如SELECT、INSERT、UPDATE、DELETE，
    //以及DDL（数据定义语言）语句，例如CREATE TABLE。
    //也可以用来执行那些不是标准的SQL的数据库特定的命令。


    //login
    QSqlDatabase database;
    bool usrtableFlag;                 // user表是否已经存在
    bool m_isLogIn = false;            // 登录成功标志
    bool m_registerSuccess = false;    // 注册成功标志
    bool m_nameFlag = false;           //用户名有效标志,//用户名是否相匹配
    bool m_passwdFlag = false;         //密码有效标志
    bool m_logining = false;           //当前是否已经登录

    int usr_id;
    QString usr_passwd;
    QString user_name;
    int m_userPassLevelNumber;

};

#endif // LOGIN_H

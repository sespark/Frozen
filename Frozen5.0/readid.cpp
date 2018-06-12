#include "readid.h"
#include <fstream>
#include <sstream>
#include <iostream>
#include <string>

using std::string;
using std::ifstream;
using std::ofstream;
using std::stringstream;
using std::endl;

ReadID::ReadID(QObject *parent)
    :QObject(parent)
{
    ifstream in("Frozen_Config");

    string str;
    if(std::getline(in,str) && str !=""){
        m_hasUserInfo = true;

        //        int tmp;
        //        stringstream s(str);
        //        s >> tmp;
        //        m_levelID = tmp;
        //        if(std::getline(in,str)){
        string name;
        stringstream ss(str);
        ss >> name;
        m_userName = QString::fromStdString(name);
        //        }
        if(std::getline(in,str)){
            string password;
            stringstream sss(str);
            sss >> password;
            m_userPassWord = QString::fromStdString(password);
        }
        in.close();
    }else{
        m_hasUserInfo = false;


        ofstream out("Frozen_Config");
//        m_levelID = 0;
        m_userName ="";
        m_userPassWord = "";
//        out << m_levelID << endl;
        out << m_userName.toStdString() << endl;
        out << m_userPassWord.toStdString() << endl;
        out.close();
    }
}

//int ReadID::levelID()
//{
//    return m_levelID;
//}


//void ReadID::setLevelID(int i)
//{
//    ofstream out("Frozen_Config");

//    m_levelID = i;
//    out << m_levelID << endl;
//    emit levelIDChanged();
//}

void ReadID::setUsername(QString name)
{
    ofstream out("Frozen_Config",ofstream::app);
    m_userName = name;
    out << m_userName.toStdString()<< endl;
    emit userNameChanged();

}

void ReadID::setUserpassWord(QString pw)
{
    ofstream out("Frozen_Config",ofstream::app);
    m_userPassWord = pw;
    out << m_userPassWord.toStdString() << endl;
    emit userPassWordChanged();

}

void ReadID::setUserPassWord(QString pw)
{
    ofstream out("Frozen_Config",ofstream::app);
    m_userPassWord = pw;
    out << m_userPassWord.toStdString() << endl;
    emit userPassWordChanged();
}

void ReadID::setUserName(QString name)
{
    ofstream out("Frozen_Config");
    m_userName = name;
    out << m_userName.toStdString() << endl;
    emit userNameChanged();
}

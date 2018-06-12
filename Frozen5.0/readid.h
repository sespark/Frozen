#ifndef READID_H
#define READID_H

#include <QObject>
#include <string>

using std::string;

class ReadID : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(int levelID READ levelID WRITE setLevelID NOTIFY levelIDChanged)
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString userPassWord READ userPassWord WRITE setUserPassWord NOTIFY userPassWordChanged)
    Q_PROPERTY(bool hasUserInfo READ hasUserInfo WRITE setHasUserInfo NOTIFY hasUserInfoChanged)
public:

    explicit ReadID(QObject *parent = nullptr);

    //getting
//    int levelID();
    QString userPassWord(){return m_userPassWord;}
    QString userName(){return m_userName;}
    bool hasUserInfo(){return m_hasUserInfo;}

    //setting Method
    Q_INVOKABLE void setUsername(QString name);
    Q_INVOKABLE void setUserpassWord(QString pw);


    //setting
//    void setLevelID(int i);
    void setUserPassWord(QString pw);
    void setUserName(QString name);
    void setHasUserInfo(bool l){m_hasUserInfo = l;emit hasUserInfoChanged();}

signals:
//    void levelIDChanged();
    void userPassWordChanged();
    void userNameChanged();
    void hasUserInfoChanged();

private:
//    int m_levelID;
    QString m_userPassWord;
    QString m_userName;

    bool m_hasUserInfo = false;
};

#endif // READID_H

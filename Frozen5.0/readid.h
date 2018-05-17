#ifndef READID_H
#define READID_H

#include <QObject>
#include <string>

using std::string;

class ReadID : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int levelID READ levelID WRITE setLevelID NOTIFY levelIDChanged)

public:

    explicit ReadID(QObject *parent = nullptr);

    //getting
    int levelID();

    //setting
    void setLevelID(int i);
signals:
    void levelIDChanged();

private:
    int m_levelID;
};

#endif // READID_H

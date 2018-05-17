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
    ifstream in("config");

    string str;
    if(std::getline(in,str)){
        int tmp;
        stringstream s(str);
        s >> tmp;
        m_levelID = tmp;
        in.close();
    }else{
        ofstream out("config");
        m_levelID = 0;
        out << m_levelID << endl;
        out.close();
    }
}

int ReadID::levelID()
{
    return m_levelID;
}

void ReadID::setLevelID(int i)
{
    ofstream out("config");

    m_levelID = i;
    out << m_levelID << endl;
    emit levelIDChanged();
}

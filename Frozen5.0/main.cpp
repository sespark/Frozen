#include <QApplication>
#include <VPApplication>
#include <QQmlApplicationEngine>

#include "login.h"
#include "readid.h"

int main(int argc, char *argv[])
{

  QApplication app(argc, argv);

  qmlRegisterType<Login>("Login",1,0,"Login");
  qmlRegisterType<ReadID>("ReadID",1,0,"ReadID");

  VPApplication vplay;
  QQmlApplicationEngine engine;
  vplay.initialize(&engine);
  vplay.setMainQmlFileName(QStringLiteral("qml/PlatformerWithLevelEditorMain.qml"));

  engine.load(QUrl(vplay.mainQmlFileName()));

  return app.exec();
}


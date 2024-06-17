#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickView>
#include <QFile>
#include <QGuiApplication>
#include <qqmlapplicationengine.h>
#include <QtDebug>
#include <QQmlContext>
#include "QObjects/AddSyncModule.h"


int main(int argc, char* argv[]){
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:/qml/screens/MainWindow.qml"));
    qmlRegisterType<AddSyncModule>("user.QObjects",1,0,"AddSyncModule");
    QObject* root_obj = engine.rootObjects().first();
    qDebug() << root_obj->children();
    QObject* addSyncModuleWindow = root_obj->findChild<QObject *>("addSyncModuleWindow");
    qDebug() << addSyncModuleWindow;
    AddSyncModule* addSyncModule = new AddSyncModule(addSyncModuleWindow);
    qDebug() << addSyncModule;
    return app.exec();
}


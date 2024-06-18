#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickView>
#include <QFile>
#include <QGuiApplication>
#include <QQmlapplicationengine.h>
#include <QtDebug>
#include <QQmlContext>
#include "QObjects/MainWindow.h"

AddSyncModule* addSyncModule;
MainWindow* mainWindow;


void instantiateObjects(QQmlApplicationEngine& engine){
    QObject* root_obj = engine.rootObjects().first();
    qDebug() << root_obj->children();
    QObject* addSyncModuleWindow = root_obj->findChild<QObject *>("addSyncModuleWindow");
    qDebug() << addSyncModuleWindow;
    addSyncModule = new AddSyncModule(addSyncModuleWindow);
    mainWindow = new MainWindow(root_obj, addSyncModule);
    qDebug() << addSyncModule;
}
int main(int argc, char* argv[]){
    QGuiApplication app(argc, argv);
    qmlRegisterType<AddSyncModule>("user.QObjects",1,0,"AddSyncModule");
    QQmlApplicationEngine engine(QUrl("qrc:/qml/screens/MainWindow.qml"));
    instantiateObjects(engine);
    return app.exec();
}


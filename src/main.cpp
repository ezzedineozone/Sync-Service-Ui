#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickView>
#include <QFile>
#include <QGuiApplication>
#include <QQmlapplicationengine.h>
#include <QtDebug>
#include <QQmlContext>
#include "QObjects/MainWindow.h"
#include "dependencies/json/json.hpp"
#include "dependencies/asio/asio.hpp"
#include "tcp_client.h"


AddSyncModule* addSyncModule;
MainWindow* mainWindow;
TcpClient* client;
int service_started;


int instantiateObjects(const QQmlApplicationEngine& engine){
    QObject* root_obj = engine.rootObjects().first();
    qDebug() << root_obj->children();
    QObject* addSyncModuleWindow = root_obj->findChild<QObject *>("addSyncModuleWindow");
    qDebug() << addSyncModuleWindow;
    addSyncModule = new AddSyncModule(addSyncModuleWindow);
    mainWindow = new MainWindow(root_obj, addSyncModule);
    QObject* syncTable = mainWindow->qObj->findChild<QObject*>("syncTable");
    return 1;
}
int connect_to_service(){
    client = new TcpClient("127.0.0.1","13");
    service_started = client->start_connection();
    return service_started;
}
int startup_routine(const QQmlApplicationEngine& engine)
{
    int objects_instantiated = instantiateObjects(engine);
    int service_connected = connect_to_service();
    return objects_instantiated & service_connected;
}
int main(int argc, char* argv[]){
    QGuiApplication app(argc, argv);
    qmlRegisterType<AddSyncModule>("user.QObjects",1,0,"AddSyncModule");
    QQmlApplicationEngine engine(QUrl("qrc:/qml/screens/MainWindow.qml"));
    int startup_routine_success = startup_routine(engine);
    if(!startup_routine_success)
    {
    }
    return app.exec();
}


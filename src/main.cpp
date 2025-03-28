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


MainWindow* mainWindow;
std::vector<SyncModule*> modules;
int service_started;


int instantiateObjects(const QQmlApplicationEngine& engine){
    QObject* root_obj = engine.rootObjects().first();
    qDebug() << root_obj->children();
    QObject* addSyncModuleWindowQObj = root_obj->findChild<QObject *>("addSyncModuleWindow");
    qDebug() << addSyncModuleWindowQObj;
    AddSyncModule* addSyncModule = new AddSyncModule(addSyncModuleWindowQObj);
    QObject* syncTableQObj = root_obj->findChild<QObject *>("syncTable");
    QObject* error_modal = root_obj->findChild<QObject *>("modal_error");
    ErrorModal* modal = new ErrorModal(error_modal);
    SyncTable* table = new SyncTable(syncTableQObj, modules);
    QObject* ptr_prorgress_bar = root_obj->findChild<QObject*>("progress_bar_");
    mainWindow = new MainWindow(root_obj, addSyncModule, table, modal);
    return 1;
}
int startup_routine(const QQmlApplicationEngine& engine)
{
    int objects_instantiated = instantiateObjects(engine);
    int service_connected_started = mainWindow->onConnectToService();
    return objects_instantiated & service_connected_started;
}
int check_boolean(bool bl){

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


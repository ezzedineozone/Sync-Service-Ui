#ifndef Included_MAINWINDOW_H

#define Included_MAINWINDOW_H

#include <QObject>
#include <cstring>
#include <QtDebug>
#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QString>
#include "../helper.h"
#include "AddSyncModule.h"
#include "SyncTable.h"
#include "../tcp_client.h"
#include <QFuture>
#include <QtConcurrent/QtConcurrent>
class MainWindow : public QObject
{
    Q_OBJECT
private:

public:
    QObject* qObj;
    AddSyncModule* addSyncModule;
    SyncTable* syncTable;
    MainWindow(QObject* obj, AddSyncModule* module, SyncTable* table): qObj(obj), addSyncModule(module), syncTable(table){
        const QMetaObject* metaObj = obj->metaObject();
        char* className = new char[strlen(metaObj->className()) - 2];
        helper::getQmlClasstype(obj, className);
        qDebug() << addSyncModule->qObj;
        if(!strcmp(className,"MainWindow_QMLTYPE")){
            qDebug() << " mainwindow Correct type passed";
            QMetaObject::Connection connection = QObject::connect(obj,SIGNAL(addButtonClicked()),addSyncModule,SIGNAL(openSignal()));
            QMetaObject::Connection connection2 = QObject::connect(addSyncModule->qObj, SIGNAL(done()), this, SLOT(onDone()));
            QMetaObject::Connection connection3 = QObject::connect(qObj, SIGNAL(connectToService()), this, SLOT(onConnectToService()));
            QMetaObject::Connection connection4 = QObject::connect(this, SIGNAL(serviceConnected()), obj, SIGNAL(serviceConnected()));
            QMetaObject::Connection connection5 = QObject::connect(this, SIGNAL(serviceConnected()),table, SIGNAL(serviceConnected()));
            if(!connection2)
                qDebug() << "failed to connect signals";
        }
        else {
            qDebug() << "incorrect type passed";
        }
    }
signals:
    void serviceConnected();
public slots:
    int onDone(){
        return 1;
    }
    int onConnectToService(){
        QFuture<int> future = QtConcurrent::run([=]() {
            TcpClient& client = TcpClient::get_instance("127.0.0.1", "13");
            TcpClient::connect_objects(syncTable, addSyncModule);
            int connection_started = client.start_connection();
            return connection_started;
        });
        QFutureWatcher<int>* watcher = new QFutureWatcher<int>(this);
        connect(watcher, &QFutureWatcher<int>::finished, [=]() {
            int connection_started = watcher->result();
            if (connection_started) {
                emit serviceConnected();
            } else {
                qDebug() << "Something went wrong connecting to the service";
            }
            watcher->deleteLater();
        });
        watcher->setFuture(future);
    }
};
#endif


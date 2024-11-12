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
#include "ErrorModal.h"
#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include "thread"
class MainWindow : public QObject
{
    Q_OBJECT
private:

public:
    QObject* qObj;
    AddSyncModule* addSyncModule;
    SyncTable* syncTable;
    ErrorModal* modal;
    MainWindow(QObject* obj, AddSyncModule* module, SyncTable* table, ErrorModal* modal): qObj(obj), addSyncModule(module), syncTable(table), modal(modal){
        const QMetaObject* metaObj = obj->metaObject();
        std::string className = helper::getQmlClasstype(obj);
        qDebug() << className;
        int result = (className == "MainWindow_QMLTYPE");
        if(result){
            qDebug() << " mainwindow Correct type passed";
            QMetaObject::Connection connection = QObject::connect(obj,SIGNAL(addButtonClicked()),addSyncModule,SIGNAL(openSignal()));
            QMetaObject::Connection connection2 = QObject::connect(addSyncModule->qObj, SIGNAL(done()), this, SLOT(onDone()));
            QMetaObject::Connection connection3 = QObject::connect(qObj, SIGNAL(connectToService()), this, SLOT(onConnectToService()));
            QMetaObject::Connection connection4 = QObject::connect(this, SIGNAL(serviceConnected()), obj, SIGNAL(serviceConnected()));
            QMetaObject::Connection connection5 = QObject::connect(this, SIGNAL(serviceConnected()),table, SIGNAL(serviceConnected()));
            QMetaObject::Connection connection6 = QObject::connect(this, SIGNAL(serviceConnected()),this, SLOT(onServiceConnected()));
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
    int onServiceConnected()
    {
        std::thread read_thread([this]{
            TcpClient& client = TcpClient::get_instance("127.0.0.1", "13");
            client.start_reading();
        });
        read_thread.detach();
        return 1;
    }
    int onConnectToService() {
        TcpClient& client = TcpClient::get_instance("127.0.0.1", "13");
        TcpClient::connect_objects(syncTable, addSyncModule, modal);
        std::thread connection_start_thread([this, &client]{
            int connection_started = client.start_connection();
            if(connection_started)
                emit serviceConnected();
        });
        connection_start_thread.detach();
        return 0;
    }
};
#endif


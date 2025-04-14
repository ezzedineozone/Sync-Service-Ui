#ifndef SYNCTABLE_H

#define SYNCTABLE_H
#include "../tcp_client.h"
#include <QObject>
#include <cstring>
#include <QtDebug>
#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QString>
#include "../helper.h"
#include "../sync_module.h"
#include <filesystem>

namespace  fs = std::filesystem;
class SyncTable : public QObject
{
    Q_OBJECT
private:

public:
    QObject* qObj;
    
    std::vector<SyncModule*>& modules;
    SyncTable(QObject* obj, std::vector<SyncModule*>& modules): qObj(obj), modules(modules){
        const QMetaObject* metaObj = qObj->metaObject();
        std::string className = helper::getQmlClasstype(obj);
        qDebug() << className;
        int result = (className == "SyncTable_QMLTYPE");
        QMetaObject::Connection connection = QObject::connect(this, SIGNAL(serviceConnected()),this, SLOT(onServiceConnected()));
        QMetaObject::Connection connection3 = QObject::connect(this, SIGNAL(moduleAdded(QString, QString, QString, QString, QString)),qObj, SIGNAL(moduleAdded(QString, QString , QString , QString , QString)));
        QMetaObject::Connection connection2 = QObject::connect(this, SIGNAL(modulesFetched(std::vector<SyncModule*>)), this, SLOT(onModulesFetched(std::vector<SyncModule*>)));;
        QMetaObject::Connection connection4 = QObject::connect(this, SIGNAL(modifyCompletion(QString, double)), qObj, SIGNAL(modifyCompletion(QString, double)));
        QMetaObject::Connection connection5 = QObject::connect(this, SIGNAL(modifyStatus(QString, QString)), qObj, SIGNAL(modifyStatus(QString, QString)));
        QMetaObject::Connection connection6 = QObject::connect(qObj, SIGNAL(moduleDelete(QString)), this, SLOT(onModuleDelete(QString)));
        QMetaObject::Connection connection7 = QObject::connect(this, SIGNAL(moduleDeleted(QString)), this, SLOT(onModuleDeleted(QString)));
        QMetaObject::Connection connection8 = QObject::connect(this, SIGNAL(moduleDeleted(QString)), qObj, SIGNAL(moduleDeleted(QString)));
        QMetaObject::Connection connection9 = QObject::connect(qObj, SIGNAL(moduleEdit(QString, QString, QString, QString, QString)), this, SLOT(onModuleEdit(QString, QString, QString, QString, QString)));
        QMetaObject::Connection connection10 = QObject::connect(qObj, SIGNAL(moduleSync(QString)), this, SIGNAL(moduleSync(QString)));
        QMetaObject::Connection connection11 = QObject::connect(this, SIGNAL(moduleSync(QString)), this, SLOT(onModuleSync(QString)));
        if(result){
            qDebug() << " synctable Correct type passed";
        }
        else {
            qDebug() << "incorrect type passed";
        }
        emit modifyCompletion("module10", 0.7);
        emit modifyStatus("module10", "paused");
        emit modifyStatus("module7", "active");
        emit modifyCompletion("module11", 0.3);
    }
signals:
    void modulesFetched(std::vector<SyncModule*> init_modules);
    void serviceConnected();
    void moduleAdded(QString name, QString source, QString destination, QString type, QString direction);
    void moduleDelete(QString name);
    void moduleDeleted(QString name);
    void modifyCompletion(QString name, double value);
    void modifyStatus(QString name, QString status);
    void moduleSync(QString name);

public slots:
    void onServiceConnected(){
    };
    void onModulesFetched(std::vector<SyncModule*> init_modules){
        for(SyncModule* module : init_modules)
        {
            this->modules.push_back(module);
            emit moduleAdded(
                QString::fromStdString(module->name),                // Assuming name is a std::string
                QString::fromUtf8(module->source.u8string().c_str()), // Assuming source is a std::filesystem::path
                QString::fromUtf8(module->destination.u8string().c_str()), // Assuming destination is a std::filesystem::path
                QString::fromStdString(module->type),                // Assuming type is a std::string
                QString::fromStdString(module->direction)
            );
        }
        emit modifyCompletion(QString::fromStdString(std::string("Module8")),0.8);
    };
    void onModuleAdded(QString name, QString source, QString destination, QString type, QString direction){
        qDebug() << "Module added from QML";
    }
    void onModuleDeleted(QString name){
        qDebug() << "Module deleted from QML";
        for(auto it = modules.begin(); it != modules.end(); ++it) {
            if((*it)->name == name.toStdString()) {
                delete *it;
                modules.erase(it);
                break;
            }
        }
        qDebug() << "Module deleted from SyncTable";
    }
    void onModuleDelete(QString name){
        TcpClient& client = TcpClient::get_instance("127.0.0.1","13");
        client.notify_removal(name.toStdString());
        qDebug() << "Module deleted from QML";
    }
    void onModuleEdit(QString name, QString source, QString destination, QString type, QString direction){
        TcpClient& client = TcpClient::get_instance("127.0.0.1","13");
        // SyncModule module(name.toStdString(), source.toStdString(), destination.toStdString(), type.toStdString(), direction.toStdString());
        std::unique_ptr<SyncModule> module = std::make_unique<SyncModule>(name.toStdString(), source.toStdString(), destination.toStdString(), type.toStdString(), direction.toStdString());
        client.notify_edit(name.toStdString(), std::move(module));
        qDebug() << "Module edit request sent from QML";
    }
    void onModuleSync(QString name){
        TcpClient& client = TcpClient::get_instance("127.0.0.1","13");
        client.request_sync(name.toStdString());
        qDebug() << "Module sync request sent from QML";
    }
};


#endif


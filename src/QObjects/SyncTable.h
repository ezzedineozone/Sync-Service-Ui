#ifndef SYNCTABLE_H

#define SYNCTABLE_H

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
        if(result){
            qDebug() << " synctable Correct type passed";
        }
        else {
            qDebug() << "incorrect type passed";
        }
        for (int i = 0; i < 5; ++i) {
            emit moduleAdded("Module" + QString::number(i + 1),
                             "Source" + QString::number(i + 1),
                             "Destination" + QString::number(i + 1),
                             "Type" + QString::number(i + 1),
                             "Direction" + QString::number(i + 1));
        }
        QObject* tableView = qObj->findChild<QObject*>("loader");
        emit modifyCompletion("module10", 0.7);
        emit modifyStatus("module10", "paused");
        emit modifyStatus("module7", "error");
    }
signals:
    void modulesFetched(std::vector<SyncModule*> init_modules);
    void serviceConnected();
    void moduleAdded(QString name, QString source, QString destination, QString type, QString direction);
    void modifyCompletion(QString name, double value);
    void modifyStatus(QString name, QString status);

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


};


#endif


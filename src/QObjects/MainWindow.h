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
#include "iostream"
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
        if(!strcmp(className,"MainWindow_QMLTYPE")){
            qDebug() << " mainwindow Correct type passed";
            QMetaObject::Connection connection = QObject::connect(obj,SIGNAL(addButtonClicked()),addSyncModule,SIGNAL(openSignal()));
            QMetaObject::Connection connection2 = QObject::connect(addSyncModule->qObj, SIGNAL(done()), this, SLOT(onDone()));
        }
        else {
            qDebug() << "incorrect type passed";
        }
    }
public slots:
    int onDone(){
        // int module_added = syncTable->add_module();
        std::cout << "added signal done";
    }
};


#endif


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
class MainWindow : public QObject
{
    Q_OBJECT
private:

public:
    QObject* qObj;
    AddSyncModule* addSyncModule;
    MainWindow(QObject* obj, AddSyncModule* module){
        const QMetaObject* metaObj = obj->metaObject();
        qObj = obj;
        char* className = new char[strlen(metaObj->className()) - 2];
        helper::getQmlClasstype(obj, className);
        addSyncModule = module;
        qDebug() << className;
        if(!strcmp(className,"MainWindow_QMLTYPE")){
            qDebug() << "Correct type passed";
            QMetaObject::Connection connection = QObject::connect(obj,SIGNAL(addButtonClicked()),addSyncModule,SIGNAL(openSignal()));
        }
        else {
            qDebug() << "incorrect type passed";
        }
    }
};


#endif


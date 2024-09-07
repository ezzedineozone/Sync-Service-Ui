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
class SyncTable : public QObject
{
    Q_OBJECT
private:

public:
    QObject* qObj;
    SyncTable(QObject* obj){
        const QMetaObject* metaObj = obj->metaObject();
        qObj = obj;
        char* className = new char[strlen(metaObj->className()) - 2];
        helper::getQmlClasstype(obj, className);
        qDebug() << className;
        if(!strcmp(className,"SyncTable_QMLTYPE")){
            qDebug() << " synctable Correct type passed";
        }
        else {
            qDebug() << "incorrect type passed";
        }
    }
    Q_INVOKABLE int add_module(const QString& qmlObjectName, const QString& syncId, const QString& type, const QString& direction, const QString& source, const QString& directory) {

        if (qObj) {
            // Call the addSyncModule function
            QMetaObject::invokeMethod(qObj, "addSyncModule", Q_ARG(QString, syncId), Q_ARG(QString, type), Q_ARG(QString, direction), Q_ARG(QString, source), Q_ARG(QString, directory));
        } else {
            qWarning() << "QML object not found";
        }
    }
};


#endif


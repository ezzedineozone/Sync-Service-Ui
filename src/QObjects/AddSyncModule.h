#include <QObject>
#include <cstring>
#include <QtDebug>
#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QString>
#include "../helper.h"
class AddSyncModule : public QObject
{
    Q_OBJECT
private:
    QString source;
    QString destination;
    QString type;
    QString direction;
public:
    AddSyncModule(QObject* obj){
        const QMetaObject* metaObj = obj->metaObject();
        char* className = helper::getQmlClasstype(obj);
        int result = strcmp(className,"AddSyncModule_QMLTYPE");
        if (result == 0)
        {
            qDebug() << "Correct type passed";
            QMetaProperty source_prop = metaObj->property(metaObj->indexOfProperty("source"));
            QMetaProperty destination_prop = metaObj->property(metaObj->indexOfProperty("destination"));
            QMetaProperty type_prop = metaObj->property(metaObj->indexOfProperty("type"));
            QMetaProperty direction_prop = metaObj->property(metaObj->indexOfProperty("direction"));
            setSource(QString(source_prop.read(obj).toString()));
            setDestination(QString(destination_prop.read(obj).toString()));
            setDirection(QString(direction_prop.read(obj).toString()));
            setType((type_prop.read(obj).toString()));
        }
        else
            qDebug() << "wrong type passed";
    }
    void setSource(QString source){
        this->source = source;
    }
    void setDestination(QString destination){
        this->destination = destination;
    }
    void setType(QString type){
        this->type = type;
    }
    void setDirection(QString direction){
        this->direction = direction;
    }
    QString getSource(){
        return source;
    }
    QString getDestination(){
        return destination;
    }
    QString getType(){
        return type;
    }
    QString getDirection(){
        return direction;
    }
};

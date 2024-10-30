#ifndef ERRORMODAL_H

#define ERRORMODAL_H

#include <QObject>
#include <QtDebug>
#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QString>
#include "../helper.h"
namespace  fs = std::filesystem;
class ErrorModal : public QObject
{
    Q_OBJECT
private:

public:
    QObject* qObj;
    ErrorModal(QObject* obj): qObj(obj){
        const QMetaObject* metaObj = qObj->metaObject();
        QMetaObject::Connection connection = QObject::connect(this, SIGNAL(errorThrow(QString)),this, SLOT(onErrorThrown(QString)));
    }
signals:
    void errorThrown(QString msg);
public slots:
    void onErrorThrown(QString msg){
        qObj->setProperty("visible", true);
        QObject* errorTextObj = qObj->findChild<QObject*>("generalErrorText");
        if (errorTextObj) {
            errorTextObj->setProperty("text", msg);
        } else {
            qDebug() << "Error: Could not find 'generalErrorText' child object.";
        }
    }
};


#endif


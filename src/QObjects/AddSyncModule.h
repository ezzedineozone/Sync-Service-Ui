#ifndef Included_ADDSYNCMODULE_H

#define Included_ADDSYNCMODULE_H


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
    QObject* qml_obj;
    const QMetaObject* meta_obj;


public:
        QObject* qObj;
    AddSyncModule(QObject* obj){
        const QMetaObject* metaObj = obj->metaObject();
        this->qObj = obj;
        char* className = new char[strlen(metaObj->className()) - 2];
        helper::getQmlClasstype(obj, className);
        qDebug() << className;
        int result = strcmp(className,"AddSyncModule_QMLTYPE");
        if (result == 0)
        {
            qml_obj = obj;
            meta_obj = metaObj;
            qDebug() << "Correct type passed";
            QObject::connect(this, SIGNAL(openSignal()),this, SLOT(onOpenSignal()));
            QObject::connect(obj, SIGNAL(done()), this, SLOT(onDone()));
            QObject::connect(obj, SIGNAL(cancel()), this, SLOT(onCancel()));
            QObject::connect(obj, SIGNAL(sourceFolderAccepted()), this, SLOT(onSourceFolderAccepted()));
            QObject::connect(obj, SIGNAL(destinationFolderAccepted()), this, SLOT(onDestinationFolderAccepted()));
            QObject::connect(obj, SIGNAL(typeSelected()), this, SLOT(onTypeSelected()));
            QObject::connect(obj, SIGNAL(directionSelected()), this, SLOT(onDirectionSelected()));
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

signals:
    void openSignal();
    void done();
    void cancel();
    void sourceFolderAccepted();
    void destinationFolderAccepted();
    void typeSelected();
    void directionSelected();
public slots:
    void onOpenSignal(){
        QMetaProperty visible_prop = meta_obj->property(meta_obj->indexOfProperty("visible"));
        visible_prop.write(qml_obj, true);
    };
    void onCancel(){
        QMetaProperty visible_prop = meta_obj->property(meta_obj->indexOfProperty("visible"));
        visible_prop.write(qml_obj, false);
    };
    void onSourceFolderAccepted()
    {
        QObject* sourceFolderDialog = qml_obj->findChild<QObject*>("source_folder_dialog");
        QObject* sourceInputBox = qml_obj->findChild<QObject*>("source_input");
        const QMetaObject* sourceFolderMeta = sourceFolderDialog->metaObject();
        const QMetaObject* sourceInputBoxMeta = sourceInputBox->metaObject();
        QMetaProperty selectedFolderProp = sourceFolderMeta->property(sourceFolderMeta->indexOfProperty("selectedFolder"));
        QMetaProperty sourceInputBoxTextProp = sourceInputBoxMeta->property(sourceInputBoxMeta->indexOfProperty("text"));
        QString sourceUrl = selectedFolderProp.read(sourceFolderDialog).toString();
        sourceInputBoxTextProp.write(sourceInputBox, sourceUrl.right(sourceUrl.length() - 8));
        this->source = sourceUrl;
    };
    void onDestinationFolderAccepted(){
        QObject* destinationFolderDialog = qml_obj->findChild<QObject*>("destination_folder_dialog");
        QObject* destinationInputBox = qml_obj->findChild<QObject*>("destination_input");
        const QMetaObject* destinationFolderMeta = destinationFolderDialog->metaObject();
        const QMetaObject* destinationInputBoxMeta = destinationInputBox->metaObject();
        QMetaProperty selectedFolderProp = destinationFolderMeta->property(destinationFolderMeta->indexOfProperty("selectedFolder"));
        QMetaProperty sourceInputBoxTextProp = destinationInputBoxMeta->property(destinationInputBoxMeta->indexOfProperty("text"));
        QString destinationUrl = selectedFolderProp.read(destinationFolderDialog).toString();
        sourceInputBoxTextProp.write(destinationInputBox, destinationUrl.right(destinationUrl.length() - 8));
        this->destination = destinationUrl;
    };
    void onTypeSelected(){
        QObject* typeSelector = qml_obj->findChild<QObject*>("type_selector");
        const QMetaObject* typeSelectorMeta = typeSelector->metaObject();
        QMetaProperty currentTextProp = typeSelectorMeta->property(typeSelectorMeta->indexOfProperty("currentText"));
        QString selectedDirection = currentTextProp.read(typeSelector).toString();
        this->direction = selectedDirection;
    };
    void onDirectionSelected(){
        QObject* directionSelector = qml_obj->findChild<QObject*>("direction_selector");
        const QMetaObject* directionSelectorMeta = directionSelector->metaObject();
        QMetaProperty currentTextProp = directionSelectorMeta->property(directionSelectorMeta->indexOfProperty("currentText"));
        QString selectedDirection = currentTextProp.read(directionSelector).toString();
        qDebug() << selectedDirection;
        this->direction = selectedDirection;
    };
    void onDone(){

    };
};

#endif


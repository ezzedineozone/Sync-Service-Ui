#ifndef Included_ADDSYNCMODULE_H

#define Included_ADDSYNCMODULE_H


#include <QObject>
#include <cstring>
#include <QtDebug>
#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QString>
#include "../sync_module.h"
#include "../helper.h"
#include "../tcp_client.h"
#include <filesystem>
#include "QDir"
#include "string"
namespace fs = std::filesystem;

class AddSyncModule : public QObject
{
    Q_OBJECT
private:
    QString name;
    QString source;
    QString destination;
    QString type;
    QString direction;
    QObject* qml_obj;
    const QMetaObject* meta_obj;


public:
        QObject* qObj;
    AddSyncModule(QObject* obj): type(QString("local")), direction(QString("one-way")){
        const QMetaObject* metaObj = obj->metaObject();
        this->qObj = obj;
        std::string className = helper::getQmlClasstype(obj);
        qDebug() << className;
        int result = (className == "AddSyncModule_QMLTYPE");
        if (result)
        {
            qml_obj = obj;
            meta_obj = metaObj;
            qDebug() << " addsyncmodule Correct type passed";
            QObject::connect(this, SIGNAL(openSignal()),this, SLOT(onOpenSignal()));
            QObject::connect(obj, SIGNAL(cancel()), this, SLOT(onCancel()));
            QObject::connect(obj, SIGNAL(sourceFolderAccepted()), this, SLOT(onSourceFolderAccepted()));
            QObject::connect(obj, SIGNAL(destinationFolderAccepted()), this, SLOT(onDestinationFolderAccepted()));
            QObject::connect(obj, SIGNAL(typeSelected()), this, SLOT(onTypeSelected()));
            QObject::connect(obj, SIGNAL(directionSelected()), this, SLOT(onDirectionSelected()));
            QObject::connect(obj, SIGNAL(done()), this, SLOT(onDone()));
            QObject::connect(obj, SIGNAL(nameModified()), this, SLOT(onNameModified()));
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
    void submit();
    void cancel();
    void sourceFolderAccepted();
    void destinationFolderAccepted();
    void typeSelected();
    void directionSelected();
public slots:
    void onDone(){
        SyncModule module(this->name.toStdString(), fs::path(this->source.toStdString()), fs::path(this->destination.toStdString()), this->type.toStdString(), this->direction.toStdString());
        qDebug() << module.to_string();
        TcpClient& client = TcpClient::get_instance("127.0.0.1","13");
        client.notify_add(module);
    }
    void onOpenSignal(){
        QMetaProperty visible_prop = meta_obj->property(meta_obj->indexOfProperty("visible"));
        visible_prop.write(qml_obj, true);
    };
    void onCancel(){
        QMetaProperty visible_prop = meta_obj->property(meta_obj->indexOfProperty("visible"));
        visible_prop.write(qml_obj, false);
    };
    void onNameModified(){
        QObject* moduleNameTextArea = qml_obj->findChild<QObject*>("module_name");
        const QMetaObject* moduleNameMeta = moduleNameTextArea->metaObject();
        QMetaProperty currentTextProp = moduleNameMeta->property(moduleNameMeta->indexOfProperty("text"));
        QString moduleName = currentTextProp.read(moduleNameTextArea).toString();
        this->name = moduleName;
    }
    void onSourceFolderAccepted()
    {
        QObject* sourceFolderDialog = qml_obj->findChild<QObject*>("source_folder_dialog");
        QObject* sourceInputBox = qml_obj->findChild<QObject*>("source_input");
        const QMetaObject* sourceFolderMeta = sourceFolderDialog->metaObject();
        const QMetaObject* sourceInputBoxMeta = sourceInputBox->metaObject();
        QMetaProperty selectedFolderProp = sourceFolderMeta->property(sourceFolderMeta->indexOfProperty("selectedFolder"));
        QMetaProperty sourceInputBoxTextProp = sourceInputBoxMeta->property(sourceInputBoxMeta->indexOfProperty("text"));
        QString sourceUrl = selectedFolderProp.read(sourceFolderDialog).toString();
        QString nativeSourcePath = QDir::toNativeSeparators(sourceUrl.mid(8));
        sourceInputBoxTextProp.write(sourceInputBox, nativeSourcePath);
        this->source = nativeSourcePath;
    };
    void onDestinationFolderAccepted(){
        QObject* destinationFolderDialog = qml_obj->findChild<QObject*>("destination_folder_dialog");
        QObject* destinationInputBox = qml_obj->findChild<QObject*>("destination_input");
        const QMetaObject* destinationFolderMeta = destinationFolderDialog->metaObject();
        const QMetaObject* destinationInputBoxMeta = destinationInputBox->metaObject();

        QMetaProperty selectedFolderProp = destinationFolderMeta->property(destinationFolderMeta->indexOfProperty("selectedFolder"));
        QMetaProperty destinationInputBoxTextProp = destinationInputBoxMeta->property(destinationInputBoxMeta->indexOfProperty("text"));

        QString destinationUrl = selectedFolderProp.read(destinationFolderDialog).toString();
        QString nativeDestinationPath = QDir::toNativeSeparators(destinationUrl.mid(8));

        destinationInputBoxTextProp.write(destinationInputBox, nativeDestinationPath);
        this->destination = nativeDestinationPath;
    };
    void onTypeSelected(){
        qDebug() << "type selected";
        QObject* typeSelector = qml_obj->findChild<QObject*>("type_selector");
        const QMetaObject* typeSelectorMeta = typeSelector->metaObject();
        QMetaProperty currentTextProp = typeSelectorMeta->property(typeSelectorMeta->indexOfProperty("currentText"));
        QString selectedType = currentTextProp.read(typeSelector).toString();
        qDebug() << selectedType;
        this->type = selectedType;
    };
    void onDirectionSelected(){
        QObject* directionSelector = qml_obj->findChild<QObject*>("direction_selector");
        const QMetaObject* directionSelectorMeta = directionSelector->metaObject();
        QMetaProperty currentTextProp = directionSelectorMeta->property(directionSelectorMeta->indexOfProperty("currentText"));
        QString selectedDirection = currentTextProp.read(directionSelector).toString();
        qDebug() << selectedDirection;
        this->direction = selectedDirection;
    };
};

#endif


#include <Qobject>
#include <QMetaObject>
#include <QtDebug>
#include <QMetaProperty>
#include <string>
#include "sstream"
#ifndef HELPER_H
#define HELPER_H
class helper{
public:
    static std::string getQmlClasstype(QObject* obj) {
        const QMetaObject* metaObj = obj->metaObject();
        std::string className = metaObj->className();
        std::vector<std::string> parts;
        std::stringstream ss(className);
        std::string item;
        while (std::getline(ss, item, '_')) {
            parts.push_back(item);
        }
        if (parts.size() >= 2) {
            return parts[0] + "_" + parts[1];
        } else if (parts.size() == 1) {
            return parts[0];
        }

        return "";
    }
    static void printProperties(QObject* obj)
    {
        const QMetaObject* meta_obj = obj->metaObject();
        for(int i = 0; i < meta_obj->propertyCount(); i++)
            qDebug() << meta_obj->property(i).name();
    }
};
#endif // HELPER_H

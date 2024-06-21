#include <Qobject>
#include <QMetaObject>
#include <QtDebug>
#include <QMetaProperty>
#ifndef HELPER_H
#define HELPER_H
class helper{
public:
    static void getQmlClasstype(QObject* obj, char* result)
    {
        const QMetaObject* metaObj = obj->metaObject();
        const char* className = metaObj->className();
        size_t classNameLen = strlen(className);

        // Ensure we have at least 3 characters to remove
        if (classNameLen > 3) {
            strncpy(result, className, classNameLen - 3);
            result[classNameLen - 3] = '\0';  // Null-terminate the result string
        } else {
            // Handle cases where className is too short
            result[0] = '\0';  // Set result to an empty string
        }
    }
    static void printProperties(QObject* obj)
    {
        const QMetaObject* meta_obj = obj->metaObject();
        for(int i = 0; i < meta_obj->propertyCount(); i++)
            qDebug() << meta_obj->property(i).name();
    }
};
#endif // HELPER_H

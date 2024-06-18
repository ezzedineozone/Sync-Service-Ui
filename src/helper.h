#include <Qobject>
#include <QMetaObject>
#ifndef HELPER_H
#define HELPER_H
class helper{
public:
    static void getQmlClasstype(QObject* obj, char* result)
    {
        const QMetaObject* metaObj = obj->metaObject();
        const char* className = obj->metaObject()->className();
        strncpy(result,className,strlen(className) - 3);
    }
};

#endif // HELPER_H

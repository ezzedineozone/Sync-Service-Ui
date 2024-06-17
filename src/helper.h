#include <Qobject>
#include <QMetaObject>
#ifndef HELPER_H
#define HELPER_H
class helper{
public:
    static char* getQmlClasstype(QObject* obj)
    {
        const QMetaObject* metaObj = obj->metaObject();
        const char* className = obj->metaObject()->className();
        char* substring = new char[strlen(className) + 1];
        strncpy(substring,className,strlen(className) - 3);
        return substring;
    }
};

#endif // HELPER_H

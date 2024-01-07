#include <QQmlApplicationEngine>
#include <QGuiApplication>
int main(int argc, char* argv[])
{
    QGuiApplication app(argc,argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QString("qrc:qml/screens/MainWindow.qml")));
    return app.exec();
}

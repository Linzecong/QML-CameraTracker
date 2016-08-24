#include <QGuiApplication>
#include <QQuickView>
#include <QQmlEngine>
#include <QQuickItem>
#include <QObject>
#include <QMouseEvent>

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);


    QQuickView viewer;

    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    viewer.engine()->addImportPath("F:/Qt/Qt5.5.1-Static/qml");
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.show();


    return app.exec();
}

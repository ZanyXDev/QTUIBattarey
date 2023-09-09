#include <QtCore/QCoreApplication>
#include <QtCore/QTranslator>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtGui/QScreen>

#ifdef QT_DEBUG
#include <QtCore/QDirIterator>
#include <QtCore/QLoggingCategory>
#endif

int main(int argc, char *argv[]) {

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

#ifdef QT_DEBUG
    QLoggingCategory::setFilterRules(QStringLiteral("qt.qml.binding.removal.info=true"));
#endif

    QCoreApplication::setOrganizationName("ZanyXDev");
    QCoreApplication::setApplicationName(PACKAGE_NAME_STR);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/res/qml");
    QQmlContext *context = engine.rootContext();

    context->setContextProperty("pt", 1);
    context->setContextProperty("AppVersion",VERSION_STR);
#ifdef QT_DEBUG
    context->setContextProperty("isDebugMode", true );
#endif

    context->setContextProperty("isMobile",false);
    context->setContextProperty("DevicePixelRatio",2);

    const QUrl url(QStringLiteral("qrc:/res/qml/main.qml"));
    QObject::connect(
                &engine, &QQmlApplicationEngine::objectCreated, &app,
                [url](const QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) QCoreApplication::exit(-1);
    },
    Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}

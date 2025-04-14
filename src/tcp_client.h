#ifndef TCPCLIENT_H
#define TCPCLIENT_H
#include "dependencies/asio/asio.hpp"
#include "iostream"
#include "sync_module.h"
#include "QString"
#include "QtDebug"
#include "QObject"
#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include "dependencies/json/json.hpp"
#include "QObjects/ErrorModal.h"
class AddSyncModule;
class SyncTable;

class TcpClient : public QObject, public std::enable_shared_from_this<TcpClient> {
    Q_OBJECT
public:
    static TcpClient& get_instance(const std::string& ip, const std::string& port);
    static void connect_objects(SyncTable* table, AddSyncModule* addSync, ErrorModal* modal);

    int start_connection();
    int start_reading();
    void notify_add(const SyncModule& module);
    void notify_removal(std::string name);
    void notify_edit(std::string name, std::unique_ptr<SyncModule> module);
    void request_sync(std::string name);
    int command_handler(nlohmann::json j);

private:
    TcpClient(std::string ip, std::string port);

    static std::shared_ptr<TcpClient> instance;
    static std::once_flag initInstanceFlag;

    std::string vectorToString(const std::vector<SyncModule>& vector);

    std::string message_;

    bool started;

    std::string ip;
    std::string port;
    asio::io_context io_context;
    asio::ip::tcp::resolver resolver;
    asio::ip::tcp::socket socket_;
    static SyncTable* sync_table;
    static AddSyncModule* add_sync_module;
    static ErrorModal* error_modal;
    int get_index_of_delimitter(std::string);

    void notify_success(std::string type, const std::error_code& ec, std::size_t bytes_transferred);
};
#endif


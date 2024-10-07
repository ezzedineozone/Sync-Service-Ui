#ifndef TCPCLIENT_H
#define TCPCLIENT_H
#include "dependencies/asio/asio.hpp"
#include "iostream"
#include "sync_module.h"
#include "QString"
#include "QtDebug"
#include "QObject"
class TcpClient : public QObject, public std::enable_shared_from_this<TcpClient> {
public:
    static TcpClient& get_instance(const std::string& ip, const std::string& port);

    int start_connection();
    int start_reading();
    void notify_add(const SyncModule& module);
    void notify_removal(std::string name);

private:
    TcpClient(std::string ip, std::string port);

    static std::shared_ptr<TcpClient> instance;
    static std::once_flag initInstanceFlag;

    std::string message_;

    bool started;

    std::string ip;
    std::string port;
    asio::io_context io_context;
    asio::ip::tcp::resolver resolver;
    asio::ip::tcp::socket socket_;

    void notify_success(std::string type, const std::error_code& ec, std::size_t bytes_transferred);
};
#endif


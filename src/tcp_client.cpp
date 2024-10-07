#include "tcp_client.h"
#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include "dependencies/json/json.hpp"
std::shared_ptr<TcpClient> TcpClient::instance;
std::once_flag TcpClient::initInstanceFlag;

TcpClient& TcpClient::get_instance(const std::string& ip, const std::string& port) {
    std::call_once(initInstanceFlag, [&]() {
        instance.reset(new TcpClient(ip, port));
    });
    return *instance;
}

TcpClient::TcpClient(std::string ip, std::string port)
    : ip(std::move(ip)), port(std::move(port)), io_context(), resolver(io_context), socket_(io_context) {}

int TcpClient::start_connection() {
    try {
        asio::ip::tcp::resolver::results_type endpoints = resolver.resolve(ip, port);
        asio::connect(socket_, endpoints);
        this->started = true;

        QFuture<int> future = QtConcurrent::run([=]() {
            return start_reading();
        });

        QFutureWatcher<int>* watcher = new QFutureWatcher<int>();
        connect(watcher, &QFutureWatcher<int>::finished, [=]() {
            int finished_reading = watcher->result();
            if (finished_reading) {
                qDebug() << "Finished reading successfully.";
            }
            watcher->deleteLater();
        });

        watcher->setFuture(future);


        return 1;
    } catch (std::exception&) {
        std::cout << "could not establish connection, check if the service is started\n";
        return 0;
    }
}

int TcpClient::start_reading() {
    if(!this->started)
    {
        qDebug() << "start connection first before reading";
    }
    for (;;) {
        std::string msg;
        std::array<char, 128> buf;
        std::error_code error;

        size_t len = socket_.read_some(asio::buffer(buf), error);
        if (error == asio::error::eof)
        {
            qDebug() << "connection closed";
            break;
        }
        else if (error)
            throw std::system_error(error); // Some other error.

        msg.append(buf.data(), len);
        qDebug() << QString::fromStdString(msg);
    }
    return 1;
}
void TcpClient::notify_removal(std::string name)
{
    nlohmann::json j;
    j["command"] = "remove";
    j["data"] = name;
    message_ = j.dump();
    asio::async_write(socket_, asio::buffer(message_), std::bind(&TcpClient::notify_success, shared_from_this(), "remove", std::placeholders::_1, std::placeholders::_2));
}
void TcpClient::notify_add(const SyncModule& module)
{
    nlohmann::json j;
    j["command"] = "add";
    j["data"] = module.to_json();
    message_ = j.dump();
    asio::async_write(socket_, asio::buffer(message_), std::bind(&TcpClient::notify_success, shared_from_this(), "add", std::placeholders::_1, std::placeholders::_2));
}
void TcpClient::notify_success(std::string type, const std::error_code& ec, std::size_t bytes_transferred) {
    if (!ec) {
        qDebug() << "Command '" + QString::fromStdString(type) + "' successfully sent. Bytes transferred:" << bytes_transferred;
    }
    else {
        qDebug() << "Error sending command '" + QString::fromStdString(type) + "':" << QString::fromStdString(ec.message());
    }
}


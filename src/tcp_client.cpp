#include "tcp_client.h"
#include "QObjects/AddSyncModule.h"
#include "QObjects/SyncTable.h"
#include "QString"
std::shared_ptr<TcpClient> TcpClient::instance;
std::once_flag TcpClient::initInstanceFlag;
SyncTable* TcpClient::sync_table = nullptr;
AddSyncModule* TcpClient::add_sync_module = nullptr;
ErrorModal* TcpClient::error_modal = nullptr;


TcpClient& TcpClient::get_instance(const std::string& ip, const std::string& port) {
    std::call_once(initInstanceFlag, [&]() {
        instance.reset(new TcpClient(ip, port));
    });
    return *instance;
}

TcpClient::TcpClient(std::string ip, std::string port)
    : ip(std::move(ip)), port(std::move(port)), io_context(), resolver(io_context), socket_(io_context) {}

void TcpClient::connect_objects(SyncTable* table, AddSyncModule* addSync, ErrorModal* modal)
{
    sync_table = table;
    add_sync_module = addSync;
    TcpClient::error_modal = modal;
}
int TcpClient::start_connection() {
    try {
        asio::ip::tcp::resolver::results_type endpoints = resolver.resolve(ip, port);
        asio::connect(socket_, endpoints);
        this->started = true;
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
    std::string msg;
    for (;;) {
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
        std::string delimitter = std::string("\r\n");
        size_t pos = msg.find(delimitter);
        if(pos != std::string::npos)
        {
            size_t pos0 = 0;
            size_t pos1 = pos;
            std::string obj_sent = msg.substr(pos0,pos1);
            msg.erase(0, pos+delimitter.length());
            qDebug() << QString::fromStdString(obj_sent);
            nlohmann::json j = nlohmann::json::parse(obj_sent);
            command_handler(j);
        }
    }
    return 1;
}
int TcpClient::command_handler(nlohmann::json j){
    std::string command = j["command"];
    if(command == "init")
    {
        std::vector<SyncModule*> modules;
        if (j["data"].is_array()) {
            for (const auto& item : j["data"]) {
                SyncModule* module = new SyncModule(item);
                modules.push_back(module);
            }
        }
        emit sync_table->modulesFetched(modules);
    }
    else if(command == "add")
    {
        nlohmann::json module = j["data"]; // its fine to not use new this object will only be used for ease of extracton of strings and then destroyed, the obj will be saved later in SyncTable
        emit sync_table->moduleAdded(
            QString::fromStdString(module["name"]),
            QString::fromStdString(module["source"]),
            QString::fromStdString(module["destination"]),
            QString::fromStdString(module["type"]),
            QString::fromStdString(module["direction"])
        );
    }
    else if (command == "-1")
    {
        QString errorMsg = QString("Command: \"%1\"\nError Message: %2").arg(QString::fromStdString(command)).arg(QString::fromStdString(j["data"]));
        emit TcpClient::error_modal->errorThrown(errorMsg);
    }
    return 1;
}
std::string TcpClient::vectorToString(const std::vector<SyncModule>& modules) {
    std::ostringstream oss;
    oss << "SyncModules: [";

    for (size_t i = 0; i < modules.size(); ++i) {
        oss << modules[i].to_json().dump();
        if (i < modules.size() - 1) {
            oss << ", ";
        }
    }
    oss << "]";
    return oss.str();
}
void TcpClient::notify_removal(std::string name)
{
    nlohmann::json j;
    j["command"] = "remove";
    j["data"] = name;
    message_ = j.dump() + "\r\n";
    asio::async_write(socket_, asio::buffer(message_), std::bind(&TcpClient::notify_success, shared_from_this(), "remove", std::placeholders::_1, std::placeholders::_2));
}
void TcpClient::notify_add(const SyncModule& module)
{
    nlohmann::json j;
    j["command"] = "add";
    j["data"] = module.to_json();
    message_ = j.dump() + "\r\n";
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


#include "dependencies/asio/asio.hpp"
class TcpClient{
public:
    TcpClient(std::string ip, std::string port): io_context(), resolver(io_context), socket(io_context){
        asio::ip::tcp::resolver::results_type endpoints =
            resolver.resolve(ip,port);
        asio::connect(socket, endpoints);
    }
private:
    asio::io_context io_context;
    asio::ip::tcp::resolver resolver;
    asio::ip::tcp::socket socket;
};

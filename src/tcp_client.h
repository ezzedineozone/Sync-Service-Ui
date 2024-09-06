#include "dependencies/asio/asio.hpp"
#include "iostream"
class TcpClient{
public:
    TcpClient(std::string ip, std::string port):ip(ip),port(port), io_context(), resolver(io_context), socket(io_context){
    }
    int start_connection(){
        try{
            asio::ip::tcp::resolver::results_type endpoints =
                resolver.resolve(ip,port);
            asio::connect(socket, endpoints);
            return 1;
        }
        catch(std::exception)
        {
            std::cout << "could not establis connection, check if the service is started\n";
            return 0;
        }
    }
private:
    std::string ip;
    std::string port;
    asio::io_context io_context;
    asio::ip::tcp::resolver resolver;
    asio::ip::tcp::socket socket;
};

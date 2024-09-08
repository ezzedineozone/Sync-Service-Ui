#include "dependencies/asio/asio.hpp"
#include "iostream"
class TcpClient{
public:
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
    static TcpClient& get_instance(const std::string& ip, const std::string& port) {
        std::call_once(initInstanceFlag, [&]() {
            instance.reset(new TcpClient(ip, port));
        });
        return *instance;
    }
    std::string read_message(){
        std::string msg;
        for (;;)
        {
            std::array<char, 128> buf;
            std::error_code error;

            size_t len = socket.read_some(asio::buffer(buf), error);
            if (error == asio::error::eof)
                break; // Connection closed cleanly by peer.
            else if (error)
                throw std::system_error(error); // Some other error.

            msg.append(buf.data(),len);
        }
        return msg;
    }
private:
    TcpClient(std::string ip, std::string port):ip(ip),port(port), io_context(), resolver(io_context), socket(io_context){
    }


    static std::unique_ptr<TcpClient> instance;
    static std::once_flag initInstanceFlag;


    std::string ip;
    std::string port;
    asio::io_context io_context;
    asio::ip::tcp::resolver resolver;
    asio::ip::tcp::socket socket;
};


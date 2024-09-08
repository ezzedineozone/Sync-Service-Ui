#include "tcp_client.h"
std::unique_ptr<TcpClient> TcpClient::instance = nullptr;
std::once_flag TcpClient::initInstanceFlag;

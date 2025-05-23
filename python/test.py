import socket

# 创建TCP服务器
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('localhost', 12345))
sock.listen(1)

print('Python: Waiting for connection')
conn, addr = sock.accept()
print('Python: Connected by', addr)

# 等待MATLAB发送数字1
print('Python: Waiting for 1 from MATLAB')
data = conn.recv(1)
print('Python: Received', int.from_bytes(data, byteorder='big'), 'from MATLAB')

# 发送数字2给MATLAB
print('Python: Sending 2 to MATLAB')
conn.sendall(int.to_bytes(2, length=1, byteorder='big'))

# 等待MATLAB发送数字3
print('Python: Waiting for 3 from MATLAB')
data = conn.recv(1)
print('Python: Received', int.from_bytes(data, byteorder='big'), 'from MATLAB')

# 发送数字4给MATLAB
print('Python: Sending 4 to MATLAB')
conn.sendall(int.to_bytes(4, length=1, byteorder='big'))

# 关闭TCP连接
conn.close()

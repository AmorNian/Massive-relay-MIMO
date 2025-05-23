% 创建TCP客户端对象
t = tcpclient('localhost', 12345);

% 发送数字1给Python
disp('MATLAB: Sending 1 to Python');
write(t, int8(1));

% 等待Python发送数字2
disp('MATLAB: Waiting for 2 from Python');
while t.NumBytesAvailable == 0
    pause(0.1);
end
data = read(t, 1, 'int8');
disp(['MATLAB: Received ', num2str(data), ' from Python']);

% 发送数字3给Python
disp('MATLAB: Sending 3 to Python');
write(t, int8(3));

% 等待Python发送数字4
disp('MATLAB: Waiting for 4 from Python');
while t.NumBytesAvailable == 0
    pause(0.1);
end
data = read(t, 1, 'int8');
disp(['MATLAB: Received ', num2str(data), ' from Python']);

% 关闭TCP连接
clear t;

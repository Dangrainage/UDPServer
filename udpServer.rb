require 'socket'

isWriting = false

if ARGV.empty?
  puts "Input port to listen to"
  port_str = gets.chomp
else
  flag = ARGV[0]
    
  if flag == "-p" 
    port_str = ARGV[1]
end


port_int = port_str.to_i

listen_port = port_int
bind_address = '0.0.0.0'

server_socket = UDPSocket.new

server_socket.bind(bind_address, listen_port)

puts "UDP server listening on #{bind_address}:#{listen_port}"

if isWriting == true
  file.puts "UDP server listening on #{bind_address}:#{listen_port}"
end

loop do
  
  message, client_info = server_socket.recvfrom(1024)

  message_str = message.to_s

  

  if message_str.include?("stop!server")
    abort("Got server stop signal, quitting!")
  else 
    puts "Received from #{client_info[2]}: #{message_str}"
  end
end

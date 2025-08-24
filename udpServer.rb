require 'socket'

isWriting = false

if ARGV.empty?
  puts "Input port to listen to"
  port_str = gets.chomp
else
  flag1 = ARGV[0]
  flag2 = ARGV[2]
  
  if flag1 == "-p" 
    port_str = ARGV[1]
  elsif flag1 == "-o" 
    file_to_output = ARGV[1]
    isWriting = true
  end

  if flag2 == "-p" 
    port_str = ARGV[3]
  elsif flag2 == "-o"
    file_to_output = ARGV[3]
    isWriting = true
  end
end

if isWriting == true
  file = File.new("#{file_to_output}", "w")
  puts "Logging everything to #{file_to_output}"
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
    if isWriting == true
      file.puts("Got server stop signal, quitting!")
      file.close
    end
    
    puts "Got server stop signal, quitting!"
    exit()
  else 
    puts "Received from #{client_info[2]}: #{message_str}"
    if isWriting == true
      file.puts("Received from #{client_info[2]}: #{message_str}")
    end
  end
end

require 'socket'

isWriting = false
logDetails = true
check = nil
file_to_output = nil
port_str = nil

def true?(obj)
  obj.to_s.downcase == "true" || obj.to_s.downcase == "t" # stolen directly from stack overflow 
end



if ARGV.empty?
  puts "No port to listen to was defined, exiting"
  exit(0)
else
  ARGV.each_slice(2) do |flag, value|
    case flag
    when "-p"
      port_str = value
    when "-o"
      file_to_output = value
      isWriting = true
    when "-n"
      check = value
    when "h", "-h", "help", "-help"
      puts "         -p <port number> to define a port to listen to. (mandatory)"
      puts "         -o <output file name> to define a file to log all the output to. (optional)"
      puts "         -n true/t toggles logging details to the output file (optional only when -o is used)"
      puts "         -h/help/h will print this message"
      exit(0)
    end
  end
end

if true?(check)
  logDetails = false
end

if logDetails == false and isWriting == false
  puts "Cannot pass '-n' flag without an output file"
  exit(1)
end

if isWriting == true
  file = File.new("#{file_to_output}", "w")
  if logDetails == true
    file.puts("Logging all details to #{file_to_output}")
    puts("Logging all details to #{file_to_output}")
  elsif logDetails == false
    puts("Only messages will be logged to #{file_to_output}")
  end
end



port_int = port_str.to_i

listen_port = port_int
bind_address = '0.0.0.0'

server_socket = UDPSocket.new

server_socket.bind(bind_address, listen_port)

puts "UDP server listening on #{bind_address}:#{listen_port}"

if isWriting and logDetails == true 
  file.puts "UDP server listening on #{bind_address}:#{listen_port}"
end

loop do
  
  message, client_info = server_socket.recvfrom(65507)

  message_str = message.to_s

  

  if message_str.include?("stop!server")
    if isWriting and logDetails == true
      file.puts("Got server stop signal, quitting!")
      file.close
    elsif isWriting and logDetails == false
      puts("Got server stop signal, quitting!")
      file.close
    end
    
    puts "Got server stop signal, quitting!"
    exit()
  else 
    puts "Received from #{client_info[2]}: #{message_str}"
    if isWriting and logDetails == true
      file.puts("Received from #{client_info[2]}: #{message_str}")
    elsif isWriting == true and logDetails == false
        file.puts(message_str)
    end
  end
end

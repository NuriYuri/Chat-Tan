module Command
  module Admin
    #> Chargement des strings relatifs à ce module
    self.load_string("command_admin")
    module_function
    #===
    #> Interface de récupération de commandes
    #===
    def __get_command(command_id, command)
      case command_id
      when :prune
        return [:command_prune, self.get_string(1), nil]
      end
    end
    
    public
    def command_prune(event, command)
      _mod = ::Command::Admin
      user = event.author
      if user.permission?(:manage_messages, event.channel)
        event.channel.prune(command[1].to_i)
        event.channel.send_temporary_message(format(_mod.get_string(3), nb: command[1]), 3)
      else
        user.pm(format(_mod.get_string(2), channel: event.channel.name, server: event.server.name))
      end
    end
    
  end
end

  
module Command
  module UBG #Useless But Great
    #> Chargement des strings relatifs à ce module
    self.load_string("command_ubg")
    module_function
    #===
    #> Interface de récupération de commandes
    #===
    def __get_command(command_id, command)
      case command_id
      when :whoami
        return [:command_whoami, self.get_string(1), nil]
      when :roll
        return [:command_roll, self.get_string(4), nil]
      when :time
        return [:command_time, self.get_string(9), nil]
      when :eat
        return [:command_eat, self.get_string(11), nil]
      when :chrono
        return [:command_chrono, self.get_string(14), :init_command_chrono]
      when :afk
        return [:command_afk, self.get_string(18), :init_command_afk]
      when :beer
        return [:command_beer, self.get_string(24), nil]
      end
    end
    
    public
    def command_whoami(event, command)
      _mod = ::Command::UBG
      user = event.author
      event << sprintf(_mod.get_string(2), user.username, user.id, user.mention)
      event << user.avatar_url
      event << sprintf(_mod.get_string(3), user.game) if(user.game)
    end
    
    def command_roll(event, command)
      _mod = ::Command::UBG
      user = event.author.mention
      faces = (command.size > 1) ? command[1].to_i & 0x3FFFFFFF : 6
      faces = 6 if faces < 2
      value = 1 + rand(faces)
      if faces < 4
        event << sprintf(_mod.get_string(8), user, _mod.get_string(3+faces), value)
      else
        event << sprintf(_mod.get_string(7), user, faces, value)
      end
    end
    
    def command_time(event, command)
      _mod = ::Command::UBG
      time = Time.new
      time -= 3600*(rand(22)+1) if(rand(10)==1)
      event << sprintf(_mod.get_string(10), time.strftime("%H:%M:%S.%L"))
    end
    
    def command_eat(event, command)
      _mod = ::Command::UBG
      username = event.author.mention
      return event << sprintf(_mod.get_string(12), username, command[1]) if command.size > 1
      event << sprintf(_mod.get_string(13), username)
    end
    
    def init_command_chrono
      @_command_chrono = {}
    end
      
    def command_chrono(event, command)
      _mod = ::Command::UBG
      uid = event.author.id
      if(command[1] == _mod.get_string(15) or !@_command_chrono[uid])
        event << _mod.get_string(16)
        return @_command_chrono[uid] = Time.new
      end
      event << sprintf(_mod.get_string(17), (Time.new-@_command_chrono[uid].to_i-3600).strftime("%H:%M:%S.%L"))
    end
    
    def init_command_afk
      @_command_afk_list = []
    end
    
    def command_afk(event, command)
      _mod = ::Command::UBG
      if(command.size == 1)
        if @_command_afk_list.include?(event.author)
          @_command_afk_list.delete(event.author)
          event << sprintf(_mod.get_string(19), event.author.mention)
        else
          @_command_afk_list << event.author
          event << sprintf(_mod.get_string(20), event.author.mention)
        end
      else
        event << _mod.get_string(21)
        return event << _mod.get_string(22) if @_command_afk_list.size == 0
        event << (@_command_afk_list.collect do |i| i.username end).join(_mod.get_string(23))
      end
    end
    
    def command_beer(event, command)
      _mod = ::Command::UBG
      event << _mod.get_string(25)
      event << sprintf(_mod.get_string(26),event.author.mention)
    end
    
  end
end

  
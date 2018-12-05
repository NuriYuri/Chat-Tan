module Command
  module Pokeball
    #> Chargement des strings relatifs à ce module
    self.load_string("command_pokeball")
    module_function
    #===
    #> Interface de récupération de commandes
    #===
    def __get_command(command_id, command)
      case command_id
      when :pokeball
        return [:command_pokeball, self.get_string(1), :init_command_pokeball]
      else
        return [:command_buy_pokeball, self.get_string(2), nil]
      end
    end
    
    public
    #===
    #> Initialisation de la commande Pokeball
    #===
    def init_command_pokeball
      @cmd_pokeball_nb = {}
      @cmd_pokeball_times = {}
    end
    #===
    #> Commande Pokéball : Lancé
    #===
    def command_pokeball(event, command)
      _mod = ::Command::Pokeball
      uid = event.author.id
      metion = event.author.mention
      nb_ball = @cmd_pokeball_nb[uid] || 10
      return event << mod.get_string(3) if nb_ball <= 0
      nb_ball -= 1
      unless command[1]
        users = event.channel.users
        users.delete(event.author)
        username = users[rand(users.size)].username
      else
        username = command[1]
      end
      event << sprintf(_mod.get_string(4), metion)
      if(rand(100) < ((Time.now.sec - 13) % 30 + 15))
        event << sprintf(_mod.get_string(6), username)
        if(rand(100) < 15)
          event << _mod.get_string(7)
          nb_ball += 1
          @cmd_pokeball_nb.each_key do |i|
            @cmd_pokeball_nb[i] += 1
          end
        end
      else
        event << sprintf(_mod.get_string(5), username)
      end
      @cmd_pokeball_nb[uid] = nb_ball
      if(nb_ball > 0)
        event << sprintf(_mod.get_string(8), nb_ball, metion)
      else
        event << sprintf(_mod.get_string(9), metion)
        @cmd_pokeball_times[uid] = Time.new
      end
    end
    #===
    #> Achat Pokéball
    #===
    def command_buy_pokeball(event, command)
      _mod = ::Command::Pokeball
      uid = event.author.id
      if((@cmd_pokeball_nb[uid] || 1) > 0)
        event << _mod.get_string(10)
      else
        delta_time = Time.new - @cmd_pokeball_times[uid]
        if(delta_time < 300)
          event << sprintf(_mod.get_string(11), (300-delta_time)/60 + 1)
        else
          event << sprintf(_mod.get_string(12), event.author.mention)
          @cmd_pokeball_nb[uid] = 10
        end
      end
    end
  end
end
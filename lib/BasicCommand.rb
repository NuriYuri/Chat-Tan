#encoding: utf-8

module Command
  module BasicCommands
    #> Chargement des strings relatifs à ce module
    self.load_string("basic_commands")
    #> Tableau d'association des commandes à un id de string
    Command2Descr = {
      "/democratie" => 4,
      "/mehry" => 5,
      "/lol" => 6,
      "/ping" => 7,
      4 => [8],
      5 => [9],
      6 => [10,11,12,13,14,15],
      7 => [17,17,17,17,17,17,17,17,17,17,17,17,18,19],
    }
    
    module_function
    #===
    #> Interface de récupération de commandes
    #===
    def __get_command(command_id, command)
      case command_id
      when :help
        return [:command_help, self.get_string(1), nil]
      else
        return [:command_disp_string, self.get_string(Command2Descr[command]), nil]
      end
    end
    
    public
    #===
    #> Commande aide, affiche l'intégralité des commandes
    #===
    def command_help(event, command)
      event << ::Command::BasicCommands.get_string(2)
      command_descr = ::Command::BasicCommands.get_string(3)
      @commands.each do |cmd, command_info|
        event << sprintf(command_descr, cmd, command_info[1])
      end
    end
    
    #===
    #> Commande assez basique qui affiche des strings selon divers cas
    #===
    def command_disp_string(event, command)
      ids = Command2Descr[id = Command2Descr[command[0]]]
      mod = ::Command::BasicCommands
      event << mod.get_string(ids[rand(ids.size)])
      if id == 6 and rand(10) < 3 #/lol
        event << mod.get_string(16)
      end
    end
  end
end
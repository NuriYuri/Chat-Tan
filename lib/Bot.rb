#encoding: utf-8

module Bot
  #> Socket contenant le bot dicord
  Socket = Discordrb::Bot.new(token: ::BotToken, application_id: ::BotAppID)
  Socket.run(:async)
  Socket.should_parse_self = ::BotParse
  #> Interfaces du bot
  Interfaces = []
  
  self.load_string("bot")
  
  #> Méthode à appeler dans initialize pour déclencher le traitement des messages
  def init_message(params)
    Socket.message(params) do |event|
      self.parse_message(event)
    end
  end
  
  #> Traitement d'un message
  def parse_message(event)
    command = parse_command(event.content)
    if command_info = @commands[command[0]]
      send(command_info[0], event, command)
    else
      event.respond(sprintf(Bot.get_string(1), command[0]))
    end
  end
  
  #> Ajout de commandes depuis un module
  #  from = module en question
  #  command_hash = "/command" => :internal_command_id
  #  Le module renvoie [:method_to_call, description, :init_method or nil]
  def set_command(from, command_hash)
    self.class.include(from) unless self.class.include?(from)
    @commands = Hash.new unless @commands
    command = commands = internal_id = nil
    command_hash.each do |command, internal_id|
      commands = @commands[command] = from.__get_command(internal_id, command)
      self.send(commands[2]) if commands[2]
    end
  end
  
  module_function
  def find_server(name)
    Socket.servers.each_value do |server|
      return server if server.name == name
    end
    return nil
  end
  
  def find_channel(server, name, voice = nil)
    case voice
    when nil
      channels = server.channels
    when false
      channels = server.text_channels
    else
      channels = server.voice_channels
    end
    channels.each do |channel|
      return channel if channel.name == name
    end
    return nil
  end
  
  def find_role(server, name)
    server.roles.each do |role|
      return role if role.name == name
    end
  end
  
  #> Création d'une interface
  def make_interface(_class)
    Interfaces << _class.new
  end
end
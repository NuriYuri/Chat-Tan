#encoding: utf-8

module Channel
  class BotChannels
    include Bot
    def initialize
      #> Récupération des commandes basiques
      set_command(
        ::Command::BasicCommands, 
        "/help" => :help,
        "/democratie" => nil,
        "/mehry" => nil,
        "/lol" => nil,
        "/ping" => nil,
      )
      #> Récupération de la commande pokeball
      set_command(
        ::Command::Pokeball,
        "/pokeball" => :pokeball,
        "/pokeball_buy" => nil,
      )
      #> Récupération des commandes cools
      set_command(
        ::Command::UBG,
        "/whoami" => :whoami,
        "/roll" => :roll,
        "/time" => :time,
        "/eat" => :eat,
        "/chrono" => :chrono,
        "/afk" => :afk,
        "/beer" => :beer,
      )
      #> Récupération des commandes de musique
      set_command(
        ::Command::Song,
        "/startvoice" => :startvoice,
        "/playmusic" => :playsong,
        "/stopmusic" => :stop,
        "/nextmusic" => :next,
      )
      server_id = server = channel = nil
      #> Démarrage de l'écoute sur certains channels
      Socket.servers.each do |server_id, server|
        if channel = find_channel(server, "bot") or channel = find_channel(server, "general")
          init_message(start_with: "/", in: channel)
        end
      end
    end
    #> Intégration de l'interface
    Bot.make_interface(self)
  end
end
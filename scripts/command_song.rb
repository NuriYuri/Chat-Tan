module Command
  module Song
    #> Chargement des strings relatifs à ce module
    self.load_string("command_song")
    #> Constantes importantes
    SongOperator = self.get_string(4)
    Paths = {
    "music" => "Z:/Musique/", #>Ajoutez autant d'associations "path" => "realpath" que nécessaire
    }
    Formats = [".flac", ".mp3", ".ogg", ".flv", ".mp4"]
    module_function
    #===
    #> Interface de récupération de commandes
    #===
    def __get_command(command_id, command)
      case command_id
      when :startvoice
        return [:command_startvoice, self.get_string(1), :init_song]
      when :playsong
        return [:command_playsong, self.get_string(8), nil]
      when :stop
        return [:command_stopsong, self.get_string(14), nil]
      when :next
        return [:command_song_next, self.get_string(17), nil]
      end
    end
    
    public
    #===
    #> Initialisation de la voix
    #===
    def init_song
      @song_current_list = nil
      @song_current_path = nil
      @song_current_voice = nil
      @song_currently_playing = nil
      @song_last_song = nil
      @song_thread = nil
    end
    
    def member_is_song_operator?(event)
      return false unless server = event.server
      return false unless role = find_role(server, SongOperator)
      return false unless member = server.member(event.author.id)
      return member.role?(role)
    end
    #===
    #> Commande start voice, incite Chat-Tan à se connecter à un channel
    #===
    def command_startvoice(event, command)
      _mod = ::Command::Song
      return event << _mod.get_string(2) if @song_currently_playing
      return event << _mod.get_string(3) unless member_is_song_operator?(event)
      return event << _mod.get_string(6) if command.size != 2
      channel = find_channel(event.server, command[1], true)
      return event << sprintf(_mod.get_string(5), command[1], event.server.name) unless channel
      begin
        @song_current_voice = Bot::Socket.voice_connect(channel)
        event << sprintf(_mod.get_string(13), command[1])
      rescue Exception
        @song_current_voice = nil
        event << sprintf(_mod.get_string(7), $!.class, $!.message)
      end
    end
    
    #===
    #> command start song : Joue une musique
    #===
    def command_playsong(event, command)
      _mod = ::Command::Song
      return event << _mod.get_string(9) unless @song_current_voice
      return event << _mod.get_string(3) unless member_is_song_operator?(event)
      #> Si le repertoire n'est pas défini ou n'existe pas
      if(command.size == 1 or (command[1]!=@song_current_path and !Paths[command[1]]))
        event << _mod.get_string(10)
        return Paths.each_key do |path| event << path end
      end
      #> Chargement de la liste si le path a changé
      song_load_path(path = command[1]) if command[1]!=@song_current_path
      return pm_list_to_user(event.user.pm) unless command[2]
      return event << _mod.get_string(11) unless @song_current_list.include?(command[2])
      stop_song
      event << sprintf(_mod.get_string(12),command[2])
      @song_last_song = @song_currently_playing = command[2]
      @song_thread = Thread.new do 
        @song_current_voice.play_file(Paths[command[1]]+command[2])
        @song_currently_playing = nil
        Bot::Socket.send_message(event.channel.id, command[3]) if command[3]
      end
    end
    #===
    #> command_stopsong : arrêter la musique
    #===
    def command_stopsong(event, command)
      _mod = ::Command::Song
      return event << _mod.get_string(9) unless @song_current_voice
      return event << _mod.get_string(3) unless member_is_song_operator?(event)
      return event << _mod.get_string(15) unless @song_currently_playing
      event << sprintf(_mod.get_string(16), @song_currently_playing)
      stop_song
    end
    Song_Renext = "renext"
    #===
    #> command_song_next : Jouer la musique suivante
    #===
    def command_song_next(event, command)
      _mod = ::Command::Song
      return event << _mod.get_string(9) unless @song_current_voice
      return event << _mod.get_string(3) unless member_is_song_operator?(event)
      new_song = @song_current_list.index(@song_last_song)
      new_song = -1 unless new_song
      new_song = @song_current_list[new_song+1]
      command_obj = ["/???", @song_current_path, new_song]
      if(command[1] == Song_Renext)
        command_obj << "#{command[0]} #{command[1]}"
      end
      command_playsong(event, command_obj)
    end
    #===
    #> Arrêter la lecture d'une musique
    #===
    def stop_song
     return unless @song_thread
     if @song_thread.alive?
      @song_thread.kill
      @song_current_voice.stop_playing
      @song_currently_playing = nil
      sleep(0.2)
     end
    end
    Song_PathSearchMusic = "*.*"
    Song_SubPaths = "*/"
    #===
    #> Chargement d'une liste
    #===
    def song_load_path(path)
      @song_current_path = path
      @song_currently_playing = nil
      songs = nil
      Dir.chdir(Paths[path]) do
        #> Musiques dans le répertoire
        songs = Dir[Song_PathSearchMusic]
        songs.delete_if do |song| !Formats.include?(File.extname(song)) end
        #> Musiques dans les sous répertoires de niveau 1
        Dir[Song_SubPaths].each do |sub_path|
          sub_songs = Dir[sub_path+Song_PathSearchMusic]
          sub_songs.delete_if do |song| !Formats.include?(File.extname(song)) end
          songs += sub_songs
        end
      end
      @song_current_list = songs
    end
    #===
    #> Envoyer la liste des musiques par MP
    #===
    def pm_list_to_user(pm)
      return unless pm
      channel_id = pm.id
      counter = 0
      str = String.new
      song = nil
      @song_current_list.each do |song|
        str << "#{song}\n"
        counter += 1
        if(counter == 15)
          Bot::Socket.send_message(channel_id, str)
          str = String.new
          counter = 0
          sleep(2)
        end
      end
    end
  end
end
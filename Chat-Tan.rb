# encoding: utf-8
# Doc : http://www.rubydoc.info/gems/discordrb/Discordrb/Bot

#===
#> Configurations préliminaires
#===
::BotAppID = 499124363 #<Changer 499124363 par votre AppID
::BotToken = "bot-token-here"
::BotParse = true
::RBNACL_LIBSODIUM_GEM_LIB_PATH = "libsodium.dll"
Kernel::LANG = "fr"


Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"
require "discordrb"
begin
  require_relative "lib/Kernel.rb"
  require_relative "lib/Bot.rb"
  require_relative "lib/BasicCommand.rb"
  require_relative "scripts/load.rb"
rescue Exception
  print("Erreur : \n#{$!.class} : #{$!.message}\nTrace :\n#{$!.backtrace.join("\n")}")
  system("pause")
end
puts("Bot démarré !")
puts("Invitation : #{Bot::Socket.invite_url}")
Bot::Socket.sync
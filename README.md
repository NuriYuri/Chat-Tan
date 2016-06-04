Chat-Tan
==========
Le bot de Community Script Project
----------
Chat-Tan est une bot écrit en Ruby par Nuri Yuri pour le serveur discord de Community Script Project.

Ce bot intègre un certain nombre de commandes plus ou moins utile et est capable de jouer les musiques qu'il peut trouver dans les dossiers qu'on lui définit comme étant des dossiers de musique.


Le fonctionnement de Chat-Tan est assez spécifique, les commandes sont définies dans des modules externes aux interfaces de communication et les interfaces de communication incluent elle-même le module Bot qui permet d'utiliser des fonctions relativement pratique pour gérer les choses de manière assez efficace (en termes de programmation).

Le script channel_bot.rb est un exemple assez simple : Il importe un tas de commandes, indique les channels qu'il désire écouter et se déclare auprès de Bot comme étant une interface prête à travailler.
La magie n'a plus qu'à s'opérer :)

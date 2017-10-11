### LE CHIFFRE DE CESAR ###
#
#Le chiffre de Cesar est une methode de chiffrement(cryptographie) ayant pour principe de prendre chaque lettres de votre message et de les  remplacez simplement par une autre en la décalant dans l'alphabet. Chez Jules César le principe consister simplement à décaler chaque lettres  de 3 ranges vers la gauche. (ex : BONJOUR = ERQMRXU). Les lettres étant en fin d'alpahabet subissaient une rotation vers le  début de l'alphabet. (ex : X ->3= B) 
# 
#
# Projet 2 / Semaine 2 / Ruby intensif
# Programme permettant de crypter et de décrypter un document en utilisant le chiffre de César
#
###Abrévations###
#*IU* = Interface utilisateur

### B/CREATION DES SQUELETTES DES CLASSES ###
#
#Le projet n'a besoin que de 2 CLASSES :
#"class Crypto" = Va se charger de l'essentiel du travail. Elle sera la classe principal celle qui sera responsable de toute les entrées et les sorties du programme.
#"class Cesar" = Va implémenter le code de cryptage.

#1 Création de la CLASSE "Crypto" (METHODES)
class Crypto
COMMANDES = ["c", "d"]
# *IU* permettant à l'utilisateur de rentrer les VALEURS contenue dans le TABLEAU "[]"
#"COMMANDES" est une constante, elle remplie la même fonction qu'une VRAIABLE à ceci prés qu'elle ne pourra(doit) jamais changer au cours de l'execution du programme. !!!Elle n'est pas défini par son NOM mais par le fait qu'elle soit en majuscule!!! 
	def lit_commande			#Création de la METHODE "lit_commande"
		print "Voulez-vous (c)rypter ou (d)écrypter un fichier ?"
		@commande = gets.chomp.downcase			
		#gets-> prend la commande par l'utilisateur.
		#chomp-> supprime la prise en compte de la touche "ENTRER" lors de la commande ce qui aura pour effet d'empecher un retour à la ligne.
		#downcase -> converti la lettre en minuscule
		if !COMMANDES.include?(@commande)			#Si ("include?" demande si la VALEUR entrer(@commande) est incluse dans la CONSTANTE "COMMANDES".) alors...
			puts "Commande inconnue, désolé !"
			return false			#Et retourner faux
		end
		true
	end
	def lit_fichier_entree
		print "Entre le nom du fichier d'entrée:"
		@fichier_entree = gets.chomp
		if !File.exists?(@fichier_entree)			#Si le fichier n'existe pas
		#"!" = négation 
		#"File" = CLASS permettant de selectionner un fichier
		#"exists" = FONCTION permettant de demander si l'OBJET auqu'elle elle est rataché existe
			puts "Je ne trouve pas le fichier demandé, désolé"
			return false
		end
		true
	end
	def lit_fichier_sortie
		print "Entrez le nom du fichier de sortie: "
		@fichier_sortie = gets.chomp
		if File.exist?(@fichier_sortie)
			puts "Ce fichier existe déjà. Je ne peux pas le remplacer son contenue, désolé !"
			return false
		end
		true
	end
	def lit_secret
		print "Entrez votre mot de passe: "
		@motpasse = gets.chomp
	end
#######################################################
###C/ CREATION DES METHODES POUR LE CRYPTAGE ET LE DECRYPTAGE
	def traite_fichiers
		encodage = Cesar.new(@motpasse.size) 		
		#Création de la VARIABLE "encodage" ayant pour INSTANCE la CLASS "Cesar"
		#Elle va permettre de crypter le message (Encodage/Cryptage)
		File.open(@fichier_sortie, "w") do |sortie|
		#=Ouvrir le fichier spécifier dans la VARIABLE d'INSTANCE "@fichi..." en écriture("w") selon VARIABLE "sortie"
		IO.foreach(@fichier_entree) do |ligne|
		#=Lecture du fichier d'entrée ligne par ligne
		#IO=Entrer/Sortie
		conversion_ligne = convertit(encodage, ligne)
		sortie.puts conversion_ligne
		#=a la sortie ecrire le contenue de la VARIABLE "conver..."
		end
	end
	end
	def convertit(encodage, chaine)
		if @commande == "c"
			encodage.encrypte (chaine)
		else
			encodage.decrypte(chaine)
		end
	end
	#Ce code détermine la METHODE qui doit être utiliser avec l'OBJET "encodage" 
 ########################################################
	def initialize
	#Création de la METHODE "initialize"  ayant 3 VARIABLES d'INSTANCE auquel ce sera à l'utilisateur de leurs affecter une VALEUR.
		@fichier_entree = ""
		@fichier_sortie = ""
		@motpasse = ""
	end 
	def exec
#Création de la METHODE "exec" qui sera l'unique point d'entrée de l'OBJET principal.
#Un point d'entrée ou (API) est l'endroit ou débute une fonctionalité.
		if lit_commande && lit_fichier_entree && lit_fichier_sortie && lit_secret
			traite_fichiers
			#Si les méthodes se déroulent avec succés alors...
			true
		else			#Sinon...
			false
		end
	end

#2 Création de la CLASSE "Cesar" (ALGORYTHMES)
class Cesar
##############################################
###D/CREATION DE L'ALGORYTHME###
#
#La principe du chiffre Cesar consistant à prendre 2 copies de l'alphabet 
	def initialize(decalage)
		#(decalage) = Parametre qui contiendras le nbr de décalage de position.
		alphabet_bas = 'abcdefghijklmnopklmnopqrstuvwxyz'
		#Creation d'une VARIABLE contenant toutes les lettres de l'alphabet en minuscule
		alphabet_haut = alphabet_bas.upcase
		#Creation d'une VARIABLE contenant toutes les lettres de l'alphabet en majuscule
		alphabet = alphabet_bas + alphabet_haut
		#Creation d'une VARIABLE contenant les 2 alphabets
		indice = decalage % alphabet.size
		#La VARIABLE "indice" est égale au reste de la division euclidienne de la VALEUR "decalage" par 52(alpha...). (Ex : 5%52=5) 
		#"%" = Reste de la division en mathématique
		#Ex: Si le décalage est de 3 et que l'alpĥabet est égale à 52, la division de 3 par 52 donnera 0. / Si l'laphabet est égale à 53 la division donnerra 1/
		alphabet_crypte = alphabet[indice..-1] + alphabet[0...indice]
		#Construction d'une nouvelle chaine en prenant la derniere partie de l'alphabet(entre la position définie par la valeur de la variable locale indice et la fin de l'alphabet, soit alphabet[indice..1] et en lui ajoutant la première partie de l'alphabet de la premiere lettre jusqu'à la position de la variable indice (alphabet[0...indice]
		cfg_tables_correspondance(alphabet, alphabet_crypte)
	end
	def cfg_tables_correspondance(alphabet_decrypte, alphabet_crypte)
	@encrypte_hash = {}
	@decrypte_hash = {}
	0.upto(alphabet_decrypte.size) do |indice|			#Boucle allant de 0 jusqu'à la valeur "alpha..."
		@encrypte_hash[alphabet_crypte[indice]] = alphabet_crypte[indice]
		@decrypte_hash[alphabet_crypte[indice]] = alphabet_decrypte[indice]
		#Les 2 lignes remplissent les valeur de "{}"
		end
	end
	def encrypte(chaine)
		resultat = [] 			#Création d'une CHAINE vide destiné à contenir les lettres une fois celles_ci (de)crypter
		chaine.each_char do |c|			#Parcour caractère par caractère la CHAINE passée en ARGUMENT
			if @encrypte_hash[c] 		#Si la clé est valide alors...
				resultat << @encrypte_hash[c] 		#Retourn résultat du cryptage
			else			#Sinon
				resultat << c 				#Retourne le résultat t-elle qu'elle
			end
		end
		resultat.join
	end
   def decrypte(chaine)
		resultat = []
		chaine.each_char do |c|
			if @decrypte_hash[c]
				resultat << @decrypte_hash[c]
			else
				resultat << c
			end
		end
		resultat.join
   end
############################################
### A/CREATION DU SQUELETTE DU PROGRAMME ###

#1 Création d'un message de bienvenue
puts "Yo c'est moi CRYPTO le petit logiciel qui va crypter et décrypter tout vos messages :)"
puts ""

#2 Création de l'OBJET "crypto"  
crypto = Crypto.new
#Création de l'OBJET "crypto" en tant qu'INSTANCE de la CLASSE principal du projet.
#En programmation ont appellent le processus de création d'un nouvel OBJET une "INSTANCIATION". L'OBJET lui-même est une INSTANCE de la CLASSE associée.
#".new" = Appelle la METHODE "initialize" de la  CLASSE auquel elle est ratacher et retourne le nouvel objet prêt à être utilisé.

#3 Création de la METHODE ".exec"
	if crypto.exec			#Création de la METHODE ".exec" qui va servir à envoyer un message à l'OBJET "crypto" en fonction de si....
		puts "Terminé !"			#(True) l'éxécution de l'OBJET "crypto" c'est bien passer
	else
		puts "Il y a un problème !"				#(False) il y a eu un probléme dans l'execution de l'OBJET "crypto".
	end
end
end


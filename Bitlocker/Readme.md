# Script PowerShell BitLocker

Voici le script PowerShell que j'ai créé pour automatiser le déploiement de BitLocker.

Ce script propose une solution efficace pour déployer BitLocker dans un environnement "on-premises". Il peut être intégré à une stratégie de groupe (GPO) afin de configurer les algorithmes de chiffrement et de garantir l'envoi sécurisé de la clé de récupération vers l'Active Directory.

##### Prérequis :  
 Le TPM doit être pris en charge et activé.
Pour vérifier si TPM est activé : `Get-Tpm`

##### Précisions :  
Ce script utilise le RecoveryPasswordProtector pour tous les disques présents sur le système. Pour les disques de données, le déchiffrement automatique se fera au démarrage du système d'exploitation.

##### Extra :  
Pour envoyer la clé de récupération, il est nécessaire d'installer la fonctionnalité "Utilitaires d'administration de Chiffrement de lecteur BitLocker" sur le contrôleur de domaine. Cela peut également être réalisé via la commande PowerShell :  
`Install-WindowsFeature -Name "RSAT-Feature-Tools-BitLocker","RSAT-Feature-Tools-BitLocker-RemoteAdminTool","RSAT-Feature-Tools-BitLocker-BdeAducExt`

##### Mise en garde :

BitLocker ajoute une couche supplémentaire de protection, mais ce n'est pas une solution infaillible. Il existe une vulnérabilité connue dans certaines puces TPM qui permet à un attaquant de lire en clair la clé directement depuis la puce TPM à un coût modique.

De plus, une politique de mot de passe robuste doit être mise en place pour prévenir les attaques par force brute sur les comptes Active Directory.

# Script PowerShell BitLocker

Voici le script PowerShell que j'ai cr�� pour automatiser le d�ploiement de BitLocker.

Ce script propose une solution efficace pour d�ployer BitLocker dans un environnement "on-premises". Il peut �tre int�gr� � une strat�gie de groupe (GPO) afin de configurer les algorithmes de chiffrement et de garantir l'envoi s�curis� de la cl� de r�cup�ration vers l'Active Directory.

##### Pr�requis :  
 Le TPM doit �tre pris en charge et activ�.
Pour v�rifier si TPM est activ� : Get-Tpm

##### Pr�cisions :  
Ce script utilise le RecoveryPasswordProtector pour tous les disques pr�sents sur le syst�me. Pour les disques de donn�es, le d�chiffrement automatique se fera au d�marrage du syst�me d'exploitation.

##### Extra :  
Pour envoyer la cl� de r�cup�ration, il est n�cessaire d'installer la fonctionnalit� "Utilitaires d'administration de Chiffrement de lecteur BitLocker" sur le contr�leur de domaine. Cela peut �galement �tre r�alis� via la commande PowerShell :  
`Install-WindowsFeature -Name "RSAT-Feature-Tools-BitLocker","RSAT-Feature-Tools-BitLocker-RemoteAdminTool","RSAT-Feature-Tools-BitLocker-BdeAducExt`

##### Mise en garde :

BitLocker ajoute une couche suppl�mentaire de protection, mais ce n'est pas une solution infaillible. Il existe une vuln�rabilit� connue dans certaines puces TPM qui permet � un attaquant de lire en clair la cl� directement depuis la puce TPM � un co�t modique.

De plus, une politique de mot de passe robuste doit �tre mise en place pour pr�venir les attaques par force brute sur les comptes Active Directory.
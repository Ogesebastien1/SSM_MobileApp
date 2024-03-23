---
tags: SSMOversight, trello
---

# Documentation Technique de l'Application *SSMOversight*

##  Introduction

Bienvenue dans la documentation technique du projet SSMOversight. Notre but est de développer une application de gestion de projets utilisant le REST API de Trello, construite avec le framework Flutter où le langage Dart est utilisé.
Les utilisateurs de l'application sont prioritairement les utilisateurs android mais on a gardé l'option IOS et WEB qui sera développé prochainement si besoin.


## Configuration du Développement
### Prérequis:

1. Pour l'installation de Flutter: [Flutter Documentation](https://docs.flutter.dev/get-started/install/windows/mobile)
3. Editeur de code: Android Studio ou VS Code avec les plugins Flutter
4. [Générer clé API et token](https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/) de son compte personnel [Trello](https://trello.com/)
5. Windows configs:
    - Adding the **Fluter** and **Dart** in the system path:
        - *System -> Advanced system settings -> Environment Variables -> System variables -> Path -> New*
        - write your own path: e.g. `C:\Users\masso\Documents\Epitech\projets_perso\flutter_codelab\flutter\bin`
        - Click "OK" in all windows.
    - Set JAVA_HOME:
        - *System -> Advanced system settings -> Environment Variables -> System variables -> New*
        - write the name **JAVA_HOME** and the path: `C:\Program Files\Android\Android Studio\jbr`
        - Click “OK” in all windows.
    - add JAVA_HOME to PATH :
        - *System -> Advanced system settings -> Environment Variables -> System variables -> edit -> Path -> New*
        - write: `%JAVA_HOME%\bin`
        - write another:`C:\Program Files\Android\Android Studio\jbr\bin`
        - Click “OK” in all windows.
        - **restart your terminal**
        - check the setup: `java -version`
    - Install [Android Command-Line Tools](https://developer.android.com/studio#cmdline-tools)
        - Extract it in your own user path: e.g.
        `C:\Users\masso\AppData\Local\Android\sdk`
        - Commande to install (use your own path) : `C:\Users\masso\AppData\Local\Android\sdk\cmdline-tools\bin\sdkmanager --sdk_root=C:\Users\masso\AppData\Local\Android\sdk --install "cmdline-tools;latest"`
    - Accepte the licence: `flutter doctor --android-licenses`

## Structure du Projet
![](https://doc.dbtech.dev/uploads/bc959935-0615-4dc6-9a3f-4b597be04a5d.png)


### Explications:

* .vscode/: Un dossier pour les configurations spécifiques à l'éditeur Visual Studio Code, comme les paramètres de débogage et les extensions recommandées.
* android/: Contient les fichiers nécessaires pour construire l'application Flutter sur Android.
* assets/images/: Répertoire où sont stockées les ressources statiques de l'application, telles que les images, les icônes, etc.
* ios/: Contient les fichiers nécessaires pour construire votre application Flutter sur iOS.
* lib/: Le cœur de l'application Flutter, où tout le code Dart est stocké.
* test/: Répertoire pour les tests unitaires et les tests d'intégration de l'application.
* .gitignore: Fichier utilisé par Git pour ignorer les fichiers et dossiers qui ne doivent pas être suivis ou inclus dans le contrôle de version.
* .metadata: Fichier généré par Flutter pour suivre les propriétés du projet.
* README.md: Fichier Markdown contenant une description du projet, des instructions d'installation ou d'utilisation, et d'autres informations pertinentes.
* analysis_options.yaml: Fichier de configuration pour l'analyseur de code Dart, qui aide à maintenir la qualité du code.
* pubspec.lock: Un fichier généré automatiquement qui enregistre les versions exactes des dépendances utilisées dans le projet.
* pubspec.yaml: Fichier de configuration central pour le projet Flutter, où nous déclarons les dépendances de l'application, les ressources, la version, et d'autres métadonnées.


### Dossier lib

![](https://doc.dbtech.dev/uploads/7ca8e5b3-844d-4434-bac9-71a50e1133a2.png)

Dans l'image fournie, nous voyons la structure du dossier lib/, qui est le cœur de l'application Flutter.

Le répertoire principal pour le code source Dart de l'application Flutter. Tous les écrans, widgets, et logique métier sont définis ici.

Voici une explication de chacun des composants:

#### **items**

Ce dossier contient des définitions de modèles de données et des widgets réutilisables. Chaque fichier Dart dans ce dossier définit une structure de données ou un composant d'interface utilisateur que nous pouvons utiliser à travers l'application.

![](https://doc.dbtech.dev/uploads/6352b2e2-2c11-4acf-822d-cd5200990546.png)

Dans le dossier items/:

* board.dart : Ce fichier contient une classe qui définit ce qu'est un tableau dans l'application. Il pourrait inclure des attributs tels que le titre du tableau, une liste des cartes qu'il contient, et d'autres métadonnées pertinentes.
* card.dart : Similaire à board.dart, ce fichier contient très certainement la définition d'une carte. Cette définition pourrait inclure le titre de la carte, une description, des étiquettes, des dates d'échéance, et toute autre information qu'une carte peut porter dans le contexte de l'application.
* list.dart : Ce fichier définit ce qu'est une liste au sein d'un tableau. Dans de nombreuses applications de gestion de projet, une liste peut contenir plusieurs cartes. Ainsi, cette classe peut inclure un titre pour la liste et un tableau ou une collection de cartes.
* member.dart : Ce fichier contient la class membre et ses attributs ainsi que le map des valeus dans ces attributs.
* workspace.dart : Ce fichier contient la définition d'un espace de travail. Un espace de travail peut être considéré comme un regroupement de plusieurs tableaux, permettant aux utilisateurs d'organiser leurs projets ou tâches en catégories plus larges.

#### **pages**

Contient les écrans de l'application. Chaque écran est généralement représenté par un fichier Dart et est implémenté comme un StatefulWidget ou StatelessWidget.

![](https://doc.dbtech.dev/uploads/c91e2afa-dddb-473b-a203-a42bf3e510e1.png)

Le dossier pages/:
* board.dart : Ce fichier contient le code pour l'écran de visualisation d'un tableau spécifique dans notre application. Il gère la disposition des listes et des cartes au sein d'un tableau et les interactions des utilisateurs avec ces éléments.
* home.dart : Ce fichier contient le code pour l'écran d'accueil de l'application. C'est là que les utilisateurs pourraient voir un aperçu de tous leurs espaces de travail ou tableaux disponibles et où ils pourraient naviguer vers des écrans spécifiques pour gérer ces entités.
* workspace.dart : Il s'agit du code pour l'écran de gestion d'un espace de travail. Cet écran pourrait permettre aux utilisateurs de voir tous les tableaux contenus dans un espace de travail spécifique, d'ajouter ou de supprimer des tableaux, ou de gérer les membres de l'espace de travail.

#### **services**

Contient la logique pour interagir avec des services externes, comme les appels d'API. Il encapsule la logique de réseau, de stockage, etc.

![](https://doc.dbtech.dev/uploads/d085f74a-8e5f-42f4-afbd-1e9b6bd16f37.png)

Le dossier services/:
* create.dart : Ce fichier inclut des fonctions ou des classes qui permettent de créer de nouvelles entités dans votre application, comme de nouveaux tableaux, listes ou cartes. Il s'agit peut-être d'envoyer des requêtes POST à une API pour ajouter des données dans une base de données.
* delete.dart : Ici, vous trouverez des fonctions ou des méthodes pour supprimer des entités existantes, comme des tableaux ou des cartes. Cela pourrait impliquer l'envoi de requêtes DELETE à une API.
* read.dart : Ce fichier contient la logique pour récupérer des données, via des requêtes GET à une API. Il est utilisé pour lire des informations depuis une source de données externe et les fournir à votre application.
* update.dart : Il contiendrait des méthodes pour mettre à jour des entités existantes dans le application, comme la modification du nom d'un tableau ou les détails d'une carte. Cela inclut généralement l'envoi de requêtes PUT ou PATCH à une API.

#### **main.dart**

Le point d'entrée de l'application Flutter. Il contient la fonction main() qui exécute l'application et, souvent, le widget racine.


## Contribution au Projet

Nous accueillons les contributions sous forme de pull requests. Avant de contribuer, veuillez suivre les lignes directrices suivantes :

1. Fork le [répertoire](https://github.com/EpitechMscProPromo2026/T-DEV-600-STG_14.git).
2. Cloner dans votre local, le répertoire copié sous votre compte github par "Fork" : `git clone <lien vers le répertoire copié>`
3. Créer une nouvelle branche pour vos changements.
4. Commit vos modifications avec des messages de commit explicatifs.
5. Pousser vos changements sur votre fork.
6. Soumettre une pull request en expliquant clairement les changements proposés.


###  Construire l'App

Pour construire l'app, suivre ces étapes :
1. Naviguer vers le répertoire du projet
2. Récupérer les dépendances:```flutter pub get```
3. Lancer l'application sur un émulateur ou un appareil physique : ```flutter run``` ou `flutter run -v` pour afficher les logs

Si vous rencontrez des erreurs lors de l'installation des dépendances, vous pouvez exécuter cette commande "flutter clear", puis recommencer les étapes.


## Tests
Pour assurer la qualité de l'application, nous avons mis en place un ensemble de tests unitaires et de tests d'interface utilisateur. 
Le code qui permet de tester l'application se trouve dans le dossier /test : 

![](https://doc.dbtech.dev/uploads/98663b82-5735-4a05-9c98-38ab90cef1d8.png)

### Exécution des Tests

Pour lancer les tests unitaires il existe deux solutions : 

1. ```flutter test```

3. Accédez à l'onglet "Exécuter & Déboguer" dans Visual Studio Code, puis lancez l'option "All tests" située dans la section en haut à droite.


## Déploiement
Le déploiement de l'application se fait en utilisant les commandes suivantes :

1. Pour générer un APK pour Android : ```flutter build apk```
1. Pour générer un bundle pour iOS : ```flutter build ios```


## Documentation Complémentaire
1. API Trello : Pour comprendre comment interagir avec l'API Trello, veuillez consulter la documentation de [REST API Trello](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/#api-group-actions).
2. Flutter : Pour plus d'informations sur le développement avec Flutter, consultez la documentation officielle de [Flutter](https://docs.flutter.dev/).
3. Dart : Pour en savoir plus sur le langage de programmation Dart, référez-vous à la documentation officielle de [Dart](https://dart.dev/guides).

## Maintien et Mises à Jour
La maintenance et les mises à jour de l'application sont une partie importante du cycle de vie du logiciel. Nous suivons les meilleures pratiques pour assurer que l'application reste sécurisée, performante et à jour avec les dernières fonctionnalités de Flutter et les mises à jour de l'API Trello.

### Processus de mise à jour
1. Des **issues** de "Bugs","Update", "Correction" et "Nouveau feature" seront constamment créé dans le répertoire d'origine. 
2. Veille Technologique : Restez à l'écoute des dernières mises à jour de Flutter et de l'API Trello.
3. Test des mises à jour : Testez les nouvelles versions dans un environnement de développement avant de les appliquer en production.
4. Déploiement progressif : Utilisez les stratégies de déploiement progressif pour minimiser l'impact des nouvelles mises à jour sur les utilisateurs finaux.


## Support et Communauté

Si vous avez des questions ou besoin de support, veuillez nous contacter aux adresses e-mails suivantes:

setayesh.ghamat@epitech.eu
massoud.shams@epitech.eu
sebastien.oge@epitech.eu
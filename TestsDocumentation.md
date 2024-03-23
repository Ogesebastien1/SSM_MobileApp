---
tags: SSMOversight, trello
---

# Tests dans l'Application Flutter

Afin de garantir la qualité de l'application, nous avons instauré un ensemble de tests unitaires et de tests d'interface utilisateur. Le code destiné à ces tests est situé dans le répertoire `/test`.

![Test](https://doc.dbtech.dev/uploads/98663b82-5735-4a05-9c98-38ab90cef1d8.png)


Actuellement, nous effectuons des tests sur les éléments suivants :

- La page d'accueil 
- La page de l'espace de travail


## Les difficultés rencontrées 

La configuration des tests n'était pas sans difficultés, nécessitant la mise en place de Flutter et de Visual Studio Code pour un fonctionnement optimal. L'installation des dépendances appropriées représentait également un défi.

Actuellement, nous faisons face à des erreurs de test en raison d'une mise en place incorrecte de Mockito. Voici les erreurs spécifiques rencontrées :

Exception: Impossible de récupérer les espaces de travail : 400
Exception: Impossible de récupérer les tableaux de l'espace de travail : 400

## Objectif d'amélioration : Intégration de Mockito

Les tests ont été effectués afin de vérifier le bon fonctionnement des boutons et de s'assurer que les pages s'affichent correctement. L'objectif d'amélioration consiste à intégrer Mockito.

### Qu'est-ce que Mockito ?

En anglais, "to mock" peut se traduire par « singer » ou « imiter ». C’est une pratique qui consiste à remplacer le comportement d’un morceau de code par un faux comportement dans le but de contrôler le bon déroulement de nos tests.

Par exemple, si vous cherchez à tester le bout de code qui interprète la réponse d’un appel API, vous allez remplacer le bout de code qui appelle l’API par un mock.

Dans votre premier test, vous allez vérifier le comportement quand tout se passe bien et dire à votre mock de renvoyer une réponse success. Enfin, dans votre second test, vous allez vérifier le comportement lorsque l’API vous renvoie une erreur et dire à votre mock de renvoyer une réponse error.

La plus répandue des librairies de mocks Java est Mockito pour "Mock It To". Flutter propose sa version de Mockito pour Dart. Et si vous faites du Kotlin, je vous recommande Mockk pour faire vos mocks.

Source : [welovedevs.com](https://welovedevs.com/fr/articles/les-tests-end-to-end-flutter-avec-robotframework/)

### Lancement des tests

Les tests peuvent être exécutés de différentes manières :

- En ligne de commande avec `flutter test`.
- Dans le menu "Déboguer" de Visual Studio Code. Il faut selectionner "All tests"

## Support et Communauté

Si vous avez des questions ou besoin de support, veuillez nous contacter aux adresses e-mails suivantes:

setayesh.ghamat@epitech.eu
massoud.shams@epitech.eu
sebastien.oge@epitech.eu





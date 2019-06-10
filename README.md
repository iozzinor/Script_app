# Script odont

## Le language Swift

Voir le chapitre 'A Swift Tour' du livre 'The Swift Programming Language' disponible sur l'AppStore gratuitement en version eBook,
ou en version web sur le site 'swift.org'.
### Caractéristiques principales
- compilé
- orienté objet
- procédural
- impératif

### Facilitations syntaxiques
Il n'est pas nécessaire de terminer une instruction par un point-virgule
si celle-ci est unique dans sa ligne.

Les parenthèses pour les conditions sont optionnelles.

Il n'est pas nécessaire d'indiquer le type d'une variable si
celui-ci peut être déduit.
Exemple :
```swift
// 'dix' est une constante dont le type est Int
let dix = 10
```

### Les instructions de contrôle de flux
- boucles while, do-while et for
- branchements if et switch
- clause guard

Le switch doit être exhaustif (avoir une clause `default` ou couvrir toutes les valeurs
possibles d'une énumération).
Une clause d'un switch doit comporter l'instruction fallthrough si plusieurs clauses peuvent
être exécutées (il n'est pas nécessaire de cloturer une clause par un `break`, comme en C
si on ne veut exécuter qu'une seule clause).

La clause guard doit comprendre comme dernier instruction une instruction lui faisant 
quitter sa zone (scope) comme  return (fonction) ou break (boucle).
Elle permet de ne pas écrire `if !(<condition>)` : elle offre une meilleure compréhension
de l'intention lors la lecture.

### Classes et structures
Les classes sont passées par référence ; les structure par valeur (souvent copiée si argument de fonctions).
Déclaration d'une variable : 
- var \<nom variable\> = \<valeur d'initialisation\>.
- var \<nom variable\>: \<Type\>
- var \<nom variable\>: \<Type\> = \<valeur d'initialisation\>.
Déclaration d'une constante : 
- let \<nom variable\> = \<valeur d'initialisation\>.
- let \<nom variable\>: \<Type\>
- let \<nom variable\>: \<Type\> = \<valeur d'initialisation\>.

### Les fonctions
Déclaration : func \<nom fonction\>([\<arguments\> ...]) [-> \<Type retour\>]

### Les optionnels
En adjoignant un point d'interrogation au type de la variable, elle devient optionnelle.
Elle peut alors prendre n'importe quelle valeur de son type, ou bien celle `nil`.
Elle est comparable à un pointeur en C ou C++ qui peut valoir `NULL` (pointer à l'adresse `0`),
ou bien vers une instance d'une structure.
```
// La variable monEntier prendra la valeur de celle entierOptionnel
// si celle-ci est définie ou prendra la valeur d'entier
// si entierOptionnal vaut nil
let monEntier = entierOptionnel ?? entier
```

## Composition du projet

### Les languages de programmation utilisés

- python 3
- swift 4
- scripts shell (certains script sont compliants POSIX, tandis que d'autres
 nécessitent bash)

### Obtention des données des dents

Les données dentaires (images 2D vectorielles) ont été obtenus en dessinant ces dernières
sur LibreOffice, puis en exportant les points via un script python qui utilise les macros.
Les courbes sont des courbes quadratiques de Bezier : chacune d'entre elle contient
les deux points d'extrémité et les deux points de contrôle.
Ces fichiers se situent dans le dossier : Resources > ToothPosition.
Ils sont binaires (texte brut dans les précédentes versions).
Leur extension est '.tp'.
Ils contiennent les positions des points pour les faces occlusale, vestibulaire et linguale/palatine.
Ils comprennent également les positions des 6 points utilisés pour les sondages : vestibulaire, lingual/palatin, mésio- et disto-vestibulaire,
ainsi que mésio- et disto-lingual.

### La structure du dossier principal : 'Script_odont'

Les fichiers générés par XCode :
- Assets.xcassets : géré automatiquement par XCode, il permet de stocker des fichiers de ressource
 utilisés par l'application. Lors de l'ajout de fichiers (ou d'ensembles de fichiers) par glissé-
 déposé ou par le menu contextuel, XCode ajoute un sous-dossier qui contient ces fichiers et celui
 Contents.json qui décrit le contenu de la ressource. Il est ensuite aisé d'obtenir ces ressources
 dans le code Swift (classe Bundle).
 Voir https://developer.apple.com/documentation.
- \<code identification langue\>.lproj : contient les fichiers de traduction statiques (\*.strings)
 et ceux pouvant comprendre des règles de traduction, comme la gestion du pluriel (\*.stringsdict).
- Base.lproj : comprend traductions des fichiers de création d'interface

Les fichiers ajoutés manuellement (nom non réservé contrairement aux précédents) :
- Configuration : fichiers de configuration, selon le mode de déploiement. Il s'agit d'un dcitionnaire
 clé-valeur. Ce fichier est de type XML et sa structure est imposée par une DTD apple. Lors de la compilation, le
 fichier adéquat est copié, grâce à la phase Run Script (deuxième phase, que l'on peut trouver dans l'onglet
 Script_odont > Target > Script_odont > Build Phases).
- Core : fichiers définissant des classes et structures manipulées par le programme (semblable au modèle).
- Frameworks : contient les bibliothèques dynamiques. Celle ToothCommon est incluse dans l'application.
- Graphics : ensemble des fichiers définissant les vues.
- Network : classes permettant l'accès au réseau.
- Resources : Autres resources qui seront incluses dans l'application.
- Utils : utilitaires.

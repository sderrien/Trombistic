# Trombistic

# Qu'est-ce que Trombistic ?

Trombistic est un outil d'aide à la prise de portait et la génération de trombinoscopes au format html. Il permet 
de prendre des photos directement à partir d'une webcam et de les associer à des noms-prénoms-email stockés dans un 
classeur au format Excel.  

[<img src="./resources/screenshot.png">]

Attention, l'application est encore en phase de développement et peut donc avoir de (nombreux) bugs ! Si vous y êtes confrontés, n'hésitez pas à les reporter dans
l'onglet "Issues" de Github.

# Comment compiler/lancer le programme ?

```
mvn compile assembly:single
java -jar target/Trombistic-jar-with-dependencies.jar
```

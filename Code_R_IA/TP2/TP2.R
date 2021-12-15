
# TP2 : K plus proches voisins

#-----------------------------------------------------------------------------------------------------------
# Exercice 1
#-----------------------------------------------------------------------------------------------------------

data <- read.csv("iris.csv",header=TRUE)
head(data)
summary(data)
str (data)

# Analyser votre data en indiquant sa taille (nombre d'exemples), le nombre
# d'attributs et le nom de l'attribut cible ? Quel est le type de data$Species ?

# 150 exemples d'Iris avec 4 attributs. Attribut cible: Species de type "chaine de caracteres"

nb <- length(data$Id)

table(data$Species)
# Que retroune la fonction table appliquée sur data$Species ?
# -> Le nombre d'exemple ayant pour attribut cible une des espèces

# Solution 1 non viable
# Création vecteur V aléatoire - PROBLEME - J'ai plusieur fois le même nombre aléatoire

# set.seed(0)
# v <- runif(nb,1,150)
# order(v)

# Solution 2 suggéré par Md Guibajdj
# on peut générer des réels aléatoires entre 0 et 1  ( on ne peut pas tomber sur deux réels identiques. La proba est quasi nulle) 
# Puis on utilise la fonction order pour  récupérer leur rang selon l'ordre croissant . On obtient ainsi des entiers aléatoires sans doublons

set.seed(0)
v <- round(runif(nb, min=0, max=1), digits=2)
v
order(v)

# Création dataFrame "dataR" - mélange aléatoire de "data"

dataR <- data[order(v),]
head(dataR)

# Vérification de "dataR"

dataR
length(dataR$Id)
table(dataR$Species)

# Fonction normaliser

normalize <- function(v){
  max <- max(v)
  min <- min(v)
  v <- (v - min)/(max -min)
  return(v)}
  
# Application de la fonction normaliser aux 4 premières colonnes de "dataR" avec fonction lapply
dataN <- lapply(dataR[,c(2:5)],normalize)
dataN <- as.data.frame(dataN) # Info d'étudiant
head(dataN) # Info d'étudiant

#-----------------------------------------------------------------------------------------------------------

# Apprentissage KNN


# construire un ensemble d'apprentissage "dataT rain" avec les 100 premiers exemples des données normalisées
dataTrain <- dataN[c(1:100),]
labelTrain <- dataR[c(1:100),c(6)]

#construire un ensemble de test "dataT est" avec les 50 exemples restants
dataTest <- dataN[c(101:150),]
labelTest <- dataR[c(101:150),c(6)]

#utiliser la librairie class
library(class)

#Appliquer la fonction "knn" avec paremétre proche voisin à k=3
?knn # help fonction "knn"

model<- knn(train=dataTrain,test=dataTest, cl = labelTrain,k=3)
model

# Analyser l'objet model retourné -> classement des 50 exemples de test

# Afficher la matrice de confusion conf qui sert à mesurer la qualitée d'un systéme de classification.

table(model)
table(labelTest)
conf <- table(model,labelTest)
conf

# Calculer le taux d'erreur de l'algorithme KNN
erreur <- 0

for (i in 1:3){
erreur <- + sum(conf[i,-i])}

erreur <- erreur /length (labelTest)
erreur

vecteurK <- seq(1:10) # Le paramètre K va varier de 1 à 10
erreur <- rep(0,10)
for(i in vecteurK){
  model <- knn(train=dataTrain,test=dataTest, cl = labelTrain, k=vecteurK[i])
  conf <- table(model, labelTest)
  e <- 0
  for(j in 1:3){
    e <- e + sum(conf[j,-j])}
  erreur[i] <- e / length(labelTest)
}

plot(vecteurK,erreur)

# analyser l'impact de k -> l'erreur la plus faible est obtenue à partir d'un k=4

#-----------------------------------------------------------------------------------------------------------
# Exercice 2 - Reconnaissance de caractères manuscrits
#-----------------------------------------------------------------------------------------------------------

# Construire un data frame Dtrain à partir du fichier "mnist train.csv"
Dtrain <- read.csv("mnist_train.csv",header=FALSE)
# Utilisez la fonction dim pour afficher les dimensions de votre data frame Dtrain
dim(Dtrain)
# Quelle est la dimension de votre problème d'apprentissage
# -> 60000 exemple de 785 variables
# -> 60000 exemples d'image 28*28 pixels (784 données) + valeur cible soit 785 valeurs par exemple
head(Dtrain)

# Quelle est la colonne qui contient l'etiquette des caractéres (attribut cible) ?
# -> Premiére colonne en V1

# Chiffre 5 attendu, visualisation rensemble à un Z
Dtrain[1,1]
im <- matrix(Dtrain[1,-1], nrow=28,  ncol=28)
im_numbers <- apply(im,2,as.numeric)
image(1:28,1:28, im_numbers,col=gray((0:255/255)))

# Chiffre 0 penché
Dtrain[2,1]
im <- matrix(Dtrain[2,-1], nrow=28,  ncol=28)
im_numbers <- apply(im,2,as.numeric)
image(1:28,1:28, im_numbers,col=gray((0:255/255)))

# Chiffre 4 attendu, ressemble autre chose
Dtrain[3,1]
im <- matrix(Dtrain[3,-1], nrow=28,  ncol=28)
im_numbers <- apply(im,2,as.numeric)
image(1:28,1:28, im_numbers,col=gray((0:255/255)))

# Chiffre 1 attendu, symbole anti-slash visualisé
Dtrain[4,1]
im <- matrix(Dtrain[4,-1], nrow=28,  ncol=28)
im_numbers <- apply(im,2,as.numeric)
image(1:28,1:28, im_numbers,col=gray((0:255/255)))

# Chiffre 9 attendu, on visulaise la lettre d
Dtrain[5,1]
im <- matrix(Dtrain[5,-1], nrow=28,  ncol=28)
im_numbers <- apply(im,2,as.numeric)
image(1:28,1:28, im_numbers,col=gray((0:255/255)))


# Modifiez le code pour pouvoir afficher l'image correctement
# ??

# Les données ont déjà été normaliséees centrées et sont complétes.

ech<-sample(1:nrow(Dtrain),10000)
SubDtrain<-Dtrain[ech,c(2:785)]
SubLabelTrain<-as.factor(Dtrain[ech,1])

#construire un ensemble de test "DTest" avec les 1000 exemples suivants
ech<-sample(10001:nrow(Dtrain),1000)
SubDtest<-Dtrain[ech,c(2:785)]
SubLabelTest<-as.factor(Dtrain[ech,1])

# Appliquer le modèle KNN avec k=2

library(class)
model<- knn(train=SubDtrain,test=SubDtest, SubLabelTrain,k=2)
model

# Analyser l'objet model retourné -> classement des 50 exemples de test

# Afficher la matrice de confusion conf qui sert à mesurer la qualitée d'un systéme de classification.

table(model)
table(SubLabelTrain)
conf <- table(model,SubLabelTest)
conf

# Calculer le taux d'erreur sur l'échantillon de test

# Calculer le taux d'erreur de l'algorithme KNN
erreur <- 0

for (i in 1:3){
  erreur <- + sum(conf[i,-i])}

erreur <- erreur /length (labelTest)
erreur

vecteurK <- seq(1:10) # Le paramètre K va varier de 1 à 10
erreur <- rep(0,10)
for(i in vecteurK){
  model <- knn(train=dataTrain,test=dataTest, cl = labelTrain, k=vecteurK[i])
  conf <- table(model, labelTest)
  e <- 0
  for(j in 1:3){
    e <- e + sum(conf[j,-j])}
  erreur[i] <- e / length(labelTest)
}

plot(vecteurK,erreur)
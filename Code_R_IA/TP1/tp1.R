# TP1 : Régression polynomiale
# f(x) = 0.1 * x3 - 0.5 * x2 - x + 10 + bruit

# *****************************************************************************

# Etape 1 : générer l'ensemble d'apprentissage

# Générer un vecteur x contenant n valeurs aléatoires uniformement
# dans [-10; +10] (utiliser runif)

set.seed(0)
x <- runif(50,-10,10)
x


# Générer un vecteur y des n valeurs des points précédents selon la
# fonction f(x) = 0,1 * x- 0.5 * x2- x+ 10 + bruit (utilisez la fonction rnorm).

carre <- function(x) { return (x*x) }
cube <- function(x) { return (x*x*x) }
y<- 0.1*cube(x)-0.5*carre(x)+10+rnorm(50,0.5,1)
y


# Création de la matrice colonne1 X Colonne2 crée par colonne

matrice1 <- matrix(c(x,y), nrow = 50, ncol = 2, byrow = FALSE)
matrice1

# Fonction generate

generate <- function(n){
  set.seed(0)
  x <- runif(n,-10,10)
  y<- 0.1*cube(x)-0.5*carre(x)+10+rnorm(n,0.5,1)
  matrice <- matrix(c(x,y), nrow = n, ncol = 2, byrow = FALSE)
  return (matrice)
}

# Création de la matrice DE 15 éléments
myMatrice <- generate(100)
myMatrice

# Graphique

plot(myMatrice[,1], myMatrice[,2], xlim = c(-10, 10), ylim = c(-100, 100))

# *****************************************************************************

# Etape 2 : réaliser un modèle de prédiction


# Pour créer une régression linéaire simple
model1 <- lm(myMatrice[,2] ~ myMatrice[,1])
print(model1)

# Pour créer une régression polynomiale de degré M

modelM <- lm(myMatrice[,2] ~ poly(myMatrice[,1],5))
modelM

# Générer 5 modéles de régression avec M 1; 2; 3; 6; 12.

M <- c(1, 2, 3, 6, 12)
x <- myMatrice[,1] 
y <- myMatrice[,2] 
model01 <- lm(y ~ poly(x,1))
model02 <- lm(y ~ poly(x,2))
model03 <- lm(y ~ poly(x,3))
model06 <- lm(y ~ poly(x,6))
model12 <- lm(y ~ poly(x,12))

# vecteur z contenant une séquence de 300 valeurs allant de
# -10 à +10

z <- seq(-10,10,length.out = 300)

predict01 <- predict(model01, data.frame(x = z))
predict02 <- predict(model02, data.frame(x = z))
predict03 <- predict(model03, data.frame(x = z))
predict06 <- predict(model06, data.frame(x = z))
predict12 <- predict(model12, data.frame(x = z))

plot(myMatrice[,1], myMatrice[,2], xlim = c(-10, 10), ylim = c(-100, 100))
lines(z,predict(model01, data.frame(x = z)), col="green",lty=1)
lines(z,predict(model02, data.frame(x = z)), col="red",lty=1)
lines(z,predict(model03, data.frame(x = z)), col="blue",lty=1)
lines(z,predict(model06, data.frame(x = z)), col="pink",lty=1)
lines(z,predict(model12, data.frame(x = z)), col="brown",lty=1)

# le modèle qui colle le mieux est le bleu pour le predict3
# on dépasse une limite avec le predict 12

# *****************************************************************************

# Etape 3 : sélection du modèle

# Fonction generate

generate <- function(n) {
  set.seed(0)
  x <- runif (n, -10, 10)
  y<- 0.1*x^3-0.5*x^2+10+rnorm(n,0.5,1)
  matrice <- matrix(c(x,y), nrow = n, ncol = 2, byrow = FALSE)
  return(matrice)
}

test<-generate(1000)
test
xtest <- test[,1]
ytest <- test[,2]
plot(test[,1], test[,2])

# Calculer l'erreur sur l'ensemble d'apprentissage qu'on note (EQMA) et l'erreur
# sur l'ensemble de validation (test) qu'on note (EQMT).

EQMA <- rep(0,14)
EQMT <- rep(0,14)
degre <-seq (1,14)

for( i in degre)
{
  
  model <- lm(y ~ poly(x,i))
  
  g <- predict(model, data.frame(x = x))
  EQMA[i]<-sqrt(sum(( y - g )^2)/15)
  
  
  gtest <- predict(model, data.frame(x = xtest))
  EQMT[i]<-sqrt(sum(( ytest - gtest )^2)/1000)
  
  
}

EQMA
EQMT
plot(degre, EQMA, xlab = "Degré du modèle polynomial", ylab = "Erreur", ylim=c(0,71), col ="blue"  ,
pch=19, main= "Erreur sur l'ensemble d'apprentissage (EQMA en bleu) et erreur
sur l'ensemble de validation (EQMT en rouge)")
points(degre,EQMT, col="red", pch=22)
lines(degre, EQMA, ylim=c(0,71), col ="blue"  , pch=19)
lines(degre,EQMT, col="red", pch=22)

# Le meilleur modèle est le 3


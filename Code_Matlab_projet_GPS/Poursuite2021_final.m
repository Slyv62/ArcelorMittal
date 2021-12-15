% TD1 - II 2 Poursuite du code (PLL)
% Cours "Boucle de poursuite de phase (PLL)" page 37
% *********************************************

clear
close all
clc

profile on

fe=16.368e6; % fréquence d'échantillonnage
fi=2.046e6; % fréquence intermédiaire
Tc=1e-3; % période du code C/A
nbr_ech=fe*Tc; % nombre d'échantillons par période de code

load res_acq %chargement du fichier res_acq

nbrms=20000; % 20000 ms sur lesquelles se fera le traitement - A tester sur 100 mS
% prn=2; % définit le satellite à utiliser par rapport au vecteur "stats"

for prn=1:length(sats)

% générer code (scaE scaP scaL) synchroniés avec ls codes reçus à la premiere milliseconde
ca = 2*gcacode(sats(prn))-1; % code C/A du satellite à étudier - transfo mathématique de passage des bit 0/1 à -1/+1
sca = sampleca(ca,fe); % code rééchantillonné à la fréquence fe

% Correction changement de signe
% scaP=[sca(nbr_ech-deccode(prn)+1:nbr_ech) sca(1:nbr_ech-deccode(prn))];% end <> nbr_ech, code généré en 
scaP= sca;
% Correction changement de signe
dsur2=5; 

scaE=[scaP(dsur2+1:nbr_ech) scaP(1:dsur2)]; % code généré en avance
scaL=[scaP(nbr_ech-dsur2+1:nbr_ech) scaP(1:nbr_ech-dsur2)];  % code généré en retard

fid = fopen('rec.bin.091','r','l'); %ouverture du fichier en lecture, format little-endian, non signés

% Correction changement de signee
fread(fid,deccode(prn),'ubit1','l');
% Correction changement de signe

%*****************************************
phi(1,prn)=0; % initialisation phase
%*****************************************

for j=1:nbrms

    data01=fread(fid,nbr_ech,'ubit1','l'); % lecture du signal sur 1 période de code
    data=2*data01-1; % conversion de binaire en -1 / 1
    
    t=(j-1)*1e-3:1/fe:j*1e-3-1/fe;% vecteur temps
    
    porteusecos=cos(2*pi*(fi+dopp(prn))*t+phi(j,prn));
    porteusesin=sin(2*pi*(fi+dopp(prn))*t+phi(j,prn));
    
    IE(j)=sum(data.'.*porteusesin.*scaE);
    IP(j)=sum(data.'.*porteusesin.*scaP);
    IL(j)=sum(data.'.*porteusesin.*scaL);
    QE(j)=sum(data.'.*porteusecos.*scaE);
    QP(j)=sum(data.'.*porteusecos.*scaP);
    QL(j)=sum(data.'.*porteusecos.*scaL);
    
    %*****************************************
    % Poursuite du code (PLL)
    %*****************************************
    deltaphi=atan(QP(j)/IP(j));
    phi(j+1,prn)=phi(j,prn)+deltaphi;
    porteusecos2=cos(2*pi*(fi+dopp(prn))*t+phi(j+1,prn));
    porteusesin2=sin(2*pi*(fi+dopp(prn))*t+phi(j+1,prn));
    IP2(j,prn)=sum(data.'.*porteusesin2.*scaP);
    QP2(j,prn)=sum(data.'.*porteusecos2.*scaP);
    discEL(j)=IE(j)-IL(j);
    discELenv(j)=sqrt(IE(j)^2+QE(j)^2)-sqrt(IL(j)^2+QL(j)^2);
    %*****************************************
    
    % discrimant Early - Late Power indépendant de la phase
    discELpow=(IE(j)^2+QE(j)^2)-(IL(j)^2+QL(j)^2);
   
   if discELpow>0
        % générer les prochains code (scaE scaP scaL) plus en avance
        % car le satelite se rapproche (la distance sattelite-recepteur
        % diminue)
               
        scaE=[scaE(2:nbr_ech) scaE(1)]; % code généré en avance
        scaP=[scaP(2:nbr_ech) scaP(1)];% end <> nbr_ech, code généré en 
        scaL=[scaL(2:nbr_ech) scaL(1)];  % code généré en retard
        dec(j,prn)=+1; % enregistrement décalage à droite
        
   elseif discELpow<0
        %générer les prochains code plus en retard car le statelite
        %s'éloigne (la distance sattelite-recepteur augmente)
        
        scaE=[scaE(nbr_ech) scaE(1:nbr_ech-1)];
        scaP=[scaP(nbr_ech) scaP(1:nbr_ech-1)];
        scaL=[scaL(nbr_ech) scaL(1:nbr_ech-1)];
        dec(j,prn)=-1; % enregistrement décalage à gauche
   end
     
end

figure
plot (IP2(:,prn))
hold all
plot (QP2(:,prn))
legend('IP2','QP2')
title(['IP2 QP2 - Satellite', num2str(prn)])

fclose(fid)

figure
plot(cumsum(dec(:,prn)))
title(['cumsum - Satellite', num2str(prn)])

end


% figure
% plot(cumsum(dec(:,3)))

% clearvars -except sats dopp deccode dec phi IP2
save res_pours








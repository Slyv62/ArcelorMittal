% --------- TD1 - Question 1.4 -----------
% Intégration cohérente et non-cohérente pour tous les sattelites
% P27 et P28 du cours
%-----------------------------------------

clear
close all
clc

% --------------
% Cas N=1 et K=1 -> 9 trouvés
% Cas N=1 et K=5 -> 8 trouvés
% Cas N=5 et K=1 -> 11 trouvés - Meilleur résultat
% Cas N=5 et K=5 -> 11 trouvés
% Cas N=1 et K=18 -> 8 trouvés
% --------------

CasN=5; % Generation du code SCA Cas N fois 1 MS - Ne pas dépasser 9
CasK=1;


fe=16.368e6; % fréquence d'échantillonnage de la carte d'acquisition
fi=2.046e6; % fréquence intermédiaire de la carte d'acquisition
Tc=1e-3; % période du code GPS  C/A - 1mS
nbr_ech=fe*Tc; % nombre d'échantillons par période de code de 1mS

sats=[];
deccode=[];
dopp=[];

for prn=1:32 % 32 satellite possible en GPS

ca = 2*gcacode(prn)-1; % code C/A du satellite à étudier - transformation mathématique de passage des bit 0/1 à -1/+1
sca = sampleca(ca,fe); % code rééchantillonné à la fréquence fe

% Fonction generant le ve cteur N fois
% initialisation du vecteur

scaN=[];
for i=1:CasN
   scaN=[scaN sca]; 
end

fid = fopen('rec.bin.091','r','l'); % ouverture du fichier d'aquisition en lecture, format little-endian, non signés

data01=fread(fid,CasN*nbr_ech,'ubit1','l'); % lecture du signal sur 1 période de code
data=2*data01-1; % conversion de binaire en -1 / 1
fclose(fid); 

t=0:1/fe:1e-3-1/fe;% vecteur temps
N=length(t); % Nbre d'échantillon

vectdopp=-5000:20:5000; % augmentation de la précision par pas de 20 Hz à la place de 200 Hz
indc=1;

fid = fopen('rec.bin.091','r','l'); % ouverture du fichier en lecture, format little-endian, non signés
resultK=0;

for k=1:CasK
    data01=fread(fid,CasN*nbr_ech,'ubit1','l'); % lecture du signal sur CasN période de code
    data=2*data01-1; % conversion de binaire en -1 / 1
    indc=1;
    
    for fdoppler=vectdopp
        t=0:1/fe:CasN*1e-3-1/fe;% vecteur temps
        porteusecos=cos(2*pi*(fi+fdoppler)*t);
        porteusesin=sin(2*pi*(fi+fdoppler)*t);
        dataport=data.*porteusecos.'+1i*data.*porteusesin.';
        prodfft=fft(dataport).*conj(fft(scaN)).'; % conj = conjugué
        r=ifft(prodfft);
        result(:,indc)=(abs(r)).^2; %Enregistrer les résultats dans une matrice
        indc=indc+1;
    end
    resultK=resultK+result;
end

fclose(fid); % fermeture du fichier 

maxr=max(max(resultK));
moyr=mean(mean(resultK));

if maxr/moyr>20 % condition d'affichage des PICs avec un de rapport 20
   
    figure
    mesh(vectdopp,1:N,resultK(1:nbr_ech,:))% représentation matrice
    title(['PRN' num2str(prn)])
    xlabel('Doppler')
    ylabel('Decalage de code')
    zlabel('Niveau de correlation avec N=x & K=x')
    title('Niveau de correlation avec le sattelite X en balayant le doppler N=x K=x en 3D')

    [abscisse,ord]=find(resultK==maxr);
    sats=[sats prn]
    deccode=[deccode abscisse(1)] % ,le décalage entre
    dopp=[dopp vectdopp(ord(1))]
    
    abscisse %le décalage entre data et le signal réplique qu'on a généré
    ord % 
    vectdopp(ord) % le doppler du signal reçu

end
end

% Sauvegarde données dans fichier res_acq
clearvars -except sats deccode dopp
save res_acq















% --------- TD1 - Question 1.4 -----------
% Int�gration coh�rente et non-coh�rente pour tous les sattelites
% P27 et P28 du cours
%-----------------------------------------

clear
close all
clc

% --------------
% Cas N=1 et K=1 -> 9 trouv�s
% Cas N=1 et K=5 -> 8 trouv�s
% Cas N=5 et K=1 -> 11 trouv�s - Meilleur r�sultat
% Cas N=5 et K=5 -> 11 trouv�s
% Cas N=1 et K=18 -> 8 trouv�s
% --------------

CasN=5; % Generation du code SCA Cas N fois 1 MS - Ne pas d�passer 9
CasK=1;


fe=16.368e6; % fr�quence d'�chantillonnage de la carte d'acquisition
fi=2.046e6; % fr�quence interm�diaire de la carte d'acquisition
Tc=1e-3; % p�riode du code GPS  C/A - 1mS
nbr_ech=fe*Tc; % nombre d'�chantillons par p�riode de code de 1mS

sats=[];
deccode=[];
dopp=[];

for prn=1:32 % 32 satellite possible en GPS

ca = 2*gcacode(prn)-1; % code C/A du satellite � �tudier - transformation math�matique de passage des bit 0/1 � -1/+1
sca = sampleca(ca,fe); % code r��chantillonn� � la fr�quence fe

% Fonction generant le ve cteur N fois
% initialisation du vecteur

scaN=[];
for i=1:CasN
   scaN=[scaN sca]; 
end

fid = fopen('rec.bin.091','r','l'); % ouverture du fichier d'aquisition en lecture, format little-endian, non sign�s

data01=fread(fid,CasN*nbr_ech,'ubit1','l'); % lecture du signal sur 1 p�riode de code
data=2*data01-1; % conversion de binaire en -1 / 1
fclose(fid); 

t=0:1/fe:1e-3-1/fe;% vecteur temps
N=length(t); % Nbre d'�chantillon

vectdopp=-5000:20:5000; % augmentation de la pr�cision par pas de 20 Hz � la place de 200 Hz
indc=1;

fid = fopen('rec.bin.091','r','l'); % ouverture du fichier en lecture, format little-endian, non sign�s
resultK=0;

for k=1:CasK
    data01=fread(fid,CasN*nbr_ech,'ubit1','l'); % lecture du signal sur CasN p�riode de code
    data=2*data01-1; % conversion de binaire en -1 / 1
    indc=1;
    
    for fdoppler=vectdopp
        t=0:1/fe:CasN*1e-3-1/fe;% vecteur temps
        porteusecos=cos(2*pi*(fi+fdoppler)*t);
        porteusesin=sin(2*pi*(fi+fdoppler)*t);
        dataport=data.*porteusecos.'+1i*data.*porteusesin.';
        prodfft=fft(dataport).*conj(fft(scaN)).'; % conj = conjugu�
        r=ifft(prodfft);
        result(:,indc)=(abs(r)).^2; %Enregistrer les r�sultats dans une matrice
        indc=indc+1;
    end
    resultK=resultK+result;
end

fclose(fid); % fermeture du fichier 

maxr=max(max(resultK));
moyr=mean(mean(resultK));

if maxr/moyr>20 % condition d'affichage des PICs avec un de rapport 20
   
    figure
    mesh(vectdopp,1:N,resultK(1:nbr_ech,:))% repr�sentation matrice
    title(['PRN' num2str(prn)])
    xlabel('Doppler')
    ylabel('Decalage de code')
    zlabel('Niveau de correlation avec N=x & K=x')
    title('Niveau de correlation avec le sattelite X en balayant le doppler N=x K=x en 3D')

    [abscisse,ord]=find(resultK==maxr);
    sats=[sats prn]
    deccode=[deccode abscisse(1)] % ,le d�calage entre
    dopp=[dopp vectdopp(ord(1))]
    
    abscisse %le d�calage entre data et le signal r�plique qu'on a g�n�r�
    ord % 
    vectdopp(ord) % le doppler du signal re�u

end
end

% Sauvegarde donn�es dans fichier res_acq
clearvars -except sats deccode dopp
save res_acq















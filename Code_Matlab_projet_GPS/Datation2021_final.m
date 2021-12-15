% TD2 - Poursuite du code (PLL)
% *********************************************

clear
close all
clc

% Charger fichier sauvegardé pour la poursuite d'une durée de 20 s

% vitesse de la lumière
C = 2.99792458e8;
  
load res_pours_syl

% Fixer numéro du satellite
for prn=1:9 %Pourquoi pas 11 - pb plantage

    % Afficher IP2 brut

    % figure
    % plot(IP2(:,prn))

    % Solution
    % sign(IP2(:,3))) -> fournit le signe
    % IP2(:,3)>0 -> donne 0 ou 1

    % Afficher IP2 traité dans le graphe

    % figure
    % plot(IP2(:,prn)>0)

    IPen01=IP2(:,prn)>0;

    %figure
    %plot (IPen01)

    i=1;
    while(IPen01(i+1)==IPen01(i))
            i=i+1;
    end

    % Déterminer le point de départ du bit précédent
    inddebut=mod(i+1,20);

    % if inddebut==0
    %     inddebut=20;
    % end

    k=1;
    for ind=inddebut:20:(length(IPen01)-19)
        messagenav(k)=round(mean(IPen01(ind:ind+19)));
        k=k+1;
    end

    % figure
    % plot(messagenav,'-*')

    preambule='10001011';
    % 1 - Déterminer l'emplacment du premier préambule
    % 2 - Verifier si tous les  300 bits (6 secondes) suivant on retrouve le préambule

    % Recherche de préambule pour déterminer la position dans la trame -
    % attention aux espaces dans strfind!

    indpreamb=strfind(messagenav,[1 0 0 0 1 0 1 1]);

    indpreambnorm=strfind(num2str(messagenav,'%d'),'10001011');
    indpreambinv=strfind(num2str(messagenav,'%d'),'01110100');
    % indpreamb=[indpreambnorm indpreambinv];
    indpreamb=[];
    
    % Check des double00

    for ind=indpreambnorm
        if (messagenav(ind+59)==0 && messagenav(ind+60)==0)
            indpreamb=[indpreamb ind];
        end
    end

    for ind=indpreambinv
        if (messagenav(ind+59)==1 && messagenav(ind+60)==1)
            indpreamb=[indpreamb ind];
        end
    end

    % Vérifier que les préambules reviennent tous les 300 bits (6 secondes)

    indpreambmod=mod(indpreamb,300);
    induniques=unique(indpreambmod);
    nc=histc(indpreambmod,induniques);
    ind1erpreamb=induniques(find(nc==max(nc)));


    %Detection préambile inverse pour mettre le message dans le sens positif

    if sum(ind1erpreamb==indpreambinv)>0 % 
        messagenav=not(messagenav); % on remet le message à l'endroit
    end

    % Vérifier que 59 et 60 bits aprés les préambules trouvés on trouve deux 0
    
    messagenav(ind1erpreamb+59:ind1erpreamb+60);
    messagenav(ind1erpreamb+359:ind1erpreamb+360);
    messagenav(ind1erpreamb+659:ind1erpreamb+660);
    
    prn
    messagenav(ind1erpreamb+50:ind1erpreamb+52)
    

    % TD2 - 3. Datation
    % *********************************************

    % lecture et convertion du TOW en secondes (on trouvera 227220)
    puiss=2.^[16:-1:0];
    
    if messagenav(ind1erpreamb+29)==0
        TOW=sum(messagenav(ind1erpreamb+30:ind1erpreamb+46).*puiss)*6-6;
    else
        TOW=sum(not(messagenav(ind1erpreamb+30:ind1erpreamb+46)).*puiss)*6-6;
    end

    jours=floor(TOW / (24*60*60));
    heures=floor(mod (TOW, 24*60*60) / (60*60));
    minutes=floor(mod (TOW, 60*60) / (60));
    secondes=floor(mod (TOW, (60)));
    disp(['SAT' num2str(prn) ' PRN' num2str(sats(prn)) ' : jour  ' num2str(jours) ' à ' num2str(heures) 'h' num2str(minutes) 'mm' num2str(secondes) 's'])

    te0=TOW-(ind1erpreamb-1)*20e-3-(inddebut-1)*1e-3-(deccode(prn)-1)/16.368e6;
    if prn==1
        % Enlever la valeur moyenne de mesure vue dans calc_pos
        tr=te0+80e-3+(0:length(IP2)-1)*1e-3;% datation de la réception de tout le signal -> Approximative car l'horloge du recepteur n'est pas précis
    end
    te(:,prn)=te0+(0:length(IP2)-1)*1e-3+cumsum(dec(:,prn)).'/16.368e6; % datation de l'émission de tout le signal
    % ttraj(:prn)=80e-3+dec(:prn)/16.368e6;
    psd(:,prn)=((tr-te(:,prn).')*C); % distance
    figure(100)
    hold all
    plot(psd(:,prn));% Distance
        % legend('1','2','3','4','5','6','7','8','9')
    
    % Calcul vitesse du satellite en m/s
    vitesse(:,prn)=((psd(20000,prn)-psd(1,prn))/20);  
    
    
    % courbe qui monte je m'éloigne du satelite, et inversement
   end

clearvars -except sats psd
save res_datation


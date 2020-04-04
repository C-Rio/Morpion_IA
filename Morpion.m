function varargout = Morpion(varargin)
% MORPION MATLAB code for Morpion.fig
% Last Modified by GUIDE v2.5 16-Nov-2016 11:34:22

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Morpion_OpeningFcn, ...
                       'gui_OutputFcn',  @Morpion_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT


% --- Executes just before Morpion is made visible.
function Morpion_OpeningFcn(hObject, eventdata, handles, varargin)

    % Choose default command line output for Morpion
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);

    global choix ordre tour maj_IA IA;
    choix = 1; %type de partie à jouer (JvsJ, JvsIA, IAvsIA)
    ordre = 1; %ordre de jeu entre l'IA et le joueur
    tour = 0; %permet de différencier les deux joueurs
    maj_IA = []; %matrice qui contiendra tous les coups joués et permettra la mise à jour de l'apprentissage

    %chargement de l'éventuel fichier contenant l'apprentissage (dans IA)
    if exist('save.mat', 'file') == 2
        load('save.mat');
    else %ou initialisation de la variable IA
        %on verra l'état du plateau comme un nombre à 9 chiffres en base 3 (19683 lignes) 
        %et les jetons associés aux 9 cases constitueront les colonnes
        %on choisit de ne pas initialiser à 10 pour essayer d'améliorer les
        %résultats de l'IA (voir le rapport)
        IA = ones(19683, 9)*20;
    end


% --- Outputs from this function are returned to the command line.
function varargout = Morpion_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;


% --- Executes on button press in MENU.
function MENU_Callback(hObject, eventdata, handles)
%le bouton de menu ('Jouer') (ré)initialise la partie

    global choix ordre maj_IA;
    
    %remise des coups joués à zéro
    maj_IA=[];
    %remise du texte de résultat à vide
    set(handles.zone_texte,'string','');
    %(ré)initialisation des cases
    for i=(1:9)
        set(handles.(sprintf('case%d',i)),'Visible', 'on', 'Enable', 'on', 'string', ' ');
    end
    %si partie 'Joueur vs IA' avec 'IA commence', on joue un premier coup
    if(choix==2 && ordre==2)
        jeu_IA(handles, 2)
    end
    %lancement d'une partie automatique en cas de choix 'IA vs IA'
    if(choix == 3)
       partie_IA(handles);
    end
    
    
%FONCTIONS CALLBACK SUR LES CASES (toutes identiques)

% --- Executes on button press in case1.
function case1_Callback(hObject, eventdata, handles)

    global choix;
    
    %appel de la fonction clicked sur la case 1
    clicked(handles, 1);
    %test de fin de partie après chaque coup joué
    f = testFin(handles);
    
    %si 'Joueur vs IA' et partie non terminée, on fait jouer l'IA
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        %puis test de fin après chaque coup joué
        f = testFin(handles);
    end


% --- Executes on button press in case2.
function case2_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 2);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case3.
function case3_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 3);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case4.
function case4_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 4);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case5.
function case5_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 5);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case6.
function case6_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 6);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case7.
function case7_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 7);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case8.
function case8_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 8);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


% --- Executes on button press in case9.
function case9_Callback(hObject, eventdata, handles)
    global choix;
    clicked(handles, 9);
    f = testFin(handles);
    if(choix == 2 && f ~= 1)
        jeu_IA(handles, 2);
        f = testFin(handles);
    end


function clicked(handles, x)
%fonction correspondant à jouer sur la case x

    global tour maj_IA;
    
    i = indice_etat(handles);
    
    %on enregistre le coup joué dans maj_IA
    %on note la case, l'indice du plateau avant le coup, le tour (joueur)
    maj_IA = [maj_IA; x i tour];
    
    %on met à jour l'état de la case et le tour
    if tour
        set(handles.(sprintf('case%d',x)),'string','O','Enable','inactive');
        tour = 0;
    else
        set(handles.(sprintf('case%d',x)),'string','X','Enable','inactive');
        tour = 1;
    end
    

function f = testFin(handles)
%fonction qui teste toutes les possibilités de fin de partie en parcourant
%le plateau
%renvoie f=1 si la partie est finie, f=0 sinon
%si f=1, effectue le verrouillage des cases et affiche le resultat
        
    global choix IA;
    
    %on créée 2 vecteurs de 8 cases correspondants aux 8 alignements de
    %cases possibles pour gagner, un pour X, un pour O
    X = zeros(8, 1);
    O = zeros(8, 1);
    %une variable comptant les cases occupées, nécessaire en cas de fin de
    %partie sans victoire (plateau plein)
    cases_occupees = 0;
    %on initialise f à 0
    f = 0;
        
    %vérification par ligne + comptage cases occupées
    for i=(1:3:7)
        if(get(handles.(sprintf('case%d',i)),'string') == 'X')
            X(floor(i/3 +1)) = X(floor(i/3 +1)) +1;
            cases_occupees = cases_occupees + 1;
        elseif(get(handles.(sprintf('case%d',i)),'string') == 'O')
            O(floor(i/3 +1)) = O(floor(i/3 +1)) +1;
            cases_occupees = cases_occupees + 1;
        end
        if(get(handles.(sprintf('case%d',i+1)),'string') == 'X')
            X(floor(i/3 +1)) = X(floor(i/3 +1)) +1;
            cases_occupees = cases_occupees + 1;
        elseif(get(handles.(sprintf('case%d',i+1)),'string') == 'O')
            O(floor(i/3 +1)) = O(floor(i/3 +1)) +1;
            cases_occupees = cases_occupees + 1;
        end
        if(get(handles.(sprintf('case%d',i+2)),'string') == 'X')
            X(floor(i/3 +1)) = X(floor(i/3 +1)) +1;
            cases_occupees = cases_occupees + 1;
        elseif(get(handles.(sprintf('case%d',i+2)),'string') == 'O')
            O(floor(i/3 +1)) = O(floor(i/3 +1)) +1;
            cases_occupees = cases_occupees + 1;
        end
    end
        
    %vérification par colonne
    for i=(1:3)
        if(get(handles.(sprintf('case%d',i)),'string') == 'X')
            X(i+3) = X(i+3) +1;
        elseif(get(handles.(sprintf('case%d',i)),'string') == 'O')
            O(i+3) = O(i+3) +1;
        end
        if(get(handles.(sprintf('case%d',i+3)),'string') == 'X')
            X(i+3) = X(i+3) +1;
        elseif(get(handles.(sprintf('case%d',i+3)),'string') == 'O')
            O(i+3) = O(i+3) +1;
        end
        if(get(handles.(sprintf('case%d',i+6)),'string') == 'X')
            X(i+3) = X(i+3) +1;
        elseif(get(handles.(sprintf('case%d',i+6)),'string') == 'O')
            O(i+3) = O(i+3) +1;
        end
    end
                
    %vérification première diagonale
    if(get(handles.(sprintf('case%d',1)),'string') == 'X')
        X(7) = X(7) +1;
    elseif(get(handles.(sprintf('case%d',1)),'string') == 'O')
        O(7) = O(7) +1;
    end
    if(get(handles.(sprintf('case%d',5)),'string') == 'X')
        X(7) = X(7) +1;
    elseif(get(handles.(sprintf('case%d',5)),'string') == 'O')
        O(7) = O(7) +1;
    end
    if(get(handles.(sprintf('case%d',9)),'string') == 'X')
        X(7) = X(7) +1;
    elseif(get(handles.(sprintf('case%d',9)),'string') == 'O')
        O(7) = O(7) +1;
    end
    
    %vérification deuxième diagonale
    if(get(handles.(sprintf('case%d',3)),'string') == 'X')
        X(8) = X(8) +1;
    elseif(get(handles.(sprintf('case%d',3)),'string') == 'O')
        O(8) = O(8) +1;
    end
    if(get(handles.(sprintf('case%d',5)),'string') == 'X')
        X(8) = X(8) +1;
    elseif(get(handles.(sprintf('case%d',5)),'string') == 'O')
        O(8) = O(8) +1;
    end
    if(get(handles.(sprintf('case%d',7)),'string') == 'X')
        X(8) = X(8) +1;
    elseif(get(handles.(sprintf('case%d',7)),'string') == 'O')
        O(8) = O(8) +1;
    end
      
    %vérification si ligne complète pour un joueur, si oui -> fin
    if(max(X)==3 || max(O)==3)
        %on incrémente f
        f = 1;
        %on verrouille les cases restantes
        for i=(1:9)
            set(handles.(sprintf('case%d',i)),'Enable','inactive');
        end
        %affichage du vainqueur
        if(max(X)==3)
            set(handles.zone_texte,'string','Les X ont gagné');
        else
            set(handles.zone_texte,'string','Les O ont gagné');
        end
    %vérification plateau complet, si oui -> fin
    elseif(cases_occupees == 9)
        %on incrémente f
        f = 1;
        %affichage résultat
        set(handles.zone_texte,'string','Egalité');
        %toutes les cases occupées => pas de verrouillage nécessaire
    end
    
    %si la partie est effectivement finie on effectue l'apprentissage
    if f == 1
        apprentissage(handles);
        %on sauvegarde la matrice IA mise à jour dans le fichier 'save.mat'
        %dans le cas 'IA vs IA' (choix = 3) on ne sauvegardera pas à 
        %chaque partie mais après l'ensemble des parties demandées
        %(voir fonction partie_IA)
        if choix ~= 3
            save('save.mat', 'IA');
        end
    end


% --- Executes on selection change in menu_deroulant.
function menu_deroulant_Callback(hObject, eventdata, handles)
%fonction mettant à jour la variable choix spécifiant le type de partie
%choix = 1 <=> 'Joueur vs Joueur'
%choix = 2 <=> 'Joueur vs IA'
%choix = 3 <=> 'IA vs IA'

    global choix;
    choix = get(hObject,'Value');
    
    %si choix => 'IA vs IA', on ouvre un champ de texte pour entrer le
    %nombre de parties à faire jouer à l'IA
    if(choix == 3)
        set(handles.nb_games, 'Visible', 'on');
    else
        set(handles.nb_games, 'Visible', 'off');
    end
    if(choix == 2)
        set(handles.ordre, 'Visible', 'on');
    else
        set(handles.ordre, 'Visible', 'off');
    end
    

% --- Executes during object creation, after setting all properties.
function menu_deroulant_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function x = indice_etat(handles)
%renvoie la valeur associée à l'état du plateau en considérant ce plateau
%comme un nombre à 9 chiffres en base 3
%(on aura un décalage de 1 car matlab commence son indiçage à 1)
    x = 0;
    for i=(1:9)
        if(get(handles.(sprintf('case%d',i)),'string') == 'X')
            x = x + 2*(3^(i-1));
        elseif(get(handles.(sprintf('case%d',i)),'string') == 'O')
            x = x + 1*(3^(i-1));
        end
    end


function jeu_IA(handles, p)
%fonction de jeu de l'IA, le paramètre p indiquera un comportement
%différent de l'IA
    global IA;
    
    %on met dans un vecteur v la ligne de l'IA corresponedant à la situation
    v = IA(indice_etat(handles)+1,:);
    
    %on initialise un vecteur et un indice à 1
    w=[];
    a=1;
       
    %pour optimiser l'apprentissage, l'IA se comportera différemment une
    %partie sur deux, en fonction du caractère pair ou impair de p
    %dans le cas pair, l'IA fera intervenir son apprentissage avec des
    %probabilités, dans le cas impair, elle jouera aléatoirement sur les
    %cases disponibles
    if mod(p,2) == 0
        %on pré-alloue la mémoire au vecteur w car elle peut être importante
        w(sum(v(1,:),2)) = 0;
        %on copie dans ce vecteur les indices du vecteur v autant de fois
        %que la valeur de v à cet indice (résultats de l'apprentissage)
        for i=(1:numel(v))
                for j=(1:v(i))
                    w(a) = i;
                    a = a+1;
                end
        end
    else
        %on copie dans le vecteur  w les indices de v dont les valeurs sont
        %positives (cases disponibles)
        for i=(1:numel(v))
            if v(i)>0
                w(a) = i;
                a = a+1;
            end
        end
    end

    %on choisit une valeur aléatoire dans le vecteur w
    r = (double(int8(rand(1,1)*(numel(w)-1)))+1);
    %si cette valeur correspond à une case occupée, c'est ici qu'on met à
    %jour l'IA en mettant la valeur de cette case à 0
    %on relance alors cette fonction qui marchera à coup sûr maintenant
    if (get(handles.(sprintf('case%d',w(r))),'string') ~= ' ')
        IA(indice_etat(handles)+1, w(r)) = 0;
        jeu_IA(handles, p);
    else
        %on fait joué l'IA sur la case chosit ainsi
        clicked(handles, w(r));
    end

    
function partie_IA(handles)
%fonction de partie automatique 'IA vs IA'

    global maj_IA IA;
    %on initialise une variable qui sera passée à 'jeu_IA' pour déterminer
    %son caractère (voir 'jeu_IA')
    p=0;
    %on jouera autant de parties qu'indiqué dans 'string' de 'nb_games'
    for i=(1:str2num(get(handles.nb_games, 'string')))
        %on remet les coups joués à 0 avant chaque partie
        maj_IA=[];
        %on réinitialise les cases
        for j=(1:9)
            set(handles.(sprintf('case%d',j)),'Visible', 'on', 'Enable', 'on', 'string', ' ');
        end
        %tant que la partie n'est pas finie, on fait jouer l'IA
        while(testFin(handles) ~= 1)
            jeu_IA(handles, p);
        end
        %on incrémente la variable p pour la prochaine partie
        p=p+1;
    end
    %dans le cas des parties 'IA vs IA' on ne sauvegarde l'apprentissage
    %dans le fichier 'save.mat' qu'après l'éxécution de l'ensemble des
    %parties pour optimiser en temps
    save('save.mat', 'IA');
        
    
%les coefficients associés à l'apprentissage ont été modifiés par rapport
%au sujet afin d'essayer d'obtenir de meilleurs résultats (voir le rapport)
function apprentissage(handles)
%fonction qui met à jour l'IA grâce à la matrice maj_IA
    global IA maj_IA tour;
        
    %on initialise une variable gagnant en fonction du résultat
    if strcmp(get(handles.zone_texte,'string'),'Egalité')
        gagnant = 2;
    elseif tour == 0
        gagnant = 1;
    else
        gagnant = 0;
    end
          
    %en cas d'égalité on récompense tous les coups joués sans distinction
    if gagnant == 2
        for i = (1:size(maj_IA,1))
            IA(maj_IA(i,2)+1, maj_IA(i,1)) = IA(maj_IA(i,2)+1, maj_IA(i,1)) +1;
        end
    else     
    %sinon on parcourt la matrice maj_IA et on effectue des tests
        for i = (1:size(maj_IA,1))
            %s'il s'agit du joueur gagnant, on le récompense
            if(maj_IA(i, 3) == gagnant)
                IA(maj_IA(i,2)+1, maj_IA(i,1)) = IA(maj_IA(i,2)+1, maj_IA(i,1)) +2;
            else
                %sinon, si on peut encore décrémenter, on punit le coup
                if IA(maj_IA(i,2)+1, maj_IA(i,1)) > 1
                    IA(maj_IA(i,2)+1, maj_IA(i,1)) = IA(maj_IA(i,2)+1, maj_IA(i,1)) -2;
                    %on va maintenant compter les cases dont la valeur est
                    %nulle
                    k = 0;
                    for j=(1:9)
                        if IA(maj_IA(i,2)+1, j) == 0
                            k = k + 1;
                        end
                    end
                    %si toutes les cases sont tombées à 0, on réinitialise
                    %la ligne
                    if k == 9
                        IA(maj_IA(i,2)+1, :) = ones(1,9)*20;
                    end
                end
            end
        end
    end


function nb_games_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function nb_games_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in ordre.
function ordre_Callback(hObject, eventdata, handles)
    global ordre;
    ordre = get(hObject,'Value');
    

% --- Executes during object creation, after setting all properties.
function ordre_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

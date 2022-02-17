% Please insert the names and email addresses of the group members: 
% Bhuvanesh Verma
% bhuvanesh.verma@uni-potsdam.de
% Md.Delwar Hossain 
% hossain1@uni-potsdam.de 

% Tips:
% - You may include the facts below to represent the differences
%   between the coordinates of neighboring cells
%
% diff(0,1). diff(0,-1). diff(1,0). diff(-1,0).

% Your encoding please...

hint(X,Y,0):- first(X,Y).
hint(X,Y,0):- final(X,Y).


% Evaluating size of Seek Number grid
size(T):- T = #sum{1,X:cell(X,1)}.

% Total time or steps required to complete
time(1..T*T-1):-size(T).
    


% Actions or Moves
diff(0,1). % up
diff(0,-1). % down
diff(1,0). % right
diff(-1,0). % left

% Initialization
holds(X,Y,0):-first(X,Y).


% pick a move (up,down,left,right) at every time interval, provided the resulting cell is a valid cell
{occ(A,B,T):diff(A,B),cell(X+A,Y+B)} = 1 :-holds(X,Y,T-1), time(T).

% Update holds value with new candidate cell for the path
holds(X+A,Y+B,T):- occ(A,B,T),holds(X,Y,T-1),pre(T).
    
% Verify that a cell is visited once
:- holds(X,Y,T),holds(X,Y,S),T!=S.
    
% Create a path with chosen consecutive holds(candidates)
%path(X,Y,A,B):- holds(X,Y,T-1),holds(A,B,T).
{path(X,Y,A,B):cell(X,Y),cell(A,B),diff(A-X,B-Y)}= S*S-1 :- size(S).

% Constraint the path using holds predicate to include candidate cells only
:- holds(X,Y,T), path(X,Y,A,B), not holds(A,B,T+1).

% Verify the last candidate is given final candidate cell
:- not holds(X,Y,T*T-1),final(X,Y),size(T).

% if a new cell is selected which contains hint, then turn switch ON.
switch(N,T):- holds(X,Y,T),hint(X,Y,N),T>0.
no_turn(T):- switch(N,T).
    
% if switch is ON, verify that number of turns equal allowed turns at time T
swi_sum(K,T):- K = #sum{V,U:switch(V,U),U<T},time(T). % Permitted turns at time T
tur_sum(K,T):- K = #count{U:turn(U),U=0..T},time(T).  % Turns taken till time T

% Update turn
turn(T):- {A+C==1;A+C==-1}=1,occ(C,_,T-1),occ(A,_,T),not no_turn(T-1).

% Verify if Switch is On, then turns contraint satisfies as well
:- swi_sum(K,T), not tur_sum(K,T),switch(N,T). 

pre(T):- swi_sum(N,T),tur_sum(K,T),K<=N.
#show path/4.

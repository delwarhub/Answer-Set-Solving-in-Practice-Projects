% INSERT NAMES AND EMAIL ADDRESSES OF YOUR GROUP MEMBERS:
% Bhuvanesh Verma verma@uni-potsdam.de
% Md. Delwar Hossain hossain1@uni-potsdam.de

#include <incmode>. % built-in incremental mode of clingo
move(1).
move(-1).

holds(at(elevator(X),Y),0) :- init(at(elevator(X),Y)).
holds(request(deliver(X),Y),0) :- init(request(deliver(X),Y)).
holds(request(call(up),Y),0) :- init(request(call(up),Y)).
holds(request(call(down),Y),0) :- init(request(call(down),Y)).
    
el(X,F,0) :- holds(at(elevator(X),F),0). % Define initial position of elevator
req(X,F,0) :- holds(request(deliver(X),F),0). % Define initial Delivery Request
req(D,F,0) :- holds(request(call(D),F),0). % Define initial Call Request
elev(N):-agent(elevator(N)). % Define Elevators
call(D):- holds(request(call(D),F),0). % Define Call Requests


% assigning different task to elevators
assign(N,req(N,F,T)):- req(N,F,T), elev(N). % Assign Delivery Request to respective Elevators.
{assign(N,req(D,F,T)):req(D,F,T)} :- el(N,X,0),call(D). % Assign Call requests randomly to elevators.

:- req(D,F,T), not assign(_,req(D,F,T)). % It should not be the case that there is a request but it is not assigned to any elevator.
:- assign(N,req(D,F,_)), assign(M,req(D,F,_)), M!=N, req(D,F,_), call(D). % it should not be the case that same Call Request is assigned to multiple elevators.
:- assign(E,req(E,F,_)), assign(R,req(D,F,_)), call(D), not assign(R,req(R,F,_)), E!=R. % it should not be the case that a floor with delivery request is
% assigned to elevator who do not have delivery on that floor.

min_fl(E,F) :- F = #min{ K : assign(E,req(_,K,_))},elev(E),F!=#sup. % lower most floor assigned to the elevator.
max_fl(E,F) :- F = #max{ K : assign(E,req(_,K,_))},elev(E),F!=#inf. % top most floor assigned to the elevator.

% Ideal Distance traversed between assigned requests.

% Case 1 : Initial position of elevator is close to min
dist(E,D,0) :-  min_fl(E,A), max_fl(E,B), el(E,X,0), A < X,B>X, M = X-A, N = B-X, M < N, A!=B, D = 2*(X-A)+(B-X). 

% Case 2 : Initial position of elevator is close to max
dist(E,D,1) :-  min_fl(E,A), max_fl(E,B), el(E,X,0), A < X,B>X, M = X-A, N = B-X, M > N, A!=B, D = 2*(B-X)+(X-A).

% Case 3 : Initial position of elevator is less or equal to min
dist(E,D,2) :- min_fl(E,A), max_fl(E,B), el(E,X,0), A >= X, D = |B-X|.

% Case 4 : Initial position of elevator is greater or equal to max
dist(E,D,3) :- min_fl(E,A), max_fl(E,B), el(E,X,0), B <= X, D = |X-A|.

% Case 5 (1 or 2) : Initial position of elevator is in between min and max
{ dist(E,D,1) ; dist(E,D,0) } = 1  :- min_fl(E,A), max_fl(E,B), el(E,X,0), A < X, M = X-A, N = B-X, M == N, A!=B, D = 2*(B-X)+(X-A) .  

tot(D):- D = #sum{K,E:dist(E,K,_)}. % Total distance travelled by all the elevators.

#minimize{D:tot(D)}. % Minimize total distance among all models


#show. % output atoms will be declared below
#program base. % static rules go below
assign(N,R,0):- assign(N,R). % Add time interval to assign predicate
tot_mov(E,0,0):-elev(E). % Total number of moves by elevator at time t

#program step(t). % actions, effects, and minimization go below

holds(at(elevator(X),S),t) :-holds(at(elevator(X),S),t-1),max_fl(X,S),assign(X,req(_,S,_),t-1). % When elevator is at max assigned floor
holds(at(elevator(X),S),t) :-holds(at(elevator(X),S),t-1) ,min_fl(X,S),assign(X,req(_,S,_),t-1). % When elevator is at min assigned floor
    
% Case 2 : Initial - Max - Initial - Min

% Traverse till max
{ holds(at(elevator(X),L),t):not assign(X,req(_,S,_),t-1) ; holds(at(elevator(X),S),t):assign(X,req(_,S,_),t-1) } = 1 :-
            holds(at(elevator(X),S),t-1),dist(X,D,1), L = S+1,max_fl(X,M),L<=M, S>=F,el(X,F,0),assign(X,req(_,M,_),t-1).
        
% Return to Initial       
holds(at(elevator(X),L),t) :- holds(at(elevator(X),S),t-1),dist(X,D,1), L = S-1,L>=F-1, el(X,F,0),max_fl(X,M),
                                                        not assign(X,req(_,M,_),t-1),S<=M.
% Traverse to min
{ holds(at(elevator(X),L),t):not assign(X,req(_,S,_),t-1) ; holds(at(elevator(X),S),t):assign(X,req(_,S,_),t-1) } = 1 :-
                                    holds(at(elevator(X),S),t-1),dist(X,D,1), L = S-1,min_fl(X,M),L>=M,S<F,el(X,F,0).
        
% Case 1 : Initial - Min -Initial- Max

% Traverse till min
{ holds(at(elevator(X),L),t):not assign(X,req(_,S,_),t-1) ; holds(at(elevator(X),S),t):assign(X,req(_,S,_),t-1) } = 1 :-
            holds(at(elevator(X),S),t-1),dist(X,D,0), L = S-1,min_fl(X,M),L>=M, S<=F,el(X,F,0),assign(X,req(_,M,_),t-1).
            
% Traverse to initial
holds(at(elevator(X),L),t) :- holds(at(elevator(X),S),t-1),dist(X,D,0), L = S+1, el(X,F,0) ,L<=F+1, min_fl(X,M),
                                                        not assign(X,req(_,M,_),t-1),S>=M.
% Traverse to max                                                        
{ holds(at(elevator(X),L),t):not assign(X,req(_,S,_),t-1) ; holds(at(elevator(X),S),t):assign(X,req(_,S,_),t-1) } = 1 :-
                                    holds(at(elevator(X),S),t-1),dist(X,D,0), L = S+1,max_fl(X,M),L<=M,S>F,el(X,F,0).        
        
 % Case 4 : Initial - Min - Max       
{ holds(at(elevator(X),L),t):not assign(X,req(_,S,_),t-1) ; holds(at(elevator(X),S),t):assign(X,req(_,S,_),t-1) } = 1 :-
                                                holds(at(elevator(X),S),t-1),dist(X,D,2), L = S+1,max_fl(X,M),L<=M.

% Case 3 : Initial - Max - Min
{ holds(at(elevator(X),L),t):not assign(X,req(_,S,_),t-1) ; holds(at(elevator(X),S),t):assign(X,req(_,S,_),t-1) } = 1 :-
                                                holds(at(elevator(X),S),t-1),dist(X,D,3), L = S-1,min_fl(X,M),L>=M.         
        
        
               
assign(N,req(X,Y,T),t):- assign(N,req(X,Y,T),t-1), not holds(at(elevator(N),Y),t-1). % Update assign predicate
    
 % update do predicate 
{ do(elevator(X),move(1),t): D==1;do(elevator(X),move(-1),t): D==-1 ;do(elevator(X),serve,t): D==0}=1 :- 
                                                    holds(at(elevator(X),S),t),holds(at(elevator(X),T),t-1), D = S-T.   
% Update holds predicate
holds(request(deliver(X),Y),t) :-  assign(X,req(X,Y,_),t).
holds(request(call(D),Y),t)  :-  assign(_,req(D,Y,_),t).


:- tot_mov(E,N,t), dist(E,M,_), N > M. % Number of moves at each time stamp should be less than ideal moves
tot_mov(E,N+M,t):- M = #sum{|A|,t : do(elevator(E),move(A),t)},tot_mov(E,N,t-1),elev(E). % Number of moves by all elevators at time t

#show do(A,X,t) : do(A,X,t). % output atoms indicating actions



#program check(t). % fulfillment of all requests can, e.g., be checked as follows

#show holds(X,t) : holds(X,t). % output atoms indicating states

:- query(t), holds(request(R,F),t).

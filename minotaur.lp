
% Please insert the names and email addresses of the group members:
% Bhuvanesh Verma, bhuvanesh.verma@uni-potsdam.de
% Arthur Hilbert, arthur.hilbert@uni-potsdam.de
% Md Delwar Hossain, hossain1@uni-potsdam.de

% modeling the basics of the game
step(1..N) :- maxsteps(N).
at(X,Y,0) :- start(X,Y).
pos_m(X,Y,0) :- mino(X,Y).
diff(0,1). diff(0,-1). diff(1,0). diff(-1,0).

move(X,Y,A,B) :- field(X,Y), field(A,B), not wall(X,Y,A,B), not wall(A,B,X,Y), diff(X-A,Y-B).

% guessing ways for theseus to move through the labyrinth
{at(A,B,T):move(X,Y,A,B), not pos_m(A,B,S) ; at(X,Y,T)} =1 :- at(X,Y,S),step(T),T=S+1,not goal(X,Y).

% calculate the distance from previous minotaur position to current theseus position
max_m(N,T) :- pos_m(X,Y,S), at(A,B,T), step(T), T=S+1, N=|X-A|+|Y-B|.

% generating valid moves for minotaur
pos_move(X,Y,A,B,T,1) :- pos_m(X,Y,S), move(X,Y,A,B), step(T),T=S+1, Y-B==0, max_m(N,T), at(I,J,T), |A-I|+|B-J|<N.
pos_move(X,Y,A,B,T,1,0) :- pos_m(X,Y,S), move(X,Y,A,B), step(T), T=S+1,Y-B==0, max_m(N,T), at(I,J,T), |A-I|+|B-J|<N.
pos_move(X,Y,P,Q,T,2,0) :- pos_move(X,Y,A,B,T,1,_), move(A,B,P,Q), Q-B==0, 1 {X!=P; Y!=Q}, max_m(N,T), at(I,J,T), |P-I|+|Q-J|<N-1.
pos_move(X,Y,P,Q,T,2,1) :- pos_move(X,Y,A,B,T,1,_), move(A,B,P,Q), A-P==0, 1 {X!=P; Y!=Q}, not pos_move(_,_,_,_,T,2,0), max_m(N,T), at(I,J,T), |P-I|+|Q-J|<N-1.    
pos_move(X,Y,A,B,T,1,1) :- not pos_move(_,_,_,_,T,1,0), pos_m(X,Y,S), move(X,Y,A,B), step(T), T=S+1, X-A==0, max_m(N,T), at(I,J,T), |A-I|+|B-J|<N.

% making the minotaur chase theseus
pos_m(X,Y,T) :- pos_move(A,B,X,Y,T,1,_), not pos_move(A,B,_,_,T,2,_).
pos_m(X,Y,T) :- pos_move(A,B,X,Y,T,2,_).
pos_m(X,Y,T) :- pos_m(X,Y,S), not pos_move(_,_,_,_,T,_,_), T=S+1,step(T).
    
% check solution candidates
:- not at(A,B,_), goal(A,B).
:- pos_m(X,Y,T), at(X,Y,T).

#minimize{T:at(_,_,T)}.
#show at/3.

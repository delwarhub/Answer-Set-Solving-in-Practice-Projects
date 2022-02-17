% INSERT NAMES AND EMAIL ADDRESSES OF YOUR GROUP MEMBERS:
% Name: Md Delwar Hossain 
% Email: hossain1@uni-potsdam.de

subgrid_size(3).

% HINTS:
% - For subgrid_size(s), subgrids can be identified by labels 0..s*s-1
% - A cell (x,y) can be mapped to the subgrid labeled (((x-1)/s)*s + (y-1)/s)

% Your implementation please...

 % assign the size of subgrid, which is the square root of row/column length
#const i=3.

% define generic parameters
grid(1..i*i,1..i*i).
v(1..i*i).

% define variables
initial(A,B,(((A-1)/i)*i + (B-1)/i),N) :- initial(A,B,N).
sudoku(A,B,S,N) :- initial(A,B,S,N).

% get the remaining squares to be filled
gridR(A,B) :- grid(A,B), not initial(A,B,_,_).
gridR(A,B,(((A-1)/i)*i + (B-1)/i)) :- gridR(A,B).

% Assign possibilities, code to control combinatorical explosion
{sudoku(A,B,S,N): v(N), not initial(A,_,_,N), not initial(_,B,_,N), not initial(_,_,S,N)} = 1 :- gridR(A,B,S).

% assign constraints
:-#sum{1,A,N:sudoku(A,B,S,N)} != i*i, A=(1..i*i).
:-#sum{1,B,N:sudoku(A,B,S,N)} != i*i, B=(1..i*i).
:-#sum{1,S,N:sudoku(A,B,S,N)} != i*i, S=(0..i*i-1).

% project and output 
sudoku(A,B,N) :- sudoku(A,B,S,N).

#show sudoku/3.

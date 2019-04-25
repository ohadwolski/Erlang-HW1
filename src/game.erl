%%%-------------------------------------------------------------------
%%% @author guy ab
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. אפר׳ 2019 10:11
%%%-------------------------------------------------------------------
-module(game).
-author("guy ab").

%% API
-export([canWin/1,nextMove/1,explanation/0]).

%% zero case?
canWin(1)->true;
canWin(2)->true;
canWin(3)->false;
canWin(N) when N>3 ->
  (not canWin(N-1)) or (not canWin(N-2)).
%% zero case?
nextMove(1) ->{true,1};
nextMove(2) ->{true,2};
nextMove(3)-> false;
nextMove(N) when N>3 ->
  CanIWin=canWin(N),
  CanEnemyWin1 = canWin(N-1),
  CanEnemyWin2 = canWin(N-2),
  if
    not CanIWin -> false;
    not CanEnemyWin1 -> {true,1};
    not CanEnemyWin2 -> {true,2}
  end.

explanation() -> {"Tail Recursion is hard to implement because the result depends on the answer from two different branches and it is difficult to create one condition for the two branches so no other part is calculated and the recursion becomes a tail recursion"}.


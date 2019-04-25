%%%-------------------------------------------------------------------
%%% @author Ohad Wolski
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Apr 2019 11:52
%%%-------------------------------------------------------------------
-module(my_test).
-author("Ohad Wolski").

%% API
-export([run/0]).


run() ->
  io:format("expecting ~p and got ~p ~n",[57.84955592153876,Shapes:shapesArea(validShapes4())]).
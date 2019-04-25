%%%-------------------------------------------------------------------
%%% @author guy ab
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. אפר׳ 2019 09:33
%%%-------------------------------------------------------------------
-module(shapes).
-author("guy ab").

%% API
-export([shapesArea/1,squaresArea/1,trianglesArea/1,shapesFilter/1,shapesFilter2/1]).

shapesArea({shapes, List}) ->
  legalShapes(List),
  calcListArea(0, List).

calcListArea(Sum, []) ->
  Sum;
calcListArea(Sum, [{Shape, {Type, Size1, Size2}} | T]) ->
  calcListArea(Sum + calcArea({Shape, {Type, Size1, Size2}}), T).

calcArea({Shape, {Type, Size1, Size2}}) when Size1 > 0, Size2 > 0 ->
  if
    Shape =:= rectangle andalso Type =:= dim -> calcRectArea({rectangle, {Type, Size1, Size2}});
    Shape =:= triangle andalso Type =:= dim -> calcTriangleArea({triangle, {Type, Size1, Size2}});
    Shape =:= ellipse andalso Type =:= radius -> calcEllipseArea({ellipse, {Type, Size1, Size2}})
  end.

calcRectArea({rectangle, {dim, Width, Height}}) when Width > 0, Height > 0 ->
  Width * Height.

calcTriangleArea({triangle, {dim, Base, Height}}) when Base > 0, Height > 0 ->
  (Base * Height) / 2.

calcEllipseArea({ellipse, {radius, Radius1, Radius2}}) when Radius1 > 0, Radius2 > 0 ->
  Radius1 * Radius2 * math:pi().

legalShapes([]) ->
  ok;
legalShapes([{Shape, {Type, Size1, Size2}} | T]) when Size1 > 0, Size2 > 0,
  (Shape =:= rectangle andalso Type =:= dim orelse
  Shape =:= triangle andalso Type =:= dim orelse
  Shape =:= ellipse andalso Type =:= radius) ->
    legalShapes(T).

squaresArea({shapes, List}) ->
  legalShapes(List),
  SquaresOnlyFilter = shapesFilter2(square),
  ListOfSquares = SquaresOnlyFilter({shapes, List}),
  calcListArea(0, element(2,ListOfSquares)).

trianglesArea({shapes, List}) ->
  legalShapes(List),
  TrianglesOnlyFilter = shapesFilter(triangle),
  ListOfTriangles = TrianglesOnlyFilter({shapes, List}),
  calcListArea(0, element(2,ListOfTriangles)).

shapesFilter(FilterShape) when FilterShape =:= rectangle orelse FilterShape =:= ellipse orelse FilterShape =:= triangle ->
  fun({shapes,List}) ->
    legalShapes(List),
    NewList = [{Shape, {Type, Size1, Size2}}  || {Shape, {Type, Size1, Size2}} <- List, Shape =:= FilterShape],
    {shapes, NewList}
  end.


shapesFilter2(FilterShape) when FilterShape =:= rectangle orelse FilterShape =:= ellipse orelse FilterShape =:= triangle ->
  shapesFilter(FilterShape);
shapesFilter2(FilterShape) when FilterShape =:= circle orelse FilterShape =:= square ->
  FilterFunction = if
                     FilterShape =:= circle -> shapesFilter(ellipse);
                     FilterShape =:= square -> shapesFilter(rectangle)
                   end,
  RegularShapeFilterFunction = fun({shapes,List}) ->
                                legalShapes(List),
                                NewList = [{Shape, {Type, Size1, Size2}}  || {Shape, {Type, Size1, Size2}} <- List, Size1 == Size2],
                                {shapes, NewList}
                               end,
  fun({shapes, List}) ->
    FilterFunction(RegularShapeFilterFunction({shapes, List}))
  end.

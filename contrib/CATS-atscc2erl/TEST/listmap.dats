(* ****** ****** *)
//
// HX-2015-07:
// A running example
// from ATS2 to Erlang
//
(* ****** ****** *)
//
#define
ATS_DYNLOADFLAG 0
//
(* ****** ****** *)

%{^
%%
-module(listmap_dats).
%%
-export([main0_erl/0]).
%%
-compile(nowarn_unused_vars).
-compile(nowarn_unused_function).
%%
-include("./libatscc2erl/libatscc2erl_all.hrl").
%%
%} // end of [%{]

(* ****** ****** *)
//
#define
LIBATSCC2ERL_targetloc
"$PATSHOME\
/contrib/libatscc2erl/ATS2-0.3.2"
//
(* ****** ****** *)
//
#include
"{$LIBATSCC2ERL}/staloadall.hats"
//
(* ****** ****** *)
//
extern
fun
list_map
  {a:t0p}{b:t0p}{n:int}
  (xs: list(INV(a), n), f: cfun(a, b)): list (b, n)
//
implement
list_map (xs, f) =
(
case+ xs of
| list_nil () => list_nil ()
| list_cons (x, xs) => list_cons (f(x), list_map (xs, f))
) (* end of [list_map] *)
//
(* ****** ****** *)
//
extern
fun
fromto
  : (int, int) -> List0 (int) = "mac#fromto"
//
implement
fromto(m, n) =
if m < n
  then list_cons(m, fromto(m+1, n)) else list_nil()
// end of [if]
//
(* ****** ****** *)
//
extern
fun
mytest
  : (int, int) -> List0(int) = "mac#mytest"
//
implement
mytest (m, n) = let
  val xs = fromto (m, n)
in
  list_map{int}{int} (xs, lam x => m * n * x)
end // end of [mytest]
//
(* ****** ****** *)

implement
{a}(*tmp*)
print_list(xs) = let
//
val sep = ", "
//
fun
loop
(
  i: int, xs: List(a)
) : void =
(
case+ xs of
| list_nil() => ()
| list_cons(x, xs) => let
    val () =
    if i > 0 then print(sep)
    val () = print_val<a> (x)
  in
    loop (i+1, xs)
  end // end of [list_cons]
)
//
in
  loop (0, xs)
end // end of [print_list]

(* ****** ****** *)

extern
fun
main0_erl : () -> void = "mac#"
implement
main0_erl () =
{
//
val () = println! ("mytest(5, 10) = ", mytest(5, 10))
//
} (* end of [main0_erl] *)

(* ****** ****** *)

(* end of [listmap.dats] *)

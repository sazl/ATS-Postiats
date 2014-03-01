(*
** reference-counted abstract syntax tree
*)

(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload "libats/SATS/refcount.sats"
staload _ = "libats/DATS/refcount.dats"
//
(* ****** ****** *)

datavtype
exp_node =
  | EXPnum of double
  | EXPadd of (exp, exp)
  | EXPsub of (exp, exp)
// end of [exp_node]

where exp = refcnt (exp_node)

(* ****** ****** *)
//
fun exp_num
  (x: double): exp = refcnt_make (EXPnum(x))
//
fun exp_add
  (e1: exp, e2: exp) = refcnt_make (EXPadd(e1, e2))
//
fun exp_sub
  (e1: exp, e2: exp) = refcnt_make (EXPsub(e1, e2))
//
(* ****** ****** *)

extern
fun copy_exp (!exp): exp
implement
copy_exp (e0) = refcnt_incref (e0)

(* ****** ****** *)

extern
fun free_exp (exp): void
extern
fun free_exp_node (exp_node): void

(* ****** ****** *)

implement
free_exp (e0) = let
  var en: exp?
  val ans = refcnt_decref (e0, en)
in
//
if ans
  then let
    prval () =
      opt_unsome (en)
    // end of [prval]
  in
    free_exp_node (en)
  end // end of [then]
  else let
    prval () = opt_unnone (en) in (*nothing*)
  end // end of [else]
// end of [if]
//
end // end of [free_exp]

implement
free_exp_node (en) =
(
case+ en of
| ~EXPnum (x) => ()
| ~EXPadd (e1, e2) => (free_exp (e1); free_exp (e2))
| ~EXPsub (e1, e2) => (free_exp (e1); free_exp (e2))
)

(* ****** ****** *)

extern
fun eval_exp (!exp): double
extern
fun eval_exp_node (!exp_node): double

(* ****** ****** *)

implement
eval_exp
  (e0) = res where
{
  val (
    pf, fpf | p
  ) = refcnt_vtakeout (e0)
  val res = eval_exp_node (!p)
  prval () = fpf (pf)
} (* end of [eval_exp] *)

(* ****** ****** *)

implement
eval_exp_node (en) =
(
case+ en of
| EXPnum (x) => x
| EXPadd (e1, e2) => eval_exp (e1) + eval_exp (e2)
| EXPsub (e1, e2) => eval_exp (e1) - eval_exp (e2)
) (* end of [eval_exp_node] *)

(* ****** ****** *)

implement
main0 () =
{
val e1 = exp_num (1.0)
val e2 = exp_num (2.0)
val e3 = exp_num (3.0)
val exp = exp_sub (exp_add (e1, e2), e3)
val () = println! ("ans = ", eval_exp (exp))
val () = free_exp (exp)
} (* end of [main0] *)

(* ****** ****** *)

(* end of [calc_refcount.dats] *)

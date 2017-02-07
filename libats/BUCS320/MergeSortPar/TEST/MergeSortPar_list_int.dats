(* ****** ****** *)
(*
** DivideConquer:
** MergeSortPar_list
**
*)
(* ****** ****** *)

#define
ATS_DYNLOADFLAG 0

(* ****** ****** *)
//
%{^
#include <pthread.h>
%} // end of [%{^]
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#include
"share/HATS\
/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)

#staload "./testlib.dats"

(* ****** ****** *)
//
#define MERGESORTPAR_LIST
//
#include "./../mydepies.hats"
#include "./../mylibies.hats"
//
(* ****** ****** *)
//
#staload
MSP_list = $MergeSortPar_list
//
assume $MSP_list.elt_t0ype = int
//
implement
gcompare_val_val<int>(x, y) = compare(x, y)
//
implement
MergeSortPar_list_int(xs) = $MSP_list.MergeSortPar_list<>(xs)
//
(* ****** ****** *)

(* end of [MergeSortParPar_list_int.dats] *)
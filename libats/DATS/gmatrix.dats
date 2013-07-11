(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2013 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
** later version.
**
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
**
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)

(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: July, 2013 *)

(* ****** ****** *)

staload
UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "libats/SATS/gvector.sats"
staload "libats/SATS/gmatrix.sats"

(* ****** ****** *)

(*
symintr nil_v
overload nil_v with gvector_v_nil
overload nil_v with gmatcol_v_nil
symintr unnil_v
overload unnil_v with gvector_v_unnil
overload unnil_v with gmatcol_v_unnil
symintr unnil_nil_v
overload unnil_nil_v with gmatcol_v_unnil_nil
symintr cons_v
overload cons_v with gvector_v_cons
overload cons_v with gmatcol_v_cons
symintr uncons_v
overload uncons_v with gvector_v_uncons
overload uncons_v with gmatcol_v_uncons
*)

(* ****** ****** *)

implement{a}
gmatcol_getref_col_at
  {m,n}{ld}(M, m, j) = let
//
val pcol = $UN.cast2Ptr1(ptr_add<a> (addr@(M), j * m))
//
in
  $UN.ptr2cptr{array(a,m)}(pcol)
end // end of [gmatcol_getref_col_at]

implement{a}
gmatrow_getref_row_at
  {m,n}{ld}(M, n, i) = let
//
val prow = $UN.cast2Ptr1(ptr_add<a> (addr@(M), i * n))
//
in
  $UN.ptr2cptr{array(a,n)}(prow)
end // end of [gmatrow_getref_row_at]

(* ****** ****** *)

implement{a}
multo_gvector_gmatcol_gvector
  {m,n}{d1,ld2,d3}
(
  V1, M2, V3, m, n, d1, ld2, d3
) = let
//
fun loop
  {l1,l2,l3:addr}{n:nat} .<n>.
(
  pf1: !GV (a, l1, m, d1)
, pf2: !GMC (a, l2, m, n, ld2)
, pf3: !GV (a?, l3, n, d3) >> GV (a, l3, n, d3)
| p1: ptr(l1), p2: ptr(l2), p3: ptr(l3), n: int n
) : void = let
in
//
if n > 0 then let
//
prval (pf21, pf22) = gmatcol_v_uncons (pf2)
prval (pf31, pf32) = gvector_v_uncons (pf3)
//
prval () = array2gvector(!p2)
val () = !p3 := mul_gvector_gvector_scalar (!p1, !p2, m, d1, 1)
val () = loop (pf1, pf22, pf32 | p1, ptr_add<a> (p2, ld2), ptr_add<a> (p3, d3), n-1)
prval () = gvector2array(!p2)
//
prval () = pf2 := gmatcol_v_cons (pf21, pf22)
prval () = pf3 := gvector_v_cons (pf31, pf32)
//
in
  // nothing
end else let
//
prval () = pf3 := gvector_v_unnil_nil{a?,a}(pf3)
//
in
  // nothing
end // end of [if]
//
end // end of [loop]
//
prval () = lemma_gmatcol_param (M2)
//
in
  loop (view@V1, view@M2, view@V3 | addr@V1, addr@M2, addr@V3, n)
end // end of [multo_gvector_gmatcol_gvector]
////
(* ****** ****** *)

(*
implement{a}
multo_gmatrix_gmatrix_gmatrix
(
  A, B, C, mord, p, q, r, lda, ldb, ldc
) = (
case+ mord of
| MORDrow () =>
    multo_gmatrow_gmatrow_gmatrow (A, B, C, p, q, r, lda, ldb, ldc)
| MORDcol () =>
    multo_gmatcol_gmatcol_gmatcol (A, B, C, p, q, r, lda, ldb, ldc)
) (* end of [multo_gmatrix_gmatrix_gmatrix] *)
*)

(* ****** ****** *)

implement{a}
tmulto_gvector_gvector_gmatcol
  {m,n}{d1,d2,ld3}
(
  V1, V2, M3, m, n, d1, d2, ld3
) = let
//
fun loop
  {l1,l2,l3:addr}{n:nat} .<n>.
(
  pf1: !GV (a, l1, m, d1)
, pf2: !GV (a, l2, n, d2)
, pf3: !GMC (a?, l3, m, n, ld3) >> GMC (a, l3, m, n, ld3)
| p1: ptr l1, p2: ptr l2, p3: ptr l3, m: int m, n: int n
) : void =
(
if n > 0
  then let
//
prval (pf21, pf22) = gvector_v_uncons (pf2)
prval (pf31, pf32) = gmatcol_v_uncons (pf3)
//
val k = !p2
prval () = array2gvector(!p3)
val (
) = multo_scalar_gvector_gvector (k, !p1, !p3, m, d1, 1)
val (
) = loop (pf1, pf22, pf32 | p1, ptr_add<a> (p2, d2), ptr_add<a> (p3, ld3), m, pred(n))
prval () = gvector2array(!p3)
prval () = pf2 := gvector_v_cons (pf21, pf22)
prval () = pf3 := gmatcol_v_cons (pf31, pf32)
//
in
  // nothing
end else let
//
prval () = (pf3 := gmatcol_v_unnil_nil{a?,a}(pf3))
//
in
  // nothing
end // end of [if]
)
//
prval () = lemma_gmatcol_param (M3)
//
in
  loop (view@V1, view@V2, view@M3 | addr@V1, addr@V2, addr@M3, m, n)
end // end of [tmul_gvector_gvector_gmatcol]

(* ****** ****** *)

implement{a}
tmulto_gvector_gvector_gmatrow
  {m,n}{d1,d2,ld3}
(
  V1, V2, M3, m, n, d1, d2, ld3
) = let
//
fun loop
  {l1,l2,l3:addr}{m:nat} .<m>.
(
  pf1: !GV (a, l1, m, d1)
, pf2: !GV (a, l2, n, d2)
, pf3: !GMR (a?, l3, m, n, ld3) >> GMR (a, l3, m, n, ld3)
| p1: ptr l1, p2: ptr l2, p3: ptr l3, m: int m, n: int n
) : void =
(
if m > 0
  then let
//
prval (pf11, pf12) = gvector_v_uncons (pf1)
prval (pf31, pf32) = gmatrow_v_uncons (pf3)
//
val k = !p1
prval () = array2gvector(!p3)
val (
) = multo_scalar_gvector_gvector (k, !p2, !p3, n, d2, 1)
val (
) = loop (pf12, pf2, pf32 | ptr_add<a> (p1, d1), p2, ptr_add<a> (p3, ld3), pred(m), n)
prval () = gvector2array(!p3)
prval () = pf1 := gvector_v_cons (pf11, pf12)
prval () = pf3 := gmatrow_v_cons (pf31, pf32)
//
in
  // nothing
end else let
//
prval () = (pf3 := gmatrow_v_unnil_nil{a?,a}(pf3))
//
in
  // nothing
end // end of [if]
)
//
prval () = lemma_gmatrow_param (M3)
//
in
  loop (view@V1, view@V2, view@M3 | addr@V1, addr@V2, addr@M3, m, n)
end // end of [tmul_gvector_gvector_gmatrow]

(* ****** ****** *)

(* end of [gmatrix.dats] *)

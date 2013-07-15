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

staload "libats/SATS/gvector.sats"

(* ****** ****** *)
//
sortdef mord = int
//
stadef mrow: mord = 0 // row-major
stadef mcol: mord = 1 // col-major
//
datatype MORD (int) =
  | MORDrow (mrow) of () | MORDcol (mcol) of ()
//
(* ****** ****** *)
//
datasort transp = tpn | tpt | tpc
datatype TRANSP (transp) =
  | TPN (tpn) of () | TPT (tpt) of () | TPC (tpc) of ()
//
(* ****** ****** *)

dataprop
transpdim
(
  transp
, int // row
, int // col
, int // row_new
, int // col_new
) =
  | {m,n:int} TPDIM_N (tpn, m, n, m, n) of ()
  | {m,n:int} TPDIM_T (tpt, m, n, n, m) of ()
  | {m,n:int} TPDIM_C (tpc, m, n, n, m) of ()
// end of [transpdim]

(* ****** ****** *)
//
// HX: [transp] is inverse
//
prfun
transpdim_transp
  {tp:transp}{m1,n1:int}{m2,n2:int}
  (pf: transpdim (tp, m1, n1, m2, n2)): transpdim (tp, n1, m1, n2, m2)
// end of [transpdim_transp]

(* ****** ****** *)

sortdef uplo = int
stadef uplo_l: uplo = 0 // lo
stadef uplo_u: uplo = 1 // up
datatype UPLO (uplo) = UPLO_L (uplo_l) | UPLO_U (uplo_u) of ()

(* ****** ****** *)

sortdef diag = int
stadef diag_n: diag = 0 // non
stadef diag_u: diag = 1 // unit
datatype DIAG (diag) = DIAG_N (diag_n) | DIAG_U (diag_u) of ()

(* ****** ****** *)

sortdef side = int
stadef side_l: side = 0 // left
stadef side_r: side = 1 // right
datatype SIDE (side) = SIDE_L (side_l) | SIDE_R (side_r) of ()

(* ****** ****** *)
//
// HX-2013-07:
// generic matrix:
// element, row, col, ord, ld
//
abst@ype
gmatrix_t0ype
  (a:t@ype, mo:mord, m:int, n:int, ld:int) (* irregular *)
//
typedef gmatrix
  (a:t0p, mo:mord, m:int, n:int, ld:int) = gmatrix_t0ype (a, mo, m, n, ld)
viewdef gmatrix_v
  (a:t0p, mo:mord, l:addr, m:int, n:int, ld:int) = gmatrix_t0ype (a, mo, m, n, ld) @ l
//
stadef GMX = gmatrix
stadef GMX = gmatrix_v
//
(* ****** ****** *)

praxi
lemma_gmatrix_param
  {a:t0p}{mo:mord}
  {m,n:int}{ld:int}
  (M: &GMX (a, mo, m, n, ld))
: [0 <= mo; mo <= 1; 0 <= m; 0 <= n; 1 <= ld] void
praxi
lemma_gmatrix_v_param
  {a:t0p}{mo:mord}
  {l:addr}{m,n:int}{ld:int}
  (pf: !GMX (a, mo, l, m, n, ld))
: [0 <= mo; mo <= 1; 0 <= m; 0 <= n; 1 <= ld] void

(* ****** ****** *)
//
typedef gmatrow
  (a:t0p, m:int, n:int, ld:int) = gmatrix_t0ype (a, mrow, m, n, ld)
viewdef gmatrow_v
  (a:t0p, l:addr, m:int, n:int, ld:int) = gmatrix_t0ype (a, mrow, m, n, ld) @ l
//
stadef GMR = gmatrow
stadef GMR = gmatrow_v
//
(* ****** ****** *)
//
typedef gmatcol
  (a:t0p, m:int, n:int, ld:int) = gmatrix_t0ype (a, mcol, m, n, ld)
viewdef gmatcol_v
  (a:t0p, l:addr, m:int, n:int, ld:int) = gmatrix_t0ype (a, mcol, m, n, ld) @ l
//
stadef GMC = gmatcol
stadef GMC = gmatcol_v
//
(* ****** ****** *)
//
(*
// HX-2013-07:
// Don't use [gmatrix_initize]
// unless you know what you are doing
*)
praxi
gmatrix_initize
  {a:t0p}{mo:mord}{m,n:int}{ld:int}
  (&GMX(a?, mo, m, n, ld) >> GMX(a, mo, n, m, ld)): void
praxi
gmatrix_uninitize
  {a:t0p}{mo:mord}{m,n:int}{ld:int}
  (&GMX(a, mo, m, n, ld) >> GMX(a?, mo, n, m, ld)): void
//
(* ****** ****** *)
//
praxi
gmatrix_flipord
  {a:t0p}{mo:mord}
  {m,n:int}{ld:int}
  (M: &GMX(a, mo, m, n, ld) >> GMX(a, 1-mo, n, m, ld)): void
praxi
gmatrix_v_flipord
  {a:t0p}{mo:mord}
  {l:addr}{m,n:int}{ld:int}
  (pf: !GMX(a, mo, l, m, n, ld) >> GMX(a, 1-mo, l, n, m, ld)): void
//
(* ****** ****** *)

fun{a:t0p}
gmatrow_imake_matrixptr
  {m,n:int}{ld:int}
(
  M: &GMR(a, m, n, ld), int m, int n, int(ld)
) : matrixptr (a, m, n)
fun{a:t0p}
gmatcol_imake_matrixptr
  {m,n:int}{ld:int}
(
  M: &GMC(a, m, n, ld), int m, int n, int(ld)
) : matrixptr (a, n, m)

(* ****** ****** *)

(* end of [gmatrix.sats] *)

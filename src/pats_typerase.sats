(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
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
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: July, 2012
//
(* ****** ****** *)

staload
LOC = "pats_location.sats"
typedef location = $LOC.location

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_dynexp2.sats"

(* ****** ****** *)

staload "pats_dynexp3.sats"

(* ****** ****** *)

staload "pats_histaexp.sats"
staload "pats_hidynexp.sats"

(* ****** ****** *)
//
// HX-2012-09:
// [s2exp_tyer] is essentially for
// measuring the size of a given type
//
fun s2exp_tyer // flag=0/1:shallow/deep
  (loc: location, flag: int, s2e0: s2exp): hisexp
// end of [s2exp_tyer]

fun s2exp_tyer_deep
  (loc: location, s2e0: s2exp): hisexp
// end of [s2exp_tyer_deep]

fun s2exp_tyer_shallow
  (loc: location, s2e0: s2exp): hisexp
// end of [s2exp_tyer_shallow]

(* ****** ****** *)

fun p3at_tyer (p3t: p3at): hipat
fun p3atlst_tyer (p3ts: p3atlst): hipatlst

(* ****** ****** *)

fun d3exp_tyer (d3e: d3exp): hidexp
fun d3explst_tyer (d3es: d3explst): hidexplst

(* ****** ****** *)

fun d3eclist_tyer (d3cs: d3eclist): hideclist

(* ****** ****** *)

(* end of [pats_typerase.sats] *)

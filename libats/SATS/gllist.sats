(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2012 Hongwei Xi, ATS Trustful Software, Inc.
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
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Time: October, 2010
//
(* ****** ****** *)
//
// HX: generic functional lists (fully indexed)
//
(* ****** ****** *)
//
// HX-2012-11-27: ported to ATS/Postiats from ATS/Anairiats
//
(* ****** ****** *)

#define ATS_STALOADFLAG 0 // no need for staloading at run-time

(* ****** ****** *)

staload "libats/SATS/ilist_prf.sats" // for handling integer sequences

(* ****** ****** *)

sortdef vt0p = viewt@ype

(* ****** ****** *)

(*
// HX: [stamped] is introduced in prelude/basics_pre.sats
*)

dataviewtype
gllist (
  a:viewt@ype+, ilist(*ind*)
) =
  | gllist_nil (a, ilist_nil) of ()
  | {x:int}{xs:ilist}
    gllist_cons
      (a, ilist_cons (x, xs)) of (stamped (a, x), gllist (a, xs))
    // end of [gllist_cons]
// end of [gllist]

(* ****** ****** *)

fun{a:vt0p}
gllist_length
  {xs:ilist}
  (xs: !gllist (a, xs)):<> [n:nat] (LENGTH (xs, n) | int n)
// end of [gllist_length]

(* ****** ****** *)

fun{a:vt0p}
gllist_append
  {xs1,xs2:ilist} (
  xs1: gllist (a, xs1), xs2: gllist (a, xs2)
) :<!wrt> [res:ilist] (APPEND (xs1, xs2, res) | gllist (a, res))
// end of [gllist_append]

(* ****** ****** *)

fun{a:vt0p}
gllist_revapp
  {xs1,xs2:ilist} (
  xs1: gllist (a, xs1), xs2: gllist (a, xs2)
) :<!wrt> [res:ilist] (REVAPP (xs1, xs2, res) | gllist (a, res))
// end of [gllist_revapp]

fun{a:vt0p}
gllist_reverse
  {xs:ilist} (
  xs: gllist (a, xs)
) :<!wrt> [ys:ilist] (REVERSE (xs, ys) | gllist (a, ys))
// end of [gllist_reverse]

(* ****** ****** *)

fun{a:vt0p}
gllist_mergesort$cmp {x1,x2:int}
  (x1: &stamped (a, x1), x2: &stamped (a, x2)): int(sgn(x1-x2))
fun{a:vt0p}
gllist_mergesort {xs:ilist}
  (xs: gllist (a, xs)): [ys:ilist] (SORT (xs, ys) | gllist (a, ys))
// end of [gllist_mergesort]

(* ****** ****** *)

(* end of [gllist.sats] *)

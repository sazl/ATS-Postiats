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

(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: December, 2012 *)

(* ****** ****** *)

staload
UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "libats/SATS/linmap.sats"

(* ****** ****** *)

stadef mytkind = $extkind"atslib_linmap_list"

(* ****** ****** *)

vtypedef
map (key:t0p, itm:vt0p) = map (mytkind, key, itm)

(* ****** ****** *)

extern
praxi
map_foldin
  {k:t0p;i:vt0p} (x: !List0_vt @(k, i) >> map (k, i)): void
// end of [map_foldin]
extern
praxi
map_unfold
  {k:t0p;i:vt0p} (x: !map (k, i) >> List0_vt @(k, i)): void
// end of [map_unfold]

extern
castfn
map_encode {k:t0p;i:vt0p} (x: List0_vt @(k, i)):<> map (k, i)
extern
castfn
map_decode {k:t0p;i:vt0p} (x: map (k, i)):<> List0_vt @(k, i)

(* ****** ****** *)

implement
linmap_nil<mytkind> () = map_encode (list_vt_nil ())

(* ****** ****** *)

implement
linmap_is_nil<mytkind>
  (map) = ans where {
  prval () = map_unfold (map)
  val ans = (
    case+ map of list_vt_nil _ => true | list_vt_cons _ => false
  ) : bool // end of [val]
  prval () = map_foldin (map)
} // end of [linmap_is_nil]

implement
linmap_isnot_nil<mytkind>
  (map) = ans where {
  prval () = map_unfold (map)
  val ans = (
    case+ map of list_vt_nil _ => false | list_vt_cons _ => true
  ) : bool // end of [val]
  prval () = map_foldin (map)
} // end of [linmap_isnot_nil]

(* ****** ****** *)

implement(k,i)
linmap_size<mytkind><k,i>
  (map) = res where {
  prval () = map_unfold (map)
  val res = g1int2uint (list_vt_length (map))
  prval () = map_foldin (map)  
} // end of [linmap_size]

(* ****** ****** *)

implement(k,i)
linmap_free<mytkind><k,i>
   (map) = list_vt_free<(k,i)> (map_decode (map))
// end of [linmap_free]

(* ****** ****** *)

implement(k,i)
linmap_insert_any<mytkind><k,i>
  (map, k0, x0) = let
  prval () = map_unfold (map)
  val () = map := list_vt_cons ( @(k0, x0), map )
  prval () = map_foldin (map)
in
  // nothing
end // end of [linmap_insert_any]

(* ****** ****** *)

implement
(k,i,env)
linmap_foreach_env<mytkind><k,i><env>
  (map, env) = let
//
vtypedef ki = @(k, i)
//
implement
list_vt_foreach$cont<ki><env> (kx, env) = linmap_foreach$cont (kx.0, kx.1, env)
implement
list_vt_foreach$fwork<ki><env> (kx, env) = linmap_foreach$fwork (kx.0, kx.1, env)
//
prval () = map_unfold (map)
val () = list_vt_foreach_env (map, env)
prval () = map_foldin (map)
//
in
  // nothing
end // end of [linmap_foreach_env]

(* ****** ****** *)

implement(k,i)
linmap_listize<mytkind><k,i>
  (map) = res where {
  prval () = map_unfold (map)  
  val res = list_vt_copy<(k,i)> (map)
  prval () = map_foldin (map)
} // end of [linmap_listize]

implement(k,i)
linmap_listize_free<mytkind><k,i> (map) = map_decode (map)

(* ****** ****** *)

implement(k,i)
linmap_search_ngc<mytkind><k,i>
  (map, k0) = let
//
vtypedef ki = @(k, i)
//
fun loop
  {n:nat} .<n>. (
  kxs: !list_vt (ki, n), k0: k
) :<> Ptr0 = let
in
//
case+ kxs of
| @list_vt_cons
    (kx, kxs1) => let
    val iseq =
      equal_key_key<k> (kx.0, k0)
    // end of [val]
  in
    if iseq then let
      prval () = fold@ (kxs)
    in
      $UN.castvwtp1{Ptr1} (kxs)
    end else let
      val res = loop (kxs1, k0)
      prval () = fold@ (kxs) in res
    end // end of [if]
  end // end of [list_vt_cons]
| @list_vt_nil () => let
    prval () = fold@ (kxs) in the_null_ptr
  end // end of [list_vt_cons]
//
end // end of [loop]
//
prval () = map_unfold (map)
val res = loop (map, k0) // HX: Ptr1
prval () = map_foldin (map)
//
in
  res
end // end of [linmap_search_ngc]

(* ****** ****** *)

implement(k,i)
linmap_takeout_ngc<mytkind><k,i>
  (map, k0) = let
//
vtypedef ki = @(k, i)
vtypedef mynode0 = mynode0 (mytkind, k, i)
vtypedef mynode1 = mynode1 (mytkind, k, i)
//
fun loop (
  kxs: &List0_vt (ki) >> _, k0: k
) : mynode0 = let
//
vtypedef kis = List0_vt (ki)
//
in
//
case+ kxs of
| @list_vt_cons
    (kx, kxs1) => let
    val iseq =
      equal_key_key<k> (kx.0, k0)
    // end of [val]
  in
    if iseq then let
      val p1 = addr@ (kxs1)
      prval () = fold@ (kxs)
      val res = $UN.castvwtp0{mynode1} (kxs)
      val () = kxs := $UN.castvwtp0{kis} (p1)
    in
      res
    end else let
      val res = loop (kxs1, k0)
      prval () = fold@ (kxs) in res
    end // end of [if]
  end // end of [list_vt_cons]
| @list_vt_nil () => let
    prval () = fold@ (kxs) in mynode_null ()
  end // end of [list_vt_cons]
//
end // end of [loop]
//
prval () = map_unfold (map)
val res = loop (map, k0) // HX: mynode0
prval () = map_foldin (map)
//
in
  res
end // end of [linmap_takeout_ngc]

(* ****** ****** *)

(* end of [linmap_list.dats] *)

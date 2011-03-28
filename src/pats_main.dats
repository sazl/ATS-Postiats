(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
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
// Start Time: March, 2011
//
(* ****** ****** *)

staload "libc/SATS/stdio.sats"

(* ****** ****** *)

staload "pats_location.sats"
staload "pats_lexing.sats"
staload "pats_tokbuf.sats"
staload "pats_syntax.sats"
staload "pats_parsing.sats"

(* ****** ****** *)
//
dynload "pats_utils.dats"
//
dynload "pats_symbol.dats"
dynload "pats_filename.dats"
dynload "pats_location.dats"
//
(* ****** ****** *)

dynload "pats_reader.dats"
dynload "pats_lexbuf.dats"
dynload "pats_lexing_token.dats"
dynload "pats_lexing_print.dats"
dynload "pats_lexing_error.dats"
dynload "pats_lexing.dats"

dynload "pats_label.dats"
dynload "pats_fixity.dats"
dynload "pats_syntax_print.dats"
dynload "pats_syntax.dats"

dynload "pats_tokbuf.dats"
dynload "pats_parsing_util.dats"
dynload "pats_parsing_error.dats"
dynload "pats_parsing_misc.dats"
dynload "pats_parsing_e0xp.dats"
dynload "pats_parsing_sort.dats"
dynload "pats_parsing_staexp.dats"
dynload "pats_parsing_dynexp.dats"
dynload "pats_parsing_decl.dats"

(* ****** ****** *)

implement
main (
  argc, argv
) = () where {
//
  val () = println! ("Hello from ATS/Postiats!")
//
  var buf: tokbuf
  val () = tokbuf_initialize_getc (buf, lam () =<cloptr1> getchar ())
  var err: int = 0
(*
  val s0t = p_s0rt (buf, 0, err)
  val () = if (err = 0) then
    fprint_location (stdout_ref, s0t.s0rt_loc)
  val () = if (err = 0) then print_newline ()
  val () = if (err = 0) then fprint_s0rt (stdout_ref, s0t)
  val () = if (err = 0) then print_newline ()
*)
(*
  val s0e = p_s0exp (buf, 0, err)
  val () = if (err = 0) then
    fprint_location (stdout_ref, s0e.s0exp_loc)
  val () = if (err = 0) then print_newline ()
  val () = if (err = 0) then fprint_s0exp (stdout_ref, s0e)
  val () = if (err = 0) then print_newline ()
*)
//
  val d0cs = p_d0eclist (buf, 0, err)
  val _eof = p_EOF (buf, 0, err)
  val () = tokbuf_discard_all (buf)
//
  val () = if (err = 0) then fprint_d0eclist (stdout_ref, d0cs)
  val () = if (err = 0) then print_newline ()
//
  val () = tokbuf_uninitialize (buf)
//
  val () = fprint_the_lexerrlst (stdout_ref)
  val () = fprint_the_parerrlst (stdout_ref)
//
} // end of [main]

(* ****** ****** *)

(* end of [pats_main.dats] *)

/***********************************************************************/
/*                                                                     */
/*                         Applied Type System                         */
/*                                                                     */
/***********************************************************************/

/* (*
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
*) */

/* ****** ****** */

/*
(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: October, 2012 *)
*/

/* ****** ****** */

#ifndef PATS_CCOMP_INSTRSET_H
#define PATS_CCOMP_INSTRSET_H

/* ****** ****** */
//
// HX: boolean values
//
#define atsbool_true 1
#define atsbool_false 0
//
/* ****** ****** */

#define ATStysum() struct{ int contag; }
#define ATStylist(tyelt) struct{ tyelt head; void *tail; }
#define ATStyclo() struct{ void *cfun; }

/* ****** ****** */

#define ATSempty()

/* ****** ****** */

#define ATSif(x) if (x)
#define ATSifnot(x) if (!(x))
#define ATSthen()
#define ATSelse() else
#define ATSdo() do
#define ATSwhile(x) while (x)
#define ATSbreak() break
#define ATScontinue() continue
#define ATSgoto(lab) goto lab
#define ATSreturn(x) return (x)
#define ATSreturn_void(x) return

/* ****** ****** */

#define ATScaseofbeg() do {
#define ATScaseofend() } while (0) ;
#define ATSbranchbeg()
#define ATSbranchend() break

/* ****** ****** */

#define ATSPMVint(i) i
#define ATSPMVintrep(str) str

#define ATSPMVbool_true() atsbool_true
#define ATSPMVbool_false() atsbool_false
#define ATSPMVchar(c) c
#define ATSPMVfloat(rep) rep
#define ATSPMVstring(str) str

#define ATSPMVi0nt(x) x
#define ATSPMVf0loat(x) x

/* ****** ****** */

#define ATSCSTSPmyfil(info) info
#define ATSCSTSPmyloc(info) info

/* ****** ****** */

#define ATSPMVtop() atserror_top
#define ATSPMVempty() atserror_empty

/* ****** ****** */

#define ATSPMVextval(id) (id)

/* ****** ****** */

#define ATSPMVfunlab(flab) (flab)

/* ****** ****** */

#define ATSPMVcfunlab(knd, flab, env) (flab##$closurerize)env

/* ****** ****** */

#define ATSPMVptrof(lval) (&(lval))
#define ATSPMVptrof_void(lval) ((void*)0)

/* ****** ****** */

#define ATSPMVrefarg0(val) (val)
#define ATSPMVrefarg1(ref) (ref)

/* ****** ****** */

#define ATSPMVsizeof(hit) (sizeof(hit))

/* ****** ****** */
//
// HX: castfn application
//
#define ATSPMVcastfn(d2c, hit, arg) ((hit)arg)
//
/* ****** ****** */

#define ATSfcall(fun, args) (fun)args
#define ATSfunclo_fun(pmv, targs, tres) ((tres(*)targs)(pmv))
#define ATSfunclo_clo(pmv, targs, tres) ((tres(*)targs)(((ATStyclo()*)pmv)->cfun))

/* ****** ****** */

#define ATStmpdec(tmp, hit) hit tmp
#define ATStmpdec_void(tmp, hit)

#define ATSstatmpdec(tmp, hit) static hit tmp
#define ATSstatmpdec_void(tmp, hit)

/* ****** ****** */

#define ATSderef(pmv, hit) (*(hit*)pmv)

/* ****** ****** */
//
// HX: [ATSSELcon] is the same as [ATSSELboxrec]
//
#define ATSSELcon(pmv, tysum, lab) (((tysum*)pmv)->lab)
//
#define ATSSELrecsin(pmv, tyrec, lab) (pmv)
#define ATSSELfltrec(pmv, tyrec, lab) ((pmv).lab)
#define ATSSELboxrec(pmv, tyrec, lab) (((tyrec*)pmv)->lab)
#define ATSSELarrind(pmv, tyarr, lab) (((tyarr)pmv).lab)
#define ATSSELarrptrind(pmv, tyelt, lab) (((tyelt*)pmv)lab)
//
/* ****** ****** */
//
#define ATSCKnot(x) ((x)==0)
#define ATSCKiseqz(x) ((x)==0)
#define ATSCKisneqz(x) ((x)!=0)
#define ATSCKptriscons(x) (0 != (void*)(x))
#define ATSCKptrisnull(x) (0 == (void*)(x))
//
/* ****** ****** */
//
// HX: handling for/while loops
//
#define ATSbreak2(fini) goto fini
#define ATScontinue2(cont) goto cont
#define ATSLOOPopen(init, fini, cont) \
  do { init:
#define ATSLOOPclose(init, fini, cont) \
  goto init ; fini: break ; } while(0)
//
/* ****** ****** */
//
#define ATSPATCKint(pmv, pat) ((pmv)==pat)
#define ATSPATCKbool(pmv, pat) ((pmv)==pat)
#define ATSPATCKchar(pmv, pat) ((pmv)==pat)
#define ATSPATCKfloat(pmv, pat) ((pmv)==pat)
#define ATSPATCKstring(pmv, pat) (atspre_string_equal(pmv, pat))
//
#define ATSPATCKcon0(pmv, tag) (pmv==(void*)tag)
#define ATSPATCKcon1(pmv, tag) (((ATStysum()*)(pmv))->contag==tag)
//
#define ATSPATCKexn0(pmv, d2c) (((ATStysum()*)(pmv))->contag==&(d2c))
#define ATSPATCKexn1(pmv, d2c) (((ATStysum()*)(pmv))->contag==(d2c).exntag)
//
/* ****** ****** */

#define ATSINSmove(tmp, val) (tmp = val)
#define ATSINSpmove(tmp, hit, val) (*(hit*)tmp = val)

/* ****** ****** */
/*
** HX-2013-01-20:
** Do not have parentheses around [command]
*/
#define ATSINSmove_void(tmp, command) command
#define ATSINSpmove_void(tmp, hit, command) command

/* ****** ****** */

#define ATSINSmove_ptralloc(tmp, hit) (tmp = ATS_MALLOC(sizeof(hit)))

/* ****** ****** */

#define ATSINSmove_con0(tmp, tag) (tmp = ((void*)tag))
#define ATSINSmove_con1(tmp, tysum) (tmp = ATS_MALLOC(sizeof(tysum)))
#define ATSINSstore_con_tag(tmp, val) (((ATStysum()*)(tmp))->contag = val)
#define ATSINSstore_con_ofs(tmp, tyrec, lab, val) (((tyrec*)(tmp))->lab = val)

/* ****** ****** */

#define ATSINSstore_fltrec_ofs(tmp, tyrec, lab, val) ((tmp).lab = val)

/* ****** ****** */

#define ATSINSmove_boxrec(tmp, tyrec) (tmp = ATS_MALLOC(sizeof(tyrec)))
#define ATSINSstore_boxrec_ofs(tmp, tyrec, lab, val) (((tyrec*)(tmp))->lab = val)

/* ****** ****** */

#define ATSINSload(tmp, pmv) (tmp = pmv)
#define ATSINSstore(pmv1, pmv2) (pmv1 = pmv2)
#define ATSINSxstore(tmp, pmv1, pmv2) (tmp = pmv1, pmv1 = pmv2, pmv2 = tmp)

/* ****** ****** */
//
#define ATSINSmove_list_nil(tmp) (tmp = (void*)0)
#define ATSINSmove_list_phead(tmp1, tmp2, tyelt) (tmp1 = &(((ATStylist(tyelt)*)(*(void**)tmp2))->head))
#define ATSINSmove_list_ptail(tmp1, tmp2, tyelt) (tmp1 = &(((ATStylist(tyelt)*)(*(void**)tmp2))->tail))
#define ATSINSpmove_list_nil(tmp) (*(void**)tmp = (void*)0)
#define ATSINSpmove_list_cons(tmp, tyelt) (*(void**)tmp = ATS_MALLOC(sizeof(ATStylist(tyelt))))
//
/* ****** ****** */
//
#define ATSINSstore_arrpsz_asz(tmp, asz) ((tmp).size = asz)
#define ATSINSstore_arrpsz_ptr(tmp, tyelt, asz) ((tmp).ptr = ATS_MALLOC(asz*sizeof(tyelt)))
//
#define ATSINSmove_arrpsz_ptr(tmp, psz) (tmp = (psz).ptr)
//
#define ATSINSupdate_ptrinc(tmp, tyelt) (tmp = (tyelt*)(tmp) + 1)
#define ATSINSupdate_ptrdec(tmp, tyelt) (tmp = (tyelt*)(tmp) - 1)
//
/* ****** ****** */

#define ATSINSraise_exn(tmp, pmv) atsruntime_raise(pmv)

#define ATSINScaseof_fail(msg) atsruntime_handle_unmatchedval(msg)
/*
#define ATSINSfunarg_fail(msg) ...
*/

/* ****** ****** */

#endif /* PATS_CCOMP_INSTRSET_H */

/* ****** ****** */

/* end of [pats_ccomp_instrset.h] */

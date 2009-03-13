(* 

   Haproxy module for Augeas
   
   Author: Francois Deppierraz <francois.deppierraz@camptocamp.com>
   
   About: License
   This file is licensed under the LGPL

   Todo:
      - Remove multiple whitespaces from keys
      - Remove multiple whitespaces from option values
      - Named defaults sections are not correctly parsed

*)

module Haproxy =
  autoload xfm

let spc       = Util.del_ws_spc
let eol       = Util.eol
let empty     = Util.empty
let comment   = Util.comment

let indent    = del /[ \t]+/ " "

let word      = /[^# \t\n\/]+/

let words     = /[^# \t\n]+([ \t]+[^# \t\n]+)*/

(*

  Parameters

*)

let option_re = ( /option[ \t]+/ . word ) |
                ( word - /option/ )

let option    = key option_re . ( spc . store words ) ?

let line = [ indent . option . (eol|comment) ]

(*

  Sections

*)

let item      = ( line | comment | empty )

let global_re = "global"|"defaults"
let global    = [ key global_re . eol .  item * ]

let section_re = "listen"|"frontend"|"backend"
let section   = [ key section_re . spc . [ key word . ( spc . store words ) ? . eol .  item * ] ]

let lns       = (comment|empty) *  . (global|section) *

let filter    = incl "/etc/haproxy/haproxy.cfg"
                . Util.stdexcl
 
let xfm       = transform lns filter

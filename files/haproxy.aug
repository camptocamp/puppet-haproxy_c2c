(* 

   Haproxy module for Augeas
   
   Author: Francois Deppierraz <francois.deppierraz@camptocamp.com>
   
   About: License
   This file is licensed under the GPL

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

  Sections

*)

let opt_re    = ( /option[ \t]+/ . word ) |
                ( word - /option/ )

let opt       = [ key opt_re . ( spc . store words ) ? ]

let params    = indent . opt . (eol|comment)

(*

  Parameters

*)


let section   = [ key word . ( spc . store words ) ? . eol .
                  ( params ) * ]


let lns       = (comment|empty|section) *

let filter    = incl "/etc/haproxy/haproxy.cfg"
                . Util.stdexcl
 
let xfm       = transform lns filter

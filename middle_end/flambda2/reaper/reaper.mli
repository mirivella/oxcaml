(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*           Nathanaëlle Courant, Pierre Chambart, OCamlPro               *)
(*                                                                        *)
(*   Copyright 2024 OCamlPro SAS                                          *)
(*   Copyright 2024 Jane Street Group LLC                                 *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

type rebuild_data

val run :
  machine_width:Target_system.Machine_width.t ->
  cmx_loader:Flambda_cmx.loader ->
  all_code:Exported_code.t ->
  final_typing_env:Typing_env.t option ->
  Flambda_unit.t ->
  Flambda_unit.t
  * Name_occurrences.t
  * Exported_code.t
  * Slot_offsets.t
  * Typing_env.t option

val traverse :
  final_typing_env:Typing_env.t option ->
  all_code:Exported_code.t ->
  unit:Flambda_unit.t ->
  rebuild_data

val solve_and_rebuild :
  machine_width:Target_system.Machine_width.t ->
  cmx_loader:Flambda_cmx.loader ->
  rebuild_data ->
  Flambda_unit.t
  * Name_occurrences.t
  * Exported_code.t
  * Slot_offsets.t
  * Typing_env.t option

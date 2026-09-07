(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                        Basile Clément, OCamlPro                        *)
(*                                                                        *)
(*   Copyright 2024--2025 OCamlPro SAS                                    *)
(*   Copyright 2024--2025 Jane Street Group LLC                           *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

type stats

val create_stats : ?with_provenance:bool -> Table.Map.t -> stats

val print_stats : Format.formatter -> stats -> unit

type rule

type deduction =
  [ `Atom of Datalog.atom
  | `And of deduction list ]

val deduce : deduction -> (Heterogenous_list.nil, rule) Datalog.program

type t

val saturate : rule list -> t

val fixpoint : t list -> t

(** A pruning step for {!run}. After every iteration of a saturation,
    [prune ~difference ~current] is called with the facts derived during that
    iteration ([difference]) and the database at the end of it ([current]), and
    must return [current] with potentially some facts removed.

    Datalog evaluation assumes that the database only grows, so removing a fact
    is only sound if the fact is {e redundant}: every conclusion any rule could
    draw from it must also be derivable without it, and no query may depend on
    its presence. The typical use is a fact subsumed by a "top" fact, e.g.
    removing [sources x _] once [any_source x] has been derived, when all rules
    reading [sources x _] are guarded by [not (any_source x)].

    Two further caveats: a pruned fact does not reappear in any later [diff], so
    rules never fire on it after its removal (fine for redundant facts, since
    those rules must not derive anything new from it); and within a [fixpoint]
    of several [saturate] schedules, facts pruned after the iteration that
    derived them remain in the difference seen by the {e other} schedules, so
    those schedules must tolerate them as well. *)
type prune = difference:Table.Map.t -> current:Table.Map.t -> Table.Map.t

val run : ?stats:stats -> ?prune:prune -> t -> Table.Map.t -> Table.Map.t

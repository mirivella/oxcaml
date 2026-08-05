(* Dependency of cmr_creation_and_rebuild.ml, to test compilation with imports. *)

let[@inline never] add_one x = x + 1

let[@inline always] make_adder x = fun y -> x + y

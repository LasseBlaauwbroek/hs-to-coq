(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Require Coq.Program.Tactics.
Require Coq.Program.Wf.

(* Converted imports: *)

Require BinNums.
Require GHC.Base.
Require GHC.Tuple.
Require Unique.
Import GHC.Base.Notations.

(* Converted type declarations: *)

Inductive UniqSupply : Type :=
  | MkSplitUniqSupply : BinNums.N -> UniqSupply -> UniqSupply -> UniqSupply.

Inductive UniqSM result : Type :=
  | USM (unUSM : UniqSupply -> (result * UniqSupply)%type) : UniqSM result.

Record MonadUnique__Dict (m : Type -> Type) := MonadUnique__Dict_Build {
  getUniqueM__ : m Unique.Unique ;
  getUniqueSupplyM__ : m UniqSupply ;
  getUniquesM__ : m (list Unique.Unique) }.

Definition MonadUnique (m : Type -> Type) `{GHC.Base.Monad m} :=
  forall r__, (MonadUnique__Dict m -> r__) -> r__.
Existing Class MonadUnique.

Definition getUniqueM `{g__0__ : MonadUnique m} : m Unique.Unique :=
  g__0__ _ (getUniqueM__ m).

Definition getUniqueSupplyM `{g__0__ : MonadUnique m} : m UniqSupply :=
  g__0__ _ (getUniqueSupplyM__ m).

Definition getUniquesM `{g__0__ : MonadUnique m} : m (list Unique.Unique) :=
  g__0__ _ (getUniquesM__ m).

Arguments USM {_} _.

Definition unUSM {result} (arg_0__ : UniqSM result) :=
  let 'USM unUSM := arg_0__ in
  unUSM.

(* Midamble *)

Instance Default__UniqSupply
   : GHC.Err.Default UniqSupply.
Admitted.

(* Converted value declarations: *)

Local Definition Applicative__UniqSM_op_zlztzg__
   : forall {a : Type},
     forall {b : Type}, UniqSM (a -> b) -> UniqSM a -> UniqSM b :=
  fun {a : Type} {b : Type} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | USM f, USM x =>
          USM (fun us =>
                 let 'pair ff us' := f us in
                 let 'pair xx us'' := x us' in
                 pair (ff xx) us'')
      end.

Local Definition Functor__UniqSM_fmap
   : forall {a : Type}, forall {b : Type}, (a -> b) -> UniqSM a -> UniqSM b :=
  fun {a : Type} {b : Type} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | f, USM x => USM (fun us => let 'pair r us' := x us in pair (f r) us')
      end.

Local Definition Functor__UniqSM_op_zlzd__
   : forall {a : Type}, forall {b : Type}, a -> UniqSM b -> UniqSM a :=
  fun {a : Type} {b : Type} => Functor__UniqSM_fmap GHC.Base.∘ GHC.Base.const.

Program Instance Functor__UniqSM : GHC.Base.Functor UniqSM :=
  fun _ k__ =>
    k__ {| GHC.Base.fmap__ := fun {a : Type} {b : Type} => Functor__UniqSM_fmap ;
           GHC.Base.op_zlzd____ := fun {a : Type} {b : Type} =>
             Functor__UniqSM_op_zlzd__ |}.

Local Definition Applicative__UniqSM_liftA2
   : forall {a : Type},
     forall {b : Type},
     forall {c : Type}, (a -> b -> c) -> UniqSM a -> UniqSM b -> UniqSM c :=
  fun {a : Type} {b : Type} {c : Type} =>
    fun f x => Applicative__UniqSM_op_zlztzg__ (GHC.Base.fmap f x).

Definition thenUs_ {a} {b} : UniqSM a -> UniqSM b -> UniqSM b :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | USM expr, USM cont => USM (fun us => let 'pair _ us' := (expr us) in cont us')
    end.

Local Definition Applicative__UniqSM_op_ztzg__
   : forall {a : Type}, forall {b : Type}, UniqSM a -> UniqSM b -> UniqSM b :=
  fun {a : Type} {b : Type} => thenUs_.

Definition returnUs {a} : a -> UniqSM a :=
  fun result => USM (fun us => pair result us).

Local Definition Applicative__UniqSM_pure : forall {a : Type}, a -> UniqSM a :=
  fun {a : Type} => returnUs.

Program Instance Applicative__UniqSM : GHC.Base.Applicative UniqSM :=
  fun _ k__ =>
    k__ {| GHC.Base.liftA2__ := fun {a : Type} {b : Type} {c : Type} =>
             Applicative__UniqSM_liftA2 ;
           GHC.Base.op_zlztzg____ := fun {a : Type} {b : Type} =>
             Applicative__UniqSM_op_zlztzg__ ;
           GHC.Base.op_ztzg____ := fun {a : Type} {b : Type} =>
             Applicative__UniqSM_op_ztzg__ ;
           GHC.Base.pure__ := fun {a : Type} => Applicative__UniqSM_pure |}.

Local Definition Monad__UniqSM_op_zgzg__
   : forall {a : Type}, forall {b : Type}, UniqSM a -> UniqSM b -> UniqSM b :=
  fun {a : Type} {b : Type} => _GHC.Base.*>_.

Definition thenUs {a} {b} : UniqSM a -> (a -> UniqSM b) -> UniqSM b :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | USM expr, cont =>
        USM (fun us => let 'pair result us' := (expr us) in unUSM (cont result) us')
    end.

Local Definition Monad__UniqSM_op_zgzgze__
   : forall {a : Type},
     forall {b : Type}, UniqSM a -> (a -> UniqSM b) -> UniqSM b :=
  fun {a : Type} {b : Type} => thenUs.

Local Definition Monad__UniqSM_return_ : forall {a : Type}, a -> UniqSM a :=
  fun {a : Type} => GHC.Base.pure.

Program Instance Monad__UniqSM : GHC.Base.Monad UniqSM :=
  fun _ k__ =>
    k__ {| GHC.Base.op_zgzg____ := fun {a : Type} {b : Type} =>
             Monad__UniqSM_op_zgzg__ ;
           GHC.Base.op_zgzgze____ := fun {a : Type} {b : Type} =>
             Monad__UniqSM_op_zgzgze__ ;
           GHC.Base.return___ := fun {a : Type} => Monad__UniqSM_return_ |}.

(* Skipping all instances of class `Control.Monad.Fix.MonadFix', including
   `UniqSupply.MonadFix__UniqSM' *)

Definition takeUniqFromSupply
   : UniqSupply -> (Unique.Unique * UniqSupply)%type :=
  fun '(MkSplitUniqSupply n s1 _) => pair (Unique.mkUniqueGrimily n) s1.

Definition getUniqueUs : UniqSM Unique.Unique :=
  USM (fun us => let 'pair u us' := takeUniqFromSupply us in pair u us').

Local Definition MonadUnique__UniqSM_getUniqueM : UniqSM Unique.Unique :=
  getUniqueUs.

Definition splitUniqSupply : UniqSupply -> (UniqSupply * UniqSupply)%type :=
  fun '(MkSplitUniqSupply _ s1 s2) => pair s1 s2.

Definition getUs : UniqSM UniqSupply :=
  USM (fun us => let 'pair us1 us2 := splitUniqSupply us in pair us1 us2).

Local Definition MonadUnique__UniqSM_getUniqueSupplyM : UniqSM UniqSupply :=
  getUs.

Fixpoint uniqsFromSupply (arg_0__ : UniqSupply) : list Unique.Unique
  := let 'MkSplitUniqSupply n _ s2 := arg_0__ in
     cons (Unique.mkUniqueGrimily n) (uniqsFromSupply s2).

Definition getUniquesUs : UniqSM (list Unique.Unique) :=
  USM (fun us =>
         let 'pair us1 us2 := splitUniqSupply us in
         pair (uniqsFromSupply us1) us2).

Local Definition MonadUnique__UniqSM_getUniquesM
   : UniqSM (list Unique.Unique) :=
  getUniquesUs.

Program Instance MonadUnique__UniqSM : MonadUnique UniqSM :=
  fun _ k__ =>
    k__ {| getUniqueM__ := MonadUnique__UniqSM_getUniqueM ;
           getUniqueSupplyM__ := MonadUnique__UniqSM_getUniqueSupplyM ;
           getUniquesM__ := MonadUnique__UniqSM_getUniquesM |}.

(* Skipping definition `UniqSupply.mkSplitUniqSupply' *)

Fixpoint listSplitUniqSupply (arg_0__ : UniqSupply) : list UniqSupply
  := let 'MkSplitUniqSupply _ s1 s2 := arg_0__ in
     cons s1 (listSplitUniqSupply s2).

Definition uniqFromSupply : UniqSupply -> Unique.Unique :=
  fun '(MkSplitUniqSupply n _ _) => Unique.mkUniqueGrimily n.

Definition splitUniqSupply3
   : UniqSupply -> GHC.Tuple.triple_type UniqSupply UniqSupply UniqSupply :=
  fun us =>
    let 'pair us1 us' := splitUniqSupply us in
    let 'pair us2 us3 := splitUniqSupply us' in
    pair (pair us1 us2) us3.

Definition splitUniqSupply4
   : UniqSupply ->
     GHC.Tuple.quad_type UniqSupply UniqSupply UniqSupply UniqSupply :=
  fun us =>
    let 'pair (pair us1 us2) us' := splitUniqSupply3 us in
    let 'pair us3 us4 := splitUniqSupply us' in
    pair (pair (pair us1 us2) us3) us4.

Definition initUs {a : Type}
   : UniqSupply -> UniqSM a -> (a * UniqSupply)%type :=
  fun init_us m => let 'pair r us := unUSM m init_us in pair r us.

Definition initUs_ {a : Type} : UniqSupply -> UniqSM a -> a :=
  fun init_us m => let 'pair r _ := unUSM m init_us in r.

Definition liftUSM {a} : UniqSM a -> UniqSupply -> (a * UniqSupply)%type :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | USM m, us => let 'pair a us' := m us in pair a us'
    end.

Definition lazyThenUs {a : Type} {b : Type}
   : UniqSM a -> (a -> UniqSM b) -> UniqSM b :=
  fun expr cont =>
    USM (fun us =>
           let 'pair result us' := liftUSM expr us in
           unUSM (cont result) us').

Definition getUniqueSupplyM3 {m : Type -> Type} `{MonadUnique m}
   : m (GHC.Tuple.triple_type UniqSupply UniqSupply UniqSupply) :=
  GHC.Base.liftM3 GHC.Tuple.pair3 getUniqueSupplyM getUniqueSupplyM
  getUniqueSupplyM.

Definition liftUs {m : Type -> Type} {a : Type} `{MonadUnique m}
   : UniqSM a -> m a :=
  fun m =>
    getUniqueSupplyM GHC.Base.>>=
    (GHC.Base.return_ GHC.Base.∘ GHC.Base.flip initUs_ m).

Fixpoint lazyMapUs {a : Type} {b : Type} (arg_0__ : a -> UniqSM b) (arg_1__
                     : list a) : UniqSM (list b)
  := match arg_0__, arg_1__ with
     | _, nil => returnUs nil
     | f, cons x xs =>
         lazyThenUs (f x) (fun r =>
                       lazyThenUs (lazyMapUs f xs) (fun rs => returnUs (cons r rs)))
     end.

(* External variables:
     Type cons list nil op_zt__ pair BinNums.N GHC.Base.Applicative GHC.Base.Functor
     GHC.Base.Monad GHC.Base.const GHC.Base.flip GHC.Base.fmap GHC.Base.fmap__
     GHC.Base.liftA2__ GHC.Base.liftM3 GHC.Base.op_z2218U__ GHC.Base.op_zgzg____
     GHC.Base.op_zgzgze__ GHC.Base.op_zgzgze____ GHC.Base.op_zlzd____
     GHC.Base.op_zlztzg____ GHC.Base.op_ztzg__ GHC.Base.op_ztzg____ GHC.Base.pure
     GHC.Base.pure__ GHC.Base.return_ GHC.Base.return___ GHC.Tuple.pair3
     GHC.Tuple.quad_type GHC.Tuple.triple_type Unique.Unique Unique.mkUniqueGrimily
*)

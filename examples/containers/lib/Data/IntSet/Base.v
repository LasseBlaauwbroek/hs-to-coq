(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Require Coq.Program.Tactics.
Require Coq.Program.Wf.

(* Converted imports: *)

Require Data.Bits.
Require Data.Foldable.
Require GHC.Base.
Require GHC.Num.
Require GHC.Prim.
Require GHC.Real.
Import Data.Bits.Notations.
Import GHC.Base.Notations.
Import GHC.Num.Notations.

(* Converted type declarations: *)

Definition Prefix :=
  GHC.Num.Int%type.

Definition Nat :=
  GHC.Num.Word%type.

Definition Mask :=
  GHC.Num.Int%type.

Definition Key :=
  GHC.Num.Int%type.

Definition BitMap :=
  GHC.Num.Word%type.

Inductive IntSet : Type := Bin : Prefix -> Mask -> IntSet -> IntSet -> IntSet
                        |  Tip : Prefix -> BitMap -> IntSet
                        |  Nil : IntSet.

Inductive Stack : Type := Push : Prefix -> IntSet -> Stack -> Stack
                       |  Nada : Stack.
(* Midamble *)

Require Coq.ZArith.Zcomplements.
Require Import Coq.Numbers.BinNums.

Definition shiftLL (n: Nat) (s : BinInt.Z) : Nat :=
	Coq.NArith.BinNat.N.shiftl n (Coq.ZArith.BinInt.Z.to_N s).
Definition shiftRL (n: Nat) (s : BinInt.Z) : Nat :=
	Coq.NArith.BinNat.N.shiftr n (Coq.ZArith.BinInt.Z.to_N s).

Definition highestBitMask (n: Nat) : Nat := match n with
 | Coq.Numbers.BinNums.N0 => Coq.Numbers.BinNums.N0
 | Coq.Numbers.BinNums.Npos p => Coq.Numbers.BinNums.Npos (Coq.ZArith.Zcomplements.floor_pos p) end.

Require Import NArith.
Definition bit_N := shiftLL 1%N.

Definition popCount_N : N -> GHC.Num.Int := fun x => 0%Z.   (* TODO *)

Instance Bits__N : Data.Bits.Bits N :=  {
  op_zizazi__ := N.land ;
  op_zizbzi__ := N.lor ;
  bit := bit_N;
  bitSizeMaybe := fun _ => None ;
  clearBit := fun n i => N.clearbit n (Coq.ZArith.BinInt.Z.to_N i) ;
  complement := fun _ => 0%N  ; (* Not legally possible with N *)
  complementBit := fun x i => N.lxor x (bit_N i) ;
  isSigned := fun x => true ;
  popCount := popCount_N ;
  rotate := shiftLL;
  rotateL := shiftRL;
  rotateR := shiftRL;
  setBit := fun x i => N.lor x (bit_N i);
  shift := shiftLL;
  shiftL := shiftLL;
  shiftR := shiftRL;
  testBit := fun x i => N.testbit x (Coq.ZArith.BinInt.Z.to_N i);
  unsafeShiftL := shiftRL;
  unsafeShiftR := shiftRL;
  xor := N.lxor;
  zeroBits := 0;
}.


Fixpoint size_nat (t : IntSet) : nat :=
  match t with
  | Bin _ _ l r => S (size_nat l + size_nat r)%nat
  | Tip _ bm => 0
  | Nil => 0
  end.

Require Omega.
Ltac termination_by_omega :=
  Coq.Program.Tactics.program_simpl;
  simpl;Omega.omega.


(* Z.ones 6 = 64-1 *)
Definition suffixBitMask : GHC.Num.Int := (Coq.ZArith.BinInt.Z.ones 6)%Z.


(* Converted value declarations: *)

(* The Haskell code containes partial or untranslateable code, which needs the
   following *)

Axiom unsafeFix : forall {a}, (a -> a) -> a.

(* Skipping instance Monoid__IntSet *)

(* Translating `instance Data.Semigroup.Semigroup Data.IntSet.Base.IntSet'
   failed: OOPS! Cannot find information for class Qualified "Data.Semigroup"
   "Semigroup" unsupported *)

(* Translating `instance Data.Data.Data Data.IntSet.Base.IntSet' failed: OOPS!
   Cannot find information for class Qualified "Data.Data" "Data" unsupported *)

(* Translating `instance GHC.Exts.IsList Data.IntSet.Base.IntSet' failed: OOPS!
   Cannot find information for class Qualified "GHC.Exts" "IsList" unsupported *)

(* Translating `instance GHC.Show.Show Data.IntSet.Base.IntSet' failed: OOPS!
   Cannot find information for class Qualified "GHC.Show" "Show" unsupported *)

(* Translating `instance GHC.Read.Read Data.IntSet.Base.IntSet' failed: OOPS!
   Cannot find information for class Qualified "GHC.Read" "Read" unsupported *)

(* Translating `instance Control.DeepSeq.NFData Data.IntSet.Base.IntSet' failed:
   OOPS! Cannot find information for class Qualified "Control.DeepSeq" "NFData"
   unsupported *)

Axiom indexOfTheOnlyBit : forall {A : Type}, A.

(* Translating `indexOfTheOnlyBit' failed: `Addr#' literals unsupported *)

Definition bin : Prefix -> Mask -> IntSet -> IntSet -> IntSet :=
  fun arg_0__ arg_1__ arg_2__ arg_3__ =>
    match arg_0__ , arg_1__ , arg_2__ , arg_3__ with
      | _ , _ , l , Nil => l
      | _ , _ , Nil , r => r
      | p , m , l , r => Bin p m l r
    end.

Definition bitcount : GHC.Num.Int -> GHC.Num.Word -> GHC.Num.Int :=
  fun a x => a GHC.Num.+ Data.Bits.popCount x.

Definition size : IntSet -> GHC.Num.Int :=
  fix size t
        := match t with
             | Bin _ _ l r => size l GHC.Num.+ size r
             | Tip _ bm => bitcount (GHC.Num.fromInteger 0) bm
             | Nil => GHC.Num.fromInteger 0
           end.

Definition bitmapOfSuffix : GHC.Num.Int -> BitMap :=
  fun s => shiftLL (GHC.Num.fromInteger 1) s.

Definition branchMask : Prefix -> Prefix -> Mask :=
  fun p1 p2 =>
    Coq.ZArith.BinInt.Z.pow 2 (Coq.ZArith.BinInt.Z.log2 (Coq.ZArith.BinInt.Z.lxor p1
                                                                                  p2)).

Definition empty : IntSet :=
  Nil.

Definition equal : IntSet -> IntSet -> bool :=
  fix equal arg_0__ arg_1__
        := match arg_0__ , arg_1__ with
             | Bin p1 m1 l1 r1 , Bin p2 m2 l2 r2 => andb (m1 GHC.Base.== m2) (andb (p1
                                                                                   GHC.Base.== p2) (andb (equal l1 l2)
                                                                                                         (equal r1 r2)))
             | Tip kx1 bm1 , Tip kx2 bm2 => andb (kx1 GHC.Base.== kx2) (bm1 GHC.Base.== bm2)
             | Nil , Nil => true
             | _ , _ => false
           end.

Local Definition Eq___IntSet_op_zeze__ : IntSet -> IntSet -> bool :=
  fun t1 t2 => equal t1 t2.

Definition highestBitSet : Nat -> GHC.Num.Int :=
  fun x => indexOfTheOnlyBit (highestBitMask x).

Definition unsafeFindMax : IntSet -> option Key :=
  fix unsafeFindMax arg_0__
        := match arg_0__ with
             | Nil => None
             | Tip kx bm => Some GHC.Base.$ (kx GHC.Num.+ highestBitSet bm)
             | Bin _ _ _ r => unsafeFindMax r
           end.

Definition lowestBitMask : Nat -> Nat :=
  fun x => x Data.Bits..&.(**) GHC.Num.negate x.

Definition lowestBitSet : Nat -> GHC.Num.Int :=
  fun x => indexOfTheOnlyBit (lowestBitMask x).

Definition unsafeFindMin : IntSet -> option Key :=
  fix unsafeFindMin arg_0__
        := match arg_0__ with
             | Nil => None
             | Tip kx bm => Some GHC.Base.$ (kx GHC.Num.+ lowestBitSet bm)
             | Bin _ _ l _ => unsafeFindMin l
           end.

Definition foldlBits {a}
    : GHC.Num.Int -> (a -> GHC.Num.Int -> a) -> a -> Nat -> a :=
  fun prefix f z bitmap =>
    let go :=
      unsafeFix (fun go bm acc =>
                  let j_6__ :=
                    let scrut_0__ := lowestBitMask bm in
                    match scrut_0__ with
                      | bitmask => GHC.Prim.seq bitmask (let scrut_1__ := indexOfTheOnlyBit bitmask in
                                                match scrut_1__ with
                                                  | bi => GHC.Prim.seq bi (go (Data.Bits.xor bm bitmask) ((f acc)
                                                                                                         GHC.Base.$!
                                                                                                         (prefix
                                                                                                         GHC.Num.+ bi)))
                                                end)
                    end in
                  if bm GHC.Base.== GHC.Num.fromInteger 0 : bool
                  then acc
                  else j_6__) in
    go bitmap z.

Definition foldl {a} : (a -> Key -> a) -> a -> IntSet -> a :=
  fun f z =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | z' , Nil => z'
                 | z' , Tip kx bm => foldlBits kx f z' bm
                 | z' , Bin _ _ l r => go (go z' l) r
               end in
    fun t =>
      let j_6__ := go z t in
      match t with
        | Bin _ m l r => let j_7__ := go (go z l) r in
                         if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                         then go (go z r) l
                         else j_7__
        | _ => j_6__
      end.

Definition foldlFB {a} : (a -> Key -> a) -> a -> IntSet -> a :=
  foldl.

Definition toDescList : IntSet -> list Key :=
  foldl (GHC.Base.flip cons) nil.

Definition foldl'Bits {a}
    : GHC.Num.Int -> (a -> GHC.Num.Int -> a) -> a -> Nat -> a :=
  fun prefix f z bitmap =>
    let go :=
      unsafeFix (fun go arg_0__ arg_1__ =>
                  let j_10__ :=
                    match arg_0__ , arg_1__ with
                      | bm , acc => let j_8__ :=
                                      let scrut_2__ := lowestBitMask bm in
                                      match scrut_2__ with
                                        | bitmask => GHC.Prim.seq bitmask (let scrut_3__ := indexOfTheOnlyBit bitmask in
                                                                  match scrut_3__ with
                                                                    | bi => GHC.Prim.seq bi (go (Data.Bits.xor bm
                                                                                                               bitmask)
                                                                                         ((f acc) GHC.Base.$! (prefix
                                                                                         GHC.Num.+ bi)))
                                                                  end)
                                      end in
                                    if bm GHC.Base.== GHC.Num.fromInteger 0 : bool
                                    then acc
                                    else j_8__
                    end in
                  match arg_0__ , arg_1__ with
                    | _ , arg => j_10__
                  end) in
    go bitmap z.

Definition foldl' {a} : (a -> Key -> a) -> a -> IntSet -> a :=
  fun f z =>
    let go :=
      fix go arg_0__ arg_1__
            := let j_4__ :=
                 match arg_0__ , arg_1__ with
                   | z' , Nil => z'
                   | z' , Tip kx bm => foldl'Bits kx f z' bm
                   | z' , Bin _ _ l r => go (go z' l) r
                 end in
               match arg_0__ , arg_1__ with
                 | arg , _ => j_4__
               end in
    fun t =>
      let j_7__ := go z t in
      match t with
        | Bin _ m l r => let j_8__ := go (go z l) r in
                         if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                         then go (go z r) l
                         else j_8__
        | _ => j_7__
      end.

Definition mask : GHC.Num.Int -> Mask -> Prefix :=
  fun i m =>
    Coq.ZArith.BinInt.Z.land i (Coq.ZArith.BinInt.Z.lxor (Coq.ZArith.BinInt.Z.lnot
                                                         (Coq.ZArith.BinInt.Z.pred m)) m).

Definition match_ : GHC.Num.Int -> Prefix -> Mask -> bool :=
  fun i p m => (mask i m) GHC.Base.== p.

Definition nomatch : GHC.Num.Int -> Prefix -> Mask -> bool :=
  fun i p m => (mask i m) GHC.Base./= p.

Definition maskW : Nat -> Nat -> Prefix :=
  fun i m =>
    Coq.ZArith.BinInt.Z.of_N (i Data.Bits..&.(**) (Data.Bits.xor
                             (Data.Bits.complement (m GHC.Num.- GHC.Num.fromInteger 1)) m)).

Definition natFromInt : GHC.Num.Int -> Nat :=
  fun i => GHC.Real.fromIntegral i.

Definition shorter : Mask -> Mask -> bool :=
  fun m1 m2 => (natFromInt m1) GHC.Base.> (natFromInt m2).

Definition nequal : IntSet -> IntSet -> bool :=
  fix nequal arg_0__ arg_1__
        := match arg_0__ , arg_1__ with
             | Bin p1 m1 l1 r1 , Bin p2 m2 l2 r2 => orb (m1 GHC.Base./= m2) (orb (p1
                                                                                 GHC.Base./= p2) (orb (nequal l1 l2)
                                                                                                      (nequal r1 r2)))
             | Tip kx1 bm1 , Tip kx2 bm2 => orb (kx1 GHC.Base./= kx2) (bm1 GHC.Base./= bm2)
             | Nil , Nil => false
             | _ , _ => true
           end.

Local Definition Eq___IntSet_op_zsze__ : IntSet -> IntSet -> bool :=
  fun t1 t2 => nequal t1 t2.

Program Instance Eq___IntSet : GHC.Base.Eq_ IntSet := fun _ k =>
    k {|GHC.Base.op_zeze____ := Eq___IntSet_op_zeze__ ;
      GHC.Base.op_zsze____ := Eq___IntSet_op_zsze__ |}.

Definition node : GHC.Base.String :=
  GHC.Base.hs_string__ "+--".

Definition null : IntSet -> bool :=
  fun arg_0__ => match arg_0__ with | Nil => true | _ => false end.

Definition prefixBitMask : GHC.Num.Int :=
  Data.Bits.complement suffixBitMask.

Definition prefixOf : GHC.Num.Int -> Prefix :=
  fun x => x Data.Bits..&.(**) prefixBitMask.

Definition revNat : Nat -> Nat :=
  fun x1 =>
    let scrut_0__ :=
      ((shiftRL x1 (GHC.Num.fromInteger 1)) Data.Bits..&.(**) GHC.Num.fromInteger
      6148914691236517205) Data.Bits..|.(**) (shiftLL (x1 Data.Bits..&.(**)
                                                      GHC.Num.fromInteger 6148914691236517205) (GHC.Num.fromInteger
                                                      1)) in
    match scrut_0__ with
      | x2 => let scrut_1__ :=
                ((shiftRL x2 (GHC.Num.fromInteger 2)) Data.Bits..&.(**) GHC.Num.fromInteger
                3689348814741910323) Data.Bits..|.(**) (shiftLL (x2 Data.Bits..&.(**)
                                                                GHC.Num.fromInteger 3689348814741910323)
                                                                (GHC.Num.fromInteger 2)) in
              match scrut_1__ with
                | x3 => let scrut_2__ :=
                          ((shiftRL x3 (GHC.Num.fromInteger 4)) Data.Bits..&.(**) GHC.Num.fromInteger
                          1085102592571150095) Data.Bits..|.(**) (shiftLL (x3 Data.Bits..&.(**)
                                                                          GHC.Num.fromInteger 1085102592571150095)
                                                                          (GHC.Num.fromInteger 4)) in
                        match scrut_2__ with
                          | x4 => let scrut_3__ :=
                                    ((shiftRL x4 (GHC.Num.fromInteger 8)) Data.Bits..&.(**) GHC.Num.fromInteger
                                    71777214294589695) Data.Bits..|.(**) (shiftLL (x4 Data.Bits..&.(**)
                                                                                  GHC.Num.fromInteger 71777214294589695)
                                                                                  (GHC.Num.fromInteger 8)) in
                                  match scrut_3__ with
                                    | x5 => let scrut_4__ :=
                                              ((shiftRL x5 (GHC.Num.fromInteger 16)) Data.Bits..&.(**)
                                              GHC.Num.fromInteger 281470681808895) Data.Bits..|.(**) (shiftLL (x5
                                                                                                              Data.Bits..&.(**)
                                                                                                              GHC.Num.fromInteger
                                                                                                              281470681808895)
                                                                                                              (GHC.Num.fromInteger
                                                                                                              16)) in
                                            match scrut_4__ with
                                              | x6 => (shiftRL x6 (GHC.Num.fromInteger 32)) Data.Bits..|.(**) (shiftLL
                                                      x6 (GHC.Num.fromInteger 32))
                                            end
                                  end
                        end
              end
    end.

Definition foldrBits {a}
    : GHC.Num.Int -> (GHC.Num.Int -> a -> a) -> a -> Nat -> a :=
  fun prefix f z bitmap =>
    let go :=
      unsafeFix (fun go bm acc =>
                  let j_6__ :=
                    let scrut_0__ := lowestBitMask bm in
                    match scrut_0__ with
                      | bitmask => GHC.Prim.seq bitmask (let scrut_1__ := indexOfTheOnlyBit bitmask in
                                                match scrut_1__ with
                                                  | bi => GHC.Prim.seq bi (go (Data.Bits.xor bm bitmask) ((f GHC.Base.$!
                                                                                                         ((prefix
                                                                                                         GHC.Num.+
                                                                                                         (GHC.Num.fromInteger
                                                                                                         64 GHC.Num.-
                                                                                                         GHC.Num.fromInteger
                                                                                                         1)) GHC.Num.-
                                                                                                         bi)) acc))
                                                end)
                    end in
                  if bm GHC.Base.== GHC.Num.fromInteger 0 : bool
                  then acc
                  else j_6__) in
    go (revNat bitmap) z.

Definition foldr {b} : (Key -> b -> b) -> b -> IntSet -> b :=
  fun f z =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | z' , Nil => z'
                 | z' , Tip kx bm => foldrBits kx f z' bm
                 | z' , Bin _ _ l r => go (go z' r) l
               end in
    fun t =>
      let j_6__ := go z t in
      match t with
        | Bin _ m l r => let j_7__ := go (go z r) l in
                         if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                         then go (go z l) r
                         else j_7__
        | _ => j_6__
      end.

Definition foldrFB {b} : (Key -> b -> b) -> b -> IntSet -> b :=
  foldr.

Definition toAscList : IntSet -> list Key :=
  foldr cons nil.

Definition toList : IntSet -> list Key :=
  toAscList.

Definition elems : IntSet -> list Key :=
  toAscList.

Local Definition Ord__IntSet_compare : IntSet -> IntSet -> comparison :=
  fun s1 s2 => GHC.Base.compare (toAscList s1) (toAscList s2).

Local Definition Ord__IntSet_op_zg__ : IntSet -> IntSet -> bool :=
  fun x y => _GHC.Base.==_ (Ord__IntSet_compare x y) Gt.

Local Definition Ord__IntSet_op_zgze__ : IntSet -> IntSet -> bool :=
  fun x y => _GHC.Base./=_ (Ord__IntSet_compare x y) Lt.

Local Definition Ord__IntSet_op_zl__ : IntSet -> IntSet -> bool :=
  fun x y => _GHC.Base.==_ (Ord__IntSet_compare x y) Lt.

Local Definition Ord__IntSet_op_zlze__ : IntSet -> IntSet -> bool :=
  fun x y => _GHC.Base./=_ (Ord__IntSet_compare x y) Gt.

Local Definition Ord__IntSet_max : IntSet -> IntSet -> IntSet :=
  fun x y => if Ord__IntSet_op_zlze__ x y : bool then y else x.

Local Definition Ord__IntSet_min : IntSet -> IntSet -> IntSet :=
  fun x y => if Ord__IntSet_op_zlze__ x y : bool then x else y.

Program Instance Ord__IntSet : GHC.Base.Ord IntSet := fun _ k =>
    k {|GHC.Base.op_zl____ := Ord__IntSet_op_zl__ ;
      GHC.Base.op_zlze____ := Ord__IntSet_op_zlze__ ;
      GHC.Base.op_zg____ := Ord__IntSet_op_zg__ ;
      GHC.Base.op_zgze____ := Ord__IntSet_op_zgze__ ;
      GHC.Base.compare__ := Ord__IntSet_compare ;
      GHC.Base.max__ := Ord__IntSet_max ;
      GHC.Base.min__ := Ord__IntSet_min |}.

Definition fold {b} : (Key -> b -> b) -> b -> IntSet -> b :=
  foldr.

Definition foldr'Bits {a}
    : GHC.Num.Int -> (GHC.Num.Int -> a -> a) -> a -> Nat -> a :=
  fun prefix f z bitmap =>
    let go :=
      unsafeFix (fun go arg_0__ arg_1__ =>
                  let j_10__ :=
                    match arg_0__ , arg_1__ with
                      | bm , acc => let j_8__ :=
                                      let scrut_2__ := lowestBitMask bm in
                                      match scrut_2__ with
                                        | bitmask => GHC.Prim.seq bitmask (let scrut_3__ := indexOfTheOnlyBit bitmask in
                                                                  match scrut_3__ with
                                                                    | bi => GHC.Prim.seq bi (go (Data.Bits.xor bm
                                                                                                               bitmask)
                                                                                         ((f GHC.Base.$! ((prefix
                                                                                         GHC.Num.+ (GHC.Num.fromInteger
                                                                                         64 GHC.Num.-
                                                                                         GHC.Num.fromInteger 1))
                                                                                         GHC.Num.- bi)) acc))
                                                                  end)
                                      end in
                                    if bm GHC.Base.== GHC.Num.fromInteger 0 : bool
                                    then acc
                                    else j_8__
                    end in
                  match arg_0__ , arg_1__ with
                    | _ , arg => j_10__
                  end) in
    go (revNat bitmap) z.

Definition foldr' {b} : (Key -> b -> b) -> b -> IntSet -> b :=
  fun f z =>
    let go :=
      fix go arg_0__ arg_1__
            := let j_4__ :=
                 match arg_0__ , arg_1__ with
                   | z' , Nil => z'
                   | z' , Tip kx bm => foldr'Bits kx f z' bm
                   | z' , Bin _ _ l r => go (go z' r) l
                 end in
               match arg_0__ , arg_1__ with
                 | arg , _ => j_4__
               end in
    fun t =>
      let j_7__ := go z t in
      match t with
        | Bin _ m l r => let j_8__ := go (go z r) l in
                         if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                         then go (go z l) r
                         else j_8__
        | _ => j_7__
      end.

Definition splitRoot : IntSet -> list IntSet :=
  fun orig =>
    match orig with
      | Nil => nil
      | (Tip _ _ as x) => cons x nil
      | Bin _ m l r => let j_1__ := cons l (cons r nil) in
                       if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                       then cons r (cons l nil)
                       else j_1__
    end.

Definition suffixOf : GHC.Num.Int -> GHC.Num.Int :=
  fun x => x Data.Bits..&.(**) suffixBitMask.

Definition bitmapOf : GHC.Num.Int -> BitMap :=
  fun x => bitmapOfSuffix (suffixOf x).

Definition singleton : Key -> IntSet :=
  fun x => Tip (prefixOf x) (bitmapOf x).

Definition tip : Prefix -> BitMap -> IntSet :=
  fun arg_0__ arg_1__ =>
    let j_4__ := match arg_0__ , arg_1__ with | kx , bm => Tip kx bm end in
    match arg_0__ , arg_1__ with
      | _ , num_2__ => if num_2__ GHC.Base.== GHC.Num.fromInteger 0 : bool
                       then Nil
                       else j_4__
    end.

Definition filter : (Key -> bool) -> IntSet -> IntSet :=
  fix filter predicate t
        := let bitPred :=
             fun kx bm bi =>
               if predicate (kx GHC.Num.+ bi) : bool
               then bm Data.Bits..|.(**) bitmapOfSuffix bi
               else bm in
           match t with
             | Bin p m l r => bin p m (filter predicate l) (filter predicate r)
             | Tip kx bm => tip kx (foldl'Bits (GHC.Num.fromInteger 0) (bitPred kx)
                                   (GHC.Num.fromInteger 0) bm)
             | Nil => Nil
           end.

Definition partition : (Key -> bool) -> IntSet -> (IntSet * IntSet)%type :=
  fun predicate0 t0 =>
    let go :=
      fix go predicate t
            := let bitPred :=
                 fun kx bm bi =>
                   if predicate (kx GHC.Num.+ bi) : bool
                   then bm Data.Bits..|.(**) bitmapOfSuffix bi
                   else bm in
               match t with
                 | Bin p m l r => match go predicate r with
                                    | pair r1 r2 => match go predicate l with
                                                      | pair l1 l2 => pair (bin p m l1 r1) (bin p m l2 r2)
                                                    end
                                  end
                 | Tip kx bm => let bm1 :=
                                  foldl'Bits (GHC.Num.fromInteger 0) (bitPred kx) (GHC.Num.fromInteger 0) bm in
                                pair (tip kx bm1) (tip kx (Data.Bits.xor bm bm1))
                 | Nil => (pair Nil Nil)
               end in
    id GHC.Base.$ go predicate0 t0.

Definition zero : GHC.Num.Int -> Mask -> bool :=
  fun i m => Coq.ZArith.BinInt.Z.eqb (Coq.ZArith.BinInt.Z.land i m) 0.

Definition subsetCmp : IntSet -> IntSet -> comparison :=
  fix subsetCmp arg_0__ arg_1__
        := let j_12__ :=
             match arg_0__ , arg_1__ with
               | Bin _ _ _ _ , _ => Gt
               | Tip kx1 bm1 , Tip kx2 bm2 => let j_2__ :=
                                                if (bm1 Data.Bits..&.(**) Data.Bits.complement bm2) GHC.Base.==
                                                   GHC.Num.fromInteger 0 : bool
                                                then Lt
                                                else Gt in
                                              let j_3__ := if bm1 GHC.Base.== bm2 : bool then Eq else j_2__ in
                                              if kx1 GHC.Base./= kx2 : bool
                                              then Gt
                                              else j_3__
               | (Tip kx _ as t1) , Bin p m l r => let j_7__ :=
                                                     let scrut_5__ := subsetCmp t1 r in
                                                     match scrut_5__ with
                                                       | Gt => Gt
                                                       | _ => Lt
                                                     end in
                                                   let j_10__ :=
                                                     if zero kx m : bool
                                                     then let scrut_8__ := subsetCmp t1 l in
                                                          match scrut_8__ with
                                                            | Gt => Gt
                                                            | _ => Lt
                                                          end
                                                     else j_7__ in
                                                   if nomatch kx p m : bool
                                                   then Gt
                                                   else j_10__
               | Tip _ _ , Nil => Gt
               | Nil , Nil => Eq
               | Nil , _ => Lt
             end in
           match arg_0__ , arg_1__ with
             | (Bin p1 m1 l1 r1 as t1) , Bin p2 m2 l2 r2 => let subsetCmpEq :=
                                                              let scrut_13__ :=
                                                                pair (subsetCmp l1 l2) (subsetCmp r1 r2) in
                                                              match scrut_13__ with
                                                                | pair Gt _ => Gt
                                                                | pair _ Gt => Gt
                                                                | pair Eq Eq => Eq
                                                                | _ => Lt
                                                              end in
                                                            let subsetCmpLt :=
                                                              let j_16__ := subsetCmp t1 r2 in
                                                              let j_17__ :=
                                                                if zero p1 m2 : bool
                                                                then subsetCmp t1 l2
                                                                else j_16__ in
                                                              if nomatch p1 p2 m2 : bool
                                                              then Gt
                                                              else j_17__ in
                                                            let j_19__ :=
                                                              if p1 GHC.Base.== p2 : bool
                                                              then subsetCmpEq
                                                              else Gt in
                                                            let j_21__ :=
                                                              if shorter m2 m1 : bool
                                                              then match subsetCmpLt with
                                                                     | Gt => Gt
                                                                     | _ => Lt
                                                                   end
                                                              else j_19__ in
                                                            if shorter m1 m2 : bool
                                                            then Gt
                                                            else j_21__
             | _ , _ => j_12__
           end.

Definition isProperSubsetOf : IntSet -> IntSet -> bool :=
  fun t1 t2 =>
    let scrut_0__ := subsetCmp t1 t2 in
    match scrut_0__ with
      | Lt => true
      | _ => false
    end.

Definition isSubsetOf : IntSet -> IntSet -> bool :=
  fix isSubsetOf arg_0__ arg_1__
        := let j_6__ :=
             match arg_0__ , arg_1__ with
               | Bin _ _ _ _ , _ => false
               | Tip kx1 bm1 , Tip kx2 bm2 => andb (kx1 GHC.Base.== kx2) ((bm1
                                                   Data.Bits..&.(**) Data.Bits.complement bm2) GHC.Base.==
                                                   GHC.Num.fromInteger 0)
               | (Tip kx _ as t1) , Bin p m l r => let j_3__ := isSubsetOf t1 r in
                                                   let j_4__ := if zero kx m : bool then isSubsetOf t1 l else j_3__ in
                                                   if nomatch kx p m : bool
                                                   then false
                                                   else j_4__
               | Tip _ _ , Nil => false
               | Nil , _ => true
             end in
           match arg_0__ , arg_1__ with
             | (Bin p1 m1 l1 r1 as t1) , Bin p2 m2 l2 r2 => let j_7__ :=
                                                              andb (p1 GHC.Base.== p2) (andb (isSubsetOf l1 l2)
                                                                                             (isSubsetOf r1 r2)) in
                                                            let j_8__ :=
                                                              if shorter m2 m1 : bool
                                                              then andb (match_ p1 p2 m2) (if zero p1 m2 : bool
                                                                        then isSubsetOf t1 l2
                                                                        else isSubsetOf t1 r2)
                                                              else j_7__ in
                                                            if shorter m1 m2 : bool
                                                            then false
                                                            else j_8__
             | _ , _ => j_6__
           end.

Definition link : Prefix -> IntSet -> Prefix -> IntSet -> IntSet :=
  fun p1 t1 p2 t2 =>
    let m := branchMask p1 p2 in
    let p := mask p1 m in
    let j_2__ := Bin p m t2 t1 in if zero p1 m : bool then Bin p m t1 t2 else j_2__.

Definition insertBM : Prefix -> BitMap -> IntSet -> IntSet :=
  fix insertBM kx bm t
        := GHC.Prim.seq kx (GHC.Prim.seq bm (match t with
                                           | Bin p m l r => let j_0__ := Bin p m l (insertBM kx bm r) in
                                                            let j_1__ :=
                                                              if zero kx m : bool
                                                              then Bin p m (insertBM kx bm l) r
                                                              else j_0__ in
                                                            if nomatch kx p m : bool
                                                            then link kx (Tip kx bm) p t
                                                            else j_1__
                                           | Tip kx' bm' => let j_3__ := link kx (Tip kx bm) kx' t in
                                                            if kx' GHC.Base.== kx : bool
                                                            then Tip kx' (bm Data.Bits..|.(**) bm')
                                                            else j_3__
                                           | Nil => Tip kx bm
                                         end)).

Definition insert : Key -> IntSet -> IntSet :=
  fun x => GHC.Prim.seq x (insertBM (prefixOf x) (bitmapOf x)).

Definition fromList : list Key -> IntSet :=
  fun xs => let ins := fun t x => insert x t in Data.Foldable.foldl ins empty xs.

Definition map : (Key -> Key) -> IntSet -> IntSet :=
  fun f => fromList GHC.Base.∘ (GHC.Base.map f GHC.Base.∘ toList).

Program Fixpoint union (arg_0__ : IntSet) (arg_1__ : IntSet) { measure (size_nat
  arg_0__ + size_nat arg_1__) } : IntSet :=
match arg_0__ , arg_1__ with
  | (Bin p1 m1 l1 r1 as t1) , (Bin p2 m2 l2 r2 as t2) => let union2 :=
                                                           let j_2__ := Bin p2 m2 l2 (union t1 r2) in
                                                           let j_3__ :=
                                                             if zero p1 m2 : bool
                                                             then Bin p2 m2 (union t1 l2) r2
                                                             else j_2__ in
                                                           if nomatch p1 p2 m2 : bool
                                                           then link p1 t1 p2 t2
                                                           else j_3__ in
                                                         let union1 :=
                                                           let j_5__ := Bin p1 m1 l1 (union r1 t2) in
                                                           let j_6__ :=
                                                             if zero p2 m1 : bool
                                                             then Bin p1 m1 (union l1 t2) r1
                                                             else j_5__ in
                                                           if nomatch p2 p1 m1 : bool
                                                           then link p1 t1 p2 t2
                                                           else j_6__ in
                                                         let j_8__ := link p1 t1 p2 t2 in
                                                         let j_9__ :=
                                                           if p1 GHC.Base.== p2 : bool
                                                           then Bin p1 m1 (union l1 l2) (union r1 r2)
                                                           else j_8__ in
                                                         let j_10__ := if shorter m2 m1 : bool then union2 else j_9__ in
                                                         if shorter m1 m2 : bool
                                                         then union1
                                                         else j_10__
  | (Bin _ _ _ _ as t) , Tip kx bm => insertBM kx bm t
  | (Bin _ _ _ _ as t) , Nil => t
  | Tip kx bm , t => insertBM kx bm t
  | Nil , t => t
end.
Solve Obligations with (termination_by_omega).

Definition unions : list IntSet -> IntSet :=
  fun xs => Data.Foldable.foldl union empty xs.

Definition lookupGE : Key -> IntSet -> option Key :=
  fun x t =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | def , Bin p m l r => let j_2__ := go def r in
                                        let j_3__ := if zero x m : bool then go r l else j_2__ in
                                        if nomatch x p m : bool
                                        then if x GHC.Base.< p : bool
                                             then unsafeFindMin l
                                             else unsafeFindMin def
                                        else j_3__
                 | def , Tip kx bm => let maskGE :=
                                        (GHC.Num.negate (bitmapOf x)) Data.Bits..&.(**) bm in
                                      let j_6__ := unsafeFindMin def in
                                      let j_7__ :=
                                        if andb (prefixOf x GHC.Base.== kx) (maskGE GHC.Base./= GHC.Num.fromInteger
                                                0) : bool
                                        then Some GHC.Base.$ (kx GHC.Num.+ lowestBitSet maskGE)
                                        else j_6__ in
                                      if prefixOf x GHC.Base.< kx : bool
                                      then Some GHC.Base.$ (kx GHC.Num.+ lowestBitSet bm)
                                      else j_7__
                 | def , Nil => unsafeFindMin def
               end in
    GHC.Prim.seq x (let j_12__ := go Nil t in
                 match t with
                   | Bin _ m l r => if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                                    then if x GHC.Base.>= GHC.Num.fromInteger 0 : bool
                                         then go Nil l
                                         else go l r
                                    else j_12__
                   | _ => j_12__
                 end).

Definition lookupGT : Key -> IntSet -> option Key :=
  fun x t =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | def , Bin p m l r => let j_2__ := go def r in
                                        let j_3__ := if zero x m : bool then go r l else j_2__ in
                                        if nomatch x p m : bool
                                        then if x GHC.Base.< p : bool
                                             then unsafeFindMin l
                                             else unsafeFindMin def
                                        else j_3__
                 | def , Tip kx bm => let maskGT :=
                                        (GHC.Num.negate (shiftLL (bitmapOf x) (GHC.Num.fromInteger 1)))
                                        Data.Bits..&.(**) bm in
                                      let j_6__ := unsafeFindMin def in
                                      let j_7__ :=
                                        if andb (prefixOf x GHC.Base.== kx) (maskGT GHC.Base./= GHC.Num.fromInteger
                                                0) : bool
                                        then Some GHC.Base.$ (kx GHC.Num.+ lowestBitSet maskGT)
                                        else j_6__ in
                                      if prefixOf x GHC.Base.< kx : bool
                                      then Some GHC.Base.$ (kx GHC.Num.+ lowestBitSet bm)
                                      else j_7__
                 | def , Nil => unsafeFindMin def
               end in
    GHC.Prim.seq x (let j_12__ := go Nil t in
                 match t with
                   | Bin _ m l r => if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                                    then if x GHC.Base.>= GHC.Num.fromInteger 0 : bool
                                         then go Nil l
                                         else go l r
                                    else j_12__
                   | _ => j_12__
                 end).

Definition lookupLE : Key -> IntSet -> option Key :=
  fun x t =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | def , Bin p m l r => let j_2__ := go l r in
                                        let j_3__ := if zero x m : bool then go def l else j_2__ in
                                        if nomatch x p m : bool
                                        then if x GHC.Base.< p : bool
                                             then unsafeFindMax def
                                             else unsafeFindMax r
                                        else j_3__
                 | def , Tip kx bm => let maskLE :=
                                        ((shiftLL (bitmapOf x) (GHC.Num.fromInteger 1)) GHC.Num.- GHC.Num.fromInteger 1)
                                        Data.Bits..&.(**) bm in
                                      let j_6__ := unsafeFindMax def in
                                      let j_7__ :=
                                        if andb (prefixOf x GHC.Base.== kx) (maskLE GHC.Base./= GHC.Num.fromInteger
                                                0) : bool
                                        then Some GHC.Base.$ (kx GHC.Num.+ highestBitSet maskLE)
                                        else j_6__ in
                                      if prefixOf x GHC.Base.> kx : bool
                                      then Some GHC.Base.$ (kx GHC.Num.+ highestBitSet bm)
                                      else j_7__
                 | def , Nil => unsafeFindMax def
               end in
    GHC.Prim.seq x (let j_12__ := go Nil t in
                 match t with
                   | Bin _ m l r => if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                                    then if x GHC.Base.>= GHC.Num.fromInteger 0 : bool
                                         then go r l
                                         else go Nil r
                                    else j_12__
                   | _ => j_12__
                 end).

Definition lookupLT : Key -> IntSet -> option Key :=
  fun x t =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | def , Bin p m l r => let j_2__ := go l r in
                                        let j_3__ := if zero x m : bool then go def l else j_2__ in
                                        if nomatch x p m : bool
                                        then if x GHC.Base.< p : bool
                                             then unsafeFindMax def
                                             else unsafeFindMax r
                                        else j_3__
                 | def , Tip kx bm => let maskLT :=
                                        (bitmapOf x GHC.Num.- GHC.Num.fromInteger 1) Data.Bits..&.(**) bm in
                                      let j_6__ := unsafeFindMax def in
                                      let j_7__ :=
                                        if andb (prefixOf x GHC.Base.== kx) (maskLT GHC.Base./= GHC.Num.fromInteger
                                                0) : bool
                                        then Some GHC.Base.$ (kx GHC.Num.+ highestBitSet maskLT)
                                        else j_6__ in
                                      if prefixOf x GHC.Base.> kx : bool
                                      then Some GHC.Base.$ (kx GHC.Num.+ highestBitSet bm)
                                      else j_7__
                 | def , Nil => unsafeFindMax def
               end in
    GHC.Prim.seq x (let j_12__ := go Nil t in
                 match t with
                   | Bin _ m l r => if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                                    then if x GHC.Base.>= GHC.Num.fromInteger 0 : bool
                                         then go r l
                                         else go Nil r
                                    else j_12__
                   | _ => j_12__
                 end).

Definition member : Key -> IntSet -> bool :=
  fun x =>
    let go :=
      fix go arg_0__
            := match arg_0__ with
                 | Bin p m l r => let j_1__ := go r in
                                  let j_2__ := if zero x m : bool then go l else j_1__ in
                                  if nomatch x p m : bool
                                  then false
                                  else j_2__
                 | Tip y bm => andb (prefixOf x GHC.Base.== y) ((bitmapOf x Data.Bits..&.(**) bm)
                                    GHC.Base./= GHC.Num.fromInteger 0)
                 | Nil => false
               end in
    GHC.Prim.seq x go.

Definition notMember : Key -> IntSet -> bool :=
  fun k => negb GHC.Base.∘ member k.

Definition split : Key -> IntSet -> (IntSet * IntSet)%type :=
  fun x t =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | x' , (Bin p m l r as t') => let j_2__ :=
                                                 if x' GHC.Base.< p : bool
                                                 then (pair Nil t')
                                                 else (pair t' Nil) in
                                               if match_ x' p m : bool
                                               then if zero x' m : bool
                                                    then let scrut_3__ := go x' l in
                                                         match scrut_3__ with
                                                           | pair lt gt => pair lt (union gt r)
                                                         end
                                                    else let scrut_6__ := go x' r in
                                                         match scrut_6__ with
                                                           | pair lt gt => pair (union lt l) gt
                                                         end
                                               else j_2__
                 | x' , (Tip kx' bm as t') => let lowerBitmap :=
                                                bitmapOf x' GHC.Num.- GHC.Num.fromInteger 1 in
                                              let higherBitmap :=
                                                Data.Bits.complement (lowerBitmap GHC.Num.+ bitmapOf x') in
                                              let j_12__ :=
                                                pair (tip kx' (bm Data.Bits..&.(**) lowerBitmap)) (tip kx' (bm
                                                                                                           Data.Bits..&.(**)
                                                                                                           higherBitmap)) in
                                              let j_13__ :=
                                                if kx' GHC.Base.< prefixOf x' : bool
                                                then (pair t' Nil)
                                                else j_12__ in
                                              if kx' GHC.Base.> x' : bool
                                              then (pair Nil t')
                                              else j_13__
                 | _ , Nil => (pair Nil Nil)
               end in
    let j_21__ :=
      let scrut_17__ := go x t in
      match scrut_17__ with
        | pair lt gt => pair lt gt
      end in
    match t with
      | Bin _ m l r => if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                       then if x GHC.Base.>= GHC.Num.fromInteger 0 : bool
                            then let scrut_22__ := go x l in
                                 match scrut_22__ with
                                   | pair lt gt => let lt' := union lt r in GHC.Prim.seq lt' (pair lt' gt)
                                 end
                            else let scrut_26__ := go x r in
                                 match scrut_26__ with
                                   | pair lt gt => let gt' := union gt l in GHC.Prim.seq gt' (pair lt gt')
                                 end
                       else j_21__
      | _ => j_21__
    end.

Definition splitMember : Key -> IntSet -> (IntSet * bool * IntSet)%type :=
  fun x t =>
    let go :=
      fix go arg_0__ arg_1__
            := match arg_0__ , arg_1__ with
                 | x' , (Bin p m l r as t') => let j_2__ :=
                                                 if x' GHC.Base.< p : bool
                                                 then pair (pair Nil false) t'
                                                 else pair (pair t' false) Nil in
                                               if match_ x' p m : bool
                                               then if zero x' m : bool
                                                    then let scrut_3__ := go x' l in
                                                         match scrut_3__ with
                                                           | pair (pair lt fnd) gt => pair (pair lt fnd) (union gt r)
                                                         end
                                                    else let scrut_6__ := go x' r in
                                                         match scrut_6__ with
                                                           | pair (pair lt fnd) gt => pair (pair (union lt l) fnd) gt
                                                         end
                                               else j_2__
                 | x' , (Tip kx' bm as t') => let bitmapOfx' := bitmapOf x' in
                                              let lowerBitmap := bitmapOfx' GHC.Num.- GHC.Num.fromInteger 1 in
                                              let higherBitmap :=
                                                Data.Bits.complement (lowerBitmap GHC.Num.+ bitmapOfx') in
                                              let j_16__ :=
                                                let gt := tip kx' (bm Data.Bits..&.(**) higherBitmap) in
                                                let found :=
                                                  (bm Data.Bits..&.(**) bitmapOfx') GHC.Base./= GHC.Num.fromInteger 0 in
                                                let lt := tip kx' (bm Data.Bits..&.(**) lowerBitmap) in
                                                GHC.Prim.seq lt (GHC.Prim.seq found (GHC.Prim.seq gt (pair (pair lt
                                                                                                                 found)
                                                                                                           gt))) in
                                              let j_17__ :=
                                                if kx' GHC.Base.< prefixOf x' : bool
                                                then pair (pair t' false) Nil
                                                else j_16__ in
                                              if kx' GHC.Base.> x' : bool
                                              then pair (pair Nil false) t'
                                              else j_17__
                 | _ , Nil => pair (pair Nil false) Nil
               end in
    let j_22__ := go x t in
    match t with
      | Bin _ m l r => if m GHC.Base.< GHC.Num.fromInteger 0 : bool
                       then if x GHC.Base.>= GHC.Num.fromInteger 0 : bool
                            then let scrut_23__ := go x l in
                                 match scrut_23__ with
                                   | pair (pair lt fnd) gt => let lt' := union lt r in
                                                              GHC.Prim.seq lt' (pair (pair lt' fnd) gt)
                                 end
                            else let scrut_27__ := go x r in
                                 match scrut_27__ with
                                   | pair (pair lt fnd) gt => let gt' := union gt l in
                                                              GHC.Prim.seq gt' (pair (pair lt fnd) gt')
                                 end
                       else j_22__
      | _ => j_22__
    end.

Definition deleteBM : Prefix -> BitMap -> IntSet -> IntSet :=
  fix deleteBM kx bm t
        := GHC.Prim.seq kx (GHC.Prim.seq bm (match t with
                                           | Bin p m l r => let j_0__ := bin p m l (deleteBM kx bm r) in
                                                            let j_1__ :=
                                                              if zero kx m : bool
                                                              then bin p m (deleteBM kx bm l) r
                                                              else j_0__ in
                                                            if nomatch kx p m : bool
                                                            then t
                                                            else j_1__
                                           | Tip kx' bm' => if kx' GHC.Base.== kx : bool
                                                            then tip kx (bm' Data.Bits..&.(**) Data.Bits.complement bm)
                                                            else t
                                           | Nil => Nil
                                         end)).

Definition delete : Key -> IntSet -> IntSet :=
  fun x => GHC.Prim.seq x (deleteBM (prefixOf x) (bitmapOf x)).

Program Fixpoint difference (arg_0__ : IntSet) (arg_1__
                              : IntSet) { measure (size_nat arg_0__ + size_nat arg_1__) } : IntSet :=
match arg_0__ , arg_1__ with
  | (Bin p1 m1 l1 r1 as t1) , (Bin p2 m2 l2 r2 as t2) => let difference2 :=
                                                           let j_2__ := difference t1 r2 in
                                                           let j_3__ :=
                                                             if zero p1 m2 : bool
                                                             then difference t1 l2
                                                             else j_2__ in
                                                           if nomatch p1 p2 m2 : bool
                                                           then t1
                                                           else j_3__ in
                                                         let difference1 :=
                                                           let j_5__ := bin p1 m1 l1 (difference r1 t2) in
                                                           let j_6__ :=
                                                             if zero p2 m1 : bool
                                                             then bin p1 m1 (difference l1 t2) r1
                                                             else j_5__ in
                                                           if nomatch p2 p1 m1 : bool
                                                           then t1
                                                           else j_6__ in
                                                         let j_8__ :=
                                                           if p1 GHC.Base.== p2 : bool
                                                           then bin p1 m1 (difference l1 l2) (difference r1 r2)
                                                           else t1 in
                                                         let j_9__ :=
                                                           if shorter m2 m1 : bool
                                                           then difference2
                                                           else j_8__ in
                                                         if shorter m1 m2 : bool
                                                         then difference1
                                                         else j_9__
  | (Bin _ _ _ _ as t) , Tip kx bm => deleteBM kx bm t
  | (Bin _ _ _ _ as t) , Nil => t
  | (Tip kx bm as t1) , t2 => let differenceTip :=
                                fix differenceTip arg_12__
                                      := match arg_12__ with
                                           | Bin p2 m2 l2 r2 => let j_13__ := differenceTip r2 in
                                                                let j_14__ :=
                                                                  if zero kx m2 : bool
                                                                  then differenceTip l2
                                                                  else j_13__ in
                                                                if nomatch kx p2 m2 : bool
                                                                then t1
                                                                else j_14__
                                           | Tip kx2 bm2 => if kx GHC.Base.== kx2 : bool
                                                            then tip kx (bm Data.Bits..&.(**) Data.Bits.complement bm2)
                                                            else t1
                                           | Nil => t1
                                         end in
                              differenceTip t2
  | Nil , _ => Nil
end.
Solve Obligations with (termination_by_omega).

Definition op_zrzr__ : IntSet -> IntSet -> IntSet :=
  fun m1 m2 => difference m1 m2.

Notation "'_\\_'" := (op_zrzr__).

Infix "\\" := (_\\_) (at level 99).

Program Fixpoint intersection (arg_0__ : IntSet) (arg_1__
                                : IntSet) { measure (size_nat arg_0__ + size_nat arg_1__) } : IntSet :=
match arg_0__ , arg_1__ with
  | (Bin p1 m1 l1 r1 as t1) , (Bin p2 m2 l2 r2 as t2) => let intersection2 :=
                                                           let j_2__ := intersection t1 r2 in
                                                           let j_3__ :=
                                                             if zero p1 m2 : bool
                                                             then intersection t1 l2
                                                             else j_2__ in
                                                           if nomatch p1 p2 m2 : bool
                                                           then Nil
                                                           else j_3__ in
                                                         let intersection1 :=
                                                           let j_5__ := intersection r1 t2 in
                                                           let j_6__ :=
                                                             if zero p2 m1 : bool
                                                             then intersection l1 t2
                                                             else j_5__ in
                                                           if nomatch p2 p1 m1 : bool
                                                           then Nil
                                                           else j_6__ in
                                                         let j_8__ :=
                                                           if p1 GHC.Base.== p2 : bool
                                                           then bin p1 m1 (intersection l1 l2) (intersection r1 r2)
                                                           else Nil in
                                                         let j_9__ :=
                                                           if shorter m2 m1 : bool
                                                           then intersection2
                                                           else j_8__ in
                                                         if shorter m1 m2 : bool
                                                         then intersection1
                                                         else j_9__
  | (Bin _ _ _ _ as t1) , Tip kx2 bm2 => let intersectBM :=
                                           fix intersectBM arg_11__
                                                 := match arg_11__ with
                                                      | Bin p1 m1 l1 r1 => let j_12__ := intersectBM r1 in
                                                                           let j_13__ :=
                                                                             if zero kx2 m1 : bool
                                                                             then intersectBM l1
                                                                             else j_12__ in
                                                                           if nomatch kx2 p1 m1 : bool
                                                                           then Nil
                                                                           else j_13__
                                                      | Tip kx1 bm1 => if kx1 GHC.Base.== kx2 : bool
                                                                       then tip kx1 (bm1 Data.Bits..&.(**) bm2)
                                                                       else Nil
                                                      | Nil => Nil
                                                    end in
                                         intersectBM t1
  | Bin _ _ _ _ , Nil => Nil
  | Tip kx1 bm1 , t2 => let intersectBM :=
                          fix intersectBM arg_18__
                                := match arg_18__ with
                                     | Bin p2 m2 l2 r2 => let j_19__ := intersectBM r2 in
                                                          let j_20__ :=
                                                            if zero kx1 m2 : bool
                                                            then intersectBM l2
                                                            else j_19__ in
                                                          if nomatch kx1 p2 m2 : bool
                                                          then Nil
                                                          else j_20__
                                     | Tip kx2 bm2 => if kx1 GHC.Base.== kx2 : bool
                                                      then tip kx1 (bm1 Data.Bits..&.(**) bm2)
                                                      else Nil
                                     | Nil => Nil
                                   end in
                        intersectBM t2
  | Nil , _ => Nil
end.
Solve Obligations with (termination_by_omega).

Module Notations.
Notation "'_Data.IntSet.Base.\\_'" := (op_zrzr__).
Infix "Data.IntSet.Base.\\" := (_\\_) (at level 99).
End Notations.

(* Unbound variables:
     Eq Gt Lt None Some andb bool comparison cons false highestBitMask id list negb
     nil op_zp__ op_zt__ option orb pair shiftLL shiftRL size_nat suffixBitMask true
     Coq.ZArith.BinInt.Z.eqb Coq.ZArith.BinInt.Z.land Coq.ZArith.BinInt.Z.lnot
     Coq.ZArith.BinInt.Z.log2 Coq.ZArith.BinInt.Z.lxor Coq.ZArith.BinInt.Z.of_N
     Coq.ZArith.BinInt.Z.pow Coq.ZArith.BinInt.Z.pred Data.Bits.complement
     Data.Bits.op_zizazi__ Data.Bits.op_zizbzi__ Data.Bits.popCount Data.Bits.xor
     Data.Foldable.foldl GHC.Base.Eq_ GHC.Base.Ord GHC.Base.String GHC.Base.compare
     GHC.Base.flip GHC.Base.map GHC.Base.op_z2218U__ GHC.Base.op_zd__
     GHC.Base.op_zdzn__ GHC.Base.op_zeze__ GHC.Base.op_zg__ GHC.Base.op_zgze__
     GHC.Base.op_zl__ GHC.Base.op_zsze__ GHC.Num.Int GHC.Num.Word GHC.Num.negate
     GHC.Num.op_zm__ GHC.Num.op_zp__ GHC.Prim.seq GHC.Real.fromIntegral
*)

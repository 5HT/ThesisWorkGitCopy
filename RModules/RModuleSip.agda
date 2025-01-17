{-# OPTIONS --cubical #-}

module ThesisWork.RModules.RModuleSip where

open import Cubical.Foundations.Prelude
open import ThesisWork.HelpFunctions
--open import Cubical.HITs.PropositionalTruncation
open import Cubical.Algebra.Module.Base
--open import Cubical.Algebra.Ring
open import Cubical.Foundations.Structure
open import ThesisWork.RModules.CommutativeRing
--open import Cubical.Foundations.Isomorphism
--open import Cubical.Foundations.Equiv
open import ThesisWork.SetSigmaType
open import Cubical.Data.Sigma.Base

open import Cubical.Algebra.AbGroup

open import Cubical.Foundations.SIP
open import Cubical.Structures.Axioms
open import Cubical.Structures.Auto
open import Cubical.Structures.Macro

module ModuleΣTheory {ℓ : Level} (R : CommutativeRing {ℓ}) where
  RawRModuleStructure = λ (M : Type ℓ) → (M → M → M) × (⟨ R ⟩ → M → M)

  RawRModuleEquivStr = AutoEquivStr RawRModuleStructure

  RawRModuleUnivalentStr : UnivalentStr _ RawRModuleEquivStr
  RawRModuleUnivalentStr = autoUnivalentStr RawRModuleStructure

  RModuleAxioms : (M : Type ℓ) (s : RawRModuleStructure M) → Type ℓ
  RModuleAxioms M (_+_ , _·_) = LeftModuleΣTheory.LeftModuleAxioms (CommutativeRing→Ring R) M (_+_ , _·_)

  RModuleStructure : Type ℓ → Type ℓ
  RModuleStructure = AxiomsStructure RawRModuleStructure RModuleAxioms

  RModuleΣ : Type (ℓ-suc ℓ)
  RModuleΣ = TypeWithStr ℓ RModuleStructure

  RModuleEquivStr : StrEquiv RModuleStructure ℓ
  RModuleEquivStr = AxiomsEquivStr RawRModuleEquivStr RModuleAxioms



  isSetRModuleΣ : (M : RModuleΣ)  → isSet (typ M)
  isSetRModuleΣ (M , snd) = LeftModuleΣTheory.isSetLeftModuleΣ (CommutativeRing→Ring R) (M , snd)

  isPropRModuleAxioms : (M : Type ℓ) (s : RawRModuleStructure M) → isProp (RModuleAxioms M s)
  isPropRModuleAxioms M (_+_ , _·_) = LeftModuleΣTheory.isPropLeftModuleAxioms (CommutativeRing→Ring R) M (_+_ , _·_)


  RModuleUnivalentStr : UnivalentStr RModuleStructure RModuleEquivStr
  RModuleUnivalentStr = axiomsUnivalentStr _ isPropRModuleAxioms RawRModuleUnivalentStr

  isSetRModuleStructure : (M : RModuleΣ) → isSet (RModuleStructure (typ M))
  isSetRModuleStructure M = isSetΣ
                            (isSetΣ (λ N K → liftFunExt λ Nx Kx → liftFunExt (isSetRModuleΣ M)) λ _ → λ N K → liftFunExt (λ Nr Kr → liftFunExt (isSetRModuleΣ M)))
                            (λ s → isProp→isSet (isPropRModuleAxioms (typ M) s))

  RModuleStructurePathP : {M N : RModuleΣ} → (p : typ M ≡ typ N) → (q : PathP (λ i → RawRModuleStructure (p i)) (fst (snd M)) (fst (snd N))) → PathP (λ i → RModuleAxioms (p i) (q i)) (snd (snd M)) (snd (snd N))
  RModuleStructurePathP {M} {N} p q = isProp→PathP (λ i → isPropRModuleAxioms (p i) (q i)) (snd (snd M)) (snd (snd N))

  isSetΣEq : (M : RModuleΣ) → isContr (Σ RModuleΣ (λ N → M ≡ N))
  isSetΣEq M = (M , refl) , (λ y → Σ≡ (snd y) {!!})

  isSetRModuleΣLift : isSet RModuleΣ
  isSetRModuleΣLift M N p q = ?
  
--                              {!!} {!!} {!!} {!!}

--  isSetRModuleΣLift : isSet RModuleΣ
--  isSetRModuleΣLift M N p q i = Σ≡ {!!} {!!}

{-# OPTIONS --cubical #-}

module ThesisWork.RProj.RProj where

open import Cubical.Foundations.Prelude
open import ThesisWork.RModules.CommutativeRing
open import ThesisWork.RModules.RModule
open import ThesisWork.RModules.RModuleHomomorphism
open import Cubical.Foundations.Structure
open import ThesisWork.RProj.ProjModule
open import ThesisWork.RProj.ProjModuleHomo
open import ThesisWork.CompatibilityCode
open import ThesisWork.UnivalentFormulations
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import ThesisWork.RModules.RMod
open import Cubical.Foundations.Univalence
open import Cubical.Data.Sigma.Properties
open import Cubical.Foundations.HLevels
open import ThesisWork.RProj.FinitelyGeneratedModule
open import ThesisWork.RProj.Projective
open import Cubical.Data.Sigma.Base
open import Cubical.Foundations.Path
open import ThesisWork.BasicCategoryTheory.ExtendedCategoryDefinitions

RProjPreCat : {ℓ : Level} → (R : CommutativeRing {ℓ}) → Precategory (ℓ-suc ℓ) ℓ
RProjPreCat R = record {ob = ProjModule R ;
                        hom = ProjectiveModuleHomomorphism R ;
                        idn = λ x → ProjModuleHomoId ;
                        seq = ProjModuleHomoComp ;
                        seq-λ = ProjModuleHomoIdLeftComp ;
                        seq-ρ = ProjModuleHomoIdRightComp ;
                        seq-α = λ f g h → sym (ProjModuleHomoCompAsso f g h)}

RProjIsCategory : {ℓ : Level} → (R : CommutativeRing {ℓ}) → isCategory (RProjPreCat R)
RProjIsCategory R = record {homIsSet = λ {M} {N} → isSetProjModuleHomo}

cong4 : {ℓ : Level} → {A : Type ℓ} → {B : A → Type ℓ} → {C : (a : A) → B a → Type ℓ} → {D : (a : A) → (ba : B a) → C a ba → Type ℓ} → {E : (a : A) → (ba : B a) → (ca : C a ba) → D a ba ca → Type ℓ}
        {x y : A} → {Bx : B x} → {By : B y} → {Cx : C x Bx} → {Cy : C y By} → {Dx : D x Bx Cx} → {Dy : D y By Cy} → 
        (f : (a : A) → (ba : B a) → (ca : C a ba) → (da : D a ba ca) → E a ba ca da) → (p : x ≡ y) → (q : PathP (λ i → B (p i)) Bx By) →
        (r : PathP (λ i → C (p i) (q i)) Cx Cy) → (s : PathP (λ i → D (p i) (q i) (r i)) Dx Dy) → PathP (λ i → E (p i) (q i) (r i) (s i)) (f x Bx Cx Dx) (f y By Cy Dy)
cong4 f p q r s i = f (p i) (q i) (r i) (s i)

CatIso≡ : {ℓ ℓ' : Level} → {C : Precategory ℓ ℓ'} → (isCategory C) → {x y : Precategory.ob C} → {u v : CatIso {C = C} x y} → CatIso.h u ≡ CatIso.h v → CatIso.h⁻¹ u ≡ CatIso.h⁻¹ v → u ≡ v
CatIso≡ isCat hu=hv hInvu=hInvv = cong4 catiso hu=hv hInvu=hInvv (toPathP (homIsSet isCat _ _ _ _)) (toPathP (homIsSet isCat _ _ _ _))

CatIsoIso : {ℓ : Level} → {R : CommutativeRing {ℓ}} → {x y : Precategory.ob (RProjPreCat R)} → Iso (CatIso {C = RProjPreCat R} x y) (CatIso {C = RModPreCat R} (ProjModule→Module x) (ProjModule→Module y))
CatIsoIso {R = R} =
  iso (λ (catiso fun inv sec ret) → catiso (ProjModHom→ModHom fun)
                                           (ProjModHom→ModHom inv)
                                           (ModuleHomo≡ (λ i → ProjectiveModuleHomomorphism.h (sec i)))
                                           (ModuleHomo≡ (λ i → ProjectiveModuleHomomorphism.h (ret i))))
      (λ (catiso fun inv sec ret) → catiso (ModHom→ProjModHom fun)
                                           (ModHom→ProjModHom inv)
                                           (ProjModuleHomo≡ (λ i → ModuleHomomorphism.h (sec i)))
                                           (ProjModuleHomo≡ (λ i → ModuleHomomorphism.h (ret i))))
                (λ z → CatIso≡ (RModIsCategory R) refl refl)
                 λ z → CatIso≡ (RProjIsCategory R) refl refl

CatIsoEq : {ℓ : Level} → {R : CommutativeRing {ℓ}} → {x y : Precategory.ob (RProjPreCat R)} → CatIso {C = RProjPreCat R} x y ≡ CatIso {C = RModPreCat R} (ProjModule→Module x) (ProjModule→Module y)
CatIsoEq = ua (isoToEquiv CatIsoIso)

IsoΣIso : {ℓ ℓ' ℓ'' : Level} → {A : Type ℓ} → {B : Type ℓ'} → {C : A → Type ℓ''} → ((a : A) → isContr (C a)) → Iso A B → Iso (Σ A C) B 
IsoΣIso contrC isoAB = iso (λ ac → Iso.fun isoAB (fst ac))
                           (λ b → (Iso.inv isoAB b) , fst (contrC _))
                           (λ z → Iso.rightInv isoAB z)
                           λ z → ΣPathP ((Iso.leftInv isoAB (fst z)) , toPathP (isContr→isProp (contrC (fst z)) _ _))

ProjisUnivalentAlt : {ℓ : Level} → (R : CommutativeRing {ℓ}) → isUnivalentAlt (RProjPreCat R)
ProjisUnivalentAlt {ℓ} R = isUnivAlt (λ x y →
  x ≡ y                                              ≃⟨ isoToEquiv (iso (λ p i → Iso.fun ModuleProjIso (p i))
                                                                        (λ p i → Iso.inv ModuleProjIso (p i))
                                                                        (λ z → refl)
                                                                         λ z → refl) ⟩
  Iso.fun ModuleProjIso x ≡ Iso.fun ModuleProjIso y  ≃⟨ isoToEquiv (invIso ΣPathPIsoPathPΣ) ⟩
  Σ (ProjModule→Module x ≡ ProjModule→Module y)
    (λ p → PathP (λ i → B (p i)) ((getIsProj x) , (getIsFinGen x)) ((getIsProj y) , (getIsFinGen y)))
                                                     ≃⟨ isoToEquiv (IsoΣIso (λ p → isProp→isContrPathP (λ i → isProp× (isPropisProj (p i)) (FinGenIsProp (p i))) _ _) (equivToIso (univEquiv RModIsUnivalent _ _))) ⟩
  CatIso (ProjModule→Module x) (ProjModule→Module y) ≃⟨ isoToEquiv (invIso CatIsoIso) ⟩
  CatIso x y ■)
    where
      B : (Module R) → Type (ℓ-suc ℓ)
      B x = (isProjectiveModule R x) × (isFinitelyGenerated x)

--  x ≡ y                                              ≃⟨ isoToEquiv (iso (λ p i → ProjModule→Module (p i)) (Module≡→ProjModule≡) (λ z → refl) λ z → {!!}) ⟩
--  ProjModule→Module x ≡ ProjModule→Module y          ≃⟨ univEquiv RModIsUnivalent (ProjModule→Module x) (ProjModule→Module y) ⟩
--  CatIso (ProjModule→Module x) (ProjModule→Module y) ≃⟨ isoToEquiv (invIso CatIsoIso) ⟩
--  CatIso x y ■)

--  x ≡ y                                             ≃⟨ isoToEquiv (iso (λ p i → Iso.fun ModuleProjIso (p i)) (λ p i → Iso.inv ModuleProjIso (p i)) (λ z → refl) (λ z → refl)) ⟩
--  Iso.fun ModuleProjIso x ≡ Iso.fun ModuleProjIso y ≃⟨ {!!} ⟩
--  CatIso x y ■)

RProjIsUnivalent : {ℓ : Level} → (R : CommutativeRing {ℓ}) → isUnivalent (RProjPreCat R)
RProjIsUnivalent R = univalentAlt→ (RProjPreCat R) (ProjisUnivalentAlt R)
--univalentAlt→ (RModPreCat R) RModIsUnivalentAlt

RProj : {ℓ : Level} → (R : CommutativeRing {ℓ}) → UnivalentCategory (ℓ-suc ℓ) ℓ
RProj R = record {cat = RProjPreCat R ;
                  isCat = RProjIsCategory R ;
                  isUni = RProjIsUnivalent R}

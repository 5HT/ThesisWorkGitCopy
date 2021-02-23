{-# OPTIONS --cubical #-}

module ThesisWork.BasicCategoryTheory.Limits.BinaryProduct where

open import Cubical.Categories.Category
open import Cubical.Core.Everything
open import Cubical.Foundations.Prelude
open import ThesisWork.BasicCategoryTheory.ElementaryArrowProperties
open import ThesisWork.BasicCategoryTheory.ExtendedCategoryDefinitions
open import ThesisWork.BasicCategoryTheory.ElementaryArrowProperties
open import ThesisWork.BasicCategoryTheory.Limits.InitialObject
open import ThesisWork.BasicCategoryTheory.Limits.TerminalObject
open import ThesisWork.BasicCategoryTheory.Limits.ZeroObject
open import ThesisWork.HelpFunctions
open import Cubical.HITs.PropositionalTruncation
open import Cubical.Foundations.Equiv
open import ThesisWork.BasicCategoryTheory.UniqueMorphismUpToIsomorphism


record BinaryProduct {ℓ ℓ'} (C : UnivalentCategory ℓ ℓ') (A B : Precategory.ob (UnivalentCategory.cat C)) : Type (ℓ-suc (ℓ-max ℓ ℓ')) where
  constructor _,BinProd_,_,_
  field
    A×B : ob (UnivalentCategory.cat C)
    pA : hom (UnivalentCategory.cat C) A×B A
    pB : hom (UnivalentCategory.cat C) A×B B
    <_×_> : {Z : ob (UnivalentCategory.cat C)} → (f : hom (UnivalentCategory.cat C) Z A) →
            (g : hom (UnivalentCategory.cat C) Z B) → hom (UnivalentCategory.cat C) Z A×B
    pAcomp : {Z : ob (UnivalentCategory.cat C)} → (f : hom (UnivalentCategory.cat C) Z A) →
             (g : hom (UnivalentCategory.cat C) Z B) → seq (UnivalentCategory.cat C) < f × g > pA ≡ f
    pBcomp : {Z : ob (UnivalentCategory.cat C)} → (f : hom (UnivalentCategory.cat C) Z A) →
             (g : hom (UnivalentCategory.cat C) Z B) → seq (UnivalentCategory.cat C) < f × g > pB ≡ g
    uni : {Z : ob (UnivalentCategory.cat C)} → (f : hom (UnivalentCategory.cat C) Z A) →
          (g : hom (UnivalentCategory.cat C) Z B) → (h : hom (UnivalentCategory.cat C) Z A×B) →
          seq (UnivalentCategory.cat C) h pA ≡ f → seq (UnivalentCategory.cat C) h pB ≡ g →
          < f × g > ≡ h

Prod<_×_>_ : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
             {Z : ob (UnivalentCategory.cat C)} → (f : hom (UnivalentCategory.cat C) Z A) →
             (g : hom (UnivalentCategory.cat C) Z B) → (P : BinaryProduct C A B) →
             hom (UnivalentCategory.cat C) Z (BinaryProduct.A×B P)
Prod< A × B > P = BinaryProduct.< P × A > B

--TODO: Could be done more cleanly if I looked up how to prove equality of objects is a property
isBinaryProduct : {ℓ ℓ' : Level} → (C : UnivalentCategory ℓ ℓ') → (A B : Precategory.ob (UnivalentCategory.cat C)) →
                  (A×B : ob (UnivalentCategory.cat C)) → Type ((ℓ-suc (ℓ-max ℓ ℓ')))
isBinaryProduct C A B A×B = ∥ Σ (BinaryProduct C A B) (λ binProd → (BinaryProduct.A×B binProd) ≡ A×B) ∥

isBinaryProductIsProp : {ℓ ℓ' : Level} → (C : UnivalentCategory ℓ ℓ') → (A B : Precategory.ob (UnivalentCategory.cat C)) →
                        (A×B : ob (UnivalentCategory.cat C)) → isProp (isBinaryProduct C A B A×B)
isBinaryProductIsProp C A B A×B = propTruncIsProp

hasBinaryProducts : {ℓ ℓ' : Level} → (C : UnivalentCategory ℓ ℓ') → (A B : Precategory.ob (UnivalentCategory.cat C)) →
                    Type (ℓ-suc (ℓ-max ℓ ℓ'))
hasBinaryProducts C A B = ∥ ((A B : Precategory.ob (UnivalentCategory.cat C)) →
                            Σ (ob (UnivalentCategory.cat C)) (isBinaryProduct C A B)) ∥

hasBinaryProductsIsProp : {ℓ ℓ' : Level} → (C : UnivalentCategory ℓ ℓ') → (A B : Precategory.ob (UnivalentCategory.cat C)) →
                          isProp (hasBinaryProducts C A B)
hasBinaryProductsIsProp C A B = propTruncIsProp

hasAllBinaryProducts : {ℓ ℓ' : Level} → (C : UnivalentCategory ℓ ℓ') → Type (ℓ-suc (ℓ-max ℓ ℓ'))
hasAllBinaryProducts C = (A B : Precategory.ob (UnivalentCategory.cat C)) → hasBinaryProducts C A B

hasAllBinaryProductsIsProp : {ℓ ℓ' : Level} → (C : UnivalentCategory ℓ ℓ') → isProp (hasAllBinaryProducts C)
hasAllBinaryProductsIsProp C p q = funExt (λ A → funExt (λ B → hasBinaryProductsIsProp C A B (p A B) (q A B)))

--****************************************************** Isomorphisms ***********************************************************
--****************************************************** Help funcs *************************************************************
DefH : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                         (P₁ P₂ : BinaryProduct C A B) →
                         hom (UnivalentCategory.cat C) (BinaryProduct.A×B P₁) (BinaryProduct.A×B P₂)
DefH P₁ P₂ = Prod< BinaryProduct.pA P₁ × BinaryProduct.pB P₁ > P₂

DefHInv : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                         (P₁ P₂ : BinaryProduct C A B) →
                         hom (UnivalentCategory.cat C) (BinaryProduct.A×B P₂) (BinaryProduct.A×B P₁)
DefHInv P₁ P₂ = Prod< (BinaryProduct.pA P₂) × (BinaryProduct.pB P₂) > P₁

--****************************************************** lemmas seq *************************************************************

lemmaADoubleSeqA2 : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                   (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C) (DefHInv P₁ P₂)
                   (seq (UnivalentCategory.cat C) (DefH P₁ P₂) (BinaryProduct.pA P₂))
                    ≡ BinaryProduct.pA P₂
lemmaADoubleSeqA2 {C = C} P₁ P₂ = (cong (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂))
                                 (BinaryProduct.pAcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁))) ∙
                                 ((BinaryProduct.pAcomp P₁ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂)))

lemmaADoubleSeqB2 : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                   (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C) (DefHInv P₁ P₂)
                   (seq (UnivalentCategory.cat C) (DefH P₁ P₂) (BinaryProduct.pB P₂))
                    ≡ BinaryProduct.pB P₂
lemmaADoubleSeqB2 {C = C} P₁ P₂ = cong (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂))
                                 (BinaryProduct.pBcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁)) ∙
                                  BinaryProduct.pBcomp P₁ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂)

lemmaADoubleSeqA : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C)
           (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂) (DefH P₁ P₂))
           (BinaryProduct.pA P₂) ≡ BinaryProduct.pA P₂
lemmaADoubleSeqA {C = C} P₁ P₂ = seq-α (UnivalentCategory.cat C) (DefHInv P₁ P₂) (DefH P₁ P₂) (BinaryProduct.pA P₂)  ∙
                                lemmaADoubleSeqA2 P₁ P₂
                                
lemmaADoubleSeqB : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C)
           (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂) (DefH P₁ P₂))
           (BinaryProduct.pB P₂) ≡ BinaryProduct.pB P₂
lemmaADoubleSeqB {C = C} P₁ P₂ = seq-α (UnivalentCategory.cat C) (DefHInv P₁ P₂) (DefH P₁ P₂) (BinaryProduct.pB P₂) ∙
                                lemmaADoubleSeqB2 P₁ P₂

lemmaCompAProd : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → UnivalentCategory.cat C .seq (DefHInv P₁ P₂) (DefH P₁ P₂) ≡
           Prod< (BinaryProduct.pA P₂) × (BinaryProduct.pB P₂) > P₂
lemmaCompAProd {C = C} P₁ P₂ = sym (BinaryProduct.uni P₂ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂)
                                   (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂) (DefH P₁ P₂))
                                   (lemmaADoubleSeqA P₁ P₂)
                                   (lemmaADoubleSeqB P₁ P₂))

lemmaCompAId : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
               (P₁ P₂ : BinaryProduct C A B) → (Prod< BinaryProduct.pA P₂ × BinaryProduct.pB P₂ > P₂) ≡
                UnivalentCategory.cat C .idn (BinaryProduct.A×B P₂)
lemmaCompAId {C = C} P₁ P₂ = BinaryProduct.uni P₂ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂)
                             (UnivalentCategory.cat C .idn (BinaryProduct.A×B P₂))
                             (seq-λ (UnivalentCategory.cat C) (BinaryProduct.pA P₂))
                             (seq-λ (UnivalentCategory.cat C) (BinaryProduct.pB P₂))

lemmaSec : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → UnivalentCategory.cat C .seq (DefHInv P₁ P₂) (DefH P₁ P₂) ≡
           UnivalentCategory.cat C .idn (BinaryProduct.A×B P₂)
lemmaSec P₁ P₂ = lemmaCompAProd P₁ P₂ ∙ lemmaCompAId P₁ P₂

--****************************************************** lemmas ret *************************************************************

lemmaBDoubleSeqA2 : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                   (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C) (DefH P₁ P₂)
                   (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂) (BinaryProduct.pA P₁))
                    ≡ BinaryProduct.pA P₁
lemmaBDoubleSeqA2 {C = C} P₁ P₂ = (cong (seq (UnivalentCategory.cat C) (DefH P₁ P₂))
                                  (BinaryProduct.pAcomp P₁ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂))) ∙
                                  (BinaryProduct.pAcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁))

lemmaBDoubleSeqB2 : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                   (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C) (DefH P₁ P₂)
                   (seq (UnivalentCategory.cat C) (DefHInv P₁ P₂) (BinaryProduct.pB P₁))
                    ≡ BinaryProduct.pB P₁
lemmaBDoubleSeqB2 {C = C} P₁ P₂ = (cong (seq (UnivalentCategory.cat C) (DefH P₁ P₂))
                                  (BinaryProduct.pBcomp P₁ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂))) ∙
                                  BinaryProduct.pBcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁)

lemmaBDoubleSeqA : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C)
           (seq (UnivalentCategory.cat C) (DefH P₁ P₂) (DefHInv P₁ P₂))
           (BinaryProduct.pA P₁) ≡ BinaryProduct.pA P₁
lemmaBDoubleSeqA {C = C} P₁ P₂ = (seq-α (UnivalentCategory.cat C) (DefH P₁ P₂) (DefHInv P₁ P₂) (BinaryProduct.pA P₁)) ∙ lemmaBDoubleSeqA2 P₁ P₂
                                
lemmaBDoubleSeqB : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → seq (UnivalentCategory.cat C)
           (seq (UnivalentCategory.cat C) (DefH P₁ P₂) (DefHInv P₁ P₂))
           (BinaryProduct.pB P₁) ≡ BinaryProduct.pB P₁
lemmaBDoubleSeqB {C = C} P₁ P₂ = (seq-α (UnivalentCategory.cat C) (DefH P₁ P₂) (DefHInv P₁ P₂) (BinaryProduct.pB P₁)) ∙ (lemmaBDoubleSeqB2 P₁ P₂)

lemmaCompBProd : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → UnivalentCategory.cat C .seq (DefH P₁ P₂) (DefHInv P₁ P₂) ≡
           Prod< (BinaryProduct.pA P₁) × (BinaryProduct.pB P₁) > P₁
lemmaCompBProd {C = C} P₁ P₂ = sym (BinaryProduct.uni P₁ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁)
                                    (seq (UnivalentCategory.cat C) (DefH P₁ P₂) (DefHInv P₁ P₂))
                                    (lemmaBDoubleSeqA P₁ P₂)
                                    (lemmaBDoubleSeqB P₁ P₂))

lemmaCompBId : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
               (P₁ P₂ : BinaryProduct C A B) → (Prod< BinaryProduct.pA P₁ × BinaryProduct.pB P₁ > P₁) ≡
                UnivalentCategory.cat C .idn (BinaryProduct.A×B P₁)
lemmaCompBId {C = C} P₁ P₂ = BinaryProduct.uni P₁ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁)
                             (UnivalentCategory.cat C .idn (BinaryProduct.A×B P₁))
                             (seq-λ (UnivalentCategory.cat C) (BinaryProduct.pA P₁))
                             (seq-λ (UnivalentCategory.cat C) (BinaryProduct.pB P₁))

lemmaRet : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
           (P₁ P₂ : BinaryProduct C A B) → UnivalentCategory.cat C .seq (DefH P₁ P₂) (DefHInv P₁ P₂) ≡
           UnivalentCategory.cat C .idn (BinaryProduct.A×B P₁)
lemmaRet P₁ P₂ = lemmaCompBProd P₁ P₂ ∙ lemmaCompBId P₁ P₂

--******************************************************** Main thms ************************************************************

BinaryProductObjectsIso : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                         (P₁ P₂ : BinaryProduct C A B) →
                         CatIso {ℓ} {ℓ'} {UnivalentCategory.cat C} (BinaryProduct.A×B P₁) (BinaryProduct.A×B P₂)
BinaryProductObjectsIso {C = C} P₁ P₂ = record {h = DefH P₁ P₂  ;
                                                h⁻¹ = DefHInv P₁ P₂ ;
                                                sec = lemmaSec P₁ P₂ ;
                                                ret = lemmaRet P₁ P₂}


--                                              sec =  (sym (BinaryProduct.uni P₂ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂)
--                                                (seq (UnivalentCategory.cat C)
--                                                     (Prod< (BinaryProduct.pA P₂) × (BinaryProduct.pB P₂) > P₁)
--                                                     (Prod< BinaryProduct.pA P₁ × BinaryProduct.pB P₁ > P₂))
--                                                     ((seq-α (UnivalentCategory.cat C)
--                                                       (Prod< (BinaryProduct.pA P₂) × (BinaryProduct.pB P₂) > P₁)
--                                                       (Prod< BinaryProduct.pA P₁ × BinaryProduct.pB P₁ > P₂)
--                                                       (BinaryProduct.pA P₂)) ∙
--                                                       (cong (λ g →
--                                                       seq (UnivalentCategory.cat C)
--                                                       (Prod< (BinaryProduct.pA P₂) × (BinaryProduct.pB P₂) > P₁) g)
--                                                       (BinaryProduct.pAcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁))) ∙
--                                                       BinaryProduct.pAcomp P₁ (BinaryProduct.pA P₂) (BinaryProduct.pB P₂))
--                                                      {!!})) ∙ {!!} ;

BinaryProductObjectsEq : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                         (P₁ P₂ : BinaryProduct C A B) → BinaryProduct.A×B P₁ ≡ BinaryProduct.A×B P₂
BinaryProductObjectsEq {C = C} P₁ P₂ = equivFun  (invEquiv (PathEqCatIso C (BinaryProduct.A×B P₁) (BinaryProduct.A×B P₂)))
                                       (BinaryProductObjectsIso P₁ P₂)

BinaryProductProjAUniqueUpToIso : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                                  (P₁ P₂ : BinaryProduct C A B) → UniqueUpToIsoLeft {C = C} (BinaryProduct.A×B P₂)
                                  (BinaryProduct.pA P₁)
                                  (λ k' → BinaryProduct.pA P₂ ≡ k')
BinaryProductProjAUniqueUpToIso {C = C} P₁ P₂ = record {h = λ k' → λ pa≡k' → DefH P₁ P₂ ;
                                                        hInv = λ k' → λ pa≡k' → DefHInv P₁ P₂ ;
                                                        compH = λ k' → λ pa≡k' →
                                                        sym ((cong (seq (UnivalentCategory.cat C) (DefH P₁ P₂)) (sym pa≡k')) ∙
                                                        BinaryProduct.pAcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁)) ;
                                                        invComp = λ k' → λ pa≡k' → lemmaSec P₁ P₂ ;
                                                        compInv = λ k' → λ pa≡k' → lemmaRet P₁ P₂}

BinaryProductProjBUniqueUpToIso : {ℓ ℓ' : Level} → {C : UnivalentCategory ℓ ℓ'} → {A B : Precategory.ob (UnivalentCategory.cat C)} →
                                  (P₁ P₂ : BinaryProduct C A B) → UniqueUpToIsoLeft {C = C} (BinaryProduct.A×B P₂)
                                  (BinaryProduct.pB P₁)
                                  (λ k' → BinaryProduct.pB P₂ ≡ k')
BinaryProductProjBUniqueUpToIso {C = C} P₁ P₂ = record {h = λ k' → λ pb≡k' → DefH P₁ P₂ ;
                                                        hInv = λ k' → λ pb≡k' → DefHInv P₁ P₂ ;
                                                        compH = λ k' → λ pb≡k' →
                                                        sym ((cong (seq (UnivalentCategory.cat C) (DefH P₁ P₂)) (sym pb≡k')) ∙
                                                        BinaryProduct.pBcomp P₂ (BinaryProduct.pA P₁) (BinaryProduct.pB P₁)) ;
                                                        invComp = λ k' → λ pb≡k' → lemmaSec P₁ P₂ ;
                                                        compInv = λ k' → λ pb≡k' → lemmaRet P₁ P₂}

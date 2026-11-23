import Lean
import ProofStudy

namespace LeanStudySolutions

open ProofStudy

-- 1A
theorem implication_chain (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  apply hQR
  apply hPQ
  exact hP

-- 1B
theorem all_follow_rule (P Q : Nat → Prop) (rule : ∀ n, P n → Q n)
    (known : ∀ n, P n) : ∀ n, Q n := by
  intro n
  apply rule n
  exact known n

-- 2A
theorem swap_and (P Q : Prop) : P ∧ Q → Q ∧ P := by
  intro h
  constructor
  · exact h.2
  · exact h.1

-- 2B
theorem swap_or (P Q : Prop) : P ∨ Q → Q ∨ P := by
  intro h
  cases h with
  | inl hP =>
    right
    exact hP
  | inr hQ =>
    left
    exact hQ

-- 2C. 2Aの定理を、PとQを入れ替えてもう一度使う。
theorem and_iff_swap (P Q : Prop) : (P ∧ Q) ↔ (Q ∧ P) := by
  constructor
  · exact swap_and P Q
  · exact swap_and Q P

-- 2D. h.2 は P の証明を受け取ると False を返す。
theorem and_not_impossible (P : Prop) : ¬ (P ∧ ¬ P) := by
  intro h
  exact h.2 h.1

-- 3A
theorem rewrite_argument (f : Int → Int) (a b : Int) (h : a = b) : f a = f b := by
  rw [h]

-- 3B
theorem isolate_x (x y : Int) (hSum : x + y = 10) (hY : y = 3) : x = 7 := by
  calc
    x = (x + y) - y := (Int.add_sub_cancel x y).symm
    _ = (10 : Int) - 3 := by rw [hSum, hY]
    _ = 7 := by rfl

-- 4A
theorem choose_number : ∃ n : Nat, n + n = 12 := by
  refine ⟨6, ?_⟩
  rfl

-- 4B
theorem shift_witness (n : Int) (h : ∃ k : Int, n = k + 3) : ∃ j : Int, n = j + 1 := by
  obtain ⟨k, hk⟩ := h
  refine ⟨k + 2, ?_⟩
  calc
    n = k + 3 := hk
    _ = (k + 2) + 1 := by omega

-- 5A
theorem zero_add_by_induction (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ k ih => rw [Nat.add_succ, ih]

-- StartHere.leanの練習1。a と b の半分を足す。
theorem even_sum (a b : Int) (ha : IsEven a) (hb : IsEven b) : IsEven (a + b) := by
  unfold IsEven at *
  obtain ⟨m, hm⟩ := ha
  obtain ⟨n, hn⟩ := hb
  refine ⟨m + n, ?_⟩
  rw [hm, hn, Int.mul_add]

-- StartHere.leanの練習2。二つの余りの和 1 + 1 から、もう一組の 2 ができる。
theorem odd_sum (a b : Int) (ha : IsOdd a) (hb : IsOdd b) : IsEven (a + b) := by
  unfold IsOdd at ha hb
  unfold IsEven
  obtain ⟨m, hm⟩ := ha
  obtain ⟨n, hn⟩ := hb
  refine ⟨m + n + 1, ?_⟩
  rw [hm, hn]
  omega

-- 最終問題
theorem even_then_odd : ∀ n : Int, IsEven n → IsOdd (n + 1) := by
  intro n hn
  unfold IsEven at hn
  unfold IsOdd
  obtain ⟨k, hk⟩ := hn
  refine ⟨k, ?_⟩
  rw [hk]

end LeanStudySolutions

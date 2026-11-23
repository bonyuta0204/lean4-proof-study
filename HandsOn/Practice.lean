import Lean

namespace LeanStudy

/-! ## 0. Infoviewで最初のゴールを見る
`intro hP` の前後で、`⊢` の後ろと仮定欄を見比べる。 -/

theorem first_proof (P : Prop) : P → P := by
  intro hP
  exact hP

/-! ## 1. 含意 `→` と「すべて」`∀` -/

-- 1A. `apply hQR` の後に何を示せばよいか、Infoviewで確認する。
theorem implication_chain (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by
  intro hP
  apply hQR
  sorry

-- 1B. 任意の n を取り、その n について rule と known を使う。
theorem all_follow_rule (P Q : Nat → Prop) (rule : ∀ n, P n → Q n)
    (known : ∀ n, P n) : ∀ n, Q n := by
  sorry

/-! ## 2. 「かつ」`∧` と「または」`∨` -/

-- 2A. `constructor` が作る2つのゴールを順番に埋める。
theorem swap_and (P Q : Prop) : P ∧ Q → Q ∧ P := by
  intro h
  constructor
  · sorry
  · sorry

-- 2B. h が左と右のどちらから来たかで分ける。
theorem swap_or (P Q : Prop) : P ∨ Q → Q ∨ P := by
  intro h
  cases h with
  | inl hP => sorry
  | inr hQ => sorry

/-
2C・2D は追加問題。解くときは、このブロックの開始・終了記号を外す。

-- 2C. 2Aで作った定理を両方向に使う。
theorem and_iff_swap (P Q : Prop) : (P ∧ Q) ↔ (Q ∧ P) := by
  sorry

-- 2D. h.2 の型を見て、何を渡せば False が得られるか考える。
theorem and_not_impossible (P : Prop) : ¬ (P ∧ ¬ P) := by
  sorry
-/

/-! ## 3. 等式で式を書き換える -/

-- 3A. f の中にある a を h で書き換える。
theorem rewrite_argument (f : Int → Int) (a b : Int) (h : a = b) : f a = f b := by
  sorry

-- 3B. `calc` の `_` に、直前の行の右辺が入る。最初の行は `Int.add_sub_cancel` を使う。
theorem isolate_x (x y : Int) (hSum : x + y = 10) (hY : y = 3) : x = 7 := by
  calc
    x = (x + y) - y := by sorry
    _ = (10 : Int) - 3 := by sorry
    _ = 7 := by rfl

/-! ## 4. 「ある」`∃` の具体例を示す -/

-- 4A. 12 を作る n を選び、等式を示す。
theorem choose_number : ∃ n : Nat, n + n = 12 := by
  sorry

-- 4B. 仮定から出てくる k をもとに、結論の j を選ぶ。
theorem shift_witness (n : Int) (h : ∃ k : Int, n = k + 3) : ∃ j : Int, n = j + 1 := by
  sorry

/-! ## 5. 自然数に対する帰納法 -/

-- 5A. `succ` 側では Nat.add_succ と帰納法の仮定 ih を使う。
theorem zero_add_by_induction (n : Nat) : 0 + n = n := by
  induction n with
  | zero => sorry
  | succ k ih => sorry

/-! ## 最終問題
「すべての整数 n について、n が偶数なら n + 1 は奇数」を、
ここに `theorem even_then_odd` として命題から書く。
この問題を書く前にファイル先頭へ `import ProofStudy` を追加する。
偶数と奇数の定義は `ProofStudy/Parity.lean` にある。 -/

end LeanStudy

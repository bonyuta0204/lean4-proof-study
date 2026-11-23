import ProofStudy

open ProofStudy

/-!
# 偶数と奇数の証明

`IsEven` と `IsOdd` の定義は `ProofStudy/Parity.lean` にある。
-/

-- 見本。4を証人に選んだ直後のゴールを見る。
example : IsEven 8 := by
  unfold IsEven
  refine ⟨4, ?_⟩
  rfl

-- 練習1。まず紙で、a + b が何の2倍かを書く。
example (a b : Int) (ha : IsEven a) (hb : IsEven b) : IsEven (a + b) := by
  sorry

-- 練習2。練習1を白紙から解き直してから取り組む。
example (a b : Int) (ha : IsOdd a) (hb : IsOdd b) : IsEven (a + b) := by
  sorry

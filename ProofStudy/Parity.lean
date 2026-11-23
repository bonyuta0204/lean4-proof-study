namespace ProofStudy

/-- 偶数は、ある整数の2倍で表せる整数。 -/
def IsEven (n : Int) : Prop :=
  ∃ k : Int, n = 2 * k

/-- 奇数は、ある整数の2倍に1を足して表せる整数。 -/
def IsOdd (n : Int) : Prop :=
  ∃ k : Int, n = 2 * k + 1

end ProofStudy

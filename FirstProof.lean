-- リストの各要素を2倍にする。
def doubleAll (xs : List Nat) : List Nat :=
  xs.map (fun x => x * 2)

-- 実際にこの入力で実行する。
#eval doubleAll [1, 2, 3] -- [2, 4, 6]
#eval doubleAll []        -- []

-- どのリストでも、変換の前後で要素の数は同じになる。
theorem length_doubleAll (xs : List Nat) :
    (doubleAll xs).length = xs.length := by
  unfold doubleAll
  apply List.length_map

# Lean 4で最初の証明を書く

## 最初のレッスンでは、変換しても件数が変わらないことを確かめる

数字のリストを受け取り、全部を2倍にする関数を書いたとします。入力が `[1, 2, 3]` なら、出力は `[2, 4, 6]`。どちらも3件です。空のリストなら、前後とも0件です。

ここで確かめたいのは、**どんなリストを渡しても、変換の前後で件数が同じになること**です。Leanでは、関数と一緒にこの性質を書き、どの入力にも当てはまる理由を検査できます。

### まず関数を実行する

VS Codeで `lean4-proof-study` フォルダを開き、[FirstProof.lean](FirstProof.lean)を表示します。初回はVS CodeにLean 4拡張機能を入れて案内に従い、`git clone https://github.com/bonyuta0204/lean4-proof-study.git` で教材を手元に置きます。 [Lean公式のセットアップ手順](https://lean-lang.org/install/)

```lean
def doubleAll (xs : List Nat) : List Nat :=
  xs.map (fun x => x * 2)

#eval doubleAll [1, 2, 3]
#eval doubleAll []
```

`def` から始まる2行が関数です。入力は `xs`、`List Nat` は自然数のリストです。`map` に渡した `fun x => x * 2` は、TypeScriptの `x => x * 2` と同じ意味です。

`#eval` の行にカーソルを置くと、右側のLean Infoviewで結果を見られます。上の行は `[2, 4, 6]`、下の行は `[]` です。Infoviewが閉じているときは、コマンドパレットから `Lean 4: InfoView: Toggle InfoView` を選びます。

ターミナルで見る場合は、リポジトリのルートで `lake env lean FirstProof.lean` を実行します。

### 次に、どの入力でも成り立つことを示す

`FirstProof.lean` の下半分を見ます。`xs` は、入力として受け取るリストの名前です。等号の左側が変換後の件数、右側が変換前の件数です。これがこのファイルで証明したい主張です。

```lean
theorem length_doubleAll (xs : List Nat) :
    (doubleAll xs).length = xs.length := by
  unfold doubleAll
  apply List.length_map
```

理由は、`map` が入力の各要素を一つの値に変換するからです。`doubleAll` の中身を見れば、`map` だけでできています。Leanの標準ライブラリには、**`map` の前後で件数が同じ**という性質が `List.length_map` という名前ですでに証明されています。

1. `unfold doubleAll` で、式の中の `doubleAll xs` を関数の中身である `xs.map ...` に置き換えます。
2. `apply List.length_map` で、件数が同じという既存の証明を当てはめます。Leanが、示したい等式にその証明が合うことを確かめます。

`by` の下にある `unfold` と `apply` が**タクティク**です。Leanに証明を進めさせる指示をこう呼びます。`unfold` の前後にカーソルを移すと、Infoviewで示すべき式がどう変わったか見られます。この残っている問題を**ゴール**と呼びます。

### 実装を変えて、Leanの反応を見る

1. `x * 2` を `x * 3` に変えます。`#eval` の結果は `[3, 6, 9]` になり、件数が同じという証明も通ります。値の変え方が変わっても、`map` は各要素につき一つの値を返すからです。
2. `x * 2` に戻し、`xs.map` を `(xs.drop 1).map` に変えます。今度は `[1, 2, 3]` から先頭が落ち、結果は `[4, 6]` です。3件が2件になったので、**変換の前後で件数が同じ**という性質が破れます。Leanは証明の `apply` の行でエラーを出します。`map` が件数を保つのは、先頭を落とした後のリストに対してです。確認したら `xs.map` に戻します。

2倍を3倍に変えても通り、先頭を落とすと止まる理由を自分の言葉で言えたら、このレッスンは完了です。次は、仮定を使う、式を書き換える、具体的な値を示す、といった証明の手順を一つずつ練習します。 [演習ガイド](GUIDE.md)

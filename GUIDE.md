# Lean 4 演習ガイド

[最初のレッスン](README.md)で `doubleAll` の証明を試したら、ここから進みます。演習は0から順に進めると合計2時間ほどです。

## 最初に命題とゴールの読み方を学ぶ（15分）

園田翔さんの『数学系エンドユーザーのためのLean入門』を、次の順に読みます。ここまではブラウザだけで進められます。

1. **命題と証明を読み分ける（5分）**。`P : Prop` は「`P` は命題」、`hP : P` は「`hP` は `P` の証明」です。`example` の行では、括弧の外にある最後の `:` の右側が、証明したい命題です。 [Leanの命題の読み方](https://shosonoda.github.io/lean-math-note/basic/chapter01/02/)
2. **ゴールがどう変わるかを見る（10分）**。ページの冒頭から `exact` の例まで読みます。Infoviewでは `⊢` の上に使える仮定が並び、`⊢` の後ろにいま示す命題が出ます。 [by と tactic モードの基本](https://shosonoda.github.io/lean-math-note/basic/chapter03/02/)

「`P` ならば `Q`」の証明は、`P` の証明を受け取って `Q` の証明を返す関数です。たとえば「`P` ならば `P`」は、受け取った証明をそのまま返します。

```lean
theorem first_proof (P : Prop) : P → P := by
  intro hP
  exact hP
```

`intro hP` で入力を受け取ると、仮定に `hP : P` が加わり、残るゴールは `⊢ P` です。`exact hP` でその証明を渡します。関数として直接書くと `fun hP => hP` です。この2行が何をしているか言葉にできたら、教材を開いて確かめます。 [関数・含意・全称命題](https://shosonoda.github.io/lean-math-note/basic/chapter03/05/)

## 演習の準備

1. VS Codeと公式のLean 4拡張機能を入れ、拡張機能の案内に従ってLeanをセットアップします。 [Lean公式のセットアップ手順](https://lean-lang.org/install/)
2. このリポジトリをクローンして、VS Codeで `lean4-proof-study` フォルダを開きます。ルートで `lake build` を1回実行すると、偶数・奇数の定義を使う演習も開けます。教材はLean 4.33.0とその標準ライブラリで動きます。
3. [ハンズオン](HandsOn/Practice.lean) の `first_proof` を開いて、以下の0から進めます。

```sh
git clone https://github.com/bonyuta0204/lean4-proof-study.git
cd lean4-proof-study
lake build
```

ターミナルで確認するなら、編集したファイルを保存してから、リポジトリのルートで `lake env lean HandsOn/Practice.lean` を実行します。未着手の練習は `sorry` の警告として残ります。

## 0. 読んだ証明をInfoviewで確かめる（10分）

[ハンズオン](HandsOn/Practice.lean) で、先ほど読んだ `first_proof` を開きます。

1. `by` の直後から2行を順にたどり、右側の **Lean Infoview** を見ます。閉じていれば `⌘⇧P` から `Lean 4: InfoView: Toggle InfoView` を実行します。
2. `intro hP` の後に、仮定欄へ `hP : P` が加わり、ゴールが `⊢ P` になることを確かめます。`⊢` の後ろが、いま示す命題です。
3. `exact hP` の `hP` を一度 `P` に変えます。エラーを読んだら元へ戻し、ゴールが消えるところまで確認します。この練習で、**命題そのものと、その命題の証明**を区別できれば十分です。

練習では `sorry` を一つずつ置き換えます。一行書く前に次のゴールを予想し、書いたらInfoviewで照合します。`sorry` がゴールを隠しているときは、一時的に `skip` に置き換えてください。`unsolved goals` の下に残りのゴールが出ます。[演習中の確認方法](#詰まったら現在のゴールから原因を絞る)

## 1. `→` と `∀` の内側に入る（15分）

`P → Q` は「`P` の証明を受け取って `Q` の証明を返す関数」として読めます。ゴールが `P → Q` なら `intro hP` で入力を受け取り、`Q` を示します。手元に `h : P → Q` があってゴールが `Q` なら、`apply h` で必要な入力 `P` を新しいゴールにできます。

- **1A `implication_chain`**。`apply hQR` の直後にゴールが `Q` になる理由を言ってから、残りを書きます。
- **1B `all_follow_rule`**。`∀ n, Q n` に `intro n` を使い、任意に選んだ一つの `n` を固定します。`rule n` と `known n` がそれぞれ何を返すか考えます。

進む目安は、**`intro` と `apply` で何が仮定に加わり、何がゴールに残るか**を説明できることです。

## 2. `∧` は二つそろえ、`∨` は場合を分ける（20分）

2Aでは、仮定 `h : P ∧ Q` に `h.1` と `h.2` が入っています。`constructor` で作った二つのゴールに、対応する証明を `exact` で渡します。`·` で始まる各ブロックを一つずつ閉じてください。

2Bの `h : P ∨ Q` は、左の証明が入った場合と右の証明が入った場合に分かれます。`cases h` の各枝で、ゴール `Q ∨ P` のどちらを示せるか決め、`left` か `right` を選びます。TypeScriptでタグ付きの型を場合分けする感覚に近いです。

追加の2Cは、`P ↔ Q` が `P → Q` と `Q → P` の両方向を含むことを練習します。2Dでは `¬ P` を `P → False` と読み、何を渡せば矛盾が得られるかを試します。

## 3. 等式を根拠に、式を一段ずつ変える（20分）

3Aは `h : a = b` を使って `f a = f b` を示す問題です。`rw [h]` がどこを書き換えたか見ます。`rw [← h]` とすれば、同じ等式を逆向きに使えます。

3Bは `x + y = 10` と `y = 3` から `x = 7` を出す問題です。`calc` で式を鎖のようにつなぎ、各行に理由を付けます。

| 理由 | 書き方 |
| --- | --- |
| 仮定の等式で置き換える | `rw [hSum, hY]` |
| 既知の等式を逆向きに使う | `(Int.add_sub_cancel x y).symm` |
| 定義に従って計算すると両辺が同じになる | `rfl` |

証明の外に `#check Int.add_sub_cancel` と書くと、補題が `x + y - y = x` を示すことを確かめられます。3Bでは `x = x + y - y` が欲しいので `.symm` で向きを逆にします。`by sorry` の `by` を残すなら、続けて `exact` と書き、その後ろに証明を渡します。

## 4. `∃` を示すには、具体的な値を出す（25分）

ゴール `∃ n, P n` に `refine ⟨値, ?_⟩` と書くと、その値が `P` を満たすことが次のゴールになります。`?_` は残りの証明を入れる場所です。仮定の側に `h : ∃ n, P n` があるときは、`obtain ⟨n, hn⟩ := h` で値 `n` と、その値についての証明 `hn : P n` を取り出せます。存在を示すその値を**証人**と呼びます。

まず **4A `choose_number`** で、`n + n = 12` を満たす値を選びます。`refine` の直後に何を証明するか確認します。

**4B `shift_witness`** では、仮定から出てくる `k` を使って結論の値を作ります。紙で証人を決めたら、Leanで証人を入れて元の等式で `rw` します。残るのは整数の足し算です。変数を含む式の整理には `omega` を使えます。たとえば次の等式です。

```lean
example (x : Int) : x + 4 = (x + 1) + 3 := by
  omega
```

次に [偶数・奇数の復習](StartHere.lean) の練習1へ移ります。「二つの偶数の半分が分かれば、和の半分は何か」を先に紙で考えます。`omega` は `2 * x` のような定数倍を含む式の整理にも使えます。翌日は練習1を白紙から解き直し、そのあと奇数の和を扱う練習2に進みます。

`unfold IsEven` はゴールの定義を展開します。`unfold IsEven at h` なら仮定 `h`、`unfold IsEven at *` なら定義を含む仮定とゴールが対象です。

## 5. `induction` で帰納法の二つのケースを作る（20分）

5Aで `induction n` を実行すると、`n = 0` のケースと、`n` が `k` の次の自然数であるケースができます。先に `zero` を `rfl` で閉じます。`succ` では `ih : 0 + k = k` が帰納法の仮定です。`rw [Nat.add_succ]` の後に残るゴールは `⊢ (0 + k).succ = k + 1` です。`.succ` は自然数に1を足す操作なので、`ih` で `0 + k` を `k` に置き換えれば閉じます。

再帰関数を一段小さい入力に適用する感覚で、**どの式を小さくすれば帰納法の仮定を使えるか**考えてください。`Nat.add_succ` の正確な型を見たければ、証明の外に `#check Nat.add_succ` と書くとInfoviewで確認できます。

## 最終問題を、命題から自分で書く（15分）

ハンズオン末尾の最終問題で、「すべての整数 `n` について、`n` が偶数なら `n + 1` は奇数」を証明します。

1. 日本語を「すべて」「なら」「奇数の具体的な条件」に分け、Leanの `theorem` の宣言を自分で書きます。`Practice.lean` の先頭に `import ProofStudy` を追加して、 [偶数・奇数の定義](ProofStudy/Parity.lean) を使います。定理の中では `ProofStudy.IsEven` と `ProofStudy.IsOdd` と書くか、証明の外で `open ProofStudy` と書けます。
2. 証人として何を選ぶか紙に書き、その証明をLeanに移します。`∀`、`→`、`∃` をどの行で扱ったか説明します。
3. `end LeanStudy` の手前に `#check even_then_odd` を書き、定理の型が日本語の命題に対応することを確かめます。表示では `∀ n : Int` が定理名の後ろの `(n : Int)` になります。証明の中に `sorry` が残っていないことも確認します。

翌日、**偶数同士の和の証明**を、前日のコードを見ずに書き直します。二つの命題で証人の選び方を説明できたら、初回のコースは完了です。

`⟨ ⟩` などの記号は演習中の形をコピーできます。VS Codeでは `\forall` や `\exists` を入力して変換する方法もあります。

## 詰まったら、現在のゴールから原因を絞る

| 表示や状況 | 次に確かめること |
| --- | --- |
| `type mismatch` | 渡したものの型と、Leanが期待する型を見比べる。仮定名にカーソルを合わせると型を確認できる。 |
| `unsolved goals` | `⊢` の後ろの未証明の命題を読む。先頭が `∀` か `→` なら `intro`、`∧` なら `constructor`、`∃` なら証人を考える。 |
| `rw` が書き換え先を見つけられない | 等式の左辺がゴールにあるか確認する。右辺があるなら `←` で向きを変える。別の仮定を書き換えるなら `rw [h] at h2`。 |
| 式を変形したいが補題の名前が分からない | 一時的に `rw?` を実行して、出た候補を見る。式を目的の形に近づける候補を選び、提案された `rw [...]` に書き直す。 [Lean by Exampleの早見表](https://lean-ja.github.io/lean-by-example/Tactic/index.html) |
| どのタクティクを使うか分からない | 仮定とゴールを日本語で書く。5分ほど止まったら、AIに「このゴールを日本語にして、次の一手のヒントだけ」と頼むか、対応する解答の最初の一行を確認する。 |

[解答](HandsOn/Solutions.lean) は問題番号か定理名で引けます。`sorry` は証明を仮置きするための記号です。Infoviewからゴールが消えても、取り組んだ定理の `sorry` がすべて消えたところで完了としてください。

演習の途中は、いま解いた定理の行から `sorry` の警告が消えたことを確かめます。偶数・奇数の演習を確認するなら、ターミナルに `lake env lean StartHere.lean` と入力します。練習1を終えた日には、翌日用の練習2の警告が残ります。

ファイル全体を解き終えたときは、`-DwarningAsError=true` を付けます。`sorry` が一つでも残っていれば、エラーになります。

```sh
lake env lean -DwarningAsError=true HandsOn/Practice.lean
lake env lean -DwarningAsError=true StartHere.lean
```

教材を編集したときは `bash scripts/check.sh` でビルド、解答、演習ファイルをまとめて検証できます。このチェックでは演習側の `sorry` を許容し、解答側の警告をエラーとして扱います。GitHub Actionsでも同じコマンドを実行します。

## 外部教材は、手が止まった論点から引く

- **タクティクの使い方を日本語で調べる**。`exact`、`intro`、`apply` などを一つずつ引けます。 [Lean by Exampleの早見表](https://lean-ja.github.io/lean-by-example/Tactic/index.html)
- **等式と存在の証明をもう一問解く**。The Mechanics of Proof の例1.2.2と2.5.5が、この教材の続きに向いています。付属の演習は教科書のリポジトリにあります。 [教科書の演習](https://github.com/hrmacbeth/math2001)・[§1.2 等式](https://hrmacbeth.github.io/math2001/01_Proofs_by_Calculation.html#proving-equalities-in-lean)・[§2.5 存在](https://hrmacbeth.github.io/math2001/02_Proofs_with_Structure.html#existence-proofs)・[§3.1 偶奇](https://hrmacbeth.github.io/math2001/03_Parity_and_Divisibility.html#definitions-parity)
- **Leanが何を証明として扱うか確かめる**。`P : Prop` と `h : P` の関係は『Theorem Proving in Lean 4』の3章、ゴールとタクティクの関係は5章で説明されています。 [3章「命題と証明」](https://aconite-ac.github.io/theorem_proving_in_lean4_ja/propositions_and_proofs.html)・[5章「タクティク」](https://aconite-ac.github.io/theorem_proving_in_lean4_ja/tactics.html)

外部教材のコードは、LeanのバージョンやMathlibなどのライブラリに依存することがあります。コードを実行するときは、各教材のセットアップ手順を確認してください。

**用語の早見**　命題は証明の対象になる主張。仮定は、その場で使える値や証明。ゴールは、いま示す命題。タクティクは、証明を組み立てる指示。証人は、存在を示す具体的な値。

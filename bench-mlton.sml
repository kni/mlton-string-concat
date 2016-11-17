fun runBench N name f =
  let
    fun loop 0 f = ()
      | loop i f = (f (); loop (i - 1) f)

    val t0 = Time.now ()
    val _ = loop N f
    val t1 = Time.now ()
  in
    print (name ^ " " ^ Real.toString(Time.toReal(Time.-(t1, t0))) ^ "\n")
  end


fun make_string size c = Byte.bytesToString(Word8Vector.tabulate(size, fn(i) => Byte.charToByte(c)))


fun bench_concat n = 
  let
    val a = "a"
    val b = make_string n #"a"
  in
    runBench 100000 ("string ^ (size is " ^ (Int.toString n) ^ ")") (fn () => (a ^ b; ()))
  end

val _ = bench_concat 1000 (* n - size of string *)


fun bench_concat_list n =
  let
    val l = map (make_string n) [#"a", #"b", #"c", #"d", #"e"]
  in
    runBench 100000 ("concat string list (size is " ^ (Int.toString n) ^ ")") (fn () => (concat l; ()))
  end

val _ = bench_concat_list 3 (* n - size of string *)
val _ = bench_concat_list 1000
val _ = bench_concat_list 10000



fun bench_concat_bcopy n = 
  let
    val a = "a"
    val b = make_string n #"a"

    open MltonStringConcat
    val r = "ab" ^ "cde\n"
  in
    if r = "abcde\n" then () else print ("ERROR: result is " ^ r);
    runBench 100000 ("string ^ with memmove (size is " ^ (Int.toString n) ^ ")") (fn () => (a ^ b; ()))
  end

val _ = bench_concat_bcopy 1000 (* n - size of string *)


fun bench_concat_list_bcopy n =
  let
    val l = map (make_string n) [#"a", #"b", #"c", #"d", #"e"]

    open MltonStringConcat
    val r = concat ["ab", "cde\n"]
  in
    if r = "abcde\n" then () else print ("ERROR: result is " ^ r);
    runBench 100000 ("concat string list with memmove (size is " ^ (Int.toString n) ^ ")") (fn () => (concat l; ()))
  end

val _ = bench_concat_list_bcopy 3 (* n - size of string *)
val _ = bench_concat_list_bcopy 1000
val _ = bench_concat_list_bcopy 10000


fun test_concatWith () =
  let
    open MltonStringConcat
    val r = concatWith "-" ["ab", "cde\n"]
  in
    if r = "ab-cde\n" then () else print ("ERROR: result is " ^ r)
  end
val _ = test_concatWith ()

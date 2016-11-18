structure MltonStringConcat =
struct
  open String
  local
    val bcopy = _import "bcopy_to_pos": Word8Array.array * int * string * int -> unit; (* dst, dst_pos, src, src_len *) 
  in
    fun op ^ (a: string, b: string): string =
      let
        val a_length = String.size a
        and b_length = String.size b
      in
        if a_length = 0 then b else 
        if b_length = 0 then a else
        let
          val arr = Word8Array.arrayUninit (a_length + b_length)
        in
          bcopy(arr, 0, a, a_length);
          bcopy(arr, a_length, b, b_length);
          Byte.bytesToString (Word8Vector.unsafeFromArray arr)
        end
      end

      (* Concatentate a list of strings. *)
      fun concat []  = ""
        | concat [s] = s
        | concat l =
          let
            fun total n []     = n
              | total n (h::t) = total (n + String.size h) t
            val cnt : int = total 0 l
          in
            if cnt = 0 then "" else
            let
              val arr = Word8Array.arrayUninit cnt
            
              fun copy (_, []:string list) = ()
                | copy (i, h::t) =
                  let
                    val h_len = String.size h
                  in
                    bcopy(arr, i, h, h_len);
                    copy(i + h_len, t)
                  end
            in
              copy (0, l);
              Byte.bytesToString (Word8Vector.unsafeFromArray arr)
            end
          end

    fun concatWith _ []     = ""
      | concatWith _ [h]    = h
      | concatWith s (h::t) =
        let
          fun make [] = []
            | make (h::t) = s::h::(make t)
        in
          concat(h::(make t))
        end
  end
end

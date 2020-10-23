# 4 "lexer.mll"
 
  open Lexing
  open Parser

  exception Lexing_error of char

  let kwd_tbl = ["let",LET; "in",IN; "set",SET; "print",PRINT]
  let id_or_kwd s = try List.assoc s kwd_tbl with _ -> IDENT s

  let newline lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = pos.pos_cnum }


# 18 "lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\240\255\241\255\075\000\243\255\245\255\246\255\247\255\
    \248\255\249\255\250\255\085\000\004\000\002\000\002\000\255\255\
    \254\255\003\000\252\255\018\000\252\255\253\255\018\000\020\000\
    \255\255\254\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\013\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\004\000\011\000\002\000\015\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\003\000\003\000\
    \255\255\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\255\255\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\255\255\255\255\017\000\000\000\
    \000\000\017\000\000\000\020\000\000\000\000\000\255\255\255\255\
    \000\000\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\013\000\015\000\013\000\016\000\016\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \013\000\000\000\013\000\014\000\000\000\000\000\000\000\000\000\
    \012\000\004\000\008\000\010\000\006\000\009\000\018\000\007\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\023\000\025\000\022\000\005\000\024\000\000\000\
    \000\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\000\000\255\255\255\255\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\021\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\013\000\014\000\017\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\013\000\000\000\255\255\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\012\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\019\000\022\000\019\000\000\000\023\000\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \011\000\011\000\011\000\011\000\011\000\011\000\011\000\011\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\014\000\017\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\019\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 27 "lexer.mll"
            ( newline lexbuf; token lexbuf )
# 144 "lexer.ml"

  | 1 ->
# 28 "lexer.mll"
                      ( newline lexbuf; token lexbuf )
# 149 "lexer.ml"

  | 2 ->
# 29 "lexer.mll"
            ( token lexbuf )
# 154 "lexer.ml"

  | 3 ->
# 30 "lexer.mll"
            ( comment lexbuf; token lexbuf )
# 159 "lexer.ml"

  | 4 ->
let
# 31 "lexer.mll"
             id
# 165 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 31 "lexer.mll"
                ( id_or_kwd id )
# 169 "lexer.ml"

  | 5 ->
# 32 "lexer.mll"
            ( PLUS )
# 174 "lexer.ml"

  | 6 ->
# 33 "lexer.mll"
            ( MINUS )
# 179 "lexer.ml"

  | 7 ->
# 34 "lexer.mll"
            ( TIMES )
# 184 "lexer.ml"

  | 8 ->
# 35 "lexer.mll"
            ( DIV )
# 189 "lexer.ml"

  | 9 ->
# 36 "lexer.mll"
            ( COMMA )
# 194 "lexer.ml"

  | 10 ->
# 37 "lexer.mll"
            ( EQ )
# 199 "lexer.ml"

  | 11 ->
# 38 "lexer.mll"
            ( LP )
# 204 "lexer.ml"

  | 12 ->
# 39 "lexer.mll"
            ( RP )
# 209 "lexer.ml"

  | 13 ->
let
# 40 "lexer.mll"
               s
# 215 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 40 "lexer.mll"
                 ( CST (int_of_string s) )
# 219 "lexer.ml"

  | 14 ->
# 41 "lexer.mll"
            ( EOF )
# 224 "lexer.ml"

  | 15 ->
let
# 42 "lexer.mll"
         c
# 230 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 42 "lexer.mll"
            ( raise (Lexing_error c) )
# 234 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

and comment lexbuf =
   __ocaml_lex_comment_rec lexbuf 19
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 45 "lexer.mll"
            ( comment lexbuf; comment lexbuf )
# 246 "lexer.ml"

  | 1 ->
# 46 "lexer.mll"
            ( () )
# 251 "lexer.ml"

  | 2 ->
# 47 "lexer.mll"
            ( failwith "commentaire non termine" )
# 256 "lexer.ml"

  | 3 ->
# 48 "lexer.mll"
            ( comment lexbuf )
# 261 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

;;


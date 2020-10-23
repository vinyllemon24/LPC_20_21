
(* Ficheiro principal do compilador arithc *)

open Format
open Lexing

(* Op��o de compila��o, para parar no parsing *)
let parse_only = ref false

(* Nome dos ficheiros fonte e alvo *)
let ifile = ref ""
let ofile = ref ""

let set_file f s = f := s 

(* As op��es do compilador vizualizadas quando se invoca arithc --help *)
let options = 
  ["-parse-only", Arg.Set parse_only, 
   "  performing the parsing stage only";
   "-o", Arg.String (set_file ofile), 
   "<file>  set the output file name"]

let usage = "usage: arithc [option] file.exp"

(* localiza um erro indicando a linha e a coluna*)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l (c-1) c

let () = 
  (* Parsing da linha de comando *)
  Arg.parse options (set_file ifile) usage;

  (* Verifica-se que nome do ficheiro fonte foi convenientemente fornecido *)
  if !ifile="" then begin eprintf "No file to compile\n@?"; exit 1 end; 

  (* Este ficheiro deve ter uma extens�o .exp *)
  if not (Filename.check_suffix !ifile ".exp") then begin
    eprintf "the file to compile must have an .exp extension\n@?";
    Arg.usage options usage;
    exit 1
  end;

  (* Por omiss�o, o ficheiro alvo tem o mesmo nome que o ficheiro fonte, s� a extens�o muda*)
  if !ofile="" then ofile := Filename.chop_suffix !ifile ".exp" ^ ".s";
  
  (* Abertura do ficheiro fonte em modo leitura *)
  let f = open_in !ifile in
    
  (* Cria��o de um buffer de analise l�xica *)
  let buf = Lexing.from_channel f in
  
  try
    (* Parsing: a fun��o Parser.prog transforma o buffer l�xico numa �rvore
       de sintaxe abstrata se nenhum erro (l�xica ou sint�ctica) foi
       detectado.
       A fun��o Lexer.token � utilizada por Parser.prog para obter o pr�ximo
       token. *)
    let p = Parser.prog Lexer.token buf in
    close_in f;
    
    (* Paramos aqui se n�o queremos ir al�m do parsing *)
    if !parse_only then exit 0;
    
    (* Compila��o da �rvore de sintaxe abstrata. O c�digo m�quina resultante
       desta transforma��o deve ser escrito no ficheiro alvo ofile. *)
    Compile.compile_program p !ofile
  with
    | Lexer.Lexing_error c -> 
	(* Erro l�xico. Recuperamos a sua posi��o absoluta e converte-se 
           em n�mero de linhas *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Lexical Error: %c@." c;
	exit 1
    | Parsing.Parse_error -> 
        (* Erro sint�ctico. Recuperamos a posi��o absoluta e converte-se
           em n�mero de linha *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Syntax Error@.";
	exit 1
    | Compile.VarUndef s-> 
	(* Erro de vari�vel durante a compila��o *)
	eprintf 
	  "Compilation Error: Variable %s Undefined@." s;
	exit 1
	






open CaptureIO
open TestSimple

let main() =

plan 9;

(* helper function *)
let printstr_x_times x str =
  let rec range i j = if i > j then [] else i :: (range (i+1) j) in
  List.iter (fun x -> print_string str;print_newline()) (range 1 x)
in

ok true "captureio loaded succesfully";

let result = capture (fun () -> print_int 5) in
is result "5" "captured int";

let result = capture_stdout (fun () -> print_string "hello") in
is result "hello" "captured string";

let result = capture_stderr (fun () -> (printstr_x_times 1 "hello")) in
is result "" "ignored stdout"; 

let sessiontop = start_capture_stdout() in
  print_string("good");
  prerr_string ("error\n");
let sessionbottom = start_capture_stderr() in
  prerr_string ("error1");
  prerr_string ("error2");

let result = finish_capture sessionbottom in
is result  "error1error2" "captured stderr";

let result = finish_capture sessiontop in
is result "good" "only captured stdout";

let x = ref 5 in
let session = start_capture_stdout() in
  x:= 5 + !x;
let result = finish_capture session in 
is result "" "captured nothing";

let filename = "testfile" in
let file_chan = Pervasives.open_out filename in
let file_descr = Unix.descr_of_out_channel file_chan in
let session = start_capture_descr [file_descr] in
  print_string("not captured");
  print_newline();
  Pervasives.output_string file_chan "is captured";
let result = finish_capture session in
is result "is captured" "captured output to descriptor";

let print_to_file = (fun () -> Pervasives.output_string file_chan "test") in
let result = (capture_descr [file_descr] print_to_file) in
is result "test" "short hand works";
Unix.unlink filename;
exit 0;;


main();;


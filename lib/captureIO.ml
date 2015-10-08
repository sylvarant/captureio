open Unix

(*
 * =====================================================================================
 *
 *         Module:  CaptureIO
 *
 *    Description:  Capture the output of a function or block of code,
 *                  similar to how Perl's IO::Capture works
 *
 *         Author:  Ajhl 
 *
 * =====================================================================================
 *)

(* 
  a capture session contains the captured descriptors, their backups 
  and the pipe descriptors
*)
type capture_session = Unix.file_descr list * Unix.file_descr list * Unix.file_descr * Unix.file_descr

(* Raised whenever forking or reading fails *)
exception IOCapture of string


(* 
  Experimental!:
  works without flush all ! due to knowing
  that Pervasives.stdout is to be flushed
*)
let capture_stdout_no_flush arg : string =
  Pervasives.flush Pervasives.stdout;
  let (exitp,entrancep) = Unix.pipe() 
  and backup = Unix.dup Unix.stdout in
  Unix.dup2 entrancep Unix.stdout;
  let _ = arg() in
  Pervasives.flush Pervasives.stdout;
  Unix.close entrancep;
  Unix.dup2 backup Unix.stdout;
  let ls = ref []  
  and channel = (Unix.in_channel_of_descr exitp) in
  try
    while true do
    let line = Pervasives.input_line channel in
        ls := line :: !ls;
    done;
    "never used"
  with _ -> 
    ((String.concat "\n" !ls))


(* 
  capture a list of descriptors by duplicating descriptors 
  return the session info
  -> Something is off with out_channel_of_descr, thus requiring
  the use of flush_all()
*)
let start_capture_ls descriptors =
  Pervasives.flush_all(); (* TODO this is rather harsh? *)
  (*List.iter (fun x -> Pervasives.flush (Unix.out_channel_of_descr x)) descriptors;*)
  let (exitp,entrancep) = Unix.pipe() 
  and backups = List.map Unix.dup descriptors in
  List.iter (Unix.dup2 entrancep) descriptors;
  (descriptors,backups,exitp,entrancep)


(* 
  concatenate the captured data
  -> Something is off with out_channel_of_descr, thus requiring
  the use of flush_all()
*)
let finish_capture (session : capture_session) =
  let (descriptors,backups,exitp,entrancep) = session in
  Pervasives.flush_all(); 
  Unix.close entrancep;
  List.iter2 Unix.dup2 backups descriptors;
  let ls = ref []  
  and channel = (Unix.in_channel_of_descr exitp) in
  try
    while true do
    let line = Pervasives.input_line channel in
        ls := line :: !ls;
    done;
    "never used"
  with End_of_file -> Unix.close exitp; ((String.concat "\n" !ls))
    | _ -> Unix.close exitp; raise (IOCapture "Could not read from captured stream?")


(* simply applies start and finish on the argument *)
let capture_ls descriptors (arg : unit -> 'a) : string =
  let session = start_capture_ls descriptors in
  let _ = arg() in
  (finish_capture session)


(* Capture stdout and stderr *)
let capture arg : string =
  capture_ls [Unix.stdout;Unix.stderr] arg


(* Only capture the stderr channel *)
let capture_stdout arg : string =
  (capture_stdout_no_flush arg)


(* Only capture the stdout channel *)
let capture_stderr arg : string =
  capture_ls [Unix.stderr] arg


(* Capture a specific descriptor *)
let capture_descr descr arg : string =
  capture_ls descr arg


(* Start a session for stdout and stderr *)
let start_capture() : capture_session =
  start_capture_ls [Unix.stdout;Unix.stderr]


(* Start a session for stdout *)
let start_capture_stdout() : capture_session =
  start_capture_ls [Unix.stdout]
   

(* Start a session for stderr *)
let start_capture_stderr() : capture_session =
  start_capture_ls [Unix.stderr]


(* Start a session for a list of descriptors *)
let start_capture_descr descr : capture_session =
  start_capture_ls descr



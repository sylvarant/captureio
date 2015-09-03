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

(* Raised whenever forking or reading fails *)
exception IOCapture of string

(* abstract type for capture data *)
type capture_session

(* Capture output *)
val capture : (unit -> 'a) -> string

(* Only capture the stdout channel *)
val capture_stdout : (unit -> 'a) -> string

(* Only capture the stderr channel *)
val capture_stderr : (unit -> 'a) -> string

(* Capture a list of file descriptors *)
val capture_descr : Unix.file_descr list -> (unit -> 'a) -> string

(* Start a new capturing session to capture multiple lines of code *)
val start_capture : unit -> capture_session

(* Start a new capturing session that only captures stdout *)
val start_capture_stdout : unit -> capture_session

(* Start a new capturing session that only captures stderr *)
val start_capture_stderr : unit -> capture_session

(* Start a new capturing session that captures a list of descriptors *)
val start_capture_descr : Unix.file_descr list -> capture_session

(* Finish a capturing session *)
val finish_capture : capture_session -> string


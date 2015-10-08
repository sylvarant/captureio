
CaptureIO
==========================================
[![Build Status](https://travis-ci.org/sylvarant/captureio.svg)](https://travis-ci.org/sylvarant/captureio)[![Coverage Status](https://coveralls.io/repos/sylvarant/captureio/badge.svg?branch=master&service=github)](https://coveralls.io/github/sylvarant/captureio?branch=master)
---------------------------------------------------------------------------

What is CaptureIO
----------------------

CaptureIO is an [OCaml](http://www.ocaml.org) library 
that captures the terminal print outs of a sequence of code or function,
in a manner similar to Perl's [IO::Capture](http://search.cpan.org/~reynolds/IO-Capture-0.05/lib/IO/Capture.pm).

Usage
-----

To capture the output of a term wrap it in a lambda that takes unit as argument.

```ocaml
let str = capture (fun () -> print_string "hello") in
assert(str = "hello");
```

Alternatively, you can start a capture session to capture the output of a block of code. 

```ocaml
let session = start_capture() in
prerr_string ("error1");
prerr_string ("error2");
let str = (finish_capture session) in
assert(str = "error1error2");
```
It is also possible to capture the output to a specific file descriptor.

```ocaml
let file_chan = Pervasives.open_out "somefile" in
let file_descr = Unix.descr_of_out_channel file_chan in
let session = start_capture_descr [file_descr] in
  print_string("not captured");
  Pervasives.output_string file_chan "is captured";
let result = finish_capture session in
assert(result = "is captured"); 
```

For the full API see the file `lib/capturio.mli` which is fully documented.
For more examples see the tests in `t/01-capture_test.ml`.

## License

[Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0)

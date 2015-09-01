
# CaptureIO
==========================================
[![Build Status](https://travis-ci.org/sylvarant/captureio.svg)](https://travis-ci.org/sylvarant/captureio)
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

For the full API see the file `lib/capturio.mli` which is fully documented.

## License

[Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0)

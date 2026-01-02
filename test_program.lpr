{ Test program to make sure FPC compiler and standard libraries
  are set up. Uses some standard libraries, makes sure that all link OK. }
program test_program;

{$mode objfpc}{$H+}

uses
  // used by CGE and LCL programs that need threads
  {$ifdef UNIX} CThreads, {$endif}
  // make sure using LSOpenCFUrlRef links OK, we had issues with it in the past
  {$ifdef DARWIN} MacOSAll, {$endif}
  // some standard units to make sure we build them OK
  SysUtils, DOM, XMLRead, FpJson;

{$ifdef DARWIN}
function OpenUrl(AUrl: String): Boolean;
var
  cf: CFStringRef;
  url: CFUrlRef;
  FileName: string;
begin
  if AUrl = '' then
    Exit(False);

  cf := CFStringCreateWithCString(kCFAllocatorDefault, @AUrl[1], kCFStringEncodingUTF8);
  if not Assigned(cf) then
    Exit(False);
  url := CFUrlCreateWithString(nil, cf, nil);

  {$ifdef CPUaarch64}
  { TODO: cannot link with LSOpenCFUrlRef on macOS/Aarch64

    Undefined symbols for architecture arm64:
      "_LSOpenCFURLRef", referenced from:
    test_program.lpr(37,25) Error: Error while linking
          _P$TEST_PROGRAM_$$_OPENURL$ANSISTRING$$BOOLEAN in test_program.o
  }
  Result := false;
  {$else}
  Result := LSOpenCFUrlRef(url, nil) = 0;
  {$endif}

  CFRelease(url);
  CFRelease(cf);
end;
{$endif}

begin
  Writeln('Hello World!');
end.

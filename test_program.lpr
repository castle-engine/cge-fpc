{ Test program to make sure FPC compiler and standard libraries
  are set up. Uses some standard libraries, makes sure that all link OK. }
program test_program;

{$mode objfpc}{$H+}

// Needed to compile OpenURL, to pass NSString around
{$ifdef DARWIN}
  {$modeswitch objectivec1}
{$endif}

uses
  // used by CGE and LCL programs that need threads
  {$ifdef UNIX} CThreads, {$endif}
  // for things needed by OpenURL
  {$ifdef DARWIN} MacOSAll, CocoaAll, {$endif}
  // some standard units to make sure we build them OK
  SysUtils, DOM, XMLRead, FpJson;

{$ifdef DARWIN}

// Code from Lazarus LCL lcl/include/sysenvapis_mac.inc .
// See
//   https://gitlab.com/freepascal.org/lazarus/lazarus/-/issues/26890
//   https://gitlab.com/freepascal.org/lazarus/lazarus/-/commit/bde2979aa0fa407e116925dbbadfa53536ab4613
// Open a given URL with the default browser
function OpenURL(AURL: String): Boolean;
var
  url: NSURL;
  ws: NSWorkspace;
begin
  Result := False;
  if AURL = '' then
    Exit;
  url := NSURL.URLWithString(NSString.stringWithUTF8String(@AURL[1]));
  // scheme is checking for "protocol" specifier.
  // if no protocol specifier exist - do not consider it as URL and fail
  if not Assigned(url) or (url.scheme.length = 0) then
    Exit;

  ws := NSWorkspace.sharedWorkspace;
  Result := ws.openURL(url);
end;

{$endif}

begin
  Writeln('Hello World!');
end.

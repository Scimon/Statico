subset ValidDirectoryPath of IO::Path where * ~~ :d;

sub nodupes ( *@a ) { return set(@a).elems == @a.elems }

class Statico {
  has ValidDirectoryPath $!templates-path;
  has ValidDirectoryPath $!data-path;
  has ValidDirectoryPath $!build-path;
  has ValidDirectoryPath $!static-path;

  submethod BUILD(
      Str :$templates-path = "",
      Str :$data-path = "",
      Str :$build-path = "",
      Str :$static-path = "",
  ) {

    if ! nodupes( $templates-path,$data-path,$build-path,$static-path ) {
      fail "Paths must be different"
    }

    $!templates-path := $templates-path.IO;
    $!data-path := $data-path.IO;
    $!build-path := $build-path.IO;
    $!static-path := $static-path.IO;
  }

  # given a folder find all .yaml files and assign them to a channel for processing
  method find-data ( Channel :$data-stream ) {
    my @list = dir $!data-path;
    while @list.pop -> $opt {
      if $opt ~~ :d {
        for dir $opt {
          @list.push($_);
        }
      } elsif $opt ~~ m/\.yaml/ && $opt !~~ m/\/_config/ {
        $data-stream.send( $opt );
      }
    }
    $data-stream.close;
  }
}

=begin pod

=head1 NAME

Statico - Static Website Generator

=head1 SYNOPSIS

=head1 DESCRIPTION

This is mostly an attempt for me to learn Perl6 by building a simple system to
combine markdown files and templates to make a static site.

=head1 AUTHOR

Simon Proctor <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Simon Proctor
This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

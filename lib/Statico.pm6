subset ValidDirectoryPath of IO::Path where * ~~ :d;

sub nodupes ( *@a ) { return set(@a).elems == @a.elems }

use YAMLish;

class Statico:ver<0.0.2>:auth<"Scimon" (simon.proctor@gmail.com)> {
  has ValidDirectoryPath $.templates-path;
  has ValidDirectoryPath $.data-path;
  has ValidDirectoryPath $.build-path;
  has ValidDirectoryPath $.static-path;

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
    my @list = ( $!data-path.IO );
    my %configs = %();
    while @list.pop -> $opt {
      if $opt ~~ :d {
        if ( "{$opt.path}/_config.yaml".IO.e ) {
          %configs{$opt.path} = parse-config(
            config => %configs{$opt.parent.path} // {},
            file => "{$opt.path}/_config.yaml".IO
          );
        } else {
          %configs{$opt.path} = %configs{$opt.parent.path} // {};
        }
        for dir $opt {
          @list.push( $_ );
        }
      } elsif $opt ~~ m/\.yaml/ && $opt !~~ m/_config\.yaml/ {
        $data-stream.send( { file => $opt, config => %configs{$opt.parent.path} // {} } );
      }
    }
    $data-stream.close;
  }
}

sub parse-config ( :%config where Hash, IO::Path :$file ) {
    my %data = load-yaml( $file.slurp );
    { %config, %data };
}

=begin pod

=head1 NAME

Statico - Static Website Generator

=head1 SYNOPSIS

=head1 DESCRIPTION

This is mostly an attempt for me to learn Perl6 by building a simple system to
combine markdown files and templates to make a static site.

=head1 AUTHOR

Scimon <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Simon Proctor
This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

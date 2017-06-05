subset ValidPath of IO::Path where * ~~ :d;

sub nodupes ( *@a ) { return @a.grep( one(@a) ).elems == @a.elems }  

class Statico {
  has ValidPath $!templates-path;
  has ValidPath $!data-path;
  has ValidPath $!build-path;

  submethod BUILD(Str :$templates-path = "",
                  Str :$data-path = "",
                  Str :$build-path = "") {

    # Must be nicer way to do this. (It's kinda cool though)
    if ! nodupes( $templates-path,$data-path,$build-path ) {
      fail "Paths must be different"
    }

    $!templates-path := $templates-path.IO;
    $!data-path := $data-path.IO;
    $!build-path := $build-path.IO;
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

use v6.c;
use lib <lib .>;
use Test;
use Statico;
use t::Env;
use File::Temp;

build-env;

my $statico = Statico.new(
    templates-path => 't/examples/templates',
    data-path => 't/examples/data',
    build-path => 't/examples/build',
    static-path => 't/examples/static',
    );

my $files = Channel.new;

$statico.find-data( data-stream => $files );

my @found = $files.list;

is-deeply( @found, [ "t/examples/data/index.yaml".IO ] );

# Make some tmp folders
my $data-path = tempdir;
my @expected;

for 1..20 {
    my $dir = "{$data-path}/$_";
    mkdir $dir;
    for 1..10 {
        my $file = "{$dir}/{$_}.yaml";
        spurt $file, qq:heredoc/END/;
title: File $_
content: |
  # Heading  
END

        @expected.push( $file.IO );
    }
}

$statico = Statico.new(
    templates-path => 't/examples/templates',
    data-path => $data-path,
    build-path => 't/examples/build',
    static-path => 't/examples/static',
    );

$files = Channel.new;

$statico.find-data( data-stream => $files );

@found = $files.list;

is-deeply( @found.sort, @expected.sort );

done-testing;

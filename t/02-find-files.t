use v6.c;
use lib <lib .>;
use Test;
use Statico;
use t::Env;

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

done-testing;

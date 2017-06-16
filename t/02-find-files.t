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
my @expected = ( { file => "t/examples/data/index.yaml".IO, config => {} }, );

is-deeply( @found, @expected );

# Make some tmp folders
my $data-path = tempdir;
@expected = ();

for 1..20 {
    my $dir = "{$data-path}/$_";
    mkdir $dir;
    for 1..10 {
        my $file = "{$dir}/{$_}.yaml";
        spurt $file, qq:to/END/;
        title: File $_
        content: |
          # Heading
        END
        @expected.push( { file => $file.IO, config => {} } );
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

is-deeply( @found.sort, @expected.sort, "Folder spidering works" );

$data-path = tempdir;

spurt "{$data-path}/_config.yaml", q:to/END/;
test: true
END

spurt "{$data-path}/index.yaml", q:to/END/;
test: true
END

$files = Channel.new;

$statico = Statico.new(
    templates-path => 't/examples/templates',
    data-path => $data-path,
    build-path => 't/examples/build',
    static-path => 't/examples/static',
    );

$statico.find-data( data-stream => $files );

@found = $files.list;
@expected = ( { file => "{$data-path}/index.yaml".IO, config => { test => True } }, );

is-deeply( @found, @expected , "_config files are processed" );

mkdir "{$data-path}/child";

spurt "{$data-path}/child/index.yaml", q:to/END/;
test: true
END

$files = Channel.new;

$statico.find-data( data-stream => $files );

@found = $files.list;
@expected = (
  { file => "{$data-path}/index.yaml".IO, config => { test => True } },
  { file => "{$data-path}/child/index.yaml".IO, config => { test => True } },
);

is-deeply( @found.sort, @expected.sort , "_config files found in children" );

done-testing;

use v6.c;
use lib <lib>;
use Test;
use File::Temp;
use Statico;

# Test requiring the module

my $generator = 'Statico::Generator::Markdown';

try require ::($generator);

ok ::($generator) !~~ 'Failure', "Required OK";

my $md-generator;

my $data-path = tempdir;
my $templates-path = tempdir;
my $static-path = tempdir;
my $build-path = tempdir;

my $statico = Statico.new( data-path => $data-path,
                           templates-path => $templates-path,
                           static-path => $static-path,
                           build-path => $build-path );

dies-ok { $md-generator = ::($generator).new() }, "Generator needs a Statico object";

ok $md-generator = ::($generator).new( statico => $statico ), "Can create a generator. Requires a populated Statico Object";

dies-ok { $md-generator.generate() }, "Needs markdown content";

ok $md-generator.generate( markdown => "# Test" ), "Can call generate with some valid markdown";

is $md-generator.generate( markdown => "# Test" ), "<h1>Test</h1>", "Check the result";

my $complex = q:to/END/;
# Test

## More Test

Test
END

is $md-generator.generate( markdown => $complex ), "<h1>Test</h1><h2>More Test</h2><p>Test</p>", "Complex Markdown";

# Test the directory spider generator
$generator = 'Statico::Generator::DirList';

try require ::($generator);

ok ::($generator) !~~ 'Failure', "Required OK";

my $expected-files = "/index.html : Index\n";
my $expected-dirs = "/directory/ : Directory\n";

my $expected-both = "{$expected-dirs}{$expected-files}";

my $list-generator;

dies-ok { $list-generator = ::($generator).new() }, "Generator needs a Statico Object";

ok $list-generator = ::($generator).new( statico => $statico ), "Can create a generator";

dies-ok { $list-generator.generate() }, "Needs a path and a template";

spurt "{$templates-path}/dir.mustache", q:to/END/;
{{#list}}
{{url}} : {{title}}
{{/list}}
END

mkdir "{$data-path}/directory";

spurt "{$data-path}/index.yaml", q:to/END/;
title: Index
content: |
  # Test
END

spurt "{$data-path}/_config.yaml", q:to/END/;
test: true
END

is $list-generator.generate( dir => $data-path.IO, template => "dir" ), $expected-files, "Basic call makes sense";
is $list-generator.generate( dir => $data-path.IO, template => "dir", files => True, dirs => False ), $expected-files, "Set expected flags files on dirs off";
is $list-generator.generate( dir => $data-path.IO, template => "dir", files => False, dirs => True ), $expected-dirs, "Set expected flags files off dirs on";
is $list-generator.generate( dir => $data-path.IO, template => "dir", files => True, dirs => True ), $expected-both, "Set expected flags files on dirs on";
is $list-generator.generate( dir => $data-path.IO, template => "dir", files => False, dirs => False ), "", "Set expected flags files off dirs off";

done-testing;

use v6.c;
use lib <lib .>;
use Test;
use t::Env;
use File::Temp;

build-env;

# Test requiring the module

my $generator = 'Statico::Generator::Markdown';

try require ::($generator);

ok ::($generator) !~~ 'Failure', "Required OK";

my $md-generator;

ok $md-generator = ::($generator).new(), "Can create a generator";

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

my $list-generator;

ok $list-generator = ::($generator).new(), "Can create a generator";

dies-ok { $list-generator.generate() }, "Needs a path and a template";

# Make a quick test environment
my $data-path = tempdir;

my $template = q:to/END/;
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

my $expected-files = "/index.html : Index\n";
my $expected-dirs = "/directory/ : Directory\n";

my $expected-both = "{$expected-dirs}{$expected-files}";

is $list-generator.generate( dir => $data-path.IO, template => $template ), $expected-files, "Basic call makes sense";
is $list-generator.generate( dir => $data-path.IO, template => $template, files => True, dirs => False ), $expected-files, "Set expected flags files on dirs off";
is $list-generator.generate( dir => $data-path.IO, template => $template, files => False, dirs => True ), $expected-dirs, "Set expected flags files off dirs on";
is $list-generator.generate( dir => $data-path.IO, template => $template, files => True, dirs => True ), $expected-both, "Set expected flags files on dirs on";
is $list-generator.generate( dir => $data-path.IO, template => $template, files => False, dirs => False ), "", "Set expected flags files off dirs off";

done-testing;

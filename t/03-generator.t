use v6.c;
use lib <lib .>;
use Test;
use t::Env;

build-env;

# Test requiring the module
my $generator = 'Statico::Generator::Markdown';
try require ::($generator);
ok ::($generator) !~~ 'Failure', "Required OK";

my $md-generator;

ok $md-generator = ::($generator).new(), "Can create a generator";

ok $md-generator.generate( "# Test" ), "Can call generate with some valid markdown";

is $md-generator.generate( "# Test" ), "<h1>Test</h1>", "Check the result";

my $complex = q:to/END/;
# Test

## More Test

Test
END

is $md-generator.generate( $complex ), "<h1>Test</h1><h2>More Test</h2><p>Test</p>", "Complex Markdown";

done-testing;

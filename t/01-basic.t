use v6.c;
use Test;
use Statico;

dies-ok {
  my $statico = Statico.new();
}, "Statico needs to know the folders to work on.";

dies-ok {
  my $statico = Statico.new(
    templates-path => 't/templates',
    data-path => 't/data',
    build-path => 't/build',
    static-path => 't/static',
  );
},"Given paths need to exists";

dies-ok {
  my $statico = Statico.new(
    templates-path => 't/examples/templates',
    data-path => 't/examples/data',
    build-path => 't/examples/data',
    static-path => 't/examples/static',
  );
},"Given paths must be different";

ok my $statico = Statico.new(
    templates-path => 't/examples/templates',
    data-path => 't/examples/data',
    build-path => 't/examples/build',
    static-path => 't/examples/static',
  ), "Valid paths are OK";

done-testing;

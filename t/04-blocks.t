use v6.c;
use lib <lib>;
use Test;
use File::Temp;
use Statico;

# Setup test environment

my $data-path = tempdir;
my $templates-path = tempdir;
my $static-path = tempdir;
my $build-path = tempdir;

my $statico = Statico.new( data-path => $data-path,
                           templates-path => $templates-path,
                           static-path => $static-path,
                           build-path => $build-path );

# Define a page template

spurt "{$templates-path}/main.mustache", q:to/END/;
{{{header}}}
{{{content}}}
{{{sidebar}}}
{{{footer}}}
END

# Define a site config using the main template

spurt "{$data-path}/_config.yaml", q:to/END/;

END

ok 1, "More tests soon";

done-testing;

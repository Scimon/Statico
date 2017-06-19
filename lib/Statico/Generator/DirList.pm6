use Statico::Generator;
use Template::Mustache;
use YAMLish;

subset ValidDirectoryPath of IO::Path where * ~~ :d;

class Statico::Generator::DirList does Statico::Generator {
    method generate ( ValidDirectoryPath:D :$dir, Str:D :$template,
                      Bool :$files = True, Bool :$dirs = False, Str :$base-url = '/' ) {

        my $stache = Template::Mustache.new;
        my @list = $dir.dir.sort;
        my %data = %( list => Array.new() );
        for @list -> $path {
            next if $path ~~ m! _config\.yaml$ !;
            if ( $path.IO.d ) {
                next unless $dirs;
                my $url = $path;
                $url ~~ s!^.*? (<-[/]>+)$ !{$0}!;
                my $title = $url.tc;
                $url = "{$base-url}{$url}/";
                
                %data{'list'}.push( { url => $url, title => $title } );
            } else {
                next unless $files;
                next unless $path ~~ m!\.yaml$ !;
                my %info = load-yaml( $path.IO.slurp );
                my $url = $path;
                $url ~~ s!^.*? (<-[/]>+) \.yaml$ !{$base-url}{$0}.html!;
                
                %data{'list'}.push( { url => $url, title => %info{'title'} } );
            }
        }
        $stache.render( $template, %data );
    }
}

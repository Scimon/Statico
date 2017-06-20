use Statico::Generator;
use Text::Markdown;

class Statico::Generator::Markdown does Statico::Generator {
    submethod BUILD ( Statico:D :$statico ) {
        # Statico object not needed here yet.
    }

    method generate ( Str:D :$markdown ) {
        my $md = parse-markdown($markdown);
        $md.to_html;
    }
}

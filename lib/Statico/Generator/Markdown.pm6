use Statico::Generator;
use Text::Markdown;

class Statico::Generator::Markdown does Statico::Generator {
    method generate ( $markdown ) {
        my $md = parse-markdown($markdown);
        $md.to_html;
    }
}

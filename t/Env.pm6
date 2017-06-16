unit module t::Env;

sub build-env is export {
    my @l = ( "t/examples/build".IO );
    while shift @l -> $f {
        if $f ~~ :d {
            my @in = dir $f;
            if @in {
                for @in {
                    @l.push($_)
                };
                @l.push($f)
            } else {
                rmdir $f;
            }
        } else {
            unlink $f;
        }
    }

    mkdir "t/examples/build";
}

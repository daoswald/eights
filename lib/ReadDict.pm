package ReadDict;

use strict;
use warnings;

use File::Slurp;

use parent qw(Exporter);
our @EXPORT_OK = qw(dict_read);

sub dict_read {
    my $full_path = shift;
    return [
        map {tr/a-zA-Z//cd; $_}
        read_file($full_path, chomp => 1)
    ];
}

1;


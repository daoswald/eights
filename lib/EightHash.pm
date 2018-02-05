package EightHash;

use strict;
use warnings;
use File::Slurp;
use parent 'Exporter';
our @EXPORT = qw(find_best_letters);
use Data::Dumper;

sub find_best_letters {
    my ($words, $length) = @_;

    my $resp = organize($words, $length);
    my $buckets         = $resp->{'buckets'};
    my $remaining_words = $resp->{'remaining'};

    tally($buckets, $remaining_words);

    my $result = max_bucket($buckets);

    return $result;
}


sub max_bucket {
    my $buckets = shift;
    my $m = 0;
    my $found = '';
    foreach my $bucket_name (keys %$buckets) {
        if ($buckets->{$bucket_name}->{'count'} > $m) {
            $m = $buckets->{$bucket_name}->{'count'};
            $found = $bucket_name;
        }
    }
    return {max => $m, letters => $found};
}
sub tally {
    my ($buckets, $words) = @_;
    BUCKET: foreach my $bucket_name (keys %$buckets) {
        WORD: foreach my $word (@$words) {
            foreach my $letter (keys %$word) {
                if (
                       ! exists $buckets->{$bucket_name}->{$letter}
                    || $word->{$letter} > $buckets->{$bucket_name}->{$letter}
                ) {
                    next WORD;
                }
            }
            $buckets->{$bucket_name}->{'count'}++;
        }
    }
    return $buckets;
}

sub organize {
    my ($dict_words, $threshold) = @_;
    my %buckets;
    my @remaining;
    foreach my $word (@$dict_words) {
        my @letters = sort split //, $word;
        my $bucket  = bucketize(@letters);
        my $key     = join '', @letters;
        if (scalar @letters == $threshold) {
            if(exists $buckets{$key}) {
                $buckets{$key}->{'count'}++;
            }
            else {
                $buckets{$key} = $bucket;
                $buckets{$key}->{'count'}++;
            }
        }
        else {
            push @remaining, $bucket;
        }
    }
    return {buckets => \%buckets, remaining => \@remaining};
}

sub bucketize {
    my @letters = @_;
    my %bucket;
    foreach my $letter (@letters) {
        $bucket{$letter}++;
    }
    return \%bucket;
}

1;

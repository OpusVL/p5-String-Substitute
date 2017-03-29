package String::Substitute;

our $VERSION = '0.007';

use Exporter::Easy (
    OK => [qw/get_all_substitutes/],
);
use Set::CrossProduct;
use Params::Validate qw(:all);
use strictures 2;

sub get_all_substitutes {
    my %params = validate(
        @_, {
            string => { type => SCALAR },
            substitutions => { type => HASHREF },
        }
    );

    my %subs = %{$params{substitutions}};

    my @character_sets = do {
        my @csets;
        my @chars = split //, $params{string};
        for my $char (@chars) {
            if (exists $subs{$char}) {
                push @csets, [ split(//, $subs{$char}) ];
            }
            else {
                push @csets, [ $char ];
            }
        }
        @csets
    };

    my $exploded_results = Set::CrossProduct->new([@character_sets])->combinations;
    my @imploded_results = map { join '', @$_ } @$exploded_results;
    return @imploded_results;
}


1;

# ABSTRACT: generate strings using different combinations of subsitute characters

=head1 SYNOPSIS

    use String::Substitute qw(get_all_substitutes);

    my @results = get_all_substitutes(
        string => 'ABC',
        substitutions => {
            A => 'Aa',
            B => 'Bb',
        },
    );

    say for @results;

would print (with nondeterministic order):

    ABC
    aBC
    AbC
    abC

As a one-liner it might look like this:

    perl -Ilib -MString::Substitute=get_all_substitutes -E 'say for get_all_substitutes(string => "ABC", substitutions => { A => "Aa", B => "Bb" })'

=head1 DESCRIPTION

This module is all about generating strings given an initial string and a set of allowed character substitutions.

=head1 EXPORTS

=head2 get_all_substitutes

Return, as a list, all possible strings that can be generated by applying different combinations of substitutions to
the string passed as the 'string' argument.  See SYNOPSIS for an example.

The order in which the different candidates are returned is not guaranteed.

Takes only keyword arguments:

=over 8

=item string

The string you want to apply the substitutions on.

=item substitutions

A HASHREF mapping each substitutable character to a string of different characters that it may be replaced with.

e.g. {A => "Aa", B => "Bb"} means that each occurrence of A will be replaced with an 'A', or an 'a', in the returned substitutions.

=back

=head1 SUPPORT

If you require assistance, support, or further development of this software, please contact OpusVL using the details below:

Telephone: +44 (0)1788 298 410

Email: community@opusvl.com

Web: L<http://opusvl.com>

=cut

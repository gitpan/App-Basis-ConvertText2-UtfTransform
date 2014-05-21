# ABSTRACT: Convert ascii text into UTF8 to simulate text formatting

=head1 NAME

App::Basis::ConvertText2::UtfTransform

=head1 SYNOPSIS

    use 5.10.0 ;
    use strict ;
    use warnings ;
    use App::Basis::ConvertText2::UtfTransform

    my $string = "<b>bold text</b> 
    <i>italic text</i>
    <m>mirrored and reversed text</m>
    <f>flipped upside down text</f>
    <t>tiny text</t>
    <l>Some Leet speak</l>
    " ;

    say utf_transform( $string) ;

=head1 DESCRIPTION

A number of popular websites (eg twitter) do not allow the use of HTML to create
bold/italic font effects.

However we can simulate this with some clever transformations of plain ascii text
into UTF8 codes which are a different font and so effectively create the same effect.

We have transformations for mirror (reverses the string too, flip (upside down),
tiny, bold, italic and leet.

We can transform A-Z a-z 0-9 and ? ! ,

See Also L<http://txtn.us/>

=head1 Notes

I currently do not have correct UTF codes for mirror, tiny or flip

=cut

package App::Basis::ConvertText2::UtfTransform;
$App::Basis::ConvertText2::UtfTransform::VERSION = '0.1.0';
use 5.014;
use warnings;
use strict;
use Acme::LeetSpeak;
use Exporter;
use vars qw( @EXPORT @ISA);

@ISA = qw(Exporter);

# this is the list of things that will get imported into the loading packages
# namespace
@EXPORT = qw(
    utf_transform
);

# ----------------------------------------------------------------------------

# UTF8 codes to transform normal ascii to different UTF8 codes
# to perform text effects that can be used on websites that allow UTF8 but
# do not allow HTML codes

# ----------------------------------------------------------------------------

my %mirror = (
    "A" => "A",
    "B" => "\x{1660}",
    "C" => "Æ†",
    "D" => "á—¡",
    "E" => "ÆŽ",
    "F" => "á–·",
    "G" => "áŽ®",     # need a good G
    "H" => "H",
    "I" => "I",
    "J" => "á‚±",
    "K" => "á´",
    "L" => "â…ƒ",
    "M" => "M",
    "N" => "Ð˜",
    "O" => "O",
    "P" => "êŸ¼",     #  or try á‘«
    "Q" => "á»Œ",
    "R" => "Ð¯",
    "S" => "Æ§",
    "T" => "T",
    "U" => "U",
    "V" => "V",
    "W" => "W",
    "X" => "X",
    "Y" => "Y",
    "Z" => "Æ¸",       # need a good Z
    "a" => "É’",
    "b" => "d",
    "c" => "É”",
    "d" => "b",
    "e" => "É˜",
    "f" => "Ê‡",
    "g" => "Ç«",
    "h" => "Êœ",
    "i" => "i",
    "j" => "á‚±",
    "k" => "Êž",
    "l" => "l",
    "m" => "m",
    "n" => "n",
    "o" => "o",
    "p" => "q",
    "q" => "p",
    "r" => "É¿",
    "s" => "Æ¨",
    "t" => "Æš",
    "u" => "u",
    "v" => "v",
    "w" => "w",
    "x" => "x",
    "y" => "y",
    "z" => "z",
    "0" => "0",
    "1" => "1",
    "2" => "2",
    "3" => "Æ¸",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "!" => "!",
    "?" => "âš",
    "," => "â",
);

my %flip = (
    "A" => "á—„",
    "B" => "á—·",
    "C" => "âŠ‚",
    "D" => "D",
    "E" => "E",
    "F" => "á–¶",
    "G" => "â…",
    "H" => "H",
    "I" => "I",
    "J" => "á˜ƒ",
    "K" => "Êž",
    "L" => "â…‚",
    "M" => "Ê",
    "N" => "N",
    "O" => "O",
    "P" => "b",
    "Q" => "âµš",
    "R" => "á–‰",
    "S" => "á´¤",
    "T" => "âŠ¥",
    "U" => "âˆ©",
    "V" => "â‹€",
    "W" => "M",
    "X" => "X",
    "Y" => "â…„",
    "Z" => "Z",          # need better
    "a" => "É",
    "b" => "p",
    "c" => "â…½",
    "d" => "q",
    "e" => "Ó©",
    "f" => "Êˆ",
    "g" => "É“",
    "h" => "Âµ",
    "i" => "!",
    "j" => "É¾",
    "k" => "Êž",
    "l" => "êž",
    "m" => "w",
    "n" => "u",
    "o" => "o",
    "p" => "b",
    "q" => "d",
    "r" => "Ê",
    "s" => "Æ¨",
    "t" => "Ê‡",
    "u" => "âˆ©",
    "v" => "Ù¨",
    "w" => "Ê",
    "x" => "x",
    "y" => "ÊŽ",
    "z" => "z",
    "0" => "0",
    "1" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "!" => "Â¡",
    "?" => "Â¿",
    "," => "â",
);

my %tiny = (
    "A" => "á´¬",
    "B" => "á´®",
    "C" => "á¶œ",
    "D" => "á´°",
    "E" => "á´±",
    "F" => "á¶ ",      # needs a proper capital
    "G" => "á´³",
    "H" => "á´´",
    "I" => "á´µ",
    "J" => "á´¶",
    "K" => "á´·",
    "L" => "á´¸",
    "M" => "á´¹",
    "N" => "á´º",
    "O" => "á´¼",
    "P" => "á´¾",
    "Q" => "á‘«",    # needs a better char
    "R" => "á´¿",
    "S" => "Ë¢",
    "T" => "áµ€",
    "U" => "áµ",
    "V" => "â±½",
    "W" => "áµ‚",
    "X" => "Ë£",
    "Y" => "Ê¸",
    "Z" => "á¶»",
    "a" => "áµƒ",
    "b" => "áµ‡",
    "c" => "á¶œ",
    "d" => "áµˆ",
    "e" => "áµ‰",
    "f" => "á¶ ",
    "g" => "áµ",
    "h" => "Ê°",
    "i" => "á¶¦",     # this one â± is a problem
    "j" => "Ê²",
    "k" => "áµ",
    "l" => "á¶«",
    "m" => "áµ",
    "n" => "á¶°",     # because â¿ looks bad
    "o" => "áµ’",
    "p" => "áµ–",
    "q" => "á‘«",    # needs a better char
    "r" => "Ê³",
    "s" => "Ë¢",
    "t" => "áµ—",
    "u" => "áµ˜",
    "v" => "áµ›",
    "w" => "Ê·",
    "x" => "Ë£",
    "y" => "Ê¸",
    "z" => "á¶»",
    "0" => "â°",
    "1" => "Â¹",
    "2" => "Â²",
    "3" => "Â³",
    "4" => "â´",
    "5" => "âµ",
    "6" => "â¶",
    "7" => "â·",
    "8" => "â¸",
    "9" => "â¹",
    "?" => "ï¹–",
    "!" => "ï¹—",
    "," => ",",
);

my %bold = (
    "A" => "\x{1D400}",
    "B" => "\x{1D401}",
    "C" => "\x{1D402}",
    "D" => "\x{1D403}",
    "E" => "\x{1D404}",
    "F" => "\x{1D405}",
    "G" => "\x{1D406}",
    "H" => "\x{1D407}",
    "I" => "\x{1D408}",
    "J" => "\x{1D409}",
    "K" => "\x{1D40A}",
    "L" => "\x{1D40B}",
    "M" => "\x{1D40C}",
    "N" => "\x{1D40D}",
    "O" => "\x{1D40E}",
    "P" => "\x{1D40F}",
    "Q" => "\x{1D410}",
    "R" => "\x{1D411}",
    "S" => "\x{1D412}",
    "T" => "\x{1D413}",
    "U" => "\x{1D414}",
    "V" => "\x{1D415}",
    "W" => "\x{1D416}",
    "X" => "\x{1D417}",
    "Y" => "\x{1D418}",
    "Z" => "\x{1D419}",
    "a" => "\x{1D41A}",
    "b" => "\x{1D41B}",
    "c" => "\x{1D41C}",
    "d" => "\x{1D41D}",
    "e" => "\x{1D41E}",
    "f" => "\x{1D41F}",
    "g" => "\x{1D420}",
    "h" => "\x{1D421}",
    "i" => "\x{1D422}",
    "j" => "\x{1D423}",
    "k" => "\x{1D424}",
    "l" => "\x{1D425}",
    "m" => "\x{1D426}",
    "n" => "\x{1D427}",
    "o" => "\x{1D428}",
    "p" => "\x{1D429}",
    "q" => "\x{1D42A}",
    "r" => "\x{1D42B}",
    "s" => "\x{1D42C}",
    "t" => "\x{1D42D}",
    "u" => "\x{1D42E}",
    "v" => "\x{1D42F}",
    "w" => "\x{1D430}",
    "x" => "\x{1D431}",
    "y" => "\x{1D432}",
    "z" => "\x{1D433}",
    "0" => "\x{1D7CE}",
    "1" => "\x{1D7CF}",
    "2" => "\x{1D7D0}",
    "3" => "\x{1D7D1}",
    "4" => "\x{1D7D2}",
    "5" => "\x{1D7D3}",
    "6" => "\x{1D7D4}",
    "7" => "\x{1D7D5}",
    "8" => "\x{1D7D6}",
    "9" => "\x{1D7D7}",
    "?" => "?",
    "!" => "!",
    "," => ",",
);

my %italic = (
    "A" => "\x{1D434}",
    "B" => "\x{1D435}",
    "C" => "\x{1D436}",
    "D" => "\x{1D437}",
    "E" => "\x{1D438}",
    "F" => "\x{1D439}",
    "G" => "\x{1D43A}",
    "H" => "\x{1D43B}",
    "I" => "\x{1D43C}",
    "J" => "\x{1D43D}",
    "K" => "\x{1D43E}",
    "L" => "\x{1D43F}",
    "M" => "\x{1D440}",
    "N" => "\x{1D441}",
    "O" => "\x{1D442}",
    "P" => "\x{1D443}",
    "Q" => "\x{1D444}",
    "R" => "\x{1D445}",
    "S" => "\x{1D446}",
    "T" => "\x{1D447}",
    "U" => "\x{1D448}",
    "V" => "\x{1D449}",
    "W" => "\x{1D44A}",
    "X" => "\x{1D44B}",
    "Y" => "\x{1D44C}",
    "Z" => "\x{1D44D}",
    "a" => "\x{1D44E}",
    "b" => "\x{1D44F}",
    "c" => "\x{1D450}",
    "d" => "\x{1D451}",
    "e" => "\x{1D452}",
    "f" => "\x{1D453}",
    "g" => "\x{1D454}",
    "h" => "\x{1D455}",
    "i" => "\x{1D456}",
    "j" => "\x{1D457}",
    "k" => "\x{1D458}",
    "l" => "\x{1D459}",
    "m" => "\x{1D45A}",
    "n" => "\x{1D45B}",
    "o" => "\x{1D45C}",
    "p" => "\x{1D45D}",
    "q" => "\x{1D45E}",
    "r" => "\x{1D45F}",
    "s" => "\x{1D460}",
    "t" => "\x{1D461}",
    "u" => "\x{1D462}",
    "v" => "\x{1D463}",
    "w" => "\x{1D464}",
    "x" => "\x{1D465}",
    "y" => "\x{1D466}",
    "z" => "\x{1D467}",
    "0" => "0",
    "1" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "?" => "?",
    "!" => "!",
    "," => ",",
);

my %code_map = (
    # m => \%mirror,
    # f => \%flip,
    # t => \%tiny,
    b => \%bold,
    i => \%italic,
) ;

# ----------------------------------------------------------------------------
sub _transform {
    my ($code, $string) = @_ ;
    my $transform = 1 ;

    if( $code eq 'm') {
        # mirror needs to be reversed
        $string = reverse $string ;
    } elsif( $code eq 'l') {
        # leet
        $string = leet( $string) ;
        $transform = 0 ;
    }

    if( $transform && $code_map{ $code}) {
        $string =~ s/([A-ZA-z0-9?!,])/$code_map{$code}->{$1}/gsm ;
    }

    return $string ;
}

# ----------------------------------------------------------------------------

# transform A-ZA-z0-9!?, into UTF8 forms suitable for websites that do not allow
# HTML codes for these
# we use the following psuedo HTML elements
# mirrored <m>text</m>
# flip     <f>text</f>
# tiny     <t>text</t>
# bold     <b>text</b>
# italic   <i>text</i>

sub utf_transform {
    my ($in) = @_;

    $in =~ s|<(\w)>(.*?)</\1>|_transform( $1, $2)|egsi;

    return $in;
}

# ----------------------------------------------------------------------------
1;

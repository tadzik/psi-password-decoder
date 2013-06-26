#!/usr/bin/perl
use XML::DOM::XPath;

sub decode_password {
    my ($pw, $jid) = @_;
    my ($cpw, $n, @pw) = ('', 0, split //, $pw);
    while (@pw) {
        my $x;
        $x += hex (shift @pw) * 4096;
        $x += hex (shift @pw) * 256;
        $x += hex (shift @pw) * 16;
        $x += hex (shift @pw);
        $cpw .= chr ($x ^ ord(substr $jid, $n, 1));
        $n++;
        $n = $n >= length $pw ? 0 : $n;
    }
    $cpw
}

my $parser = XML::DOM::Parser->new;
my $doc = $parser->parsefile ("$ENV{HOME}/.psi/profiles/default/accounts.xml");
for ($doc->findnodes ('/accounts/accounts/*')) {
    my $jid = $_->findnodes ('jid');
    my $pw  = $_->findnodes ('password');
    my $cpw = decode_password ($pw, $jid);
    print "$jid\t$cpw\n";
}

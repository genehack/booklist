package Booklist;

# $Id$
# $URL$

use warnings;
use strict;

use version; our $VERSION = qv('0.0.1');

use DateTime;
use FindBin;

use lib "$FindBin::Bin/../lib";
use Booklist::DB;

my $db;
sub db_handle {
  return $db if $db;
    
  ### FIXME should get location of database from config or env 
  chdir "$FindBin::RealBin/..";
  $db = Booklist::DB->connect(
    'dbi:SQLite:db/booklist.db',
    q{}, q{}, { AutoCommit => 1 } ,
  );

  return $db;

}
  
sub ymd2epoch {
  my( $date )  = @_;
  
  die "Date must be in YYYYMMDD format"
    unless $date =~ /^\d{8}$/;
    
  my( $yr , $mo , $dy ) = $date =~ /^(\d{4})(\d{2})(\d{2})$/;

  my $t;
  eval {
    $t = DateTime->new(
      year  => $yr , 
      month => $mo ,
      day   => $dy ,
    );
  };
  die $@ if $@;
  
  return $t->epoch;
}  







1; # Magic true value required at end of module



__END__

=head1 NAME

Booklist - Convenience functions for the 'booklist' application. 

=head1 SYNOPSIS

You don't use this directly. 

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

John SJ Anderson  C<< <genehack@genehack.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, John SJ Anderson C<< <genehack@genehack.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

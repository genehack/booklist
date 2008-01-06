package Booklist::DB::Reading;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ DBIx::Class /;

__PACKAGE__->load_components( qw/ PK::Auto Core / );

__PACKAGE__->table( 'readings' );

__PACKAGE__->add_columns( qw/ id book startdate finishdate rating / );

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->belongs_to( book => 'Booklist::DB::Book' );


sub calc_reading_duration {
  my( $self ) = @_;

  my $start    = DateTime->from_epoch( epoch => $self->startdate()  );
  my $finish   = DateTime->from_epoch( epoch => $self->finishdate() );
  my $duration = $finish - $start;

  die "Couldn't calculate duration" unless $duration;
    
  my( $mo , $dy ) = $duration->in_units( 'months' , 'days'  );

  my $dys = 's';
  $dys = '' if $dy == 1;
    
  if ( $mo ) {
    my $mos = '';
    $mos = 's' if $mo > 1;

    $duration = sprintf "%d month%s, %d day%s" , $mo , $mos , $dy , $dys;
  }
  else {
    $duration = sprintf "%d day%s" , $dy , $dys; 
  }
  
  return $duration;
}



1; # Magic true value required at end of module



__END__

=head1 NAME

Booklist::DB::Reading - DBIC table class for the 'reading' table.

=head1 SYNOPSIS

Autoloaded by DBIC framework. 

=head1 INTERFACE

=head2 calc_reading_duration

    my $duration = $reading->calc_reading_duration();

Calculates and returns the time between the 'start' and 'finish' times of a
reading object.


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

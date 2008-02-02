package Booklist::DB::Book;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ DBIx::Class /;

__PACKAGE__->load_components( qw/ PK::Auto Core / );

__PACKAGE__->table( 'books' );

__PACKAGE__->add_columns( qw/ id pages title added / );

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many( authorsbooks => 'Booklist::DB::AuthorBook' => 'book' );
__PACKAGE__->has_many( bookstags    => 'Booklist::DB::BookTag'    => 'book' );
__PACKAGE__->has_many( readings     => 'Booklist::DB::Reading' );

__PACKAGE__->many_to_many( authors => 'authorsbooks' , 'author' );
__PACKAGE__->many_to_many( tags    => 'bookstags'    , 'tag'    );


sub added_as_ymd {
  my( $self ) = @_;
  return DateTime->from_epoch( epoch => $self->added() )->ymd;
}

1; # Magic true value required at end of module




__END__

=head1 NAME

Booklist::DB::Book - DBIC table class for the 'book' table.

=head1 SYNOPSIS

Autoloaded by DBIC framework. 

=head1 INTERFACE

=head2 added_as_ymd

    my $ymd_date = $reading->start_as_ymd();

Returns the time the book was added as a YMD-formatted date.



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

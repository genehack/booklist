package Booklist::Cmd::Command::import;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use YAML qw/ LoadFile /;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Booklist;

sub usage_desc { "%c import" }

sub opt_spec {
  (
    [ 'file|f=s' , 'YAML formatted file to import from' ] ,
  )
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  $self->usage_error('Need to give a file to import from')
    unless $opt->{file};
  
  $self->usage_error('No such file') unless -e $opt->{file};
  $self->usage_error(q|Can't read that file|) unless -r $opt->{file};
  
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $yaml = LoadFile( $opt->{file} );
  
  my $db = Booklist->db_handle();

  foreach ( sort { $a <=> $b } keys %$yaml ) {
    $opt->{title}  = $yaml->{$_}{title};
    $opt->{pages}  = $yaml->{$_}{pages};
    
    $opt->{author} = [ $yaml->{$_}{author} ];
    
    $opt->{startdate} = Booklist->ymd2epoch( $yaml->{$_}{start} );

    $opt->{finishdate} = undef;
    if ( $yaml->{$_}{finish} ) {
      $opt->{finishdate} = Booklist->ymd2epoch( $yaml->{$_}{finish} )
    }

    my $book = Booklist->add_book( $opt );
    
    my $reading = Booklist->start_reading( $opt , $book );

    printf "Added reading for '%s' (start = %s ; finish = %s)\n" ,
      $book->title , $yaml->{$_}{start} , $yaml->{$_}{finish} || 'NEVER';
    
  }
}



1; # Magic true value required at end of module

__END__

=head1 NAME

Booklist::Cmd::Command::authors - list all authors from database

=head1 SYNOPSIS

Start reading a book



    booklist start --title $TITLE --author $AUTHOR --pages $PAGES [ --startedate $YYYYMMDD ]

    booklist start -t $TITLE -a $AUTHOR -p $PAGES [ -d $YYYYMMDD ]

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

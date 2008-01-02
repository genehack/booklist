package Booklist::Cmd::Command::list;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Booklist;

sub usage_desc { "%c list %o" }

sub opt_spec {
  (
    [ 'all|a' , 'list all books in database' ] ,
    [ 'read|r' , 'list all read books in database' ] ,
    [ 'unfinished|u' , 'list all unread books in database (default if nothing else specified)' ],
  );
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  if(     $opt->{all}  ) { $opt->{LIST} = 'all'  }
  elsif ( $opt->{read} ) { $opt->{LIST} = 'read' }
  else                   { $opt->{LIST} = 'unfinished' }
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db = Booklist->db_handle();

  my $search;
  if ( $opt->{LIST} eq 'all' ) {
    $search = {};
  }
  elsif ( $opt->{LIST} eq 'read' ) {
    $search = {
      startdate  => { '!=' , 'NULL' } ,
      finishdate => { '!=' , 'NULL' } ,
    };
  }
  else {
   $search = {
      startdate  => { '!=' , 'NULL' } ,
      finishdate => undef
    };
  }

  my $readings = $db->resultset('Reading')->search( $search , { order_by => 'startdate' });

  exit unless $readings->count;
    
  my $count = 1;
  while ( my $reading = $readings->next) {
    my $book    = sprintf "%3d:\n%s" , $count , $reading->book->title;
    my $names   = join ' & ' , map { $_->author } $reading->book->authors;

    my $time    = sprintf "  STARTED: %d" , Booklist->epoch2ymd( $reading->startdate );
    if ( $reading->finishdate ) {
      my $duration = Booklist->calc_reading_duration( $reading );
      $time = sprintf "%s    FINISHED: %d   ($duration)" ,
        $time , Booklist->epoch2ymd( $reading->finishdate );
    }

    print <<EOL;
$book by $names
$time

EOL
  
    $count++;
  }
  
  exit;

  
}


1; # Magic true value required at end of module

__END__

=head1 NAME

Booklist::Cmd::Command::list - list books in the database

=head1 SYNOPSIS

    booklist list [ --all ] [ --read ] [ --unfinished ]
    booklist list [ -a ] [ -r ] [ -u ]
    booklist list

Defaults to showing unfinished books. 

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

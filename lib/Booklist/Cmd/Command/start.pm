package Booklist::Cmd::Command::start;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Booklist;

sub opt_spec {
  (
    [ 'title|t=s'           , 'book title (required)'      ] , 
    [ 'author|a=s@'         , 'book author (required)'     ] , 
    [ 'pages|p=s'           , 'book page count (required)' ] ,
    [ ] ,
    [ 'startdate|start|d=s' , 'date started reading (optional; defaults to today)' ] ,
  );
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  if ( $opt->{startdate} ) {
    eval {
      $opt->{startdate} = Booklist->ymd2epoch( $opt->{startdate} ); 
    };
    $self->usage_error( $@ ) if ( $@ );
  }

  foreach my $var ( qw/ title author pages / ) {
    $self->usage_error( "$var is a required option" )
      unless $opt->{$var};
  }

}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db = Booklist->db_handle();

  my @authors;
  foreach my $author ( @{ $opt->{author} } ) {
    push @authors , $db->resultset('Author')->find_or_create({ author => $author });
  }
  
  my $book = $db->resultset('Book')->find_or_create({
    title  => $opt->{title} ,
    pages  => $opt->{pages} ,
  });

  foreach my $author ( @authors ) {
    $db->resultset('AuthorBook')->find_or_create({
      author => $author->id ,
      book   => $book->id   ,
    });
  }
  
  $book->update();
    
  my $startdate;
  if ( $opt->{startdate} ) {
    $startdate = $opt->{startdate};
  }
  else {
    $startdate = time();
  }

  my $reading_count = $db->resultset('Reading')->find({
    book       => $book->id ,
    finishdate => undef ,
  });
  
  if ( $reading_count ) {
    my $start = DateTime->from_epoch( epoch => $reading_count->startdate() )->ymd;
    my $title = $book->title;
    
    print STDERR <<EOL;
You seem to already be reading that book
You started it on $start and have not yet recorded a finish date
Use 'booklist finish --title "$title"' to finish this reading.
EOL
  
    exit(1);
    
  }
  
  my $reading = $db->resultset('Reading')->create( {
    book       => $book->id  ,
    startdate  => $startdate ,
    finishdate => undef      ,
  } );

  my $title = $book->title;
  print "Started to read '$title'\n";
  exit;
}


1; # Magic true value required at end of module

__END__

=head1 NAME

Booklist::Cmd::Command::start - start reading a book

=head1 SYNOPSIS

    booklist start --title $TITLE --author $AUTHOR --pages $PAGES [ --date $YYYYMMDD ]
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

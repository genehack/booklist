package App::Booklist::CLI::COMPLETION_BASE;
use Moose;
use namespace::autoclean;
use 5.010;
extends 'App::Booklist::CLI::BASE';
with 'MooseX::SimpleConfig';

use Date::Format;
use Date::Parse;

has id => (
  isa => 'Int' , is => 'rw' ,
  documentation => 'ID of reading being finished' ,
  traits => [ qw(Getopt) ] ,
  cmd_aliases => 'i' ,
  required => 1 ,
);

has date => (
  isa => 'Str' , is => 'rw' ,
  documentation => 'Date reading was finished' ,
  traits => [ qw(Getopt) ] ,
  cmd_aliases => 'd' ,
);

has rating => (
  isa => 'Int' , is => 'rw' ,
  documentation => 'Rating on a 1-5 scale' ,
  traits => [ qw(Getopt) ] ,
  cmd_aliases => 'r' ,
);

has review => (
  isa => 'Str' , is => 'rw' ,
  documentation => 'Review of this reading' ,
  traits => [ qw(Getopt) ] ,
  cmd_aliases => 'R' ,
);

sub complete_reading {
  my( $self ) = @_;

  my $time = ( $self->date ) ? str2time( $self->date ) : time;
  $self->date( time2str( '%Y-%m-%d' , $time ));

  my $schema  = $self->get_schema;

  my $reading = $schema->resultset( 'Readings' )->find( $self->id )
    or $self->usage_error( 'Unable to locate reading with ID=' . $self->id );

  $self->usage_error( 'That book is not currently being read.' )
    if ( $reading->finish ne 'NOT DONE' );

  my $update_hash = { finish => $self->date };
  $update_hash->{review}   = $self->review if $self->review;
  $update_hash->{rating}   = $self->rating if $self->rating;
  $update_hash->{finished} = ( $self->dnf ) ? 0 : 1;

  $reading->update( $update_hash )->discard_changes;

  my $verb = ( $self->dnf ) ? 'Stopped' : 'Finished';

  printf "%s reading book '%s' (reading ID=%d) on %s\n" ,
    $verb , $reading->book->title , $reading->id , $reading->finish;
}

1;

__END__

=head1 NAME

App::Booklist::CLI::COMPLETION_BASE - base class for commands that complete readings

=head1 AUTHOR

John SJ Anderson, C<< <genehack at genehack.org> >>

=head1 METHODS

=head2 complete_reading

Updates a reading object to indicate that the reading has been stopped or
finished, depending on the value of the 'dnf' (Did Not Finish) flag.

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-booklist at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Booklist>.  I will be
notified, and then you'll automatically be notified of progress on your bug as
I make changes.

=head1 LICENSE AND COPYRIGHT

Copyright 2010 John SJ Anderson.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

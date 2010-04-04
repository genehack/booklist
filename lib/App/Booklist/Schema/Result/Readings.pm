package App::Booklist::Schema::Result::Readings;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->load_components(
  'InflateColumn::DateTime' ,
  'TimeStamp' ,
);

__PACKAGE__->table( 'readings' );

__PACKAGE__->add_columns(
  'id'            => { data_type => 'INTEGER'  , is_auto_increment => 1 } ,
  'book_id'       => { data_type => 'INTEGER'  , is_foreign_key => 1    } ,
  'start'         => { data_type => 'DATE'     , accessor => '_start'   } ,
  'finish'        => { data_type => 'DATE'     , accessor => '_finish'  , is_nullable => 1 } ,
  'last_modified' => { data_type => 'DATETIME' , set_on_create => 1     , set_on_update => 1 } ,
  'rating'        => { data_type => 'INTEGER'  , size => 1 , is_nullable => 1 } ,
  'review'        => { data_type => 'TEXT'     , is_nullable => 1 } ,
);

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->belongs_to(
  'book' => 'App::Booklist::Schema::Result::Books' ,
  { 'foreign.id' => 'self.book_id' } ,
);

sub start {
  my( $self ) = shift;

  return $self->_start( @_ ) if @_;

  my $start = $self->_start;
  return $start->ymd('.');
}

sub finish {
  my( $self ) = shift;

  return $self->_finish( @_ ) if @_;

  return $self->_finish ? $self->_finish->ymd('.') : 'NOT DONE YET';
}

sub duration {
  my( $self ) = shift;

  my $start  = $self->_start;
  my $finish = $self->_finish;

  return ( $start and $finish ) ? $finish - $start : undef;
}

1;

__END__

=head1 NAME

App::Booklist::Schema::Readings - the readings table

=head1 AUTHOR

John SJ Anderson, C<< <genehack at genehack.org> >>

=head1 METHODS

=head2 start

Returns the date the reading was started, formatted appropriately for display.

=head2 finish

Returns the date the reading was started, formatted appropriately for display,
or the string 'NOT DONE YET' if the reading hasn't been completed.

=head2 duration

Returns the time between the start and finish of the reading, formatted
appropriately for display, or undef if the reading hasn't been completed.

Returns the

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

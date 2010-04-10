package App::Booklist::Schema::Result::Authors;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'authors' );

__PACKAGE__->add_columns(
  'id'    => { data_type => 'INTEGER' , is_auto_increment => 1 } ,
  'lname' => { data_type => 'TEXT'    , size => 255 } ,
  'fname' => { data_type => 'TEXT'    , size => 255 } ,
);

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many(
  'author_books' => 'App::Booklist::Schema::Result::AuthorBooks' ,
  { 'foreign.author_id' => 'self.id' } ,
);

__PACKAGE__->many_to_many( 'books' , 'author_books' , 'book' );

sub full_name {
  my( $self ) = shift;

  return sprintf '%s %s' , $self->fname , $self->lname;
}

1;

__END__

=head1 NAME

App::Booklist::Schema::Authors - the authors table

=head1 AUTHOR

John SJ Anderson, C<< <genehack at genehack.org> >>

=head1 METHODS

=head2 full_name

Returns a properly formatted name string for the author

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

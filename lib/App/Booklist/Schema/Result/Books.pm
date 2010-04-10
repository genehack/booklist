package App::Booklist::Schema::Result::Books;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'books' );

__PACKAGE__->add_columns(
  'id'      => { data_type => 'INTEGER' , is_auto_increment => 1 } ,
  'title'   => { data_type => 'VARCHAR' , size => 255 } ,
  'isbn'    => { data_type => 'VARCHAR' , size => 13  , is_nullable => 1 } ,
  'pages'   => { data_type => 'INTEGER' , size => 5   , is_nullable => 1 } ,
  'pubyear' => { data_type => 'INTEGER' , size => 4   , is_nullable => 1 } ,
);

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many(
  'author_books' => 'App::Booklist::Schema::Result::AuthorBooks' ,
  { 'foreign.book_id' => 'self.id' } ,
);
__PACKAGE__->many_to_many( 'authors' , 'author_books' , 'author' );

__PACKAGE__->has_many(
  'book_tags' => 'App::Booklist::Schema::Result::BookTags' ,
  { 'foreign.book_id' => 'self.id' } ,
);
__PACKAGE__->many_to_many( 'tags' , 'book_tags' , 'tag' );

__PACKAGE__->has_many(
  'readings' => 'App::Booklist::Schema::Result::Readings' ,
  { 'foreign.book_id' => 'self.id' } ,
);

sub author_list {
  my( $self ) = @_;

  my @authors = ();

  push @authors , $_->full_name
    foreach ( $self->authors );

  if ( @authors == 2 ) { return join ' & ' , @authors }
  else {
    $authors[-1] = "& $authors[-1]";
    return join ', ' , @authors;
  }
}

1;

__END__

=head1 NAME

App::Booklist::Schema::Books - the books table

=head1 AUTHOR

John SJ Anderson, C<< <genehack at genehack.org> >>

=head1 METHODS

=head2 author_list

Returns a properly formatted list of authors for the book

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

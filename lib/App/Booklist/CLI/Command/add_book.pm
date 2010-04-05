use MooseX::Declare;

class App::Booklist::CLI::Command::add_book extends App::Booklist::CLI::BASE {
  use 5.010;

  has title => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'Book title' ,
    traits => [ qw(Getopt)] ,
    cmd_aliases => 't' ,
    required => 1 ,
  );

  has author_id => (
    isa => 'ArrayRef[Num]' , is => 'rw' ,
    documentation => 'Book author database ID (can be given multiple times)' ,
    traits => [ qw(Getopt) ] ,
    cmd_aliases => 'a' ,
    required => 1 ,
  );

  has pages => (
    isa => 'Int' , is => 'rw' ,
    documentation => 'Number of pages in the book' ,
    traits => [ qw(Getopt) ] ,
    cmd_aliases => 'p' ,
  );

  has isbn => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'ISBN for the book (optional)' ,
    traits => [ qw(Getopt) ] ,
    cmd_aliases => 'i' ,
  );

  has tag => (
    isa => 'ArrayRef[Str]' , is => 'rw' ,
    documentation => 'Book tag name (can be given multiple times)' ,
    traits => [ qw(Getopt) ] ,
  );

  has tag_id => (
    isa => 'ArrayRef[Num]' , is => 'rw' ,
    documentation => 'Book tag database ID (can be given multiple times)' ,
    traits => [ qw(Getopt) ] ,
    cmd_aliases => 'T' ,
  );

  method execute ( $opt , $args ) {
    if ( $opt->{isbn} ) {
      $opt->{isbn} = $self->validate_isbn( $opt->{isbn} );
    }

    my $schema = $self->get_schema;

    my $create_args = {
      title => $self->title ,
    };
    $create_args->{pages} = $self->pages
      if $self->pages;
    $create_args->{isbn} = $self->isbn
      if $self->isbn;

    my $book = $schema->resultset('Books')->create( $create_args );

    foreach ( @{ $self->author_id } ) {
      my $author = $schema->resultset('Authors')->find($_);
      $book->add_to_authors( $author );
    };

    if ( $self->tag ) {
      foreach ( @{ $self->tag }) {
        $book->add_to_tags({ name => $_ });
      }
    }

    if ( $self->tag_id ) {
      foreach ( @{ $self->tag_id }) {
        my $tag = $schema->resultset( 'Tags' )->find($_);
        $book->add_to_tags( $tag );
      }
    }

    printf "Added book '%s' (ID=%d)\n" , $book->title , $book->id;
  }
}

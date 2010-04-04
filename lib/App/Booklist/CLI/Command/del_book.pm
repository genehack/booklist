use MooseX::Declare;

class App::Booklist::CLI::Command::del_book extends App::Booklist::CLI::BASE {
  use 5.010;

  has id => (
    isa => 'Num' , is => 'rw' ,
    documentation => 'ID of book to delete' ,
    traits => [ qw(Getopt)] ,
    required => 1 ,
  );

  method execute ( $opt , $args ) {
    my $schema = $self->get_schema();

    if ( my $book = $schema->resultset('Books')->find($self->id) ) {
      $book->delete;
      printf "Deleted book (ID=%d)\n" , $self->id;
    }
    else {
      printf STDERR "ERROR: Unable to find book with ID=%d\n" , $self->id;
      exit(1);
    }
  }
}

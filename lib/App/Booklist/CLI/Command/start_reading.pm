use MooseX::Declare;

class App::Booklist::CLI::Command::start_reading extends App::Booklist::CLI::BASE {
  use 5.010;
  use Date::Format;
  use Date::Parse;

  has id => (
    isa => 'Int' , is => 'rw' ,
    documentation => 'ID of book being read' ,
    traits => [ qw(Getopt) ] ,
    cmd_aliases => 'i' ,
    required => 1 ,
  );

  has date => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'Date reading was started' ,
    traits => [ qw(Getopt) ] ,
    cmd_aliases => 'd' ,
  );

  method execute ( $opt , $args ) {
    my $time = ( $self->date ) ? str2time( $self->date ) : time;
    $self->date( time2str( '%Y-%m-%d' , $time ));

    my $schema  = $self->get_schema;

    my $book = $schema->resultset( 'Books' )->find( $self->id )
      or $self->usage_error( 'Unable to locate book with ID=' . $self->id );

    foreach my $prev_reading ( $book->readings ) {
      if ( $prev_reading->finish eq 'NOT DONE' ) {
        $self->usage_error( 'That book is already being read.' );
      }
    }

    my $reading = $schema->resultset( 'Readings' )->create({
      book_id => $book->id ,
      start   => $self->date ,
    });

    printf "Started reading book '%s' (reading ID=%d) on %s\n" ,
      $reading->book->title , $reading->id , $reading->start;
  }
}

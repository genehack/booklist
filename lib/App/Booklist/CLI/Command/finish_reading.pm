use MooseX::Declare;

class App::Booklist::CLI::Command::finish_reading extends App::Booklist::CLI::BASE {
  use 5.010;
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

  has dnf => (
    isa => 'Bool' , is => 'rw' ,
    documentation => 'Flag indicating that this reading was stopped, not finished' ,
    traits => [ qw(Getopt) ] ,
  );

  method execute ( $opt , $args ) {
    my $time = ( $self->date ) ? str2time( $self->date ) : time;
    $self->date( time2str( '%Y-%m-%d' , $time ));

    my $schema  = $self->get_schema;

    my $reading = $schema->resultset( 'Readings' )->find( $self->id )
      or $self->usage_error( 'Unable to locate reading with ID=' . $self->id );

    if ( $reading->finish ne 'NOT DONE YET' ) {
      $self->usage_error( 'That book is not currently being read.' )
    };

    my $update_hash = { finish => $self->date };
    $update_hash->{review} = $self->review if $self->review;
    $update_hash->{rating} = $self->rating if $self->rating;
    $update_hash->{finished} = ( $self->dnf ) ? 0 : 1;

    $reading->update( $update_hash )->discard_changes;

    my $verb = ( $self->dnf ) ? 'Stopped' : 'Finished';

    printf "%s reading book '%s' (reading ID=%d) on %s\n" ,
      $verb , $reading->book->title , $reading->id , $reading->finish;
  }
}

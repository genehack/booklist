use MooseX::Declare;

class App::Booklist::CLI::Command::del_tag extends App::Booklist::CLI::BASE {
  use 5.010;

  has id => (
    isa => 'Num' , is => 'rw' ,
    documentation => 'ID of tag to delete' ,
    traits => [ qw(Getopt)] ,
  );

  has name => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'Name of tag to delete' ,
    traits => [ qw(Getopt) ] ,
  );

  method validate_args ( $opt , $args ){
    $self->usage_error( "Only one of '--id' or '--name' may be specified." )
      if ( $opt->{id} and $opt->{name} );

    $self->usage_error( "Required option missing: one of '--id' or '--name' must be given." )
      unless( $opt->{id} or $opt->{name} );
  }

  method execute ( $opt , $args ){
    my $schema = $self->get_schema();

    my $field = ( $self->id ) ? 'id'      : 'name';
    my $value = ( $self->id ) ? $self->id : $self->name;

    if ( my $tag = $schema->resultset('Tags')->find({ $field => $value }) ) {
      $tag->delete;
      printf "Deleted tag (%s=%s)\n" , $field , $value;
    }
    else {
      printf STDERR "ERROR: Unable to find tag with %s=%d\n" , $field , $value;
      exit(1);
    }
  }
}

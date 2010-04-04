use MooseX::Declare;

class App::Booklist::CLI::Command::add_tag extends App::Booklist::CLI::BASE {
  use 5.010;

  has name => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'Tag name' ,
    traits => [ qw(Getopt)] ,
    cmd_aliases => 'n' ,
    required => 1 ,
  );

  method execute ( $opt , $args ){
    my $schema = $self->get_schema_and_deploy_db_if_needed();

    my $tag = $schema->resultset('Tags')->find_or_create({
      name => $self->name ,
    });

    printf "Added tag '%s' (ID=%d)\n" ,
      $tag->name , $tag->id;
  }
}

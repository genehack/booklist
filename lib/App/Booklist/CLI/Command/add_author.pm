use MooseX::Declare;

class App::Booklist::CLI::Command::add_author extends App::Booklist::CLI::BASE {
  use 5.010;

  has first => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'First name of author' ,
    traits => [ qw(Getopt)] ,
    cmd_aliases => 'f' ,
    required => 1 ,
  );

  has last  => (
    isa => 'Str' , is => 'rw' ,
    documentation => 'Last name of author' ,
    traits => [ qw(Getopt)] ,
    cmd_aliases => 'l' ,
    required => 1 ,
  );

  method execute ( $opt , $args ) {
    my $schema = $self->get_schema_and_deploy_db_if_needed();

    my $author = $schema->resultset('Authors')->create({
      lname => $self->last ,
      fname => $self->first ,
    });

    printf "Added author '%s %s' (ID=%d)\n" ,
      $author->fname , $author->lname , $author->id;
  }
}

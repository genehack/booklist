use MooseX::Declare;

class App::Booklist::CLI::Command::add_author extends App::Booklist::CLI::BASE {
  use 5.010;
  use App::Booklist::Schema;
  use App::Booklist::CLI::Command::make_database;

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

  sub execute {
    my( $self , $opt , $args ) = @_;

    my $db = $self->file;

    App::Booklist::CLI::Command::make_database->deploy_db( $db )
        unless -e $db;

    my $schema = App::Booklist::Schema->connect( "dbi:SQLite:$db" );

    my $author = $schema->resultset('Authors')->create({
      lname => $self->last ,
      fname => $self->first ,
    });

    printf "Added author '%s %s' (ID=%d)\n" ,
      $author->fname , $author->lname , $author->id;
  }
}

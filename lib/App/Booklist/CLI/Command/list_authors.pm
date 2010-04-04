use MooseX::Declare;

class App::Booklist::CLI::Command::list_authors extends App::Booklist::CLI::BASE {
  use 5.010;
  use App::Booklist::Schema;

  sub execute {
    my( $self , $opt , $args ) = @_;

    my $db = $self->file;

    unless ( -e $db ) {
      printf STDERR <<EOM and exit(1);
ERROR: Unable to connect to database.
Do you need to run 'make_database'?
EOM
    }

    my $schema = App::Booklist::Schema->connect( "dbi:SQLite:$db" );

    my $fstring = "%3s %-30s %-40s\n";

    printf $fstring, 'ID' , 'First Name', 'Last Name';
    printf $fstring, '=' x 3 , '=' x 30 , '=' x 40;

    foreach my $author ( $schema->resultset('Authors')->all) {
      printf $fstring , $author->id , $author->fname , $author->lname;
    };
  }
}

use MooseX::Declare;

class App::Booklist::CLI::Command::make_database extends App::Booklist::CLI::BASE {
  use 5.010;
  use App::Booklist::Schema;
  use File::Basename;
  use File::Path      qw/ make_path /;
  use FindBin;

  has force => (
    isa => 'Bool' , is => 'rw' ,
    documentation => 'Overwrite existing file.',
    traits => [qw(Getopt)] ,
    default => 0 ,
  );

  method execute ( $opt , $args ) {
    my $db = $self->file;

    if ( ! $self->force and -e $db ) {
      print STDERR "ERROR: Refusing to overwrite existing database at $db";
      exit(1);
    }

    __PACKAGE__->deploy_db( $db );

    say "Created database at $db";
  }

  method deploy_db ( $class: $db ) {
    my $path = dirname( $db );
    make_path( $path );

    my $add_drop_flag = ( -e $db ) ? 1 : 0;

    if ( my $schema = App::Booklist::Schema->connect( "dbi:SQLite:$db" )) {
      $schema->deploy({ add_drop_table => $add_drop_flag });
    }
  }
};

package App::Booklist::Command::make_database;

# $Id$
# $URL$

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use File::SearchPath qw/ searchpath /;

use FindBin;
use lib "$FindBin::Bin/../lib";

use App::Booklist;

sub usage_desc { "%c make_database" }

sub opt_spec {
  (
    [ 'force' , 'overwrite an existing database' ] ,
  );
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db_file = App::Booklist->db_location();

  if ( -e $db_file ) {
    if ( $opt->{force} ) {
      unlink $db_file;
      if ( -e $db_file ) {
        print STDERR "Problem removing existing database\n";
        exit(1);
      }
    }
    else {
      print STDERR "Won't replace existing database without --force\n";
      exit(1);
    }
  }

  my $db = App::Booklist->db_handle( missing_ok => 1 );
  $db->deploy( { add_drop_table => 0 } );
  
  print "Created database at $db_file\n";
  
}


1; # Magic true value required at end of module

__END__

=head1 NAME

App::Booklist::Command::make_database - create a new empty booklist database in the default location

=head1 SYNOPSIS

    booklist make_database [ --force ]

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

John SJ Anderson  C<< <genehack@genehack.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, John SJ Anderson C<< <genehack@genehack.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.


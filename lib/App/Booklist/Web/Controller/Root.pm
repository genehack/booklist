package App::Booklist::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use App::Booklist::Form::Setup;

__PACKAGE__->config(namespace => '');

sub begin :Private {
  my( $self , $c ) = @_;

  unless ( -e $c->config->{file} ) {
    $c->model( 'DB' )->schema->deploy();
  }

  if ( my $user = $c->model( 'DB::User' )->find({ id =>1 }) ) {
    $c->stash( user => $user );
  }
  else {
    my $form = App::Booklist::Form::Setup->new();
    if ( $form->process( params => $c->request->parameters )) {
      $c->model( 'DB::User' )->create({
        id       => 1 ,
        username => $form->value->{username} ,
        password => $form->value->{password} ,
      });
      return;
    }
    else {
      $c->stash(
        form     => $form ,
        template => 'setup.tt' ,
      );
      $c->detach()
    }
  }
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body( $c->welcome_message );
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

App::Booklist::Web::Controller::Root - Root Controller for App::Booklist::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

=head2 default

Standard 404 error page

=cut

=head2 end

Attempt to render a view, if needed.

=cut

=head1 AUTHOR

John SJ Anderson

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

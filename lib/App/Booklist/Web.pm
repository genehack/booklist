package App::Booklist::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple

    StackTrace

    Authentication

    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->config(
  disable_component_resolution_regex_fallback => 1,
  name => 'App::Booklist::Web',
  'Plugin::Authentication' => {
    default => {
      class         => 'SimpleDB' ,
      user_model    => 'DB::User' ,
      password_type => 'clear' ,
    } ,
  } ,
  'Plugin::ConfigLoader' => { file => 'booklist.yaml' } ,
);

__PACKAGE__->setup();

=head1 NAME

App::Booklist::Web - Catalyst based application

=head1 SYNOPSIS

    script/app_booklist_web_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<App::Booklist::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

John SJ Anderson

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

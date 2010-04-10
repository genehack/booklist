#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst;  # Complain loudly if you don't have
                                # Catalyst::Devel installed or haven't said
                                # 'make dist' to create a standalone tarball.

name     'App-Booklist';
all_from 'lib/App/Booklist.pm';
author   q{John SJ Anderson <genehack@genehack.org>};
license  'perl';

requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Runtime' => '5.80022';
requires 'Config::General';
requires 'Moose';
requires 'namespace::autoclean';

test_requires 'Test::More' => '0.88';

install_script glob('script/*.pl');

auto_install;

WriteAll;

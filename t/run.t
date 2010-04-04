#! /usr/bin/env perl

use lib 't/tests';
use My::Test::CLI::Command::make_database;
use My::Test::CLI::Command::add_author;
use My::Test::CLI::Command::del_author;
use My::Test::CLI::Command::list_authors;

Test::Class->runtests;

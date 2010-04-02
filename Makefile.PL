use inc::Module::Install;

name     'App-Booklist';
all_from 'lib/App/Booklist.pm';
author   q{John SJ Anderson <genehack@genehack.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

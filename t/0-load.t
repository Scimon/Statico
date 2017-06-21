#!/usr/bin/env perl6

use v6.c;

use Test;
#use lib <lib>;

use-ok 'Statico', "Main Module loads OK";
use-ok 'Statico::Generator::Markdown', "Markdown Module loads OK";
use-ok 'Statico::Generator::DirList', "DirList Module loads OK";

done-testing;

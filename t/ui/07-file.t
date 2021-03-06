# Copyright (C) 2014-2016 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

BEGIN {
    unshift @INC, 'lib';
    $ENV{OPENQA_TEST_IPC} = 1;
}

use Mojo::Base -strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use Test::Mojo;
use Test::Warnings;
use Mojo::File;
use OpenQA::Test::Case;

use OpenQA::WebSockets;
use OpenQA::Scheduler;

# create Test DBus bus and service for fake WebSockets and Scheduler call
my $ws = OpenQA::WebSockets->new;
my $sh = OpenQA::Scheduler->new;

my $test_case = OpenQA::Test::Case->new;
$test_case->init_data;

my $t = Test::Mojo->new('OpenQA::WebAPI');

# Exact size of logpackages-1.png
$t->get_ok('/tests/99938/images/logpackages-1.png')->status_is(200)->content_type_is('image/png')
  ->header_is('Content-Length' => '48019');

$t->get_ok('/tests/99937/../99938/images/logpackages-1.png')->status_is(404);

$t->get_ok('/tests/99938/images/thumb/logpackages-1.png')->status_is(200)->content_type_is('image/png')
  ->header_is('Content-Length' => '6769');

# Not the same logpackages-1.png
$t->get_ok('/tests/99946/images/logpackages-1.png')->header_is('Content-Length' => '211');

$t->get_ok('/tests/99938/images/doesntexist.png')->status_is(404);

$t->get_ok('/tests/99938/images/thumb/doesntexist.png')->status_is(404);

$t->get_ok('/tests/99938/file/video.ogv')->status_is(200)->content_type_is('video/ogg');

$t->get_ok('/tests/99938/file/serial0.txt')->status_is(200)->content_type_is('text/plain;charset=UTF-8');

$t->get_ok('/tests/99938/file/y2logs.tar.bz2')->status_is(200);

$t->get_ok('/tests/99938/file/ulogs/y2logs.tar.bz2')->status_is(404);

sub write_file {
    my ($path, $content) = @_;
    local $/;    # enable 'slurp' mode
    open my $fh, ">", $path;
    print $fh $content;
    close $fh;
}

subtest 'needle download' => sub {
    # clean leftovers from previous run
    my $needle_dir = Mojo::File->new('t/data/openqa/share/tests/opensuse/needles');
    $needle_dir->remove_tree();

    $t->get_ok('/needles/opensuse/inst-timezone-text.png')->status_is(404, '404 if image not present');
    $t->get_ok('/needles/1/image')->status_is(404, '404 if image not present');
    $t->get_ok('/needles/1/json')->status_is(404, '404 if json not present');

    # create fake json file and image

    $needle_dir->make_path();
    my $json
      = '{"area" : [{"height": 217, "type": "match", "width": 384, "xpos": 0, "ypos": 0},{"height": 60, "type": "exclude", "width": 160, "xpos": 175, "ypos": 45}], "tags": ["inst-timezone"]}';
    write_file("$needle_dir/inst-timezone-text.png",  "png\n");
    write_file("$needle_dir/inst-timezone-text.json", $json);

    $t->get_ok('/needles/opensuse/inst-timezone-text.png')->status_is(200)->content_type_is('image/png')
      ->content_is("png\n");
    $t->get_ok('/needles/1/image')->status_is(200)->content_type_is('image/png')->content_is("png\n");
    $t->get_ok('/needles/1/json')->status_is(200)->content_type_is('application/json;charset=UTF-8')->content_is($json);
};


# check the download links
my $req = $t->get_ok('/tests/99946')->status_is(200);
$req->element_exists('#downloads #asset_1');
$req->element_exists('#downloads #asset_5');
my $res = OpenQA::Test::Case::trim_whitespace($req->tx->res->dom->at('#downloads #asset_1')->text);
is($res, "openSUSE-13.1-DVD-i586-Build0091-Media.iso");
is($req->tx->res->dom->at('#downloads #asset_1')->{href},
    '/tests/99946/asset/iso/openSUSE-13.1-DVD-i586-Build0091-Media.iso');
$res = OpenQA::Test::Case::trim_whitespace($req->tx->res->dom->at('#downloads #asset_5')->text);
is($res,                                                  "openSUSE-13.1-x86_64.hda");
is($req->tx->res->dom->at('#downloads #asset_5')->{href}, '/tests/99946/asset/hdd/openSUSE-13.1-x86_64.hda');

# downloads are currently redirects
$req = $t->get_ok('/tests/99946/asset/1')->status_is(302)
  ->header_like(Location => qr/(?:http:\/\/localhost:\d+)?\/assets\/iso\/openSUSE-13.1-DVD-i586-Build0091-Media.iso/);
$req = $t->get_ok('/tests/99946/asset/iso/openSUSE-13.1-DVD-i586-Build0091-Media.iso')->status_is(302)
  ->header_like(Location => qr/(?:http:\/\/localhost:\d+)?\/assets\/iso\/openSUSE-13.1-DVD-i586-Build0091-Media.iso/);

$req = $t->get_ok('/tests/99946/asset/5')->status_is(302)
  ->header_like(Location => qr/(?:http:\/\/localhost:\d+)?\/assets\/hdd\/fixed\/openSUSE-13.1-x86_64.hda/);

# verify error on invalid downloads
$t->get_ok('/tests/99946/asset/iso/foobar.iso')->status_is(404);

$t->get_ok('/tests/99961/asset/repo/testrepo/README')->status_is(302)
  ->header_like(Location => qr/(?:http:\/\/localhost:\d+)?\/assets\/repo\/testrepo\/README/);
$t->get_ok('/tests/99961/asset/repo/testrepo/README/../README')->status_is(400)
  ->content_is('invalid character in path');

# download_asset is handled by apache normally, but make sure it works - important for fullstack test
$t->get_ok('/assets/repo/testrepo/README')->status_is(200);
$t->get_ok('/assets/iso/openSUSE-13.1-DVD-i586-Build0091-Media.iso')->status_is(200);


# TODO: also test repos


SKIP: {
    skip "FIXME: allow to download only assets related to a test", 1;

    $req = $t->get_ok('/tests/99946/asset/2')->status_is(400);
}

done_testing();

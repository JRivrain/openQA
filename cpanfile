requires 'Archive::Extract';
requires 'BSD::Resource';
requires 'CSS::Minifier::XS', '>= 0.01';
requires 'Carp';
requires 'Clone';
requires 'Config::IniFiles';
requires 'Crypt::DH::GMP';
requires 'Cwd';
requires 'DBD::SQLite';
requires 'DBD::Pg';
requires 'DBIx::Class';
requires 'DBIx::Class::Core';
requires 'DBIx::Class::DeploymentHandler';
requires 'DBIx::Class::DynamicDefault';
requires 'DBIx::Class::OptimisticLocking';
requires 'DBIx::Class::ResultClass::HashRefInflator';
requires 'DBIx::Class::Schema';
requires 'DBIx::Class::Storage::Statistics';
requires 'Data::Dump';
requires 'Data::Dumper';
requires 'Data::OptList';
requires 'Date::Format';
requires 'DateTime';
requires 'DateTime::Duration';
requires 'DateTime::Format::Pg';
requires 'Digest::MD5';
requires 'Exporter';
requires 'Fcntl';
requires 'File::Basename';
requires 'File::Copy';
requires 'File::Copy::Recursive';
requires 'File::Path';
requires 'File::Spec';
requires 'FindBin';
requires 'Getopt::Long';
requires 'IO::Handle';
requires 'IO::Socket::SSL';
requires 'IPC::Cmd';
requires 'IPC::Run';
requires 'Cpanel::JSON::XS';
requires 'JavaScript::Minifier::XS', '>= 0.11';
requires 'LWP::UserAgent';
requires 'List::MoreUtils';
requires 'MRO::Compat';
requires 'Module::Implementation';
requires 'Module::Load::Conditional';
requires 'Module::Runtime';
requires 'Mojo::Base';
requires 'Mojo::ByteStream';
requires 'Mojo::IOLoop';
requires 'Mojo::IOLoop::ReadWriteProcess';
requires 'Mojo::JSON';
requires 'Mojo::RabbitMQ::Client';
requires 'Mojo::URL';
requires 'Mojo::Util';
requires 'Mojolicious', '>= 7.24';
requires 'Mojolicious::Commands';
requires 'Mojolicious::Plugin';
requires 'Mojolicious::Plugin::AssetPack';
requires 'Mojolicious::Static';
requires 'Net::DBus';
requires 'Net::OpenID::Consumer';
requires 'Package::Stash';
requires 'Params::Util';
requires 'Params::Validate';
requires 'Regexp::Common';
requires 'Sort::Versions';
requires 'SQL::SplitStatement';
requires 'SQL::Translator';
requires 'Scalar::Util';
requires 'Sub::Install';
requires 'Sub::Name';
requires 'Text::Markdown';
requires 'Time::HiRes';
requires 'Time::ParseDate';
requires 'Time::Piece';
requires 'Time::Seconds';
requires 'URI::Escape';
requires 'URI::Heuristic';
requires 'URI::URL';
requires 'URI::WithBase';
requires 'URI::data';
requires 'Pod::POM';
requires 'base';
requires 'constant';
requires 'diagnostics';
requires 'namespace::clean';
requires 'strict';
requires 'warnings';
requires 'POSIX';

on 'test' => sub {
  requires 'Perl::Critic';
  requires 'Perl::Tidy', '>= 20180101, != 20180219';
  requires 'Selenium::Remote::Driver', '>= 1.23';
  requires 'Test::Compile';
  requires 'Test::Fatal';
  requires 'Test::MockModule';
  requires 'Test::MockObject';
  requires 'Test::Mojo';
  requires 'Test::More';
  requires 'Test::Output';
  requires 'Test::Pod';
  requires 'Test::Warnings';
};

feature 'coverage', 'coverage for travis' => sub {
  requires 'Devel::Cover';
  requires 'Devel::Cover::Report::Codecov';
};

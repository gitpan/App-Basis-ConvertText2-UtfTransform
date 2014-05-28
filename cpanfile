requires "Acme::LeetSpeak" => "0";
requires "App::Basis" => "0";
requires "Exporter" => "0";
requires "Text::Emoticon" => "0";
requires "perl" => "5.014";
requires "strict" => "0";
requires "vars" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Test::More" => "0";
  requires "perl" => "5.014";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};

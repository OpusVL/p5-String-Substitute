requires "perl" => "5.006";
requires "Exporter::Easy";
requires "Params::Validate";
requires "List::Gather";
requires "Data::Munge";
requires "strictures";

on build => sub {
    requires "Test::Most";
    requires "Test::Pod";
    requires "Test::Pod::Coverage";
    requires "Pod::Coverage::TrustPod";
};
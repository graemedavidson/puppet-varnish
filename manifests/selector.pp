# selector.pp
define varnish::selector ($condition, $newurl = undef, $movedto = undef,) {
  $template = $varnish::vcl::version ? {
    4       => 'varnish/includes/backendselection.vcl.4.erb',
    default => 'varnish/includes/backendselection.vcl.erb'
  }

  concat::fragment { "${title}-selector":
    target  => "${varnish::vcl::includedir}/backendselection.vcl",
    content => template($template),
    order   => '03',
  }

}

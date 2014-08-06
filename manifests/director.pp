# director.pp
define varnish::director ($type = 'round-robin', $backends = [],) {
  validate_re($title, '^[A-Za-z0-9_]*$', "Invalid characters in director name ${title}. Only letters, numbers and underscore are allowed."
  )

  $template = $varnish::vcl::version ? {
    4       => 'varnish/includes/directors.vcl.4.erb',
    default => 'varnish/includes/directors.vcl.erb'
  }

  concat::fragment { "${title}-director":
    target  => "${varnish::vcl::includedir}/directors.vcl",
    content => template($template),
    order   => '02',
  }
}

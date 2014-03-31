class base {
	group {"puppet": ensure => "present", }
	exec { "apt-update":
	command => "/usr/bin/apt-get -y update",
	}

	package { ["build-essential", "curl", "libmagick++-dev", "imagemagick"]:
	ensure => installed,
	require => Exec["apt-update"],
	}
}

include base
include mongodb
include rvm
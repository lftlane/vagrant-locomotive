class rvm {
    package {
      ["openssl", "libreadline6", "libreadline6-dev",
      "git-core", "zlib1g","zlib1g-dev", "libssl-dev", "libyaml-dev",
      "libsqlite3-dev", "sqlite3", "libxml2-dev", "libxslt1-dev", "autoconf",
      "libc6-dev", "libncurses5-dev", "automake", "libtool", "bison",
      "subversion", "libfontconfig1"]:
      ensure => installed,
      before => Exec['download']
    }

    exec {
      "download":
          path    => ["/bin", "/usr/bin", "/usr/local/bin"],
          command => "curl -L get.rvm.io >> /tmp/rvm",
          logoutput => on_failure,
          creates => "/tmp/rvm",
          user    => "vagrant",
          group   => "vagrant",
    }

    exec {
      "install":
          path    => ["/bin", "/usr/bin", "/usr/local/bin"],
          command => "bash /tmp/rvm stable",
          environment => ["USER=vagrant", "HOME=/home/vagrant"],
          unless  => "ls /home/vagrant/.rvm/bin/rvm",
          logoutput => on_failure,
          returns => [0, 1],
          user    => "vagrant",
          group   => "vagrant",
          require => Exec['download'],
    }
    
    exec {
      "install-ruby":
          path    => [
            "/bin", "/usr/bin", "/usr/local/bin",
            "/usr/local/rvm/bin", "/home/vagrant/.rvm/bin"
          ],
          environment => ["USER=vagrant", "HOME=/home/vagrant"],
          command => "/home/vagrant/.rvm/bin/rvm install 1.9.2",
          logoutput => on_failure,
          unless  => "ls /home/vagrant/.rvm/rubies/ruby-1.9.2*/bin/ruby",
          timeout => 0,
          user    => "vagrant",
          group   => "vagrant",
          require => Exec['install'],
    }

    exec {
      "gem-update":
          path => [
            "/bin", "/usr/bin",
            "/usr/local/bin",
            "/usr/local/rvm/bin",
            "/home/vagrant/.rvm/bin"
          ],
          logoutput => on_failure,
          environment => ["USER=vagrant", "HOME=/home/vagrant"],
          command => "bash -c 'source \"/home/vagrant/.rvm/scripts/rvm\";\
            rvm --default use ruby-1.9.2;\
            gem update --system'",
          returns => [0, 1],
          user    => "vagrant",
          group   => "vagrant",
          require => Exec['install-ruby'],
    }

    exec {
      "bundler":
          path    => ["/bin", "/usr/bin", "/usr/local/bin",],
          command => "bash -c 'source \"/home/vagrant/.rvm/scripts/rvm\";\
            rvm use ruby-1.9.2;\
            gem install --no-rdoc --no-ri bundler'",
          environment => ["USER=vagrant", "HOME=/home/vagrant"],
          returns => [0, 1],
          user    => "vagrant",
          group   => "vagrant",
          require => Exec['gem-update'],
    }

    exec {
      "rails":
          path        => ["/bin", "/usr/bin", "/usr/local/bin",],
          command     => "bash -c 'source \"/home/vagrant/.rvm/scripts/rvm\";\
            rvm use ruby-1.9.2;\
            gem install --no-rdoc --no-ri rake -v \'0.9.2.2\';\
            gem install --no-rdoc --no-ri rails -v \'3.1\''",
          timeout     => 0,
          environment => ["USER=vagrant", "HOME=/home/vagrant"],
          returns     => [0, 1],
          user        => "vagrant",
          group       => "vagrant",
          require     => Exec['bundler'],
    }
}
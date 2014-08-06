require 'spec_helper'

describe 'varnish', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :lsbdistid              => 'Debian',
        :lsbdistcodename        => 'precise'
      }
    end
    
    it { should compile }
    it { should contain_class('varnish::install').with('add_repo' => 'true') }
    it { should contain_class('varnish::service').with('start' => 'yes') }
    it { should contain_class('varnish::shmlog') }
    it { should contain_file('varnish-conf').with(
      'ensure'  => 'present',
      'path'    => '/etc/default/varnish',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[varnish]',
      'notify'  => 'Service[varnish]'
      )
    }
    it { should contain_file('storage-dir').with(
      'ensure'  => 'directory',
      'path'   => '/var/lib/varnish-storage',
      'require' => 'Package[varnish]'
      )
    }
    
    context "without shmlog_tempfs" do
      let :params do
        { :shmlog_tempfs => false }
      end

      it { should_not contain_class('varnish::shmlog') }
    end
    
    context "default varnish-conf values" do
      it { should contain_file('varnish-conf').with_content(/START=yes/) }
      it { should contain_file('varnish-conf').with_content(/NFILES=131072/) }
      it { should contain_file('varnish-conf').with_content(/MEMLOCK=82000/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_VCL_CONF=\/etc\/varnish\/default\.vcl/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_LISTEN_ADDRESS=/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_LISTEN_PORT=6081/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_ADMIN_LISTEN_ADDRESS=127.0.0.1/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_ADMIN_LISTEN_PORT=6082/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_MIN_THREADS=5/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_MAX_THREADS=500/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_THREAD_TIMEOUT=300/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_STORAGE_FILE=\/var\/lib\/varnish-storage\/varnish_storage\.bin/) }    
      it { should contain_file('varnish-conf').with_content(/VARNISH_STORAGE_SIZE=1G/) }    
      it { should contain_file('varnish-conf').with_content(/VARNISH_SECRET_FILE=\/etc\/varnish\/secret/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_STORAGE=\"malloc,\${VARNISH_STORAGE_SIZE}\"/) }
      it { should contain_file('varnish-conf').with_content(/VARNISH_TTL=120/) }
      it { should contain_file('varnish-conf').with_content(/DAEMON_OPTS=\"-a \${VARNISH_LISTEN_ADDRESS}:\${VARNISH_LISTEN_PORT}/) }

    end
  end

  context "on a RedHat 6 or earlier" do
    let :facts do
      {
        :osfamily        => 'RedHat',
        :concat_basedir  => '/dne',
        :operatingsystem => 'RedHat',
	:operatingsystemmajrelease => 6
      }
    end
    
    it { should compile }
    it { should contain_class('varnish::install').with('add_repo' => 'true') }
    it { should contain_class('varnish::service').with('start' => 'yes') }
    it { should contain_class('varnish::shmlog') }
    it { should contain_file('varnish-conf').with(
      'ensure'  => 'present',
      'path'    => '/etc/sysconfig/varnish',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[varnish]',
      'notify'  => 'Service[varnish]'
      )
    }
    it { should contain_file('storage-dir').with(
      'ensure'  => 'directory',
      'path'   => '/var/lib/varnish-storage',
      'require' => 'Package[varnish]'
      )
    }
    context "without shmlog_tempfs" do
      let :params do
        { :shmlog_tempfs => false }
      end

      it { should_not contain_class('varnish::shmlog') }
    end
  end

  context "on a RedHat 7 or later" do
    let :facts do
      {
        :osfamily        => 'RedHat',
        :concat_basedir  => '/dne',
        :operatingsystem => 'RedHat',
	:operatingsystemmajrelease => 7
      }
    end
    
    it { should compile }
    it { should contain_class('varnish::install').with('add_repo' => 'true') }
    it { should contain_class('varnish::service').with('start' => 'yes') }
    it { should contain_class('varnish::shmlog') }
    it { should contain_file('varnish-conf').with(
      'ensure'  => 'present',
      'path'    => '/etc/systemd/system/varnish.service',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[varnish]',
      'notify'  => 'Service[varnish]'
      )
    }
    context "default varnish-conf values" do
      it { should contain_file('varnish-conf').with_content(/^LimitNOFILE=131072$/) }
      it { should contain_file('varnish-conf').with_content(/^LimitMEMLOCK=82000$/) }
    end

    it { should contain_file('varnish-conf-params').with(
      'ensure'  => 'present',
      'path'    => '/etc/varnish/varnish.params',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'require' => 'Package[varnish]',
      'notify'  => 'Service[varnish]'
      )
    }
    context "default varnish-conf-params values" do
      it { should contain_file('varnish-conf-params').with_content(/^RELOAD_VCL=1$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_VCL_CONF=\/etc\/varnish\/default\.vcl$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_LISTEN_ADDRESS=$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_LISTEN_PORT=6081$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_ADMIN_LISTEN_ADDRESS=127.0.0.1$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_ADMIN_LISTEN_PORT=6082$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_SECRET_FILE=\/etc\/varnish\/secret$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_STORAGE="malloc,1G"$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_TTL=120$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_USER=varnish$/) }
      it { should contain_file('varnish-conf-params').with_content(/^VARNISH_GROUP=varnish$/) }
      it { should contain_file('varnish-conf-params').with_content(/^DAEMON_OPTS="-p thread_pool_min=5 -p thread_pool_max=500 -p thread_pool_timeout=300"$/) }
    end

    it { should contain_file('storage-dir').with(
      'ensure'  => 'directory',
      'path'   => '/var/lib/varnish-storage',
      'require' => 'Package[varnish]'
      )
    }
    context "without shmlog_tempfs" do
      let :params do
        { :shmlog_tempfs => false }
      end

      it { should_not contain_class('varnish::shmlog') }
    end
  end
end

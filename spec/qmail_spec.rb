require 'spec_helper'

describe 'qmail', :type => 'class' do

  context 'On an unknown OS' do
    let :facts do
      {
        :operatingsystem => 'Unknown',
      }
    end

    it {
      expect {should raise_error(Puppet::Error)}
    }
  end

  context 'On Ubuntu with valid data specified' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
      }
    end

    let :params do
      {
        :defaultdelivery => 'foo',
        :me => 'foo',
        :rcpthosts => ['foo'],
        :smtproutes => ['foo'],
        :locals => ['foo'],
        :tcp_smtp => ['foo'],
      }
    end

    it {
      should contain_package('qmail').with({'name' => 'qmail'})
      should contain_file('/etc/qmail/defaultdelivery').with({'content' => "foo\n"})
      should contain_file('/etc/qmail/me').with({'content' => "foo\n"})
      should contain_file('/etc/qmail/rcpthosts').with({'content' => "foo\n"})
      should contain_file('/etc/qmail/smtproutes').with({'content' => "foo\n"})
      should contain_file('/etc/qmail/locals').with({'content' => "foo\n"})
      should contain_file('/etc/qmail/tcp.smtp').with({'content' => "foo\n"})
    }
  end
end

@product

Feature: Additional software packages
  As a Tails user
  I may want to install softwares not shipped in Tails
  And have them installed automatically when I enable persistence in the Greeter

  Scenario: Additional software packages are installed even without network
    Given I have started Tails without network from a USB drive with a persistent partition enabled and logged in with an administration password
    And the network is plugged
    And Tor is ready
    And all notifications have disappeared
    And available upgrades have been checked
    And I configure APT to use non-onion sources
    When I update APT using apt
    And I configure additional software packages to install "sslh"
    And I install "sslh" using apt
    And I add non-onion APT sources to persistence
    And I shutdown Tails and wait for the computer to power off
    And I start Tails from USB drive "__internal" with network unplugged and I login with persistence enabled
    Then the additional software package installation service is run
    And the package "sslh" is installed

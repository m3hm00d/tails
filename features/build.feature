@source
Feature: custom APT sources to build branches
  As a Tails developer, when I build Tails, I'd be happy if
  the proper APT sources were automatically picked depending
  on which Git branch I am working on.

  Scenario: build from an untagged stable branch where the config/APT_overlays.d directory is empty
    Given I am working on the stable base branch
    And the last version mentioned in debian/changelog is 1.0
    And Tails 1.0 has not been released yet
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the 'stable' suite

  Scenario: build from an untagged stable branch where config/APT_overlays.d is not empty
    Given I am working on the stable base branch
    And the last version mentioned in debian/changelog is 1.0
    And Tails 1.0 has not been released yet
    And config/APT_overlays.d contains 'feature-foo'
    And config/APT_overlays.d contains 'bugfix-bar'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'stable' suite
    And I should see the 'feature-foo' suite
    And I should see the 'bugfix-bar' suite
    But I should not see the '1.0' suite

  Scenario: build from a tagged stable branch where the config/APT_overlays.d directory is empty
    Given Tails 0.10 has been released
    And the last version mentioned in debian/changelog is 0.10
    And I am working on the stable base branch
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the '0.10' suite

  Scenario: build from a tagged stable branch where config/APT_overlays.d is not empty
    Given Tails 0.10 has been released
    And the last version mentioned in debian/changelog is 0.10
    And I am working on the stable base branch
    And config/APT_overlays.d contains 'feature-foo'
    When I run tails-custom-apt-sources
    Then it should fail

  Scenario: build from a bugfix branch without overlays for a stable release
    Given Tails 0.10 has been released
    And the last version mentioned in debian/changelog is 0.10.1
    And Tails 0.10.1 has not been released yet
    And I am working on the bugfix/disable_gdomap branch based on stable
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the 'stable' suite

  Scenario: build from a bugfix branch with overlays for a stable release
    Given Tails 0.10 has been released
    And the last version mentioned in debian/changelog is 0.10.1
    And Tails 0.10.1 has not been released yet
    And I am working on the bugfix/disable_gdomap branch based on stable
    And config/APT_overlays.d contains 'bugfix-disable-gdomap'
    And config/APT_overlays.d contains 'bugfix-bar'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'stable' suite
    And I should see the 'bugfix-disable-gdomap' suite
    And I should see the 'bugfix-bar' suite
    But I should not see the '0.10' suite

  Scenario: build from an untagged testing branch where the config/APT_overlays.d directory is empty
    Given I am working on the testing base branch
    And the last version mentioned in debian/changelog is 0.11
    And Tails 0.11 has not been released yet
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see the 'testing' suite
    And I should not see the '0.11' suite
    And I should not see the 'feature-foo' suite
    And I should not see the 'bugfix-bar' suite

  Scenario: build from an untagged testing branch where config/APT_overlays.d is not empty
    Given I am working on the testing base branch
    And the last version mentioned in debian/changelog is 0.11
    And Tails 0.11 has not been released yet
    And config/APT_overlays.d contains 'feature-foo'
    And config/APT_overlays.d contains 'bugfix-bar'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'testing' suite
    And I should see the 'feature-foo' suite
    And I should see the 'bugfix-bar' suite
    But I should not see the '0.11' suite

  Scenario: build from a tagged testing branch where the config/APT_overlays.d directory is empty
    Given I am working on the testing base branch
    And the last version mentioned in debian/changelog is 0.11
    And Tails 0.11 has been released
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the '0.11' suite

  Scenario: build from a tagged testing branch where config/APT_overlays.d is not empty
    Given I am working on the testing base branch
    And the last version mentioned in debian/changelog is 0.11
    And Tails 0.11 has been released
    And config/APT_overlays.d contains 'feature-foo'
    When I run tails-custom-apt-sources
    Then it should fail

  Scenario: build a release candidate from a tagged testing branch
    Given I am working on the testing base branch
    And Tails 0.11 has been released
    And the last version mentioned in debian/changelog is 0.12~rc1
    And Tails 0.12-rc1 has been tagged
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the '0.12-rc1' suite

  Scenario: build a release candidate from a tagged testing branch where config/APT_overlays.d is not empty
    Given I am working on the testing base branch
    And Tails 0.11 has been released
    And the last version mentioned in debian/changelog is 0.12~rc1
    And Tails 0.12-rc1 has been tagged
    And config/APT_overlays.d contains 'bugfix-bar'
    When I run tails-custom-apt-sources
    Then it should fail

  Scenario: build from the devel branch without overlays
    Given I am working on the devel base branch
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the 'devel' suite

  Scenario: build from the devel branch with overlays
    Given I am working on the devel base branch
    And config/APT_overlays.d contains 'feature-foo'
    And config/APT_overlays.d contains 'bugfix-bar'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'devel' suite
    And I should see the 'feature-foo' suite
    And I should see the 'bugfix-bar' suite

  Scenario: build from the feature/jessie branch without overlays
    Given I am working on the feature/jessie base branch
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the 'feature-jessie' suite

  Scenario: build from the feature/jessie branch with overlays
    Given I am working on the feature/jessie base branch
    And config/APT_overlays.d contains 'feature-7756-reintroduce-whisperback'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'feature-jessie' suite
    And I should see the 'feature-7756-reintroduce-whisperback' suite

  Scenario: build from a feature branch with overlays based on devel
    Given I am working on the feature/icedove branch based on devel
    And config/APT_overlays.d contains 'feature-icedove'
    And config/APT_overlays.d contains 'bugfix-bar'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'devel' suite
    And I should see the 'feature-icedove' suite
    And I should see the 'bugfix-bar' suite

  Scenario: build from a feature branch without overlays based on devel
    Given I am working on the feature/icedove branch based on devel
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the 'devel' suite

  Scenario: build from a feature branch with overlays based on feature/jessie
    Given I am working on the feature/7756-reintroduce-whisperback branch based on feature/jessie
    And config/APT_overlays.d contains 'feature-7756-reintroduce-whisperback'
    And config/APT_overlays.d contains 'bugfix-bar'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'feature-jessie' suite
    And I should see the 'feature-7756-reintroduce-whisperback' suite
    And I should see the 'bugfix-bar' suite

  Scenario: build from a feature branch without overlays based on feature/jessie
    Given I am working on the feature/icedove branch based on feature/jessie
    And the config/APT_overlays.d directory is empty
    When I successfully run tails-custom-apt-sources
    Then I should see only the 'feature-jessie' suite

  Scenario: build from a feature branch based on devel with dots in its name
    Given I am working on the feature/live-boot-3.x branch based on devel
    And config/APT_overlays.d contains 'feature-live-boot-3.x'
    When I successfully run tails-custom-apt-sources
    Then I should see the 'devel' suite
    And I should see the 'feature-live-boot-3.x' suite

  Scenario: build from a branch that has no config/APT_overlays.d directory
    Given I am working on the stable base branch
    And the config/APT_overlays.d directory does not exist
    When I run tails-custom-apt-sources
    Then it should fail

  Scenario: build from a branch that has no config/base_branch file
    Given I am working on the stable base branch
    And the config/base_branch file does not exist
    When I run tails-custom-apt-sources
    Then it should fail

  Scenario: build from a branch where config/base_branch is empty
    Given I am working on the stable base branch
    And the config/base_branch file is empty
    When I run tails-custom-apt-sources
    Then it should fail

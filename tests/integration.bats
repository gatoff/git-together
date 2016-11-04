#!/usr/bin/env bats

@test "soloing" {
  git-together with jh
  touch foo
  git add foo
  git-together commit -m "add foo"

  run git show --no-patch --format="%aN <%aE>"
  [ "$output" = "James Holden <jholden@rocinante.com>" ]
}

@test "pairing" {
  git-together with jh nn
  touch foo
  git add foo
  git-together commit -m "add foo"

  run git show --no-patch --format="%aN <%aE>"
  [ "$output" = "James Holden <jholden@rocinante.com>" ]
  run git show --no-patch --format="%cN <%cE>"
  [ "$output" = "Naomi Nagata <nnagata@rocinante.com>" ]
}

@test "rotation" {
  git-together with jh nn

  touch foo
  git add foo
  git-together commit -m "add foo"

  touch bar
  git add bar
  git-together commit -m "add bar"

  run git show --no-patch --format="%aN <%aE>"
  [ "$output" = "Naomi Nagata <nnagata@rocinante.com>" ]
  run git show --no-patch --format="%cN <%cE>"
  [ "$output" = "James Holden <jholden@rocinante.com>" ]
}

setup() {
  [ -f $BATS_TMPDIR/bin/git-together ] || cargo install --root $BATS_TMPDIR
  PATH=$BATS_TMPDIR/bin:$PATH

  rm -rf $BATS_TMPDIR/$BATS_TEST_NAME
  mkdir -p $BATS_TMPDIR/$BATS_TEST_NAME
  cd $BATS_TMPDIR/$BATS_TEST_NAME

  git init
  git config --add git-together.domain rocinante.com
  git config --add git-together.authors.jh "James Holden; jholden"
  git config --add git-together.authors.nn "Naomi Nagata; nnagata"
  git config --add git-together.authors.ca "Chrisjen Avasarala; avasarala@un.gov"
}
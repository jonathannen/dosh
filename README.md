# Dosh

Dev Ops Scripting.

## Installation

    $ gem install dosh

## Requirements

Ruby 1.9.3 or greater.

## Principles

1. Scripts should be standalone.
2. DRY, but self-sufficency and explictness are important too.
3. Scripts should be re-runnable, with the same outcome. If something changes
that can't be repeated, check for it and exit early.

## Conventions

- "ensure_<state>" checks if a state is true, generating a fault if not.
- "install_<noun>" installs the given noun, to a completely "ready" state.
- "meet_<noun>_<state>" takes the noun and attemps to achieve the given state.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
2a. Make sure you have some tests or way of validating the feature.
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. ... and thanks!

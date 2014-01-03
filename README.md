# KNOWtime server

This repository contains the code for the [KNOWtime](http://knowtime.ca) server.

## Related Projects

### Clients

- **iOS client:** [aeisses/Busted](https://github.com/aeisses/Busted)
- **Android client:** [aeisses/KNOWtime](https://github.com/aeisses/KNOWtime)

## Dependencies

- [Ruby 2](http://www.ruby-lang.org/)
- [Ruby on Rails 3](http://rubyonrails.org/)
- [MongoDB](http://www.mongodb.org/)
- [Memcached](http://www.memcached.org/)

### Configuration

There are some secret values and keys which we don't want to share publicly. Copy the file `config/development_secrets.yml` to your server's `/etc/knowtime_secrets.yml` file. Update this file with correct values.

## Conventions

### git

For this poject, we are using the `git flow` branching strategy. For more information on this topic, see the following pages:

- [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
- [nvie/gitflow](https://github.com/nvie/gitflow)

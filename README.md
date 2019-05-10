# Digital Democracy and Data Commons for Barcelona

This is the open-source repository for DDDC, based on [Decidim](https://github.com/decidim/decidim),
implementing the [DECODE](https://decodeproject.eu/) prototypes.


## Setting up the application

### Development

You will need to do some steps before having the app working properly once you've deployed it:

1. Clone this repository, go to the directory and starts with docker-compose
```bash
git clone https://github.com/alabs/DDDC
cd DDDC
docker-compose up
docker-compose run app rails db:create
docker-compose run app rails db:migrate
docker-compose run app rails db:seed
```

Go to http://localhost:3000/

### Staging

```bash
docker-compose run app bundle exec cap staging deploy
```

### Production

Push master branch to Heroku.
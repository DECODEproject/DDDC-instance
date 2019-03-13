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

## About petitions module

We implemented the DECODE prototypes based on a Decidim module. It's on the `decidim-petitions/` directory.

### Configuring

Dependencies:

* [decidim-decode-connector](https://github.com/DECODEproject/decidim-decode-connector). Configures at config/secrets.yml (`decode.connector_path`).
* [credential-issuer](https://github.com/DECODEproject/credential-issuer). Configures at config/secrets.yml (`decode.credential_issuer_url`).
* [chainspace](https://github.com/DECODEproject/decidim-pilot-infrastructure/). Configures at Decidim administrator admin panel.

Go to the /admin, configure a new Participatory Process, add Petition component and configure a Petition.

### Screenshots

![](docs/decode-petitions-01.png)
![](docs/decode-petitions-02.png)
![](docs/decode-petitions-03.png)
![](docs/decode-petitions-04.png)
![](docs/decode-petitions-05.png)

### GraphQL

It's important to configure the JSON attributes so it's consumed by other apps from DECODE ecosystem:

```json
{
  "mandatory": [
    {
      "predicate": "schema:addressLocality",
      "object": "Barcelona",
      "scope": "can-access",
      "provenance": {
        "url": "http://atlantis-decode.s3-website-eu-west-1.amazonaws.com"
      }
    }
  ],
  "optional": [
    {
      "predicate": "schema:dateOfBirth",
      "object": "voter",
      "scope": "can-access"
    },
    {
      "predicate": "schema:gender",
      "object": "voter",
      "scope": "can-access"
    }
  ]
}
```

To consume this data, you can do it on the GraphQL API:

```graphql
{
  petition(id:"1") {
    id,
    title,
    description,
    author,
    json_schema
  }
}
```

An example with curl:

```bash
curl 'https://betadddc.alabs.org/api' -H 'content-type: application/json'  --data '{"query":"{\n  petition(id:\"1\") {\n    id, \n    title,\n    description,\n    author,\n    json_schema \n  }\n}\n","variables":null,"operationName":null}'
```

## Zenroom

Although most of the actions to Zenroom / Chainspace are using a proxy with Petitions API, for some actions (hashing value set attributes and tallying) it's necessary to execute zenroom from the application itself. For set up purposes we're copying the binary on bin/. If you want to upgrade it, you can follow these instructions (changing 0.8.1 for the new version as published on [Zenroom](https://github.com/DECODEproject/zenroom). You can download the binary from Dyne.org (https://sdk.dyne.org:4443/view/decode/):

```bash
wget https://sdk.dyne.org:4443/view/decode/job/zenroom-static-amd64/lastSuccessfulBuild/artifact/src/zenroom-static -O bin/zenroom-static
```

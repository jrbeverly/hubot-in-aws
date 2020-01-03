# Hubot in AWS ECS

Hubot deployment in AWS using AWS ECS Fargate. This was prototyped out while I was evaluating ChatOps strategies that could be used to wrap existing web interfaces or require minimal overhead.

## Usage

A build-harness created with `make` is available for the repository. This harness simplifies the commands necessary to build and deploy the project. You can see the available targets by running `make help`:

```bash
Usage: make <target>
  help        This help text.

Terraform
  ecr         Deploy the ECR for the Hubot image
  ecs         Deploy the Hubot ECS service      
  destroy     Destroys the terraform instructure

Hubot
  launch      Launches the hubot application in docker

Docker
  docker      Build the hubot image for deployment
  deploy      Deploys the hubot image to ECR
```

### Deploy

Using docker, you can build and deploy the sample using the following steps:

```bash
make docker
make ecr
make deploy
make ecs
make launch
```

## Notes

At the time I was building this I was trying to figure out a nice way to have a ChatOps style interface for a web service. The reason for ChatOps is that I was after something that would:

1) Allow me to execute commands easily while on the go (e.g. slack + phone)
2) Offer multiple operations for diagnostic and configuration
3) Require minimal knowledge of how the system might work (e.g. `<tool> help`)

I do enjoy what ChatOps offers but it did not exactly fit the target needs I was going for:

- I didn't need the more advanced input format
- Slash commands were sufficient for the interface
- I didn't wish to develop the app within the _context_ of the Hubot application
- Additional infrastructure (ECS Service) was worrying, as I was aiming for high reliability

# Create AWS Lambda layer for Sharp image processing library

This repo was made to overcome an obstacle while integrating [npm sharp](https://www.npmjs.com/package/sharp) with AWS Lambda.

## Background

Sharp is a blazing fast and slick image processing library for Node. It's faster than any other library I have come across, and hence it is worth going through the extra installation trouble.

Sharp uses different C++ binaries for different runtime environments which are resolved during the installation process. If you just copy the `node_modules` folder to AWS Lambda containing Sharp it will not work 😞

Another issue is that Sharp is a large library (file size wise) meaning subsequent deployments can be slow. In addition, some developers report installation trouble / confusion.

To remedy all of the above, the recommended solution is to create a Lambda Layer containing a pre-canned Sharp installation from an Amazon Linux Docker image.

## What does this codebase do exactly?

This code base will do two things:

- Create a `.zip` file with a Lambda Layer containing an AMZ Linux compatible installation of Sharp
- Describe and push the layer to your AWS account

To consume the layer, in your Serverless Lambda function setup you need to reference the layer by ARN or direct resource reference:

```yml
functions:
  imageProcessor:
    handler: src/my-handler.handler
    layers:
      - arn:aws:lambda:ap-southeast-2:837126141291:layer:sharp:1
```

Or using `!Ref` syntax where "Sharp" refers to the layer name with the first character in uppercase (and "LambdaLayer" is fixed).

```yml
functions:
  imageProcessor:
    handler: src/my-handler.handler
    layers:
      - !Ref SharpLambdaLayer
```

## Get started

```
yarn install
```

Make sure you have Docker installed and running.
I'm no Docker expert, but without the `DOCKER_BUILDKIT=0` I got _a ton of errors_.

```
DOCKER_BUILDKIT=0 docker-compose up
```

This will generate the following file:

`/layers/sharp/out/sharp-0.31.2-aws-lambda-linux-x64-node-16.17.0.zip`

Using Serverless, use below command to upload the Lambda Layer containing the AMZ Linux compatible Sharp node modules to your AWS account.

Note, that at the time of writing, you cannot use Lambda Layers across regions.

```
sls deploy
```

This has been successfully tested on MacOS Ventura 13.0.1.

Sharp docs:

https://sharp.pixelplumbing.com/install#aws-lambda

This repo is based on code from https://github.com/woss/aws-lambda-layer-sharp

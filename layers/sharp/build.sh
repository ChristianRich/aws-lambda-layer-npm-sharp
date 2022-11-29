# Variables
SHARP_VERSION=$(npm show sharp version)
NODE_VERSION=16.17.0
SHARP_DIRECTORY=sharp-$SHARP_VERSION
TARBALL=sharp-$SHARP_VERSION-aws-lambda-linux-x64-node-$NODE_VERSION.zip

# current dir where the build.sh is located
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd $DIR
# https://docs.aws.amazon.com/en_pv/lambda/latest/dg/configuration-layers.html#configuration-layers-path

# Install sharp using recommended AMZ AMI settings https://sharp.pixelplumbing.com/install#aws-lambda
SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install --production --arch=x64 --platform=linux --libc=glibc --prefix ./nodejs sharp@$SHARP_VERSION

# tarball the resulting node_modules
zip -r $TARBALL nodejs

mv $TARBALL out

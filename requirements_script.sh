# Authenticate AWS CLI with your access keys
aws configure  # Follow this guide if you get stuck: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

# Create a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install required packages
pip install ask-sdk-core==1.* ask-sdk-model==1.* requests

# Prepare deployment
mkdir build
cp lambda_function.py build/
pip install --target build ask-sdk-core ask-sdk-model requests

# Create deployment package
cd build
zip -r code.zip .

# Deploy to Lambda
aws lambda update-function-code \
    --function-name unhinged-alexa \
    --zip-file fileb://code.zip

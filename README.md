# 🤖 Unhinged Alexa

Turn Alexa into unhinged mode with OpenAI integration!

![image](https://github.com/user-attachments/assets/b7e0f6f6-6e30-417d-ba2d-79c53f5babef)

---

## 🧰 Prerequisites

Make sure you have the following accounts and tools set up:

- ✅ [AWS Account](https://aws.amazon.com/account/)
- ✅ [Alexa Developer Account](https://developer.amazon.com/alexa)
- ✅ [OpenAI API Key](https://platform.openai.com/account/api-keys)  
  👉 [How to get an OpenAI API Key](https://platform.openai.com/docs/quickstart)

---

## 1️⃣ Set Up Your AWS Lambda Function

1. Go to the [AWS Lambda Console](https://console.aws.amazon.com/lambda/) and create a new function:
   - **Function name:** `unhinged-alexa`

2. Under **Configuration > Environment variables**, add:
   - **Key:** `OPENAI_API_KEY`
   - **Value:** *Your OpenAI API key*

3. Copy the Lambda function code from this repo:  
   👉 [`lambda_function.py`](https://github.com/Frazzlem8/unhinged-alexa)

---

## 2️⃣ Prepare and Deploy Your Code Locally

Open your terminal and run:

```bash
# Authenticate AWS CLI
aws configure  # If needed: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

# Set up environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install ask-sdk-core==1.* ask-sdk-model==1.* requests

# Prepare deployment package
mkdir build
cp lambda_function.py build/
pip install --target build ask-sdk-core ask-sdk-model requests

# Zip and upload
cd build
zip -r code.zip .

aws lambda update-function-code \
    --function-name unhinged-alexa \
    --zip-file fileb://code.zip
```

## 3️⃣ Create the Alexa Skill

1. Go to the Alexa Developer Console and click “Create Skill”.

2. Choose:
   - **Skill name:** *Unhinged Alexa or AI Steve*
   - **Skill model:** *Custom*
   - **Method to host your code:** Alexa-Hosted (Node.js) → **No!** Choose “Provision your own” to use your AWS Lambda.
3. Set the invocation name, e.g., ai steve

This is what the user will say to activate your skill: “Alexa, ask AI Steve to roast my haircut.”

<img width="1509" alt="Screenshot 2025-05-05 at 20 41 04" src="https://github.com/user-attachments/assets/a39eb860-ada8-4673-96fb-af86dcdc0987" />

4. In the Interaction Model, add a new Intent:
   - **Intent name:** *AiSteveIntent*
   - **Sample utterances:**

<img width="1509" alt="Screenshot 2025-05-05 at 20 43 11" src="https://github.com/user-attachments/assets/b304459e-822f-4ba2-9df1-9fa9c5ac0867" />

5. Add a slot to the intent:
   - **Slot name:** *query*
   - **Slot type:** AMAZON.SearchQuery

## 4️⃣ Connect Alexa to Lambda
Now link your Alexa skill to your Lambda function.

1. Go to your skill’s Endpoint section.
   - **Go to your skill’s Endpoint section.**
   - **Set the region and paste your Lambda’s ARN from AWS**

<img width="1509" alt="Screenshot 2025-05-05 at 20 45 53-20250505-194623" src="https://github.com/user-attachments/assets/3696790f-94da-44cd-903d-7db586218eac" />

2. Grant Alexa permission to invoke your Lambda:

```bash
aws lambda add-permission \
  --function-name unhinged-alexa \
  --statement-id "alexa-skill-$(date +%s)" \
  --action lambda:InvokeFunction \
  --principal alexa-appkit.amazon.com \
  --event-source-token <YOUR_SKILL_ID>
```
🔍 You can find your Skill ID under Skill > Skill Settings > Skill ID.

3. Save and build your skill. If successful, a green confirmation banner should appear.


## 5️⃣ Test Your Skill

1. Go to the Test tab in the Alexa Developer Console.
2. Enable testing and try phrases like:

<img width="1509" alt="Screenshot 2025-05-05 at 20 50 22" src="https://github.com/user-attachments/assets/ac121073-41ee-42fb-8e4a-33dc55647b6a" />

## ✅ You’re Done!

Your Alexa is now officially unhinged. She’ll forward user queries to your Lambda function, which in turn queries OpenAI for a response.


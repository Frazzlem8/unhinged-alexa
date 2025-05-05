aws lambda add-permission \
  --function-name unhinged-alexa \
  --statement-id "alexa-skill-$(date +%s)" \
  --action lambda:InvokeFunction \
  --principal alexa-appkit.amazon.com \
  --event-source-token <YOUR_SKILL_ID>

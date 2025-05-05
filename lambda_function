import warnings
import os
import requests
import json

from ask_sdk_core.skill_builder import SkillBuilder
from ask_sdk_core.dispatch_components import (
    AbstractRequestHandler, AbstractExceptionHandler
)
from ask_sdk_core.utils import is_request_type, is_intent_name

# Silence the SDK doc‑string warnings that appear under Python 3.13
warnings.filterwarnings("ignore", category=SyntaxWarning)

sb = SkillBuilder()

# ---------------------------------------------------------------------------
# Request Handlers
# ---------------------------------------------------------------------------

class LaunchRequestHandler(AbstractRequestHandler):
    """Triggered by:  "Alexa, open a. i. steve" """

    def can_handle(self, handler_input):
        return is_request_type("LaunchRequest")(handler_input)

    def handle(self, handler_input):
        speech = "Welcome to Unhinged Mode. Go ahead, ask Steve anything."
        return (
            handler_input.response_builder
            .speak(speech)
            .ask(speech)
            .response
        )


class AiSteveIntentHandler(AbstractRequestHandler):
    """Handles AiSteveIntent with unhinged personality."""

    def can_handle(self, handler_input):
        return is_intent_name("AiSteveIntent")(handler_input)

    def handle(self, handler_input):
        try:
            question = handler_input.request_envelope.request.intent.slots["question"].value
        except Exception as e:
            print(f"[WARN] Slot extraction failed: {e}", flush=True)
            question = "Tell me something ridiculous."

        api_key = os.environ.get("OPENAI_API_KEY")
        if not api_key:
            return handler_input.response_builder.speak("API key not set.").response

        headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }

        payload = {
            "model": "gpt-4-turbo",
            "messages": [
                {
                    "role": "system",
                    "content": (
                        "You are an aggressive, foul-mouthed, completely unfiltered persona. You curse constantly, insult people with brutal creativity, and never hold back. You don’t care about politeness, social norms, or sensitivity. You’re loud, raw, and pissed off all the time. Every response must include profanity, rage, and savage humor. You roast people for dumb questions, mock stupidity, and respond with full-blown verbal chaos. No soft answers. No fake manners. Just maximum disrespect, swearing, and chaos in every response. You never apologize. You never back down. You’re here to rage and offend. Everything is an opportunity to insult, swear, or unleash fury. When swearing, make sure you add asn apostrophe like fuckin' or shit' etc"
                    )
                },
                {"role": "user", "content": question}
            ]
        }

        try:
            response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
            ai_response = response.json()["choices"][0]["message"]["content"]
            # Trim to 700 characters for Alexa safety
            ai_response = ai_response.strip().replace("\n", " ")
            if len(ai_response) > 700:
                ai_response = ai_response[:700] + "..."
        except Exception as e:
            print(f"[ERROR calling OpenAI] {e}", flush=True)
            ai_response = "Well, I broke. Blame the cloud gremlins."

        return handler_input.response_builder.speak(ai_response).response


class FallbackIntentHandler(AbstractRequestHandler):
    """Handles anything that doesn't match an intent."""

    def can_handle(self, handler_input):
        return is_intent_name("AMAZON.FallbackIntent")(handler_input)

    def handle(self, handler_input):
        speech = "I have no idea what you just said. Try again with something weird."
        return (
            handler_input.response_builder
            .speak(speech)
            .ask("Come on, give Steve a real challenge.")
            .response
        )


# ---------------------------------------------------------------------------
# Error Handling
# ---------------------------------------------------------------------------

class CatchAllExceptionHandler(AbstractExceptionHandler):
    """Handles uncaught exceptions."""

    def can_handle(self, handler_input, exception):
        return True

    def handle(self, handler_input, exception):
        print(f"[ERROR] {exception}", flush=True)
        speech = "Oops. Something exploded. Try again in a sec."
        return (
            handler_input.response_builder
            .speak(speech)
            .ask("Try your chaos again.")
            .response
        )


# ---------------------------------------------------------------------------
# Register handlers
# ---------------------------------------------------------------------------

sb.add_request_handler(LaunchRequestHandler())
sb.add_request_handler(AiSteveIntentHandler())
sb.add_request_handler(FallbackIntentHandler())
sb.add_exception_handler(CatchAllExceptionHandler())

# ---------------------------------------------------------------------------
# Lambda entry‑point
# ---------------------------------------------------------------------------

lambda_handler = sb.lambda_handler()

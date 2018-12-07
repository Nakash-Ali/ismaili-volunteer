module.exports = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "Config",
    "type": "array",
    "items": {
        "title": "Screenshot config",
        "type": "object",
        "properties": {
            "webpageUrl": {
                "description": "Full url for the webpage to load",
                "type": "string"
            },
            "outputPath": {
								"description": "Where to save the screenshot",
                "type": "string"
            }
        },
        "required": ["webpageUrl", "outputPath"]
    }
}
import json
import boto3

def lambda_handler(event, context):
    codeguru_client = boto3.client('codeguru-security')
    bedrock_client = boto3.client('bedrock-runtime')

    try:
        findings = codeguru_client.get_findings(
            scanName=event['scanName'],
            status='Open'
        )

        finding = findings['findings'][0]
        code_snippet = finding['vulnerability']['filePath']['codeSnippet']
        recommendation = finding['remediation']['recommendation']['text']

        model_id = 'amazon.titan-text-premier-v1:0'
        prompt = (
            f"Find and fix the problem in the following code:\n\n{code_snippet}\n\n"
            f"Issue detected is: {recommendation}\n\nSolution:"
        )

        native_request = {
            "inputText": prompt,
            "textGenerationConfig": {
                "maxTokenCount": 512,
                "temperature": 0.7,
            },
        }

        response = bedrock_client.invoke_model(
            body=json.dumps(native_request),
            modelId=model_id
        )
        response_body = response['body'].read().decode('utf-8')

        return {
            'statusCode': 200,
            'bedrockResponse': response_body
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'errorMessage': str(e)
        }
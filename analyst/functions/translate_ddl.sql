CREATE OR REPLACE FUNCTION
	`functions.translate`(x STRING) RETURNS STRING
REMOTE WITH CONNECTION `us.translate`
OPTIONS (endpoint = 'https://us-central1-sb-challenge-labs.cloudfunctions.net/translate', max_batching_rows = 10);
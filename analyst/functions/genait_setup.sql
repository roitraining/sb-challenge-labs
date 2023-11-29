  CREATE SCHEMA
    `models` OPTIONS ( description = 'BQML Models',
      location = 'US');

  
CREATE OR REPLACE MODEL
  `models.upsell` REMOTE
WITH CONNECTION `us.upsell`  OPTIONS(ENDPOINT = 'text-bison@001')
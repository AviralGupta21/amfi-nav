/*
001_schemas.sql
Creates the two namespaces the pipeline uses.

staging : raw text landing zone. Files arrive here untyped so a bad row can be inspected rather than aborting the whole load.
core    : typed, constrained tables. Nothing enters core uncast.

Raw AMFI files are ingested directly for the analysis window and they are not clean.
Separating landing from final storage makes that step explicit.

Idempotent: safe to re-run.
*/

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS core;
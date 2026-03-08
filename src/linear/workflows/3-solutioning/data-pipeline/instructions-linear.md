# Data Pipeline Design — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Designs comprehensive ETL/ELT data pipelines through collaborative discovery — data sources, extraction strategies, transformation rules, loading patterns, scheduling, error handling, and data quality checks. All output is written to a Linear Document.

## Execution Rules

- NEVER generate content without user input — you are a facilitator, not a content generator
- ALWAYS treat this as collaborative discovery between data engineering peers
- ABSOLUTELY NO TIME ESTIMATES — AI development speed has fundamentally changed
- ALWAYS speak in {communication_language}
- Show your analysis before taking any action
- At each step boundary, present the A/P/C menu and WAIT for the user's selection before proceeding
- Autonomy: when `autonomy_level` is `yolo`, auto-proceed on obvious steps; when `balanced`, auto-proceed only when unambiguous; when `interactive`, always wait for explicit user input

## A/P/C Menu Protocol (used in steps 2-6)

After generating content in each step, present:
- **[A] Advanced Elicitation** — Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md`, then return to this menu with refined content
- **[P] Party Mode** — Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md`, then return to this menu with enhanced analysis
- **[C] Continue** — Accept the content and proceed to the next step

User accepts/rejects A or P results before proceeding. FORBIDDEN to advance until C is selected.

---

<workflow>

<step n="1" goal="Initialize and load context from Linear">

<action>Communicate in {communication_language} with {user_name}</action>

**1A. Check for existing pipeline design:**

<action>Call `list_documents` and search for documents with "Data Pipeline" in the title</action>

If found, present continuation menu:

"Welcome back {user_name}! I found your existing Data Pipeline work for {project_name}.
- **[R] Resume** — Continue from where we left off
- **[C] Continue** — Jump to the next logical step
- **[O] Overview** — See all remaining steps
- **[X] Start over** — Begin fresh (creates a new document)"

**1B. Load project context:**

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "prd"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "architecture"` (recommended)</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "data_model"` (recommended)</action>

**1C. Report and confirm:**

"Welcome {user_name}! Data pipeline design workspace ready for {project_name}.

**Documents Loaded:**
- PRD: {status}
- Architecture: {status}
- Data Model: {status}

What data pipeline(s) do you need to design? **[C] Continue** to data source identification"

**Success:** Context loaded, user confirmed scope. **Failure:** Not loading existing data model, not confirming scope.
</step>

<step n="2" goal="Data source identification — catalog all sources, formats, and access patterns">

**2A. Identify data sources:**

For each source:
- **Name and type:** API, database, file system, message queue, webhook, stream
- **Data format:** JSON, CSV, XML, Parquet, Avro, Protocol Buffers
- **Access pattern:** Pull (polling/batch), push (webhook/stream), CDC (change data capture)
- **Volume and velocity:** Records per day/hour/minute, average record size, peak throughput
- **Freshness requirements:** Real-time, near-real-time, hourly, daily, weekly
- **Auth and connectivity:** API keys, OAuth, VPN, IP allowlist, connection pooling

**2B. Source reliability assessment:**

For each source:
- Availability SLA (uptime, maintenance windows)
- Rate limits and throttling
- Data quality characteristics (missing fields, format inconsistencies)
- Schema stability (breaking changes frequency, versioning)
- Retry characteristics (idempotent operations, pagination stability)

**2C. Present source catalog:**

"I've identified {source_count} data sources for your pipeline:

| Source | Type | Format | Volume | Freshness | Reliability |
|---|---|---|---|---|---|
| {name} | {type} | {format} | {volume} | {freshness} | {reliability} |

Are there additional data sources? Any corrections?"

**Present A/P/C menu.** On C, hold content and proceed to step 3.

**Success:** All sources cataloged with access patterns and reliability. **Failure:** Missing sources, no volume estimates, ignoring reliability.
</step>

<step n="3" goal="Extraction strategy — how to get data from each source reliably">

**3A. Design extraction for each source:**

- **Full extraction:** When to use (small datasets, no change tracking), implementation approach
- **Incremental extraction:** Timestamp-based, ID-based, CDC-based, change flag-based
- **Streaming extraction:** Event consumers, webhook handlers, real-time subscriptions
- **Hybrid approaches:** Full refresh on schedule + incremental between refreshes

**3B. Extraction patterns:**

- Pagination strategy (cursor vs offset, page size tuning)
- Backpressure handling (rate limiting, circuit breakers)
- Checkpointing (resumable extractions, last-processed markers)
- Parallelism (concurrent source reads, partition-based parallelism)

**3C. Schema handling at extraction:**

- Schema-on-read vs schema-on-write
- Raw data preservation (store original before transformation)
- Schema detection and evolution handling
- Data type coercion rules

**Present A/P/C menu.** On C, hold content and proceed to step 4.

**Success:** Extraction strategy defined for each source with error handling. **Failure:** No incremental strategy, missing checkpointing, no schema handling.
</step>

<step n="4" goal="Transformation rules — cleaning, normalization, enrichment, business logic">

**4A. Data cleaning transformations:**

- Null handling (default values, imputation, rejection)
- String normalization (trimming, case normalization, encoding)
- Date/time standardization (timezone conversion, format unification)
- Deduplication strategy (exact match, fuzzy match, dedup window)
- Outlier detection and handling

**4B. Data normalization and enrichment:**

- Field mapping (source field -> target field, with type conversions)
- Lookup enrichment (join with reference data, geocoding, currency conversion)
- Derived fields (calculations, aggregations, categorizations)
- Denormalization for analytics (pre-computed aggregates, flattened structures)

**4C. Business rule transformations:**

- Status mapping (source status codes -> domain statuses)
- Unit conversions (currency, measurements, timezones)
- Data masking and anonymization (PII handling, GDPR compliance)
- Validation rules (reject, quarantine, or flag invalid records)

**4D. Transformation orchestration:**

- Transformation order and dependencies (DAG)
- Stateless vs stateful transformations
- Idempotency guarantees (same input always produces same output)
- Performance considerations (in-memory vs disk, batch size tuning)

**Present A/P/C menu.** On C, hold content and proceed to step 5.

**Success:** All transformations defined with clear rules and ordering. **Failure:** Missing business rules, no idempotency, ignoring data quality.
</step>

<step n="5" goal="Loading strategy and scheduling — how and when data reaches its destination">

**5A. Loading strategy per destination:**

- **Upsert (merge):** Match on natural key, insert or update — when to use
- **Append only:** Insert new records, never update — event logs, audit trails
- **Full replace:** Truncate and reload — reference data, small tables
- **SCD Type 2:** Slowly changing dimensions — historical tracking
- **Partitioned loads:** Time-based or key-based partition replacement

**5B. Destination design:**

- Target schema alignment with data model (if exists)
- Staging tables vs direct loading
- Transaction boundaries (all-or-nothing vs incremental commit)
- Post-load validation (row counts, checksums, referential integrity)

**5C. Scheduling and orchestration:**

- **Trigger type:** Cron schedule, event-driven, dependency-based, manual
- **Frequency:** Real-time, micro-batch, hourly, daily, weekly
- **Dependencies:** Pipeline DAG (which pipelines depend on others)
- **Windows:** Processing windows, maintenance windows, embargo periods
- **Concurrency:** Parallel pipeline execution, resource contention

**5D. Error handling and recovery:**

- Dead letter queues (quarantine failed records for review)
- Retry policies (max retries, backoff strategy, circuit breakers)
- Alerting (thresholds, channels, escalation)
- Manual intervention procedures (reprocess, skip, correct)
- Rollback procedures (undo partial loads, restore from checkpoint)

**Present A/P/C menu.** On C, hold content and proceed to step 6.

**Success:** Loading patterns defined, scheduling designed, error handling comprehensive. **Failure:** No retry policy, missing rollback, no alerting.
</step>

<step n="6" goal="Data quality checks, monitoring, and write to Linear Document">

**6A. Data quality checks at each pipeline stage:**

- **Source validation:** Schema conformance, completeness, freshness
- **Post-extraction:** Record counts, null rates, format compliance
- **Post-transformation:** Business rule validation, referential integrity, range checks
- **Post-load:** Row count reconciliation, checksum validation, query result verification

**6B. Data quality metrics:**

- Completeness (% non-null for required fields)
- Accuracy (% matching expected patterns/ranges)
- Consistency (cross-source agreement)
- Timeliness (data freshness, pipeline latency)
- Uniqueness (duplicate rate)

**6C. Monitoring and observability:**

- Pipeline run metrics (duration, records processed, error rate)
- Data drift detection (schema changes, distribution shifts)
- SLA tracking (freshness guarantees, processing time budgets)
- Dashboard and alerting integration

**6D. Compile the complete pipeline design document:**

<action>Compile all content from steps 2-6 into a comprehensive document</action>
<action>Generate in {document_output_language}</action>

**6E. Write to Linear Document:**

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] Data Pipeline Design: {pipeline_name}"
body_content: "{compiled_pipeline_content}"
key_map_id: "data_pipeline"
```

<action>Update `{key_map_file}` with new document ID under `documents.data_pipeline`</action>

**6F. Post handoff:**

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "Architect"
handoff_type: "data_pipeline_complete"
summary: "Data pipeline design published to Linear Document. {source_count} sources, {pipeline_count} pipelines defined."
document_id: "{pipeline_document_id}"
```

**6G. Report to user:**

**Data Pipeline Design Complete**
- **Linear Document:** {pipeline_document_title}
- **Status:** Published
- **Data Sources:** {source_count}
- **Pipelines Defined:** {pipeline_count}
- **Quality Checks:** {check_count}
- **Handoff:** Architect (Opus) notified

**Next Steps:**
1. Review the pipeline design in Linear Documents
2. Architect can integrate pipeline infrastructure into architecture
3. Run Data Migration Plan [DMG] if migrating existing data
4. Dev agent can implement pipeline code from this design

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`</action>

**Success:** Document published, handoff posted, next steps provided. **Failure:** Not publishing, no quality checks, no handoff.
</step>

</workflow>

# Data Migration Plan — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Creates a comprehensive data migration plan through collaborative discovery — migration scope assessment, strategy selection, migration script outlines, rollback procedures, data validation checks, and downtime estimation. All output is written to a Linear Document.

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

**1A. Check for existing migration plan:**

<action>Call `list_documents` and search for documents with "Data Migration" in the title</action>

If found, present continuation menu:

"Welcome back {user_name}! I found your existing Data Migration work for {project_name}.
- **[R] Resume** — Continue from where we left off
- **[C] Continue** — Jump to the next logical step
- **[O] Overview** — See all remaining steps
- **[X] Start over** — Begin fresh (creates a new document)"

**1B. Load project context:**

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "prd"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "architecture"` (recommended)</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "data_model"` (recommended — target schema)</action>

**1C. Report and confirm:**

"Welcome {user_name}! Data migration planning workspace ready for {project_name}.

**Documents Loaded:**
- PRD: {status}
- Architecture: {status}
- Data Model (target schema): {status}

What systems or databases are you migrating from? **[C] Continue** to migration scope assessment"

**Success:** Context loaded, user confirmed scope. **Failure:** Not loading target data model, not confirming migration scope.
</step>

<step n="2" goal="Migration scope assessment — what data is moving, how much, and where">

**2A. Source system inventory:**

For each source system:
- System name and type (RDBMS, NoSQL, flat files, SaaS export, legacy app)
- Database engine and version
- Schema documentation (tables, columns, types, relationships)
- Data volume (table row counts, total storage size)
- Data age and retention (oldest records, archival needs)
- Access method (direct DB access, API export, file dump)

**2B. Target system definition:**

- Target database engine and version
- Target schema (from data model document if available)
- Hosting environment (cloud provider, region, instance size)
- Performance baselines (expected write throughput, storage capacity)

**2C. Data mapping matrix:**

| Source Table | Source Columns | Target Table | Target Columns | Transform | Notes |
|---|---|---|---|---|---|
| {source} | {columns} | {target} | {columns} | {transform} | {notes} |

**2D. Scope summary:**

"Migration scope for {project_name}:

- **Source systems:** {count} ({list})
- **Tables to migrate:** {table_count}
- **Estimated total records:** {record_count}
- **Estimated data volume:** {size}
- **Data relationships to preserve:** {relationship_count}
- **Data transformations required:** {transform_count}

Any corrections or additions?"

**Present A/P/C menu.** On C, hold content and proceed to step 3.

**Success:** Full scope documented with volumes and mapping. **Failure:** Missing tables, no volume estimates, incomplete mapping.
</step>

<step n="3" goal="Migration strategy selection — approach, phases, and risk assessment">

**3A. Evaluate migration strategies:**

| Strategy | Description | Best For | Risk Level |
|---|---|---|---|
| **Big Bang** | Full cutover in single window | Small datasets, low complexity | High (all-or-nothing) |
| **Phased** | Migrate in stages by domain/table | Large datasets, can isolate domains | Medium |
| **Dual Write** | Write to both systems during transition | Zero-downtime requirement | High (consistency) |
| **Trickle** | Continuous sync, cutover when caught up | Very large datasets | Low (gradual) |
| **Blue-Green** | Parallel environments, DNS switch | Infrastructure migration | Medium |

**3B. Strategy recommendation:**

Based on scope assessment, recommend strategy with rationale:
- Data volume implications
- Downtime tolerance
- Rollback complexity
- Team capacity and expertise
- Business constraints (peak seasons, compliance windows)

**3C. Phase planning (if phased/trickle):**

For each phase:
- Tables and entities included
- Dependencies on other phases
- Validation criteria to proceed to next phase
- Estimated duration window
- Rollback scope (phase-level vs full)

**3D. Risk assessment:**

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Data loss during migration | {L/M/H} | {L/M/H} | {mitigation} |
| Schema incompatibility | {L/M/H} | {L/M/H} | {mitigation} |
| Performance degradation | {L/M/H} | {L/M/H} | {mitigation} |
| Extended downtime | {L/M/H} | {L/M/H} | {mitigation} |

**Present A/P/C menu.** On C, hold content and proceed to step 4.

**Success:** Strategy selected with clear rationale, phases defined, risks assessed. **Failure:** No strategy comparison, missing risk assessment.
</step>

<step n="4" goal="Migration scripts outline — schema changes, data transforms, sequence">

**4A. Pre-migration scripts:**

- Target schema creation (DDL for new tables, columns, constraints)
- Index creation (create after data load for performance, or before for constraint validation)
- Temporary migration infrastructure (staging tables, tracking tables, migration status table)
- Feature flags or application changes to support dual-read

**4B. Data migration scripts — for each table/entity:**

```
Migration: {sequence_number} - {table_name}
Source: {source_table} ({source_db})
Target: {target_table} ({target_db})
Strategy: {insert/upsert/transform}
Dependencies: {list of migrations that must complete first}
Estimated records: {count}

Transformations:
- {column}: {transformation rule}

Validation:
- Row count: source vs target
- Checksum: {columns to checksum}
- Sample verification: {key records to spot-check}
```

**4C. Post-migration scripts:**

- Constraint re-enablement (FKs disabled during load)
- Sequence/auto-increment resetting
- Index rebuilding and statistics update
- Cleanup of staging/temporary tables
- Application configuration updates (connection strings, feature flags)

**4D. Execution sequence:**

Present the migration DAG — which scripts run in what order, which can run in parallel:

```
Phase 1 (Reference Data):
  1.1 → Countries, Currencies, Categories (parallel)

Phase 2 (Core Entities):
  2.1 → Users (depends on: 1.1)
  2.2 → Organizations (depends on: 1.1)

Phase 3 (Dependent Entities):
  3.1 → Orders (depends on: 2.1)
  3.2 → Products (depends on: 2.2)
```

**Present A/P/C menu.** On C, hold content and proceed to step 5.

**Success:** Scripts outlined with sequence, dependencies, and transforms. **Failure:** Missing dependencies, no execution order, no staging strategy.
</step>

<step n="5" goal="Rollback procedures and data validation">

**5A. Rollback procedure per migration step:**

For each migration script:
- Rollback script or procedure
- Data preservation during rollback (backup strategy)
- Point of no return (if any — when rollback becomes impractical)
- Decision criteria (when to trigger rollback vs continue)

**5B. Rollback levels:**

- **Record-level:** Undo individual record failures (quarantine and retry)
- **Table-level:** Restore single table from backup/snapshot
- **Phase-level:** Roll back entire phase (all tables in phase)
- **Full rollback:** Return to pre-migration state entirely

**5C. Data validation — pre-migration:**

- Source data profiling (null rates, cardinality, value distributions)
- Source data quality baseline (known issues, accepted inconsistencies)
- Record counts and checksums for reconciliation

**5D. Data validation — during migration:**

- Progress tracking (records processed, success rate, error rate)
- Real-time validation (constraint violations, transform failures)
- Threshold alerts (error rate > X% triggers pause)

**5E. Data validation — post-migration:**

- **Completeness:** Row count reconciliation per table (source vs target)
- **Accuracy:** Checksum comparison on key columns
- **Referential integrity:** FK validation in target database
- **Business rules:** Application-level validation queries
- **Sample verification:** Manual spot-check of critical records
- **Regression testing:** Run application test suite against migrated data

**5F. Acceptance criteria:**

Define the criteria that must be met for migration to be considered successful:
- All row counts match within tolerance ({tolerance}%)
- Zero orphaned records (referential integrity passes)
- All business-critical queries return expected results
- Application smoke tests pass
- Performance benchmarks met (query response times)

**Present A/P/C menu.** On C, hold content and proceed to step 6.

**Success:** Rollback at every level, validation at every stage, clear acceptance criteria. **Failure:** No rollback procedure, validation only post-migration, no acceptance criteria.
</step>

<step n="6" goal="Downtime estimation, communication plan, and write to Linear Document">

**6A. Downtime estimation (if applicable):**

- Total migration window estimate (based on data volume and throughput)
- Application downtime window (if any — vs read-only mode vs zero downtime)
- Communication plan (stakeholders, timing, channels)
- Maintenance page or degraded-mode strategy

**6B. Runbook — day-of execution plan:**

```
T-24h: Final source backup, notify stakeholders
T-4h:  Pre-migration validation, staging environment test
T-1h:  Application maintenance mode, final incremental sync
T-0:   Execute migration scripts (Phase 1, 2, 3...)
T+Xh:  Post-migration validation
T+Xh:  Application cutover, smoke tests
T+Xh:  Monitoring period (enhanced alerting)
T+24h: Declare success or initiate rollback
```

**6C. Open questions and decisions needed:**

List any unresolved items requiring stakeholder input.

**6D. Compile the complete migration plan:**

<action>Compile all content from steps 2-6 into a comprehensive document</action>
<action>Generate in {document_output_language}</action>

**6E. Write to Linear Document:**

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] Data Migration Plan: {migration_name}"
body_content: "{compiled_migration_content}"
key_map_id: "data_migration"
```

<action>Update `{key_map_file}` with new document ID under `documents.data_migration`</action>

**6F. Post handoff:**

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "Architect"
handoff_type: "data_migration_complete"
summary: "Data migration plan published to Linear Document. {table_count} tables, {strategy} strategy, rollback procedures defined."
document_id: "{migration_document_id}"
```

**6G. Report to user:**

**Data Migration Plan Complete**
- **Linear Document:** {migration_document_title}
- **Status:** Published
- **Tables in Scope:** {table_count}
- **Migration Strategy:** {strategy}
- **Phases:** {phase_count}
- **Rollback Procedures:** Defined for all levels
- **Handoff:** Architect (Opus) notified

**Next Steps:**
1. Review the migration plan in Linear Documents
2. Share runbook with operations team
3. Schedule migration window with stakeholders
4. Run test migration in staging environment
5. Dev agent can implement migration scripts from this plan

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`</action>

**Success:** Document published, handoff posted, next steps provided. **Failure:** Not publishing, no runbook, no handoff.
</step>

</workflow>

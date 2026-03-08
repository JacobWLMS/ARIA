# Generate Project Context — Document Output

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Scans the existing project codebase to produce a lean, LLM-optimized project context document. Captures tech stack, architecture patterns, naming conventions, testing strategy, key files, and critical implementation rules so that downstream agents can work effectively without re-scanning the codebase. The context document is saved locally AND published to a document.

**Role:** You are a technical peer collaborating with the user to discover and document their project's critical implementation rules. Focus on unobvious details that AI agents might miss.

---

<workflow>

<step n="1" goal="Initialize, check for existing context, and discover project stack">
<action>Communicate in {communication_language} with {user_name}</action>
<action>Invoke the `read-context` task with `context_type: "project_overview"`</action>

### Check for Existing Context

<action>Search for existing project context on the platform:</action>
<action>Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document_artefact"` and `query: "Project Context"`</action>

If found:
- Load via the `read-context` task
- Present: "Found existing project context with {section_count} sections. Would you like to **update** this or **create a new one** from scratch?"

### Discover Project Technology Stack

<action>Scan the project codebase systematically:</action>
- Package and dependency files (package.json, requirements.txt, pyproject.toml, etc.)
- Configuration files (tsconfig.json, build configs, linting configs, test configs, Docker, CI/CD)
- Directory structure and layout patterns
- Entry points, routing, bootstrapping code

<action>Present discovery summary and wait for user confirmation</action>

### Success Criteria
- Existing context detected and handled (update vs new)
- Technology stack accurately identified with exact versions
- Project structure mapped
</step>

<step n="2" goal="Collaboratively generate critical implementation rules">

For each rule category, follow: present analysis, get user feedback, present A/P/C menu.

### Categories:
1. **Technology Stack & Versions** — exact versions, key deps, runtime
2. **Language-Specific Rules** — unobvious patterns agents might miss
3. **Framework-Specific Rules** — hooks, routing, data fetching, DI patterns
4. **Testing Rules** — framework, naming, mocking, coverage, test data
5. **Code Quality & Naming Conventions** — file naming, import ordering, style
6. **Architecture & Data Flow** — module boundaries, API patterns, state management
7. **Critical Don't-Miss Rules** — anti-patterns, edge cases, security, performance gotchas

For each category, present findings, get user confirmation, and offer A/P/C menu.

### Success Criteria
- All 7 categories covered with user-validated rules
- Focus on unobvious details, not boilerplate
- Each rule is specific and actionable
</step>

<step n="3" goal="Compile, optimize, save locally, publish to document">

### Compile the Project Context Document

<action>Assemble all validated category content into a single document using template at `{template}`</action>
<action>Review for redundancy, verbosity, and missing rules</action>
<action>Generate in {document_output_language}</action>

### Save Locally

<action>Write to `{project-root}/project-context.md`</action>

### Publish to document

<action>Invoke the `write-document` task with:</action>

```
title: "[{team_name}] Project Context: {project_name}"
content: "{compiled_project_context}"
key_map_entry: "documents.project_context"
```

<action>Update `{key_map_file}` with the new document ID</action>

### Report Completion

"**Project Context Generated**

- **Local File:** `{project-root}/project-context.md`
- **document:** {document_title}
- **Rules Documented:** {rule_count} across {section_count} sections
- **Status:** Published

**How Agents Use This:**
- Dev agent reads this before implementing any story
- Architect references it during architecture design
- QA agent uses it to validate implementation patterns"

<action>Invoke the help task at {project-root}/_aria/core/tasks/help.md</action>

### Success Criteria
- Document is lean and optimized for LLM consumption
- Saved both locally and on the platform
- Key map updated with document ID
</step>

</workflow>

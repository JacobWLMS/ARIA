# Document Project — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Scans a brownfield project and produces comprehensive documentation on Linear. The user selects which aspects to document (API, architecture, setup, or all), and the workflow generates structured documentation published as Linear Documents.

---

<workflow>

<step n="1" goal="Initialize and determine documentation scope">
<action>Communicate in {communication_language} with {user_name}</action>
<action>Invoke the `read-linear-context` task with `context_type: "project_overview"`</action>

<action>Ask the user what aspects of the project to document:</action>

"Welcome {user_name}! Let's document your project.

**What aspects would you like to document?**

1. **API** — API endpoints, request/response schemas, authentication
2. **Architecture** — System design, component relationships, data flow
3. **Setup** — Installation, configuration, development environment
4. **All** — Comprehensive documentation covering everything

Please select one or more, or tell me what specific areas you need documented."

<action>
  {if autonomy_level == "yolo"}
    Auto-select "All" for comprehensive documentation.
  {else}
    Wait for user selection.
  {end_if}
</action>
</step>

<step n="2" goal="Scan the project for documentation sources">
<action>Scan the project comprehensively based on the selected aspects:</action>

1. Package and dependency files
2. Configuration files (environment, Docker, CI/CD, IaC)
3. Existing documentation (README, CONTRIBUTING, CHANGELOG, OpenAPI specs)
4. Source structure (directories, modules, key code paths)
5. Key modules (entry points, routing, middleware, services, data access)

<action>For API documentation: scan routes, controllers, request/response types, auth middleware</action>
<action>For Architecture documentation: scan module boundaries, database schemas, event systems, integrations</action>
<action>For Setup documentation: scan Docker files, env vars, build scripts, CI/CD configs</action>
<action>Report progress to the user as the scan proceeds</action>
</step>

<step n="3" goal="Generate structured documentation">
<action>Compile documentation covering the relevant sections:</action>

- Project Overview (name, purpose, tech stack, high-level architecture)
- Setup Guide (prerequisites, installation, environment config, running locally, running tests)
- Architecture Overview (system design, component relationships, data flow, database schema, integrations)
- API Reference (endpoints, request/response formats, authentication, error codes)
- Key Components (core modules, shared utilities, configuration, middleware)
- Development Workflow (branch strategy, testing, code review, deployment)

<action>Generate in {document_output_language}</action>
<action>Only include sections relevant to the user's selected aspects</action>
</step>

<step n="4" goal="Publish documentation to Linear Document">
<action>Invoke the `write-to-linear-doc` task with:</action>

```
title: "[{linear_team_name}] Documentation: {project_name}"
content: "{compiled_documentation}"
key_map_entry: "documents.project_documentation"
```

<action>Update `{key_map_file}` with the new Linear Document ID</action>

<action>Report to user:</action>

"**Project Documentation Complete**

- **Linear Document:** {document_title}
- **Scope:** {documentation_aspects}
- **Status:** Published

**Next Steps:**
1. Review the documentation on Linear for accuracy
2. Run additional documentation passes for other aspects if needed
3. Keep documentation updated as the project evolves"

<action>Invoke the help task at {project-root}/_aria/linear/tasks/help.md</action>
</step>

</workflow>

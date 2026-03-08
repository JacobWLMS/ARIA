# Create Product Brief — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

<workflow>

<step n="1" goal="Initialize and load context from Linear">

**Progress: Step 1 of 6** — Next: Product Vision Discovery

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are a product-focused Business Analyst facilitator
- Engage in collaborative dialogue, not command-response
- You bring structured thinking and facilitation skills; the user brings domain expertise and product vision

### 1.1 Check for Existing Product Brief

Search Linear for an existing product brief:
- Call `list_documents` and search for documents with "Product Brief" in the title

If an existing brief is found, offer the user a choice:

{if autonomy_level == "interactive"}
  "I found an existing product brief: {brief_title}. Would you like to:
  - [R] Resume/continue editing the existing brief
  - [N] Start a new product brief from scratch (existing one will remain)"
  Wait for user selection.
{else}
  If existing brief is found, announce it and auto-proceed with new creation unless the brief appears incomplete.
{end_if}

If resuming: load the existing brief content via `get_document`, present a progress summary, and skip to the first incomplete section.

### 1.2 Load Context from Linear

Invoke the `read-linear-context` task with `context_type: "project_overview"` to fetch existing project context.

**Context Discovery — search for these artefacts on Linear:**
- Brainstorming Documents: `list_documents` searching for "Brainstorming" titles
- Research Documents: `list_documents` searching for "Research" titles
- Project Context: `list_documents` searching for "Project Context" titles

Load ALL discovered documents completely via `get_document`.

<critical>Confirm what you have found with the user, along with asking if the user wants to provide anything else. Only after this confirmation will you proceed.</critical>

### 1.3 Load Workflow Resources

- Load the product brief template from `{template}`

### 1.4 Present Setup Report

"Welcome {user_name}! I've set up your product brief workspace.

**Context Loaded from Linear:**
- Brainstorming: {brainstormCount} documents
- Research: {researchCount} documents
- Project context: {contextCount} documents

Do you have any other documents you'd like me to include, or shall we continue?"

### 1.5 Menu

"[C] Continue — Move to Product Vision Discovery (Step 2 of 6)"

### Success Criteria
- Existing brief detected and continuation offered if found
- Context loaded from Linear Documents (not local files)
- All discovered documents confirmed with user before proceeding

### Failure Modes
- Proceeding with fresh creation when existing brief exists without offering choice
- Not confirming discovered documents with user

</step>

<step n="2" goal="Discover the product vision, problem statement, and unique value proposition">

**Progress: Step 2 of 6** — Next: Target Users

### Step Goal

Conduct comprehensive product vision discovery through collaborative analysis. This is facilitation and discovery only.

### 2.1-2.5 Vision Discovery

Follow the same collaborative discovery process as the shared workflow:
- Begin vision discovery with the user
- Deep problem understanding
- Current solutions analysis
- Solution vision
- Unique differentiators

### 2.6 Generate Executive Summary and Core Vision Content

Draft Executive Summary, Problem Statement, Problem Impact, Existing Solutions, Proposed Solution, and Key Differentiators sections.

Present the drafted content to the user for review.

### 2.7 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Target Users (Step 3 of 6)"

### Success Criteria
- Clear problem statement, compelling solution vision, unique differentiators
- User confirms content before proceeding

### Failure Modes
- Accepting vague problem statements without pushing for specificity

</step>

<step n="3" goal="Define target users with rich personas and map key interactions">

**Progress: Step 3 of 6** — Next: Success Metrics

Follow the same user discovery, persona development, and journey mapping process. Generate Target Users content. Present menu with A/P/C options.

</step>

<step n="4" goal="Define success metrics, business objectives, and KPIs">

**Progress: Step 4 of 6** — Next: MVP Scope

Follow the same success metrics discovery process. Generate Success Metrics content. Present menu with A/P/C options.

</step>

<step n="5" goal="Define MVP scope with clear boundaries and future vision">

**Progress: Step 5 of 6** — Next: Publish to Linear

Follow the same MVP scope definition process. Generate MVP Scope content. Present menu with A/P/C options.

</step>

<step n="6" goal="Compile the product brief, write to Linear Document, and hand off">

**Progress: Step 6 of 6** — Final Step

### 6.1 Document Quality Check

Perform final validation: completeness and consistency checks.

### 6.2 Compile the Complete Product Brief

Compile from all elicitation steps (2-5) using the template at `{template}`. Generate in {document_output_language}.

### 6.3 Write to Linear Document

Invoke the `write-to-linear-doc` task with:

```
title: "[{linear_team_name}] Product Brief: {project_name}"
content: "{compiled_product_brief_content}"
key_map_entry: "documents.product_brief"
```

Update `{key_map_file}` with the new Linear Document ID under `documents.product_brief`.

### 6.4 Post Handoff

Invoke the `post-handoff` task with:

```
handoff_to: "PM"
handoff_type: "product_brief_complete"
summary: "Product brief created and published to Linear Document. Ready for PRD creation."
document_id: "{product_brief_doc_id}"
```

### 6.5 Report Completion

"**Product Brief Complete, {user_name}!**

- **Linear Document:** {document_title}
- **Status:** Published
- **Handoff:** PM agent notified for PRD creation

**Next Steps:**
1. Review the product brief on Linear
2. PM agent can begin PRD creation with **Create PRD**
3. Optionally run Research workflows for deeper analysis"

### 6.6 Help

Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`.

### Success Criteria
- Product brief published to Linear Document
- Key map updated with document ID
- Handoff posted to PM agent

### Failure Modes
- Publishing incomplete or inconsistent brief
- Not updating key map with document ID
- Not posting handoff to PM agent

</step>

</workflow>

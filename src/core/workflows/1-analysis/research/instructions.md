# Research — Document Output

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Conducts comprehensive research (market, domain, or technical) using web search and verified sources. The research type is determined by user input. Output is written to a document as a research report.

**Prerequisite:** Web search capability is REQUIRED. If unavailable, abort immediately and inform the user.

**Output Template:** `{template}`

---

<workflow>

<step n="1" goal="Initialize research, load context, and confirm scope with user">
<action>Communicate in {communication_language} with {user_name}</action>
<action>Invoke the `read-context` task with `context_type: "project_overview"` to check for existing context on the platform</action>

<action>Greet the user and begin topic discovery:</action>

"Welcome {user_name}! Let's get started with your research.

**What topic, problem, or area do you want to research?**
**What type of research?** [Market] [Domain] [Technical]"

<action>Clarify core topic, research goals, and scope based on the research type selected</action>
<action>Present confirmed research scope and get user approval</action>

<autonomy>
In `yolo` mode: After the user states their topic, infer goals and scope from context and proceed directly.
</autonomy>
</step>

<step n="2" goal="Execute first research area with web search and source verification">
<action>Begin the first research area based on {research_type}:</action>

- **Market:** Customer Behavior and Segments
- **Domain:** Industry Analysis and Market Dynamics
- **Technical:** Technology Stack Analysis

<action>Execute web searches, analyze findings, cross-reference sources, note confidence levels</action>
<action>Present key findings summary and A/P/C menu</action>
</step>

<step n="3" goal="Execute second research area">
<action>Begin the second research area based on {research_type}:</action>

- **Market:** Customer Pain Points and Needs
- **Domain:** Competitive Landscape and Ecosystem
- **Technical:** Integration Patterns

<action>Execute web searches, analyze, cross-reference. Present findings and A/P/C menu.</action>
</step>

<step n="4" goal="Execute third research area">
<action>Begin the third research area based on {research_type}:</action>

- **Market:** Customer Decision Journey
- **Domain:** Regulatory and Compliance Requirements
- **Technical:** Architectural Patterns

<action>Execute web searches, analyze, cross-reference. Present findings and A/P/C menu.</action>
</step>

<step n="5" goal="Execute fourth research area">
<action>Begin the fourth research area based on {research_type}:</action>

- **Market:** Competitive Analysis
- **Domain:** Technical Trends and Innovation
- **Technical:** Implementation Research

<action>Execute web searches, analyze, cross-reference. Present findings and A/P/C menu.</action>
</step>

<step n="6" goal="Synthesize findings, write to document, and hand off">
<action>Compile the complete research report in {document_output_language} using the template at `{template}`</action>

The report MUST include: Executive Summary, Table of Contents, Research Introduction, all four research area sections, Strategic Recommendations, Risk Assessment, Implementation Roadmap, Future Outlook, Methodology and Sources, Appendices.

Every factual claim MUST include a source URL.

<action>Invoke the `write-document` task with:</action>

```
title: "[{team_name}] Research: {research_topic}"
content: "{compiled_research_report}"
key_map_entry: "documents.research_{research_type}"
```

<action>Update `{key_map_file}` with the new document ID</action>

<action>Invoke the `post-handoff` task with:</action>

```
handoff_to: "PM"
handoff_type: "research_complete"
summary: "{research_type} research on '{research_topic}' published to document."
document_id: "{research_doc_id}"
```

<action>Report to user with research summary and next steps</action>
<action>Invoke the help task at {project-root}/_aria/core/tasks/help.md</action>
</step>

</workflow>

# Step 1: Validate Prerequisites and Extract Requirements

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## STEP GOAL

Validate that all required artefacts exist on Linear and extract all requirements (FRs, NFRs, and additional requirements from UX/Architecture) needed for epic and story creation.

---

<workflow>

<step n="1.1" goal="Welcome and announce the workflow">
<action>Communicate in {communication_language} with {user_name}</action>
<action>Announce: "**Create Epics and Stories — Step 1: Validate Prerequisites**"</action>
<action>Explain the four-step workflow:
1. **Validate Prerequisites** — load artefacts from Linear and extract requirements (this step)
2. **Design Epics** — group requirements into user-value-focused epics
3. **Create Stories** — break each epic into implementable user stories
4. **Linear Output** — write projects and issues to Linear with proper linking
</action>
</step>

<step n="1.2" goal="Discover artefacts from key map and Linear Documents">
<action>Read `{key_map_file}` and check for the following Linear Document entries:</action>

**Required artefacts:**

| Artefact | Key Map Path | Status |
|---|---|---|
| PRD | `documents.prd` | REQUIRED |
| Architecture | `documents.architecture` | REQUIRED |

**Optional artefacts:**

| Artefact | Key Map Path | Status |
|---|---|---|
| UX Design | `documents.ux_design` | Optional — note if available |
| Product Brief | `documents.product_brief` | Optional — note if available |

<action>If `documents.prd` is missing from `{key_map_file}`, warn the user:
"No PRD found in the key map. A PRD is required for epic and story creation. Please run the **Create PRD** workflow first."
Ask whether to proceed without it or stop.</action>

<action>If `documents.architecture` is missing from `{key_map_file}`, warn the user:
"No Architecture document found in the key map. Architecture context is required for complete epic and story creation. Please run the **Create Architecture** workflow first."
Ask whether to proceed without it or stop.</action>

<action>If `documents.ux_design` exists, note: "UX Design document found — will extract UX-related requirements."</action>
</step>

<step n="1.3" goal="Load artefacts from Linear">
<action>For each artefact found in the key map, load its content from Linear:</action>

<action>**PRD:** Call `get_document` with the document ID from `documents.prd` in `{key_map_file}`</action>
<action>**Architecture:** Call `get_document` with the document ID from `documents.architecture` in `{key_map_file}`</action>
<action>**UX Design (if available):** Call `get_document` with the document ID from `documents.ux_design` in `{key_map_file}`</action>
<action>**Product Brief (if available):** Call `get_document` with the document ID from `documents.product_brief` in `{key_map_file}`</action>

<action>Also check for existing Projects (Epics) in Linear:</action>
<action>Call `list_projects` with `team: "{linear_team_name}"` to discover any existing ARIA projects</action>
<action>If existing projects are found, present them and ask:
"Found {count} existing projects. Would you like to:
- **[A] Add** — Add more stories to existing projects
- **[N] New** — Create new projects from scratch
- **[R] Replace** — Start fresh (will not delete existing, but creates new projects)"
</action>

<action>Ask the user if there are any other Linear Documents or documents to include for analysis, and if anything found should be excluded. Wait for user confirmation before proceeding.</action>
</step>

<step n="1.4" goal="Extract Functional Requirements (FRs) from the PRD">
<action>Read the entire PRD content loaded from Linear and extract ALL functional requirements:</action>

**Extraction method:**
- Look for numbered items like "FR1:", "Functional Requirement 1:", or similar patterns
- Identify requirement statements that describe what the system must DO
- Include user actions, system behaviours, and business rules

**Format the FR list as:**

```
FR1: [Clear, testable requirement description]
FR2: [Clear, testable requirement description]
...
```

<action>Store the extracted FRs in working memory for presentation in step 1.7</action>
</step>

<step n="1.5" goal="Extract Non-Functional Requirements (NFRs) from the PRD">
<action>From the PRD content, extract ALL non-functional requirements:</action>

**Extraction method:**
- Look for performance, security, usability, reliability requirements
- Identify constraints and quality attributes
- Include technical standards and compliance requirements

**Format the NFR list as:**

```
NFR1: [Performance/Security/Usability requirement]
NFR2: [Performance/Security/Usability requirement]
...
```

<action>Store the extracted NFRs in working memory for presentation in step 1.7</action>
</step>

<step n="1.6" goal="Extract additional requirements from Architecture and UX">
<action>Review the Architecture document for technical requirements that impact epic and story creation:</action>

**Look for:**
- **Starter Template**: Does Architecture specify a starter/greenfield template? If YES, document this prominently — it will impact Epic 1 Story 1
- Infrastructure and deployment requirements
- Integration requirements with external systems
- Data migration or setup requirements
- Monitoring and logging requirements
- API versioning or compatibility requirements
- Security implementation requirements
- Tech stack decisions that constrain implementation

<action>If UX Design document was loaded, also extract:</action>

**UX requirements to look for:**
- Responsive design requirements
- Accessibility requirements
- Browser/device compatibility
- User interaction patterns that need implementation
- Animation or transition requirements
- Error handling UX requirements

**Format additional requirements as:**

```
- [Technical requirement from Architecture that affects implementation]
- [Infrastructure setup requirement]
- [Integration requirement]
- [UX requirement if applicable]
...
```

<action>Store the additional requirements in working memory</action>
</step>

<step n="1.7" goal="Present extracted requirements and confirm with user">
<action>Display a comprehensive summary to the user:</action>

**Artefacts Loaded:**

| Source | Status | Document ID |
|---|---|---|
| PRD | {loaded/not found} | {document_id} |
| Architecture | {loaded/not found} | {document_id} |
| UX Design | {loaded/not found/not applicable} | {document_id} |

**Functional Requirements Extracted:**
- Total FRs found: {count}
- Display the first several FRs as examples
- Note any areas where FR clarity is questionable

**Non-Functional Requirements Extracted:**
- Total NFRs found: {count}
- Display key NFRs
- Note any constraints that were identified

**Additional Requirements (Architecture/UX):**
- Summarise technical requirements from Architecture
- Note if a starter template was identified
- Summarise UX requirements (if applicable)

<action>Ask: "Do these extracted requirements accurately represent what needs to be built? Any additions, corrections, or requirements that were missed?"</action>
<action>Update the requirements based on user feedback until confirmation is received</action>
</step>

<step n="1.8" goal="Confirm readiness to proceed">
<action>Display: "**Requirements extraction complete. Confirm the requirements are complete and correct to [C] continue to Epic Design:**"</action>

**Menu handling:**
- IF **C**: Proceed to step-02-design-epics.md — carry all extracted requirements (FRs, NFRs, additional) forward in working memory
- IF any other comments or queries: respond to the user, then redisplay the menu option

<action>ALWAYS halt and wait for user input after presenting the menu</action>
<action>ONLY proceed to the next step when user selects C</action>
</step>

</workflow>

---

## Success Criteria

- All required Linear Documents discovered and loaded via key map
- All FRs extracted and formatted correctly from the PRD
- All NFRs extracted and formatted correctly from the PRD
- Additional requirements from Architecture and UX identified
- Existing projects checked to prevent duplicates
- User confirms requirements are complete and accurate
- Requirements carried forward in working memory for Step 2

## Failure Conditions

- Required artefacts missing without user acknowledgement
- Incomplete requirements extraction
- Proceeding without user confirmation
- Not checking for existing projects (creating duplicates)
- Attempting to create epics or stories in this step (FORBIDDEN)

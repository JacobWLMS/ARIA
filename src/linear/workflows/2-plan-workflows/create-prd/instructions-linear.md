# Create PRD — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

<workflow>

<step n="1" goal="Initialize and load context from Linear">

**Progress: Step 1 of 12** — Next: Project Discovery

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are a product-focused PM facilitator collaborating with an expert peer
- Engage in collaborative dialogue, not command-response
- You bring structured thinking and facilitation; the user brings domain expertise and product vision

### 1.1 Check for Existing PRD

Search Linear for an existing PRD:
- Call `list_documents` and search for documents with "PRD" or "Product Requirements" in the title
- If found, offer the user a choice:

{if autonomy_level == "interactive"}
  "I found an existing PRD on Linear: {prd_title}. Would you like to:
  - [R] Resume/continue editing the existing PRD
  - [N] Start a new PRD from scratch (existing one will remain)"
  Wait for user selection.
{else}
  If existing PRD is found, announce it and auto-proceed with new creation unless the PRD appears incomplete.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

If resuming: load the existing PRD content via `get_document`, present a progress summary, and skip to the first incomplete section based on what content exists. Treat any section with substantive content as complete.

### 1.2 Load Context from Linear

Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"` to fetch existing project context from Linear Documents (product brief, research reports, brainstorming notes).

**Context Discovery — search for these artefacts on Linear:**
- Product Brief: invoke `read-linear-context` with `context_type: "document"` and `scope_key: "product_brief"`
- Research Reports: call `list_documents` searching for documents with "Research" in the title
- Brainstorming: call `list_documents` searching for documents with "Brainstorming" in the title
- Project Context: call `list_documents` searching for documents with "Project Context" in the title

Load ALL discovered documents completely via `get_document`. Confirm findings with the user before proceeding:

<critical>Confirm what you have found with the user, along with asking if the user wants to provide anything else. Only after this confirmation will you proceed.</critical>

### 1.3 Load Workflow Resources

- Load the PRD template from `{template}`
- Load the PRD checklist from `{checklist}`

### 1.4 Present Setup Report

"Welcome {user_name}! I've set up your PRD workspace for {project_name}.

**Context Loaded from Linear:**
- Product briefs: {briefCount} documents {if briefCount > 0} -- loaded{else}(none found){end_if}
- Research: {researchCount} documents {if researchCount > 0} -- loaded{else}(none found){end_if}
- Brainstorming: {brainstormCount} documents {if brainstormCount > 0} -- loaded{else}(none found){end_if}
- Project docs: {projectDocsCount} documents {if projectDocsCount > 0} -- loaded (brownfield project){else}(none found — greenfield project){end_if}

{if projectDocsCount > 0}
**Note:** This is a **brownfield project**. Your existing project documentation has been loaded. In the next step, I'll ask specifically about what new features or changes you want to add to your existing system.
{end_if}

Do you have any other documents you'd like me to include, or shall we continue?"

### 1.5 Menu

"[C] Continue — Move to Project Discovery (Step 2 of 12)"

- IF C: Proceed to step 2
- IF user provides additional context: Load it, update report, redisplay menu
- IF user asks questions: Answer and redisplay menu

### Success Criteria
- Existing PRD detected and continuation offered if found
- Context loaded from Linear Documents (not local files)
- User clearly informed of brownfield vs greenfield status
- All discovered documents confirmed with user before proceeding

### Failure Modes
- Proceeding with fresh initialization when existing PRD exists without offering choice
- Looking for local files instead of Linear Documents
- Not confirming discovered documents with user
- Proceeding without user selecting C

</step>

<step n="2" goal="Discover project type, domain, and context through collaborative dialogue">

**Progress: Step 2 of 12** — Next: Product Vision

### Step Goal

Discover and classify the project — understand what type of product this is, what domain it operates in, and the project context (greenfield vs brownfield). This is classification and understanding only. No content generation yet.

### 2.1 Announce Context State

"From step 1, I have loaded:
- Product briefs: {briefCount}
- Research: {researchCount}
- Brainstorming: {brainstormCount}
- Project docs: {projectDocsCount}

{if projectDocsCount > 0}This is a brownfield project — I'll focus on understanding what you want to add or change.{else}This is a greenfield project — I'll help you define the full product vision.{end_if}"

### 2.2 Load Classification Data

Load reference data for intelligent classification:
- Load `{project-root}/_aria/shared/data/project-types-prd.csv` — find row matching detected project type, extract `project_type` and `detection_signals`
- Load `{project-root}/_aria/shared/data/domain-complexity-prd.csv` — find row matching detected domain, extract `domain`, `complexity`, `typical_concerns`, `compliance_requirements`

### 2.3 Discovery Conversation

**If the user has a product brief or project docs:** Acknowledge them, share your understanding of the product. Then ask clarifying questions to deepen understanding.

**If greenfield with no docs:** Start with open-ended discovery:
- "What problem does this solve?"
- "Who's it for?"
- "What excites you about building this?"

**Listen for classification signals as the user describes their product:**
- **Project type signals** — web app, API, mobile, SaaS, CLI tool, etc.
- **Domain signals** — healthcare, fintech, education, e-commerce, etc.
- **Complexity indicators** — regulated industries, novel technology, enterprise integrations

### 2.4 Confirm Classification

Once you have enough understanding, share your classification:

"I'm hearing this as:
- **Project Type:** {detectedType}
- **Domain:** {detectedDomain}
- **Complexity:** {complexityLevel}
- **Project Context:** {greenfield|brownfield}

Does this sound right to you?"

Let the user confirm or refine.

### 2.5 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Product Vision (Step 3 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with the current classification. Process enhanced insights. Ask user if they accept improvements. If yes, update classification and redisplay menu. If no, keep original and redisplay menu.
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with the current classification. Process collaborative insights. Ask user if they accept changes. If yes, update and redisplay. If no, keep original and redisplay.
- IF C: Proceed to step 3.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report classification.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Classification data loaded from CSV and used intelligently
- Natural conversation to understand project type, domain, complexity
- Classification validated with user before proceeding
- User's existing documents acknowledged and built upon

### Failure Modes
- Skipping classification data loading
- Generating executive summary or vision content (that's later steps)
- Not validating classification with user
- Being prescriptive instead of having natural conversation

</step>

<step n="3" goal="Discover the product vision and differentiator through collaborative dialogue">

**Progress: Step 3 of 12** — Next: Executive Summary

### Step Goal

Discover what makes this product special and understand the product vision through collaborative conversation. This is facilitation only — no content generation yet. No document writing in this step.

### 3.1 Acknowledge Classification Context

Reference the classification from step 2:
"We've established this is a {projectType} in the {domain} domain with {complexityLevel} complexity. Now let's explore what makes this product special."

### 3.2 Explore What Makes It Special

Guide the conversation to uncover the product's unique value:
- **User delight:** "What would make users say 'this is exactly what I needed'?"
- **Differentiation moment:** "What's the moment where users realize this is different or better than alternatives?"
- **Core insight:** "What insight or approach makes this product possible or unique?"
- **Value proposition:** "If you had one sentence to explain why someone should use this over anything else, what would it be?"

### 3.3 Understand the Vision

Dig deeper into the product vision:
- **Problem framing:** "What's the real problem you're solving — not the surface symptom, but the deeper need?"
- **Future state:** "When this product is successful, what does the world look like for your users?"
- **Why now:** "Why is this the right time to build this?"

### 3.4 Validate Understanding

Reflect back what you've heard and confirm:

"Here's what I'm hearing about your vision and differentiator:

**Vision:** {summarized_vision}
**What Makes It Special:** {summarized_differentiator}
**Core Insight:** {summarized_insight}

Does this capture it? Anything I'm missing?"

Let the user confirm or refine.

### 3.5 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Executive Summary (Step 4 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with the current vision insights
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with the current vision insights
- IF C: Proceed to step 4

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report vision summary.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Classification context from step 2 acknowledged and built upon
- Natural conversation to understand product vision and differentiator
- User's existing documents leveraged for vision insights
- Vision and differentiator validated with user before proceeding

### Failure Modes
- Generating executive summary or any document content (that's step 4)
- Not building on classification from step 2
- Being prescriptive instead of having natural conversation

</step>

<step n="4" goal="Generate Executive Summary from discovered vision and classification">

**Progress: Step 4 of 12** — Next: Success Criteria

### Step Goal

Generate the Executive Summary content using insights from classification (step 2) and vision discovery (step 3). This is the first substantive content — it sets the quality bar for everything that follows.

### 4.1 Synthesize Available Context

Review all available context before drafting:
- Classification from step 2: project type, domain, complexity, project context
- Vision and differentiator from step 3: what makes this special, core insight
- Input documents: product briefs, research, brainstorming, project docs

### 4.2 Draft Executive Summary

Generate the Executive Summary section applying PRD quality standards:
- **High information density** — every sentence carries weight
- **Zero fluff** — no filler phrases or vague language ("The system will allow users to..." becomes "Users can...")
- **Precise and actionable** — clear, specific statements
- **Dual-audience optimized** — readable by humans, consumable by LLMs

**Content structure to produce:**

```markdown
## Executive Summary

{vision_alignment_content — product vision, target users, problem being solved. Dense, precise summary from step 3 vision discovery.}

### What Makes This Special

{product_differentiator_content — what makes this product unique, core insight, why users will choose it over alternatives. From step 3 differentiator discovery.}

## Project Classification

{project_classification_content — project type, domain, complexity level, project context (greenfield/brownfield). From step 2 classification.}
```

### 4.3 Present Draft for Review

"Here's the Executive Summary I've drafted based on our discovery work. Please review and let me know if you'd like any changes:"

Show the full drafted content. Allow the user to:
- Request specific changes to any section
- Add missing information
- Refine language or emphasis
- Approve as-is

### 4.4 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Success Criteria (Step 5 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with the executive summary content
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with the executive summary content
- IF C: Hold the approved content in working memory for final Linear Document write. Proceed to step 5.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C if user has not requested changes. Report content summary.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Executive Summary drafted using insights from steps 2 and 3
- Content meets PRD quality standards (dense, precise, zero-fluff)
- Draft presented to user for review before proceeding
- User given opportunity to refine content

### Failure Modes
- Generating content without incorporating discovered vision and classification
- Producing vague, fluffy, or low-density content
- Not presenting draft for user review
- Writing to Linear Document prematurely (all content accumulates until step 12)

</step>

<step n="5" goal="Define comprehensive success criteria covering user, business, and technical success">

**Progress: Step 5 of 12** — Next: User Journey Mapping

### Step Goal

Define comprehensive success criteria that cover user success, business success, and technical success. Use input documents as a foundation while allowing user refinement.

### 5.1 Check Input Documents for Success Indicators

Analyze product brief, research, and brainstorming documents for success criteria already mentioned.

**If Input Documents Contain Success Criteria:**
- Acknowledge what's already documented in their materials
- Extract key success themes from brief, research, and brainstorming
- Help user identify gaps and areas for expansion
- Probe for specific, measurable outcomes

**If No Success Criteria in Input Documents:**
Start with user-centered success exploration:
- "What does 'worth it' mean for your users?"
- "What's the moment users realize their problem is solved?"
- "What specific outcomes would make early adopters excited?"

### 5.2 Explore User Success Metrics

Listen for specific user outcomes and help make them measurable:
- Guide from vague to specific: NOT "users are happy" but "users complete {key action} within {timeframe}"
- "When do users feel delighted/relieved/empowered?"
- "What's the 'aha!' moment?"
- "What does 'done' look like for the user?"

### 5.3 Define Business Success

Transition to business metrics:
- "What does 3-month success look like? 12-month success?"
- "What key business metric would indicate 'this is working'?"
- Revenue, user growth, engagement, efficiency — which matters most?
- What specific metric on what specific timeline?

### 5.4 Challenge Vague Metrics

Push for specificity:
- "10,000 users" — "What kind of users? Doing what?"
- "99.9% uptime" — "What's the real concern — data loss? Failed payments?"
- "Fast" — "How fast, and what specifically needs to be fast?"
- "Good adoption" — "What percentage adoption by when?"

### 5.5 Connect to Product Differentiator

Tie success metrics back to what makes the product special:
- Ensure metrics reflect the specific value proposition
- Adapt success criteria to domain context:
  - Consumer: user love, engagement, retention
  - B2B: ROI, efficiency, adoption
  - Developer tools: developer experience, community growth
  - Regulated: compliance milestones, safety validation
  - GovTech: government compliance, accessibility, procurement

### 5.6 Smart Scope Negotiation

Guide scope definition through success lens:
- Help user distinguish MVP (must work to be useful) from Growth (competitive) and Vision (dream)
- Guide conversation through three scope levels:
  1. **MVP:** What's essential for proving the concept?
  2. **Growth:** What makes it competitive?
  3. **Vision:** What's the dream version?
- Challenge scope creep: "Could this wait until after launch? Is this essential for MVP?"
- For complex domains: ensure compliance minimums are included in MVP

### 5.7 Generate Content

**Content structure to produce:**

```markdown
## Success Criteria

### User Success
{user success criteria based on conversation}

### Business Success
{business success metrics with specific targets}

### Technical Success
{technical success requirements}

### Measurable Outcomes
{specific measurable outcomes with timelines}

## Product Scope

### MVP — Minimum Viable Product
{MVP scope based on conversation}

### Growth Features (Post-MVP)
{growth features}

### Vision (Future)
{future vision features}
```

### 5.8 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to User Journey Mapping (Step 6 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with the success criteria content
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with the success criteria
- IF C: Hold approved content in working memory. Proceed to step 6.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report success criteria summary.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Domain Considerations

If working in regulated domains (healthcare, fintech, govtech):
- Include compliance milestones in success criteria
- Add regulatory approval timelines to MVP scope
- Consider audit requirements as technical success metrics

### Success Criteria
- User success criteria clearly identified and made measurable
- Business success metrics defined with specific targets
- Success criteria connected to product differentiator
- Scope properly negotiated (MVP, Growth, Vision)

### Failure Modes
- Accepting vague success metrics without pushing for specificity
- Not connecting success criteria back to product differentiator
- Missing scope negotiation
- Generating content without real user input

</step>

<step n="6" goal="Map ALL user types with narrative story-based journeys">

**Progress: Step 6 of 12** — Next: Domain Requirements

### Step Goal

Create compelling narrative user journeys that leverage existing personas and identify additional user types. No journey = no functional requirements = product doesn't exist.

### 6.1 Identify User Types

**If User Personas Exist in Input Documents:**
- Acknowledge personas found in product brief
- Extract key persona details and backstories
- Leverage existing insights about their needs
- Suggest additional user types: admins, moderators, support staff, API consumers, internal ops

**If No Personas in Input Documents:**
- Guide exploration of ALL people who interact with the system
- Consider beyond primary users: admins, moderators, support staff, API consumers
- Ensure comprehensive coverage of all system interactions

### 6.2 Create Narrative Story-Based Journeys

For each user type, create compelling narrative journeys:

**Persona Creation (if new):**
- Name: realistic name and personality
- Situation: What's happening in their life/work that creates the need?
- Goal: What do they desperately want to achieve?
- Obstacle: What's standing in their way?
- Solution: How does the product solve their story?

**Story-Based Journey Mapping:**
- **Opening Scene:** Where/how do we meet them? What's their current pain?
- **Rising Action:** What steps do they take? What do they discover?
- **Climax:** Critical moment where product delivers real value
- **Resolution:** How does their situation improve? What's their new reality?

Encourage narrative format with specific user details, emotional journey, and clear before/after contrast.

### 6.3 Guide Journey Exploration

For each journey, facilitate detailed exploration:
- What happens at each step specifically?
- What could go wrong? What's the recovery path?
- What information do they need to see/hear?
- What's their emotional state at each point?
- Where does this journey succeed or fail?

### 6.4 Connect Journeys to Requirements

After each journey, explicitly state:
- This journey reveals requirements for specific capability areas
- Help user see how different journeys create different feature sets
- Connect journey needs to concrete capabilities (onboarding, dashboards, notifications, etc.)

### 6.5 Aim for Comprehensive Coverage

**Minimum coverage targets:**
1. **Primary user — success path:** Core experience journey
2. **Primary user — edge case:** Error recovery, alternative goals
3. **Admin/Operations user:** Management, configuration, monitoring
4. **Support/Troubleshooting:** Help, investigation, issue resolution
5. **API/Integration** (if applicable): Developer/technical user journey

### 6.6 Generate Content

**Content structure to produce:**

```markdown
## User Journeys

{all journey narratives — rich storytelling with persona backstories, emotional arcs, specific interactions}

### Journey Requirements Summary

{summary of capabilities revealed by each journey — connects journeys to required features}
```

### 6.7 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Domain Requirements (Step 7 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with journey content
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with journey content
- IF C: Hold approved content in working memory. Proceed to step 7.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report journey summary.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- All user types identified (not just primary users)
- Rich narrative storytelling for each persona and journey
- Journey requirements clearly connected to capabilities needed
- Minimum 3-4 compelling narrative journeys covering different user types

### Failure Modes
- Only mapping primary user journeys, missing secondary users
- Creating generic journeys without rich persona details
- Missing emotional storytelling elements
- Not connecting journeys to required capabilities

</step>

<step n="7" goal="Explore domain-specific requirements for complex domains (optional)">

**Progress: Step 7 of 12** — Next: Innovation Discovery

### Step Goal

For complex domains only (those with a mapping in domain-complexity-prd.csv), explore domain-specific constraints, compliance requirements, and technical considerations. This step is OPTIONAL — skip if domain complexity is "low".

### 7.1 Check Domain Complexity

Review classification from step 2:

**If complexity is LOW:**
"The domain complexity from our discovery is low. We may not need deep domain-specific requirements. Would you like to:
- [C] Skip this step and move to Innovation
- [D] Do domain exploration anyway"

**If complexity is MEDIUM or HIGH:** Proceed with domain exploration.

### 7.2 Load Domain Reference Data

Load `{project-root}/_aria/shared/data/domain-complexity-prd.csv` — find row matching the domain from step 2. Extract `typical_concerns` and `compliance_requirements`.

### 7.3 Explore Domain-Specific Concerns

Acknowledge the domain and explore what makes it complex:

**Regulatory & Compliance:**
- What regulations apply? (HIPAA, PCI-DSS, GDPR, SOX, NIST, Section 508, etc.)
- What standards matter? (ISO, domain-specific standards)
- What certifications are needed?

**Technical Constraints:**
- Security requirements (encryption, audit logs, access control)
- Privacy requirements (data handling, consent, retention)
- Performance requirements (real-time, batch, latency)
- Availability requirements (uptime, disaster recovery)

**Integration Requirements:**
- Required systems (EMR systems, payment processors, government systems, etc.)
- Data flows and formats

**Domain Risks:**
- What could go wrong that's specific to this domain?
- What typically gets overlooked in {domain} projects?

### 7.4 Validate Completeness

"Are there other domain-specific concerns we should consider? For {domain}, what typically gets overlooked?"

### 7.5 Generate Content

**Content structure to produce (only if step was not skipped):**

```markdown
## Domain-Specific Requirements

### Compliance & Regulatory
{specific compliance requirements}

### Technical Constraints
{security, privacy, performance needs}

### Integration Requirements
{required systems and data flows}

### Risk Mitigations
{domain-specific risks and how to address them}
```

### 7.6 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Innovation Discovery (Step 8 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md`
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md`
- IF C: Hold approved content (or nothing if skipped) in working memory. Proceed to step 8.

### Success Criteria
- Domain complexity checked before proceeding
- Offered to skip if complexity is low
- Compliance, technical, and integration requirements identified
- Domain-specific risks documented with mitigations

### Failure Modes
- Not checking domain complexity first
- Not offering to skip for low-complexity domains
- Missing critical compliance requirements for regulated domains
- Being generic instead of domain-specific

</step>

<step n="8" goal="Detect and explore innovative aspects of the product (optional)">

**Progress: Step 8 of 12** — Next: Project-Type Deep Dive

### Step Goal

Detect genuine innovation in the product. This is optional — if no innovation signals are found, skip gracefully. Focus on real differentiation, not forced creativity.

### 8.1 Scan for Innovation Signals

Before proceeding, scan for innovation indicators from the conversation so far:

**General Innovation Language:**
- "Nothing like this exists"
- "We're rethinking how {X} works"
- "Combining {A} with {B} for the first time"
- "Novel approach to {problem}"

**Project-Type-Specific Signals (from CSV):**
Load `{project-root}/_aria/shared/data/project-types-prd.csv`, find matching row, extract `innovation_signals`:
- api_backend: "API composition; New protocol"
- mobile_app: "Gesture innovation; AR/VR features"
- saas_b2b: "Workflow automation; AI agents"
- developer_tool: "New paradigm; DSL creation"

### 8.2 Initial Innovation Screening

Ask targeted innovation discovery questions:
- "What makes this genuinely different from existing solutions?"
- "Are you challenging an existing assumption about how this should work?"
- "Is there a novel combination of technologies or approaches?"
- "Which aspect of this feels most innovative to you?"

### 8.3 Deep Innovation Exploration (if detected)

If innovation signals are found, explore deeply:

**Innovation Discovery Questions:**
- What makes it unique compared to existing solutions?
- What assumption are you challenging?
- How do we validate it works?
- What's the fallback if it doesn't?
- Has anyone tried this before? What happened?

**Market Context:** Consider whether competitive landscape research would be valuable for the innovative aspects.

### 8.4 No Innovation Detected Path

If no genuine innovation signals are found after exploration:
"No clear innovation signals were found — and that's fine. Many successful products are excellent executions of existing concepts. Would you like to:
- [A] Advanced Elicitation — Let's try to find innovative angles
- [C] Continue — Skip innovation section and move to Project-Type Deep Dive"

### 8.5 Generate Content (if innovation detected)

**Content structure to produce:**

```markdown
## Innovation & Novel Patterns

### Detected Innovation Areas
{innovation patterns identified}

### Market Context & Competitive Landscape
{market context and differentiation analysis}

### Validation Approach
{how to validate innovative aspects work}

### Risk Mitigation
{innovation risks and fallback strategies}
```

### 8.6 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Project-Type Deep Dive (Step 9 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with innovation content
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with innovation content
- IF C: Hold approved content (or nothing if skipped) in working memory. Proceed to step 9.

### Success Criteria
- Innovation signals properly detected (not forced)
- Genuine innovation explored with validation approach
- Risk mitigation strategies identified for innovative aspects
- Graceful skip when no innovation exists

### Failure Modes
- Forced innovation when none genuinely exists
- Creating innovation theater without real innovative aspects
- Not addressing validation approach for innovative features
- Not offering skip option when innovation is absent

</step>

<step n="9" goal="Conduct project-type specific discovery using CSV-driven guidance">

**Progress: Step 9 of 12** — Next: Functional Requirements

### Step Goal

Conduct project-type-specific discovery using CSV-driven guidance to define technical requirements unique to this type of product.

### 9.1 Load Project-Type Configuration

Load `{project-root}/_aria/shared/data/project-types-prd.csv` — find row matching project type from step 2. Extract:
- `key_questions` — semicolon-separated list of discovery questions
- `required_sections` — sections to document for this project type
- `skip_sections` — sections to skip (irrelevant for this type)

### 9.2 Guided Discovery Using Key Questions

Parse `key_questions` from CSV and explore each conversationally:

For each question, ask the user naturally and listen for their response. Ask clarifying follow-ups. Connect answers to product value proposition.

**Example Flow (for api_backend):**
- "What are the main endpoints your API needs to expose?"
- "How will you handle authentication and authorization?"
- "What data formats will you support for requests and responses?"
- "What rate limiting approach makes sense for your use case?"
- "How will you handle API versioning?"
- "Do you need to provide client SDKs?"

### 9.3 Document Project-Type Requirements

Based on user answers, synthesize requirements covering areas from `required_sections`:

**Common CSV Section Mappings:**
- "endpoint_specs" — API endpoints documentation
- "auth_model" — Authentication approach
- "platform_reqs" — Platform support needs
- "device_permissions" — Device capabilities
- "tenant_model" — Multi-tenancy approach
- "rbac_matrix" — Permission structure

Skip areas from `skip_sections` to avoid wasting time on irrelevant aspects.

### 9.4 Generate Content

**Content structure to produce:**

```markdown
## {Project Type} Specific Requirements

### Project-Type Overview
{project type summary}

### Technical Architecture Considerations
{technical architecture requirements}

{dynamic sections based on CSV required_sections and conversation}

### Implementation Considerations
{implementation-specific requirements}
```

### 9.5 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Functional Requirements (Step 10 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with project-type content
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with project-type content
- IF C: Hold approved content in working memory. Proceed to step 10.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report project-type requirements summary.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Project-type CSV configuration loaded and used effectively
- All key questions from CSV explored with user
- Required sections generated per CSV configuration
- Skip sections properly avoided

### Failure Modes
- Not loading or using project-type CSV configuration
- Creating generic content without project-type specificity
- Documenting sections that should be skipped per CSV

</step>

<step n="10" goal="Synthesize all discovery into comprehensive functional requirements">

**Progress: Step 10 of 12** — Next: Non-Functional Requirements

### Step Goal

Synthesize all previous discovery into comprehensive functional requirements. This section defines THE CAPABILITY CONTRACT for the entire product. If a capability is missing from FRs, it will NOT exist in the final product.

<critical>
- UX designers will ONLY design what's listed here
- Architects will ONLY support what's listed here
- Epic breakdown will ONLY implement what's listed here
</critical>

### 10.1 Explain FR Purpose

FRs define WHAT capabilities the product must have — the complete inventory of user-facing and system capabilities.

**Critical Properties:**
- Each FR is a testable capability
- Each FR is implementation-agnostic (could be built many ways)
- Each FR specifies WHO and WHAT, not HOW
- No UI details, no performance numbers, no technology choices
- Comprehensive coverage of all capability areas

**How They Will Be Used:**
1. UX Designer reads FRs and designs interactions for each capability
2. Architect reads FRs and designs systems to support each capability
3. PM reads FRs and creates epics/stories to implement each capability

### 10.2 Extract Capabilities from All Previous Sections

Systematically review all content generated so far:
- **Executive Summary** — core product differentiator capabilities
- **Success Criteria** — success-enabling capabilities
- **User Journeys** — journey-revealed capabilities (this is the richest source)
- **Domain Requirements** — compliance and regulatory capabilities
- **Innovation Patterns** — innovative feature capabilities
- **Project-Type Requirements** — technical capability needs
- **Scoping** — MVP vs Growth vs Vision priorities

### 10.3 Organize by Capability Area

Group FRs by logical capability areas (NOT by technology or layer):

**Good Grouping:**
- "User Management" (not "Authentication System")
- "Content Discovery" (not "Search Algorithm")
- "Team Collaboration" (not "WebSocket Infrastructure")

Target 5-8 capability areas for typical projects.

### 10.4 Generate Comprehensive FR List

**Format:** FR#: [Actor] can [capability] [context/constraint if needed]
- Number sequentially (FR1, FR2, FR3...)
- Aim for 20-50 FRs for typical projects

**Altitude Check — each FR should answer "WHAT capability exists?" not "HOW it's implemented?"**

Examples:
- GOOD: "Users can customize appearance settings"
- BAD: "Users can toggle light/dark theme with 3 font size options stored in LocalStorage"

### 10.5 Self-Validation

Before presenting to user, validate the FR list:

**Completeness Check:**
1. "Did I cover EVERY capability mentioned in the MVP scope section?"
2. "Did I include domain-specific requirements as FRs?"
3. "Did I cover the project-type-specific needs?"
4. "Could a UX designer read ONLY the FRs and know what to design?"
5. "Could an Architect read ONLY the FRs and know what to support?"
6. "Are there any user actions or system behaviors we discussed that have no FR?"

**Altitude Check:**
1. "Am I stating capabilities (WHAT) or implementation (HOW)?"
2. "Am I listing acceptance criteria or UI specifics?" (Remove if yes)
3. "Could this FR be implemented 5 different ways?" (Good)

**Quality Check:**
1. "Is each FR clear enough that someone could test whether it exists?"
2. "Is each FR independent?"
3. "Did I avoid vague terms like 'good', 'fast', 'easy'?" (Those are NFRs)

### 10.6 Generate Content

**Content structure to produce:**

```markdown
## Functional Requirements

### {Capability Area Name}

- FR1: {Specific Actor} can {specific capability}
- FR2: {Specific Actor} can {specific capability}
- FR3: {Specific Actor} can {specific capability}

### {Another Capability Area}

- FR4: {Specific Actor} can {specific capability}
- FR5: {Specific Actor} can {specific capability}

{continue for all capability areas}
```

### 10.7 Menu

Emphasize to user: "This FR list is the binding capability contract. Any feature not listed here will not exist in the final product unless we explicitly add it."

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Non-Functional Requirements (Step 11 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with the FR list — focus on coverage gaps
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with the FR list — collaborative capability validation
- IF C: Hold approved content in working memory. Proceed to step 11.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report FR summary with count.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- All previous discovery content synthesized into FRs
- FRs organized by capability areas (not technology)
- Each FR states WHAT capability exists, not HOW to implement
- Comprehensive coverage with 20-50 FRs typical
- Self-validation confirms completeness and correct altitude

### Failure Modes
- Missing capabilities from previous discovery sections
- Organizing FRs by technology instead of capability areas
- Including implementation details or UI specifics
- Using vague terms instead of testable capabilities

</step>

<step n="11" goal="Define quality attributes that matter for this specific product">

**Progress: Step 11 of 12** — Next: Polish & Publish

### Step Goal

Define non-functional requirements specifying quality attributes. Only document NFRs that actually apply to THIS product — selective, not exhaustive. Every NFR must be specific and measurable.

### 11.1 Explain NFR Purpose

NFRs define HOW WELL the system must perform, not WHAT it must do. We only document NFR categories that matter for THIS product to prevent requirement bloat.

### 11.2 Assess NFR Relevance

Quick assessment based on product context:
- **Performance:** Is there user-facing impact of speed?
- **Security:** Are we handling sensitive data or payments?
- **Scalability:** Do we expect rapid user growth?
- **Accessibility:** Are we serving broad public audiences?
- **Integration:** Do we need to connect with other systems?
- **Reliability:** Would downtime cause significant problems?

### 11.3 Explore Relevant Categories

For each relevant category, conduct targeted discovery:

**Performance (if relevant):**
- What parts need to be fast for user success?
- Specific response time expectations?
- Concurrent user scenarios to support?

**Security (if relevant):**
- What data needs protection?
- Who should have access to what?
- Compliance requirements (GDPR, HIPAA, PCI-DSS)?

**Scalability (if relevant):**
- How many users initially? Long-term?
- Seasonal or event-based traffic spikes?
- Growth scenarios to plan for?

**Accessibility (if relevant):**
- Users with visual, hearing, or motor impairments?
- Legal requirements (WCAG, Section 508)?
- Most important accessibility features?

**Integration (if relevant):**
- External systems to connect with?
- APIs or data formats to support?
- Reliability requirements for integrations?

### 11.4 Make NFRs Specific and Measurable

Convert vague requirements to testable criteria using the template: "The system shall [metric] [condition] [measurement method]"

**Examples:**
- NOT: "The system should be fast" — YES: "User actions complete within 2 seconds for 95th percentile"
- NOT: "The system should be secure" — YES: "All data encrypted at rest (AES-256) and in transit (TLS 1.3)"
- NOT: "The system should scale" — YES: "System supports 10x user growth with <10% performance degradation"

**NFR Category Guidance — include when:**
- Performance: user-facing response times impact success, real-time interactions are critical
- Security: handling sensitive data, processing payments, subject to compliance regulations
- Scalability: expecting rapid growth, variable traffic, enterprise-scale usage
- Accessibility: broad public audiences, legal requirements, B2B customers with accessibility needs

### 11.5 Generate Content

**Content structure to produce (only include relevant categories):**

```markdown
## Non-Functional Requirements

### Performance
{performance requirements — only if relevant}

### Security
{security requirements — only if relevant}

### Scalability
{scalability requirements — only if relevant}

### Accessibility
{accessibility requirements — only if relevant}

### Integration
{integration requirements — only if relevant}
```

### 11.6 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Polish & Publish (Step 12 of 12)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with NFR content
- IF P: Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md` with NFR content
- IF C: Hold approved content in working memory. Proceed to step 12.

{if autonomy_level == "interactive"}
  Present options and wait for user selection.
{else}
  Auto-proceed with C. Report NFR summary.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Only relevant NFR categories documented (no requirement bloat)
- Each NFR is specific and measurable
- NFRs connected to actual user needs and business context
- Domain-specific compliance requirements included if relevant

### Failure Modes
- Documenting NFR categories that don't apply
- Leaving requirements vague and unmeasurable
- Missing domain-specific compliance requirements
- Creating overly prescriptive technical requirements

</step>

<step n="12" goal="Polish complete PRD, write to Linear Document, link to Projects, and hand off">

**Progress: Step 12 of 12** — Final Step

### Step Goal

Polish the complete PRD for flow and coherence, write it to a Linear Document, link to Linear Projects (epics), and post a handoff to downstream agents.

### 12.1 Load PRD Purpose Reference

Load `{project-root}/_aria/shared/data/prd-purpose.md` to internalize what makes a great ARIA PRD:
- High information density — every sentence carries weight, zero fluff
- Traceability chain: Vision -> Success Criteria -> User Journeys -> Functional Requirements
- Dual-audience: human-readable AND LLM-consumable
- Anti-patterns to eliminate: "The system will allow users to...", "It is important to note that...", conversational filler
- SMART quality criteria for all requirements

### 12.2 Document Quality Review

Review the entire accumulated PRD content:

**Information Density:**
- Are there wordy phrases that can be condensed?
- Is conversational padding present? Eliminate it.
- Can sentences be more direct and concise?

**Flow and Coherence:**
- Do sections transition smoothly?
- Does the document tell a cohesive story?
- Is progression logical (vision -> criteria -> journeys -> requirements)?

**Duplication Detection:**
- Are ideas repeated across sections? Consolidate.
- Are there contradictory statements? Resolve.

**Header Structure:**
- All main sections use ## Level 2 headers
- Consistent hierarchy (##, ###, ####)
- Headers are descriptive and clear

**Readability:**
- Sentences clear and concise
- Consistent language and terminology throughout
- Technical terms used appropriately

### 12.3 Polish Actions

**Improve Flow:** Add transition sentences, smooth topic shifts, ensure logical progression.
**Reduce Duplication:** Consolidate repeated information, use cross-references, remove redundant explanations.
**Enhance Coherence:** Consistent terminology, all sections aligned with product differentiator, consistent voice.
**Optimize Headers:** All main sections use ##, descriptive and action-oriented.

**Preserve Critical Information (NOTHING essential may be lost):**
- All user success criteria
- All functional requirements (capability contract)
- All user journey narratives
- All scope decisions (MVP, Growth, Vision)
- All non-functional requirements
- Product differentiator and vision
- Domain-specific requirements
- Innovation analysis (if present)

### 12.4 Present Polished PRD for Final Approval

Present a summary of the complete polished PRD to the user:
- List all sections and their key content
- Highlight any changes made during polish
- Show the document structure

{if autonomy_level == "interactive"}
  "Review the PRD summary above. [C] Continue to publish to Linear, or provide feedback to revise."
  Wait for user approval.
{else}
  Auto-proceed to publish. Report what was polished.
  {if autonomy_level == "balanced"}
    Wait briefly for user override before publishing.
  {end_if}
{end_if}

### 12.5 Write PRD to Linear Document

Compile the complete PRD using the template at `{template}`.
Generate the document in {document_output_language}.

Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:

```
title: "{project_name} — Product Requirements Document"
content: "{compiled_prd_content}"
key_map_entry: "documents.prd"
```

Update `{key_map_file}` with the new Linear Document ID under `documents.prd`.

### 12.6 Link PRD to Existing Projects in Linear

Search for existing Linear Projects (epics):
Call `list_projects` to find projects for the team.

For each Project found, call `save_project` to update its description with the PRD link:

```
project_id: "{project_id}"
description: |
  {existing_project_description}

  ---
  ## Related Documents
  - PRD: {project_name}
```

### 12.7 Post Handoff

Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:

```
handoff_to: "Architect,SM"
handoff_type: "prd_complete"
summary: "PRD created and published to Linear Document. Ready for architecture design and epic planning."
document_id: "{prd_document_id}"
```

### 12.8 Completion Report

Report to user:

**PRD Complete**

- **Linear Document:** {prd_document_title}
- **Status:** Published
- **Project Links:** {linked_project_count} projects updated with PRD link
- **Handoff:** Architect and SM agents notified

**The PRD is the foundation. Quality here ripples through every subsequent phase. A dense, precise, well-traced PRD makes UX design, architecture, epic breakdown, and AI development dramatically more effective.**

**Next Steps:**
1. Review the PRD on Linear
2. Architect can begin architecture design with [Create Architecture]
3. UX designer can begin UX design with [Create UX Design]
4. PM can create Epics and Stories with [Create Epics & Stories]

Invoke the help task at `{project-root}/_aria/linear/tasks/help.md` to present context-aware next-step recommendations to the user.

### Success Criteria
- PRD polished for flow, coherence, information density, and zero duplication
- Complete PRD written to Linear Document (not local files)
- Key map updated with Linear Document ID
- All existing Projects linked to PRD
- Handoff posted to Architect and SM agents
- User given clear next-step guidance

### Failure Modes
- Writing PRD to local files instead of Linear Document
- Not linking PRD to existing Projects
- Not posting handoff to downstream agents
- Removing essential information during polish
- Not updating key map with new document ID

</step>

</workflow>

# Post Handoff — Plane Implementation

**Purpose:** Post structured handoff using comments for context. Handoff target and last-agent are tracked via structured comment markers that the orchestrator can parse.

## Execution

<step n="1" goal="Determine target work items">
<action>If `issue_ids` are provided, use those directly</action>
<action>Otherwise, determine targets based on `handoff_type` using `list_modules` and `list_work_items`</action>
</step>

<step n="2" goal="Post handoff comment">
<action>For each target work item, call `create_work_item_comment` with:</action>

```
work_item_id: "{target_work_item_id}"
comment_html: |
  <h2>[ARIA:HANDOFF] {current_agent} → {handoff_to}</h2>
  <p><strong>Completed:</strong> {handoff_type}</p>
  <p><strong>Summary:</strong> {summary}</p>
  <p><strong>Next Action:</strong> {recommended_next_workflow}</p>
  <h3>Context</h3>
  <p><strong>Key Decisions:</strong></p>
  <ul>{decisions as list items}</ul>
  <p><strong>Open Questions:</strong></p>
  <ul>{questions as list items}</ul>
  <p><strong>Referenced Artefacts:</strong></p>
  <ul>{artefact_refs as list items}</ul>
  <hr/>
  <p><em>[ARIA:META] from={current_agent_lowercase} to={handoff_to_lowercase}</em></p>
```
</step>

<step n="3" goal="Update key map">
<action>If `document_id` was provided, ensure it is recorded in `.key-map.yaml`</action>
</step>

<step n="4" goal="Log completion">
<action>Report: "Handoff posted: {current_agent} → {handoff_to} on {work_item_count} work items."</action>
</step>

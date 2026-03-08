# Log Work — Linear Implementation

**Note:** Linear does not have a native work log API. This task logs effort as a comment on the issue for record-keeping.

## Execution

<step n="1" goal="Post work log as comment">
<action>Call `save_comment` with:</action>

```
issueId: "{work_item_id}"
body: |
  **Work Log** ({agent_name or "ARIA Agent"})
  - Duration: {hours}h
  - Description: {description}
  ---
  _Logged by ARIA Agent System_
```
</step>

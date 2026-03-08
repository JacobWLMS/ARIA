# Story Acceptance Criteria Template

Use Given/When/Then format for all acceptance criteria. Each criterion should be independently testable.

## Format

```
**AC-{number}: {short_descriptive_title}**

**Given** {precondition or initial state}
**When** {action performed by user or system}
**Then** {expected outcome or result}
```

## Examples

**AC-1: Successful login with valid credentials**

**Given** a registered user is on the login page
**When** they enter valid email and password and click "Sign In"
**Then** they are redirected to the dashboard and see a welcome message

---

**AC-2: Login fails with invalid password**

**Given** a registered user is on the login page
**When** they enter a valid email but incorrect password and click "Sign In"
**Then** an error message "Invalid credentials" is displayed and the password field is cleared

---

**AC-3: Rate limiting on login attempts**

**Given** a user has failed login 5 times in the last 15 minutes
**When** they attempt to log in again
**Then** a "Too many attempts. Try again in {minutes} minutes" message is shown and the login form is disabled

## Guidelines

- Each AC maps to exactly one testable scenario
- Avoid compound conditions in a single AC — split into separate ACs
- Use concrete values where possible ("5 times" not "multiple times")
- Cover both happy path and error/edge cases
- Include data validation, boundary conditions, and error states
- Number ACs sequentially within each story (AC-1, AC-2, etc.)
- Reference related ACs when there are dependencies

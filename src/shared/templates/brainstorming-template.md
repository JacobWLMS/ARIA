# Brainstorming Session: {topic}

**Facilitator:** {user_name}
**Date:** {date}
**Techniques Used:** {technique_list}
**Total Ideas Generated:** {idea_count}
**Ideas Selected:** {selected_count}

## Session Context

**Topic:** {topic}
**Goals:** {goals}
**Constraints:** {constraints}
**Domains Explored:** {domains}

## Selected Ideas

{for_each_selected}
### {selected_idea_title}
{selected_idea_description}
- **Source Technique:** {technique}
- **Category:** {category}
{end_for_each}

## All Ideas by Theme

{for_each_theme}
### {theme_name}
{theme_description}

| # | Idea | Technique | Selected |
|---|------|-----------|----------|
{for_each_idea_in_theme}
| {n} | {idea} | {technique} | {star_if_selected} |
{end_for_each}
{end_for_each}

## Technique Log

| Technique | Category | Ideas Generated |
|-----------|----------|-----------------|
{for_each_technique_used}
| {technique_name} | {category} | {count} |
{end_for_each}

## Top Recommendations

{top_5_10_recommendations_with_rationale}

## Next Steps

Recommended: Create a product brief to formalize selected ideas.

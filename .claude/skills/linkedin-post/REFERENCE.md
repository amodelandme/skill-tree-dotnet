# linkedin-post — Reference

## Post structures by type

---

### Learned post

**When to use:** Something clicked. A concept landed differently than expected. A mistake was made, understood, and corrected. The insight is the story.

**Structure:**

```
[Hook — the before state or the wrong assumption. 1-2 lines.]

[What changed — the moment of shift. What you read, built, or broke.]

[What you now understand — specific, not vague. Name the thing.]

[What this means going forward — one practical takeaway.]

[Optional: what you'd tell past-you, or a question for others who've been here]
```

**Hook patterns for learned posts:**

- *"I was wrong about [X] for [longer than I'd like to admit / three years / most of my career]."*
- *"Spent [time] debugging something that turned out to be [simple root cause]."*
- *"[Concept] finally clicked for me this week. Here's what it took."*
- *"I thought [common assumption]. Turns out [what's actually true]."*

**Example:**

```
I was wrong about where validation belongs in a .NET API. For years.

I kept putting business rules in FluentValidation validators — the ones 
that check if a flag name already exists, or if a strategy configuration 
is valid for a given environment.

Convenient. Fast to write. Wrong layer.

Input validation (shape, format, required fields) belongs at the HTTP 
boundary. Business rules belong in the domain. They answer different 
questions: "Is this a valid request?" vs "Does this request make sense 
for our system?"

The moment I split them, the domain got testable without spinning up 
HTTP infrastructure. Worth the refactor.

If you've been putting everything in one validator — you're not alone. 
But there's a better place for the rules that actually matter.

#dotnet #cleanarchitecture #softwareengineering #aspnetcore
```

---

### Shipped post

**When to use:** Something real landed — a feature, a PR, a tool, a portfolio project milestone. The output is the story.

**Structure:**

```
[Hook — what you built and why it matters. 1-2 lines. Specific, not vague.]

[The problem it solves — who it's for, what it prevents or enables.]

[The most interesting technical decision — one thing, not everything.]

[What you learned building it — honest, specific.]

[What's next or what you'd do differently — shows forward momentum]
```

**Hook patterns for shipped posts:**

- *"Shipped something this week: [what it is in one clause]."*
- *"Just added [feature] to [project]. Here's why it matters more than it sounds."*
- *"Spent [time] building [thing]. The interesting part wasn't [obvious thing] — it was [unexpected thing]."*
- *"[Project] now has [feature]. The problem it solves: [one sentence]."*

**Example:**

```
Shipped something this week: a skill that audits an ASP.NET Core API 
and tells you what's missing before you hit production.

It reads your codebase like a senior engineer would — not just "is 
Swashbuckle installed?" but "is it actually wired up, and are your 
endpoints annotated?"

The interesting design decision: the skill follows the request lifecycle 
rather than a fixed folder structure. It starts at .csproj, follows the 
trail to Program.cs, then to endpoints, DTOs, and tests. Different 
projects, same trail.

What I learned building it: the checklist is easy. The pass/fail 
criteria is where the real thinking is.

Part of a larger skill library I'm building for AI-assisted .NET 
development. More on that soon.

#dotnet #aspnetcore #aitools #softwaredevelopment #buildinpublic
```

---

### Opinion post

**When to use:** You have a take on a pattern, tool, tradeoff, or assumption that's worth pushing back on. The argument is the story.

**Structure:**

```
[Hook — the take, stated plainly. Slightly contrarian gets more reads.]

[The common assumption — what most people do or believe.]

[Why it's incomplete or wrong — your evidence. Specific, not abstract.]

[Your actual position — what you do instead, or what the nuance is.]

[Closing question or invitation — sparks engagement without begging for it]
```

**Hook patterns for opinion posts:**

- *"[Common tool / pattern] is fine. It's also not the only answer."*
- *"The most dangerous line in a .NET codebase isn't [scary thing]. It's [unexpected thing]."*
- *"[Thing everyone does] is solving the wrong problem."*
- *"Hot take: [position]. Here's why I landed there."*
- *"Nobody talks about [X]. We should."*

**Example:**

```
MediatR is a fine library. It's also not the only way to structure 
a .NET API.

The pattern I keep seeing: developers reach for MediatR on day one 
because that's what the tutorials use. Then every endpoint has a 
command, a handler, and a pipeline behavior before there's a single 
business rule worth isolating.

Sometimes a service interface and a direct injection is the honest 
answer. It's less ceremonial, easier to trace, and requires zero 
explanation to a new team member.

MediatR earns its place when the pipeline behaviors are doing real 
work — cross-cutting concerns, complex retry logic, audit trails. Not 
just to feel like you're doing architecture.

Pick the tool that fits the problem. Not the one that looks impressive 
in a diagram.

What's your bar for introducing MediatR? Genuine question.

#dotnet #aspnetcore #softwarearchitecture #cleancode
```

---

## Hook writing rules

The hook is the most important part of the post. It's what shows before "see more." If it doesn't earn the click, nothing else gets read.

**Rules:**

1. **Specific beats vague.** "I was wrong about validation placement" beats "I learned something important about architecture."
2. **Before-state beats achievement.** "I was wrong about X" outperforms "I just learned X."
3. **One idea per hook.** Don't set up two things — pick the sharper one.
4. **Short sentences.** A hook longer than 15 words usually loses.
5. **Never start with "I'm excited to share."** It's the tell that a human didn't write this.

---

## Hashtag strategy

3-5 hashtags. Not more. Hashtags on LinkedIn are for discoverability, not decoration.

**Tier 1 — always include one:**
`#dotnet` `#aspnetcore` `#csharp` `#softwaredevelopment`

**Tier 2 — include if relevant:**
`#cleanarchitecture` `#softwareengineering` `#efcore` `#webdevelopment`

**Tier 3 — use sparingly:**
`#buildinpublic` `#careerdevelopment` `#backtocoding` `#100daysofcode`

**Never:**
`#hiring` `#opentowork` in the post body (use LinkedIn's built-in feature instead)
More than 5 hashtags — looks like spam

---

## Voice calibration quick reference

If no `VOICE.md` exists, use these as defaults until the profile is set up:

- **Tone:** Conversational and direct. Smart without being academic.
- **Length:** 150-250 words. Short enough to read in 60 seconds.
- **Technical depth:** Name the technology, explain the concept — don't assume the reader knows what `IValidator<T>` is, but don't over-explain it either.
- **Self-awareness:** Returning engineer building in public. Honest about the learning curve, confident about the direction.
- **What to avoid:** Motivational language, vague claims, corporate speak, humble-bragging wrapped in fake humility.

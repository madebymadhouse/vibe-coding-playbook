# Reviewing AI-Generated Code

Reading every line is not the goal. Reviewing AI code is about finding the places where it looked right but wasn't.

Here's a faster approach.

---

## The semantic review (2 minutes)

Read for intent, not implementation.

1. Does the function signature match what you asked for?
2. Does the general structure match the architecture you approved?
3. Are there any files touched that you didn't expect?
4. Is the scope right -- did it do more than you asked?

If something is surprising here, stop and dig in before checking the details.

---

## The diff review

```bash
git diff
```

For any multi-file change, `git diff` is your friend. Look for:
- Lines added in files you didn't expect
- Large deletions (AI sometimes removes things it thinks are unused)
- New dependencies added to `package.json` or equivalent
- Config changes (very easy to miss)

If a diff is too large to scan, the task was too big. Break it into smaller steps next time.

---

## Security checklist (30 seconds)

For any feature that touches user input, auth, or external data:

- [ ] User input passed directly to SQL? (SQL injection)
- [ ] User input rendered into HTML? (XSS)
- [ ] Secrets or credentials in code? (even as placeholders)
- [ ] Auth checks before sensitive operations?
- [ ] Error messages that expose internal state?

AI tools frequently forget auth checks on new endpoints. Always verify.

---

## Test review

AI-generated tests are often wrong in subtle ways:

**Mock everything, test nothing:**
```javascript
// This test is useless -- it mocks the thing it's testing
jest.mock('./economy')
test('addCoins works', () => {
  Economy.addCoins.mockResolvedValue({ balance: 100 })
  expect(await addCoins(userId, 50)).toEqual({ balance: 100 })
})
```

**Wrong assertions:**
```javascript
// Tests that it doesn't throw, not that it returns the right thing
test('user creation', async () => {
  await expect(createUser(data)).resolves.toBeDefined()
})
```

When reviewing tests: ask "what would this test catch if the implementation was broken?" If the answer is "nothing," the test is wrong.

---

## The AI self-review prompt

After getting a code change:
```
Review the code you just wrote for:
1. Any auth checks missing
2. Input validation gaps
3. Error cases not handled
4. Assumptions you made that might be wrong
5. Anything you weren't sure about

Be honest -- if something is uncertain, say so.
```

This surfaces the AI's own uncertainties before you ship.

---

## When to reject and redo

Reject and re-prompt (not just edit) when:
- The architecture is wrong (fixing details won't help)
- It used a pattern you explicitly said not to use
- The diff is 3x larger than expected (it over-built something)
- Tests are missing or clearly wrong

When rejecting: don't say "this is wrong." Say specifically what's wrong and add the constraint to your prompt. Generic rejection gets generic fixes.

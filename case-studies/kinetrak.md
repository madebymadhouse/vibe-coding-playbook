# Case Study: Kinetrak (Real-Time Body Tracking)

Kinetrak does real-time body pose estimation in the browser using MediaPipe. No server. No uploads. Your camera, your browser, your data.

Repo: [madebymadhouse/kinetrak-ai](https://github.com/madebymadhouse/kinetrak-ai)

---

## The core constraint that changed everything

We told Claude the goal. It immediately started designing a solution with a server component: send frames to an API, get back pose data, render on client.

This was wrong. The requirement was: **client-only**. No server. No uploads. For privacy.

The AI didn't flag this as a design decision. It just built what it knew how to build. We caught it in the architecture review:

```
Before you proceed: this must be 100% client-side.
No server component. No API calls with video frames. No uploads.
All processing happens in the browser.

Given that constraint, how does the architecture change?
```

Answer: MediaPipe's JavaScript SDK, which runs the pose estimation model directly in the browser via WebAssembly. No server needed.

If we hadn't done an architecture review before coding, we would have built the wrong thing.

---

## The MediaPipe integration prompt that worked

```
I'm building a browser-only pose estimation app using MediaPipe Pose Landmarker.
Stack: vanilla JavaScript, no frameworks.

I need to:
1. Access the webcam
2. Run MediaPipe Pose Landmarker on each frame
3. Get back 33 landmark positions
4. Draw a skeleton overlay on a canvas over the video

The video and canvas should be layered (canvas on top of video, same dimensions).
All of this runs in the browser with no server.

Write the minimal HTML + JS that does this. One file is fine.
MediaPipe is loaded from CDN. Don't add a build step.
```

This produced working code on the first try. The constraints ("vanilla JS", "no build step", "one file", "CDN") prevented the AI from over-complicating the setup.

---

## Where it struggled: performance

After the basic version worked, we wanted it to run at 30fps on a mid-range laptop. The AI's first version was hitting 8-12fps.

First AI response to "make it faster":

- Added a WebWorker for off-thread processing (broke everything, MediaPipe can't run in workers)
- Suggested reducing video resolution (helped slightly)
- Suggested server-side processing (we'd already excluded this)

None of these were the right answer.

The actual problem: we were calling `requestAnimationFrame`, then waiting for the pose estimation result before calling it again. Blocking the render loop.

Fix: decouple the animation loop from the inference loop. `requestAnimationFrame` runs at 60fps for rendering. Inference runs as fast as it can, writing results to a shared variable. The render loop reads the latest result without waiting.

This brought us to 28-30fps.

**What the debugging process looked like:**

```
The app is running at 8-12fps. I need 30fps.

Here is the render loop:
[paste the actual code]

Don't suggest server-side processing -- this is client-only by requirement.
Don't suggest WebWorkers -- MediaPipe can't run in workers.

Given those constraints, what's causing the frame rate issue?
Explain the problem before you write a fix.
```

With the constraints stated explicitly, the AI identified the blocking inference loop immediately.

---

## The canvas overlay: what the AI got right immediately

```
I have a video element and a canvas element.
The canvas should be positioned exactly over the video,
same size, transparent background.
Draw the pose skeleton on the canvas.

Here are the 33 MediaPipe landmark positions: [sample output]
Which points connect to which for a human skeleton?
```

Claude knew MediaPipe's landmark numbering and produced the correct connections (shoulders, elbows, wrists, hips, knees, ankles) without looking them up. This was one of those moments where the AI's training data genuinely helped -- MediaPipe is well-documented and Claude had seen it.

Saved 20 minutes of reading documentation.

---

## What the AI got wrong

**WebWorker hallucination:** It confidently suggested running MediaPipe in a worker. This is documented as not supported in MediaPipe's own docs. The AI just didn't know this limitation.

**Canvas sizing on resize:** Generated code that set canvas dimensions once at load. Broke on window resize. We caught it in review because the canvas drift on resize is obvious visually -- but the AI didn't write a resize handler.

**Landmark indexes:** Once, when we asked it to highlight specific joints (elbows, knees), it used wrong landmark indexes. The skeleton looked right until we zoomed in. Always verify landmark numbers against the official docs.

---

## Lessons

1. **State constraints explicitly before architecture.** The server vs client decision happened because we caught it early. If you'd coded first, you'd have built the wrong architecture.
2. **Exclusion constraints matter.** "Don't suggest X" (workers, server) focused the debugging immediately.
3. **Performance problems need root cause, not band-aids.** "Make it faster" gets you random suggestions. "Here's the render loop, here's the fps, here are the constraints, explain the problem" gets you the root cause.
4. **The AI knows well-documented libraries.** MediaPipe landmark connections: it knew them. React hook ordering rules: it knows them. Your custom internal system: it doesn't. Use it where it has training data.
5. **Visual bugs need visual testing.** The canvas resize bug and the landmark index bug were both invisible in tests. If you're building UI, you have to look at it.

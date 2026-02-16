# Codex-ready issue list (copy/paste into GitHub)

> Scope: build guardrails, 120fps readiness, Steam Deck/controller-first UX, ultrawide, lighting/effects, and Vulkan migration.

---

## Milestone 0 — Build & guardrails

### 1) Add BUILDING.md + dependency list (Win/Linux)
**Title**: Add BUILDING.md + dependency list (Win/Linux)

**Problem**
Build instructions are fragmented (mostly external wiki knowledge), making first-time setup slow and error-prone.

**Scope**
- Add/maintain a root `BUILDING.md`.
- Document required dependencies for Linux/Windows.
- Add quick-start commands (`./configure`, `make`).
- Add troubleshooting section for disabled modules.

**Acceptance criteria**
- New contributor can run through setup without external docs.
- Dependencies listed by capability (runtime/tooling/optional).
- File referenced from `README.md`.

**Labels**: `build`, `docs`, `good first issue`

---

### 2) Add CI: Linux + Windows build
**Title**: Add CI: Linux + Windows build

**Problem**
No automated cross-platform compile signal; regressions are discovered late.

**Scope**
- Add GitHub Actions workflows:
  - Linux build job
  - Windows build job
- Cache dependencies where possible.
- Upload build logs/artifacts.

**Acceptance criteria**
- PRs run both Linux + Windows compile checks.
- Failed dependency/module summaries are visible in logs.
- CI status is required for merge.

**Labels**: `ci`, `build`, `infrastructure`

---

### 3) Add smoke test: boot to menu (headless if possible)
**Title**: Add smoke test: boot to menu (headless if possible)

**Problem**
Build success doesn’t verify runtime startup viability.

**Scope**
- Add lightweight startup smoke test target.
- Prefer headless/offscreen options when available.
- Verify process reaches main menu or equivalent initialized state.

**Acceptance criteria**
- CI runs smoke test after build.
- Test fails on crash/startup deadlock.
- Result is deterministic in CI environment.

**Labels**: `testing`, `ci`, `runtime`

---

## Milestone 1 — 120fps

### 4) Decouple simulation tick from render tick
**Title**: Decouple simulation tick from render tick

**Problem**
Simulation likely assumes render-coupled frame step, limiting high-FPS behavior and causing instability at variable frame rates.

**Scope**
- Introduce fixed-step simulation loop.
- Allow render interpolation between sim ticks.
- Keep gameplay semantics identical at baseline frame rates.

**Acceptance criteria**
- Gameplay speed no longer changes with FPS.
- Stable behavior at 30/60/120/240 FPS.
- No regressions in deterministic systems.

**Labels**: `engine`, `performance`, `gameplay`

---

### 5) Add FPS cap options + frame pacing
**Title**: Add FPS cap options + frame pacing

**Problem**
Users need predictable frame pacing and power/perf controls.

**Scope**
- Add configurable FPS cap options.
- Implement frame pacing to reduce jitter.
- Respect VSync/VRR behavior where available.

**Acceptance criteria**
- User can select uncapped/capped FPS.
- Frame-time variance reduced vs baseline.
- No busy-wait CPU spikes when capped.

**Labels**: `engine`, `performance`, `settings`

---

### 6) Audit time-step assumptions (movement, animation, particles)
**Title**: Audit time-step assumptions (movement, animation, particles)

**Problem**
Subsystems may rely on frame-dependent deltas causing drift or overspeed.

**Scope**
- Audit movement/animation/particle update paths.
- Replace frame-dependent constants with time-step aware logic.
- Add regression checklist for behavior parity.

**Acceptance criteria**
- No frame-rate-dependent speed changes.
- Visual timing remains consistent across tested FPS.
- Audit report/checklist included in PR.

**Labels**: `engine`, `gameplay`, `tech debt`

---

## Milestone 2 — Steam Deck / controller-first

### 7) Gamepad navigation for all menus (focus system)
**Title**: Gamepad navigation for all menus (focus system)

**Problem**
Incomplete focus/navigation blocks controller-only UX.

**Scope**
- Implement consistent focus graph/navigation for all UI menus.
- Add visual focus indicators.
- Support directional + bumper/tab transitions.

**Acceptance criteria**
- Entire UI navigable without mouse.
- No focus traps/dead ends.
- Controller navigation documented for QA.

**Labels**: `ui`, `input`, `steam-deck`

---

### 8) UI scale presets + DPI scaling
**Title**: UI scale presets + DPI scaling

**Problem**
UI readability on handheld/high-DPI displays is inconsistent.

**Scope**
- Add UI scaling presets (e.g., Small/Medium/Large/Deck).
- Add DPI-aware default scaling.
- Ensure text and hit targets remain legible.

**Acceptance criteria**
- Presets exposed in settings.
- Deck-class resolution is readable by default.
- No major clipping/overlap in key menus.

**Labels**: `ui`, `accessibility`, `steam-deck`

---

### 9) Controller remap + deadzone settings
**Title**: Controller remap + deadzone settings

**Problem**
Players need control customization and stick tuning.

**Scope**
- Add controller remapping UI.
- Add deadzone/sensitivity settings.
- Persist per-profile configuration.

**Acceptance criteria**
- Bindings can be edited/reset.
- Deadzone changes are visible in input behavior.
- Config persistence verified across restarts.

**Labels**: `input`, `ui`, `settings`

---

### 10) Steam Input compatibility test doc + known issues
**Title**: Steam Input compatibility test doc + known issues

**Problem**
No shared test protocol for Steam Input across devices/layouts.

**Scope**
- Add test matrix doc for Steam Input modes.
- Document known issues and workarounds.
- Define pass/fail criteria for release gating.

**Acceptance criteria**
- QA can execute matrix without tribal knowledge.
- Known issues section maintained in-repo.
- Release checklist references this document.

**Labels**: `docs`, `qa`, `steam-deck`

---

## Milestone 3 — Ultrawide

### 11) Aspect-aware projection + HUD safe zones
**Title**: Aspect-aware projection + HUD safe zones

**Problem**
HUD/projection assumptions for 16:9 break at ultrawide/aspect extremes.

**Scope**
- Make camera projection aspect-aware.
- Add HUD safe-zone constraints and anchoring rules.
- Avoid critical info at screen extremes.

**Acceptance criteria**
- HUD remains readable/usable at 16:10, 21:9, 32:9.
- No major stretching/cropping defects.
- Safe-zone options configurable.

**Labels**: `rendering`, `ui`, `ultrawide`

---

### 12) Ultrawide test matrix + fixes (16:10, 21:9, 32:9)
**Title**: Ultrawide test matrix + fixes (16:10, 21:9, 32:9)

**Problem**
Lack of structured validation causes recurring aspect regressions.

**Scope**
- Define resolution/aspect matrix.
- Capture before/after screenshots for key screens.
- Track and fix top-priority defects.

**Acceptance criteria**
- Matrix includes gameplay + menus + cutscenes (if applicable).
- Tracked issues linked to concrete repro resolutions.
- Baseline pass required before release candidate.

**Labels**: `qa`, `rendering`, `ultrawide`

---

## Milestone 4 — Lighting/effects

### 13) Modern post-processing pipeline cleanup
**Title**: Modern post-processing pipeline cleanup

**Problem**
Legacy post pipeline structure is hard to extend and reason about.

**Scope**
- Refactor pass scheduling/resource ownership.
- Reduce state leakage between passes.
- Prepare for backend-neutral renderer path.

**Acceptance criteria**
- No visual regressions in default settings.
- Pass graph/resource flow documented.
- New pass insertion is straightforward.

**Labels**: `rendering`, `refactor`, `graphics`

---

### 14) Add improved tone mapping + bloom controls
**Title**: Add improved tone mapping + bloom controls

**Problem**
Current controls/response are limited and difficult to tune.

**Scope**
- Add selectable tone-mapping operator(s).
- Add bloom intensity/threshold controls.
- Expose user-facing graphics settings.

**Acceptance criteria**
- Settings affect output predictably.
- Defaults preserve current art direction.
- Performance impact measured and documented.

**Labels**: `rendering`, `graphics`, `settings`

---

### 15) Shadow quality tiers (basic but stable)
**Title**: Shadow quality tiers (basic but stable)

**Problem**
Shadow configuration lacks clear quality/performance tiers.

**Scope**
- Define low/medium/high shadow presets.
- Ensure stability first, quality second.
- Bind presets to sensible GPU targets.

**Acceptance criteria**
- Tiers selectable in settings.
- No severe artifacts/flicker in tier defaults.
- Performance deltas documented per tier.

**Labels**: `rendering`, `performance`, `graphics`

---

## Milestone 5 — Vulkan

### 16) Introduce Renderer abstraction (no behavior change)
**Title**: Introduce Renderer abstraction (no behavior change)

**Problem**
Backend-specific assumptions are deeply coupled to gameplay/render callsites.

**Scope**
- Add backend abstraction layer/interfaces.
- Keep OpenGL behavior unchanged.
- Move API-specific calls behind backend boundary.

**Acceptance criteria**
- OpenGL output matches baseline.
- Abstraction compiles with no behavior regressions.
- Backend boundary documented.

**Labels**: `architecture`, `rendering`, `vulkan`

---

### 17) Vulkan backend: window/swapchain + clear screen
**Title**: Vulkan backend: window/swapchain + clear screen

**Problem**
Need minimal Vulkan bring-up to validate platform/runtime integration.

**Scope**
- Create Vulkan instance/device/swapchain path.
- Present a clear-color frame.
- Integrate with existing window lifecycle.

**Acceptance criteria**
- App boots with Vulkan backend flag.
- Swapchain recreate works on resize.
- Clean shutdown without validation errors.

**Labels**: `vulkan`, `rendering`, `milestone`

---

### 18) Vulkan backend: textured meshes parity with OpenGL
**Title**: Vulkan backend: textured meshes parity with OpenGL

**Problem**
Bring-up must progress from clear screen to real scene content.

**Scope**
- Add textured mesh pipeline and resource uploads.
- Render key scene geometry with textures.
- Match baseline OpenGL visual intent where feasible.

**Acceptance criteria**
- Representative scenes render correctly.
- Texture sampling/material basics function.
- No major validation/runtime errors.

**Labels**: `vulkan`, `rendering`, `graphics`

---

### 19) Vulkan backend: lights + post effects parity
**Title**: Vulkan backend: lights + post effects parity

**Problem**
Final parity requires advanced pipeline stages (lighting + post).

**Scope**
- Port lighting path and post-processing passes.
- Validate feature parity with OpenGL path.
- Document known gaps and temporary fallbacks.

**Acceptance criteria**
- Comparable lighting/post output in target scenes.
- Performance telemetry captured (frame time + GPU time where possible).
- Remaining parity gaps tracked as follow-up issues.

**Labels**: `vulkan`, `rendering`, `graphics`, `parity`

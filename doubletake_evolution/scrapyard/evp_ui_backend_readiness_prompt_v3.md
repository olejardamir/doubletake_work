# LLM Prompt: EVP Ghost Hunter UI Backend-Readiness Cleanup v3

You are working in the GitHub repository:

```text
https://github.com/olejardamir/evp_ghost_hunter
```

The current React/Vite UI is visually close enough for now. Do **not** redesign the UI, do **not** continue Cool Edit Pro style-transfer work, and do **not** start the Python/FastAPI backend yet.

Your task is to make the existing frontend functionally ready for backend integration.

This is a frontend cleanup/contract task only. The app must still run without a backend after this task.

---

## Goal

Prepare the UI so the next backend pass can connect cleanly to a Python/FastAPI service that will receive:

```text
- the original uploaded WAV/audio file
- chunk annotations
- selected processing mode
- source pass / target track information
- backend settings
- selected source track information
- output-target intent for CH 02 and/or CH 03
```

and later return:

```text
- generated processed audio candidates for CH 02
- generated composite/patch outputs for CH 03
- backend pass metadata
- status/error information
- URLs or local object URLs for returned output audio
```

The output of this task should be a frontend that has a stable frontend/backend contract and clear mock-vs-real processing boundaries.

---

## Do not change

Do **not** change the visual design except for tiny functional label corrections.

Do **not** alter:

```text
- Cool Edit Pro visual style
- bottom player styling
- waveform styling
- panel layout
- sidebar layout
- color/theme decisions
```

Do **not** implement:

```text
- SoloAudio
- Python
- FastAPI
- ffmpeg
- queues
- real backend processing
```

Do **not** remove existing mock/local behavior unless replacing it with a clearly named backend-ready wrapper.

---

## Current functional observations to account for

The current UI is a frontend prototype. It already has:

```text
- CH 01 / CH 02 / CH 03 visual lanes
- uploaded audio decoding in the browser
- waveform peak extraction
- region selection by dragging
- chunk creation
- chunk editing
- chunk deletion
- chunk navigation
- project JSON export/import
- mock CH 02 processing behavior
- chunk WAV export
- bottom transport controls
- timeline ruler
- per-track waveform colors
```

But it is not fully backend-ready because:

```text
- the original uploaded File is not preserved as backend-upload state
- processAgain is still a local mock, not routed through a backend-ready handler
- there may be no visible Process button wired to the backend-ready process handler
- no stable API client/payload contract exists
- chunk role semantics are too narrow
- CH 03 export behavior is misleading
- project JSON lacks enough session/pass/backend metadata
- backend response application is not defined
- processing state/error behavior needs to be explicit
- CH 02 / CH 03 audio-source behavior is not clear enough
- selected chunk export may always use the original uploaded audio even if the chunk visually belongs to CH 02 or CH 03
- the distinction between active selection, pinned/highlighted track selections, and chunk source track needs to be made explicit
```

---

# Required changes

## 1. Preserve the uploaded audio file in state

The UI currently stores `audioUrl` and `loadedFilename`, but backend integration needs the original uploaded `File`.

Add state similar to:

```ts
const [audioFile, setAudioFile] = useState<File | null>(null);
```

In `handleFileLoad`, store the uploaded file:

```ts
setAudioFile(file);
```

When loading a new file, keep these states consistent:

```text
audioFile
audioUrl
loadedFilename
duration
tracks
chunks
selection
playhead
passes
status
```

When replacing `audioUrl`, revoke the old object URL safely.

Also reset any backend-specific state when a new audio file is loaded:

```text
passes
processStatus
processError
backend output URLs
sourcePassId
processingMode if needed
```

Do not retain stale backend pass metadata from a previous audio file.

---

## 2. Define stable frontend/backend TypeScript types

Create a dedicated file:

```text
src/types/backend.ts
```

Include stable backend-facing types. Use these types in app code and API client code.

Suggested baseline:

```ts
export type TrackKind = 'original' | 'processed' | 'composite';

export type ChunkRole = 'guide' | 'avoid' | 'patch' | 'guide_and_patch' | 'ignore';

export type ProcessingMode = 'anchored' | 'recursive' | 'composite';

export type ProcessStatus =
  | 'idle'
  | 'ready'
  | 'processing'
  | 'complete'
  | 'backend_offline'
  | 'failed';

export interface BackendChunk {
  id: string;
  sourceTrack: TrackKind;
  sourcePassId: string;
  start: number;
  end: number;
  rating: number;
  description: string;
  possibleWords: string;
  voiceQuality: string;
  role: ChunkRole;
}

export interface AudioPass {
  id: string;
  track: TrackKind;
  label: string;
  filename: string;
  url?: string;
  objectUrl?: string;
  meta?: string;
  createdAt: string;
  backendGenerated: boolean;
}

export interface ProcessSettings {
  useOriginalAsAnchor: boolean;
  buildWeightedReference: boolean;
  includeAvoidPrompts: boolean;
  includePatchChunks: boolean;
}

export interface ProcessRequestPayload {
  schemaVersion: 1;
  sessionId: string;
  mode: ProcessingMode;
  sourcePassId: string;
  targetTracks: TrackKind[];
  duration: number;
  loadedFilename: string | null;
  chunks: BackendChunk[];
  settings: ProcessSettings;
}

export interface ProcessResponsePayload {
  schemaVersion: 1;
  sessionId: string;
  passId: string;
  status: 'complete' | 'failed';
  message: string;
  outputs: Array<{
    track: TrackKind;
    label: string;
    filename: string;
    url: string;
    meta?: string;
  }>;
}

export interface ProjectFileV1 {
  schemaVersion: 1;
  sessionId: string;
  duration: number;
  loadedFilename: string | null;
  chunks: BackendChunk[];
  tracks: Array<{
    id: string;
    kind: TrackKind;
    channel: string;
    label: string;
    filename: string;
    meta: string;
  }>;
  passes: AudioPass[];
  processingMode: ProcessingMode;
  sourcePassId: string;
  settings: ProcessSettings;
}
```

Avoid duplicating incompatible `TrackKind`, `ChunkRole`, and backend payload types across files.

---

## 3. Expand chunk roles without breaking current behavior

Replace or extend:

```ts
type ChunkRole = 'guide' | 'avoid';
```

with:

```ts
type ChunkRole = 'guide' | 'avoid' | 'patch' | 'guide_and_patch' | 'ignore';
```

Update all role dropdowns so the user can select:

```text
Positive guide
Negative / avoid
Patch into composite
Guide + patch
Ignore for now
```

Important semantics:

```text
avoid does not mean proven noise.
avoid means “do not use as positive guidance.”
ignore means “store but do not use for processing by default.”
patch means “candidate for CH 03/composite output.”
guide_and_patch means “use both as backend guidance and as a composite candidate.”
```

Update composite mock behavior so it includes `patch` and `guide_and_patch` chunks for CH 03. Do not use `avoid` or `ignore` chunks as CH 03 patch material by default.

---

## 4. Add explicit processing controls/state needed for backend

The app needs an obvious processing path before backend work starts.

Add or confirm state for:

```ts
const [processingMode, setProcessingMode] = useState<ProcessingMode>('anchored');
const [sourcePassId, setSourcePassId] = useState('original');
const [processStatus, setProcessStatus] = useState<ProcessStatus>('ready');
const [passes, setPasses] = useState<AudioPass[]>([]);
const [processError, setProcessError] = useState<string | null>(null);
```

The UI does not need a large new panel. If a process button already exists, wire it to the backend-ready handler. If it does not visibly exist, add or reuse one existing control in the current design for:

```text
Process / Generate CH 02
```

Do not redesign the UI. Use the existing style.

Button behavior:

```text
- disabled when no audio file is loaded
- disabled while processing
- allowed when zero chunks exist only if mode supports a broad baseline pass
- status is explicit when no chunks are present and chunk-guided processing is requested
```

Also show a clear, compact status in the existing status area:

```text
READY
NO AUDIO
PROCESSING
BACKEND OFFLINE
PROCESS ERROR
PROCESS COMPLETE
```

---

## 5. Add a backend-ready process request function

Create:

```text
src/api/client.ts
```

Implement:

```ts
import type { ProcessRequestPayload, ProcessResponsePayload } from '../types/backend';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8000';

export async function requestProcessing(options: {
  audioFile: File;
  payload: ProcessRequestPayload;
  signal?: AbortSignal;
}): Promise<ProcessResponsePayload> {
  const formData = new FormData();
  formData.append('audio', options.audioFile);
  formData.append('payload', JSON.stringify(options.payload));

  const response = await fetch(`${API_BASE_URL}/api/process`, {
    method: 'POST',
    body: formData,
    signal: options.signal,
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(text || `Processing failed with HTTP ${response.status}`);
  }

  return response.json() as Promise<ProcessResponsePayload>;
}
```

Do not call the backend by default unless explicitly configured.

---

## 6. Wrap the current mock process behavior behind a backend-ready handler

Do not keep `processAgain()` as an isolated local mock.

Refactor to this shape:

```ts
const USE_MOCK_PROCESSING = import.meta.env.VITE_USE_MOCK_PROCESSING !== 'false';

const handleProcess = async () => {
  if (!audioFile) {
    setStatus('NO AUDIO');
    return;
  }

  const payload = buildProcessPayload();
  setIsProcessing(true);
  setProcessStatus('processing');
  setProcessError(null);
  setStatus('PROCESSING');

  try {
    if (USE_MOCK_PROCESSING) {
      runMockProcess(payload);
      setProcessStatus('complete');
      setStatus('PROCESS COMPLETE');
      return;
    }

    const response = await requestProcessing({ audioFile, payload });
    applyProcessResponse(response);
    setProcessStatus(response.status === 'complete' ? 'complete' : 'failed');
    setStatus(response.status === 'complete' ? 'PROCESS COMPLETE' : 'PROCESS ERROR');
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown process error';
    setProcessError(message);
    setProcessStatus(USE_MOCK_PROCESSING ? 'failed' : 'backend_offline');
    setStatus(USE_MOCK_PROCESSING ? 'PROCESS ERROR' : 'BACKEND OFFLINE');
  } finally {
    setIsProcessing(false);
  }
};
```

For now, mock processing should still visually update CH 02 so the app remains usable without backend.

---

## 7. Build a clean process payload from current UI state

Add:

```ts
function buildProcessPayload(): ProcessRequestPayload
```

It should include:

```text
schemaVersion
sessionId
mode
sourcePassId
targetTracks
duration
loadedFilename
chunks
settings
```

Reasonable defaults:

```ts
mode: processingMode ?? 'anchored'
sourcePassId: sourcePassId ?? 'original'
targetTracks: ['processed']
settings.useOriginalAsAnchor: true
settings.buildWeightedReference: true
settings.includeAvoidPrompts: true
settings.includePatchChunks: true
```

Validation inside payload build:

```text
- clamp chunk start/end to 0..duration
- ensure end > start
- remove or mark invalid chunks rather than sending impossible ranges
- include sourcePassId on each chunk
- preserve chunk IDs
- preserve sourceTrack
- preserve rating/description/possibleWords/voiceQuality/role
```

Do not send malformed ranges to the backend.

---

## 8. Define how backend responses update CH 02 and CH 03

Add a function:

```ts
function applyProcessResponse(response: ProcessResponsePayload): void
```

For now, it should at least:

```text
- add a new AudioPass entry for each output
- update track metadata for returned track(s)
- if output.track === 'processed', update CH 02 filename/meta/url metadata
- if output.track === 'composite', update CH 03 filename/meta/url metadata
- set status/message from response
```

If the backend output URL is remote, do not assume it can be decoded immediately. Keep the code defensive.

If decoding backend WAV peaks is added now, keep it optional and guarded:

```text
- try to fetch/decode returned WAV
- if decoding fails, keep existing peaks and show metadata/status
```

Do not overbuild playback of backend tracks yet unless simple and safe.

---

## 9. Add explicit per-track audio URL resolution

Before backend work begins, define one function that answers:

```text
What audio source should be used for CH 01, CH 02, and CH 03?
```

Add something like:

```ts
function resolveTrackAudioUrl(track: TrackKind): string | null {
  if (track === 'original') return audioUrl;
  const newestPass = [...passes].reverse().find((pass) => pass.track === track && (pass.objectUrl || pass.url));
  return newestPass?.objectUrl ?? newestPass?.url ?? null;
}
```

Current behavior may still fall back to original audio for mock mode, but the logic must be explicit.

This matters because:

```text
- saving a CH 02 chunk should eventually export from CH 02 audio, not always original audio
- saving a CH 03 chunk should eventually export from CH 03 audio/composite, not always original audio
- playback/audition behavior must not silently lie about which track is being heard
```

Temporary acceptable behavior:

```text
If no CH 02/CH 03 audio URL exists yet, use original audio fallback and show status such as “USING ORIGINAL AUDIO FALLBACK”.
```

Do not pretend fallback audio is real processed/composite audio.

---

## 10. Fix misleading Save CH 03 behavior

Currently `Save CH 03` appears to export CH 03, but may export the active selected chunk.

Fix this by doing one of the following:

Preferred:

```text
Save CH 03 exports the full composite/chunks track when possible.
```

Acceptable temporary alternative:

```text
Rename the button text to “Save selected chunk” or “Save chunk WAV” so it is not misleading.
```

Do not make the UI lie about what it exports.

Also make sure there remains a way to export a selected chunk WAV.

If full CH 03 export is not implemented yet, explicitly show that CH 03 full export requires a backend/composite pass.

---

## 11. Make selected chunk export track-aware

Current selected-chunk export should not blindly assume the original uploaded file is the source for every chunk.

Update selected chunk export and single chunk export so they:

```text
1. check chunk.sourceTrack
2. resolve that track’s audio URL with resolveTrackAudioUrl(chunk.sourceTrack)
3. use that URL when available
4. fall back to original audio only with an explicit status message
```

Acceptance:

```text
- CH 01 chunks export from original audio
- CH 02 chunks are prepared to export from processed pass audio when available
- CH 03 chunks are prepared to export from composite pass audio when available
- fallback behavior is explicit, not silent
```

---

## 12. Clarify active selection vs pinned/highlighted selection

The UI currently has:

```text
selection
highlights
CH 01 / CH 02 / CH 03 tabs
```

Before backend, make the semantics explicit in code and payload:

```text
selection = current drag-selected range
highlight/pinned selection = optional retained range for a channel
chunk.sourceTrack = the track whose audio/timeline the chunk belongs to
```

Add small helper functions rather than duplicating selection logic:

```ts
function getActiveSelectionForTrack(track: TrackKind): Selection | null
function getSelectedChunkSourceTrack(): TrackKind
```

When saving a chunk:

```text
- use the correct sourceTrack
- use the selected/highlighted range that belongs to that sourceTrack
- do not accidentally save a CH 01 time range as CH 02 unless explicitly selected/pinned as CH 02
```

Do not change the UI layout. This is a logic cleanup.

---

## 13. Improve project JSON for backend continuity

Update project export to include:

```json
{
  "schemaVersion": 1,
  "sessionId": "...",
  "duration": 14,
  "loadedFilename": "...",
  "chunks": [],
  "tracks": [],
  "passes": [],
  "processingMode": "anchored",
  "sourcePassId": "original",
  "settings": {
    "useOriginalAsAnchor": true,
    "buildWeightedReference": true,
    "includeAvoidPrompts": true,
    "includePatchChunks": true
  }
}
```

The project JSON does not need to embed audio. It should preserve enough metadata to reload annotations and understand backend outputs.

Add `schemaVersion` now to avoid migration problems later.

Also include a warning/status on project import if the JSON references audio or backend output URLs that are not available locally.

---

## 14. Make project import defensive

When opening a project JSON:

```text
- validate schemaVersion if present
- tolerate older exports that lack schemaVersion
- tolerate missing passes/settings/processingMode/sourcePassId
- validate chunks before loading them
- clamp chunk ranges to duration
- ignore malformed chunk entries rather than crashing
- set LOAD ERROR only for invalid JSON or incompatible shape
```

If project JSON references audio that is not currently loaded, show metadata but do not pretend audio is loaded.

Do not load remote backend output URLs automatically unless they are safe and compatible with the current browser/CORS behavior.

---

## 15. Add explicit status values

Use clear status values in the UI:

```text
READY
NO AUDIO
NO SELECTION
USING ORIGINAL AUDIO FALLBACK
PROCESSING
BACKEND OFFLINE
PROCESS ERROR
PROCESS COMPLETE
EXPORTING
EXPORT ERROR
LOAD ERROR
IMPORT WARNING
```

Do not silently fail.

If a backend call fails, preserve the current UI state and existing chunks.

---

## 16. Keep mock CH 02 / CH 03 clearly marked as mock

Until backend is real, CH 02 and CH 03 should indicate that they are preview/mock/model-placeholder outputs.

Use metadata such as:

```text
mock processed preview
mock composite preview
mock UI pass
```

Do not let users confuse smoothed peaks or local gain-modified exports with real SoloAudio output.

If a mock export alters the original audio locally, label it clearly as mock/local preview.

---

## 17. Keep timing and selection backend-safe

Backend will depend on accurate time ranges.

Ensure:

```text
- selected start/end are stored in seconds
- values are finite numbers
- values are rounded consistently, e.g. to 3 decimals
- start is always less than end
- active selection length is shown consistently in the bottom measurement panel
- chunk export and process payload use the same times displayed in the UI
```

Do not switch to sample indexes in the frontend payload. Use seconds for backend contract.

Also ensure that a selection shorter than a practical minimum is handled clearly:

```text
- either allow it but mark it valid
- or prevent saving and show NO SELECTION / TOO SHORT
```

Do not save zero-length chunks.

---

## 18. Prevent duplicate processing and stale state

While processing:

```text
- disable process button
- do not allow multiple concurrent process requests
- preserve current chunks and selection
- show PROCESSING
```

Optional but useful:

```ts
const processAbortRef = useRef<AbortController | null>(null);
```

If an AbortController is added, clean it up on unmount.

Do not implement complex job queues yet.

---

## 19. Add minimal environment documentation

Update README or add a short section documenting:

```text
VITE_USE_MOCK_PROCESSING=true/false
VITE_API_BASE_URL=http://localhost:8000
```

Explain:

```text
- mock processing is the default
- setting VITE_USE_MOCK_PROCESSING=false enables the backend request path
- backend code is not part of this task
```

Do not over-document future backend internals.

---

## 20. Preserve existing interactions

After the changes, these must still work:

```text
- load audio file
- decode and display waveform peaks
- select region by dragging
- play/pause/stop
- loop selected region
- save chunk
- edit chunk
- delete chunk
- jump to chunk
- export selected chunk WAV
- export project JSON
- open project JSON
- mock process still updates CH 02
- CH 01 / CH 02 / CH 03 buttons still function as currently intended
```

Do not break visual styling while doing these functional changes.

---

## Testing checklist

Run:

```bash
npm install
npm run build
npm run dev
```

Manual UI test:

```text
1. Open the app.
2. Load a WAV.
3. Select a region on CH 01.
4. Save it as a positive guide chunk.
5. Select another region and save it as avoid.
6. Select another region and save it as patch.
7. Select another region and save it as guide_and_patch.
8. Select another region and save it as ignore.
9. Run mock process.
10. Confirm CH 02 changes visually.
11. Confirm CH 03/composite behavior uses patch/guide_and_patch semantics.
12. Export project JSON.
13. Re-open project JSON.
14. Confirm chunks reload.
15. Confirm Save CH 03 is no longer misleading.
16. Confirm selected chunk export still exists.
17. Confirm selected chunk export is track-aware or explicitly falls back to original audio.
18. Confirm status messages appear for no audio, no selection, processing, failed export, and backend offline.
19. Confirm `VITE_USE_MOCK_PROCESSING=false` attempts the backend request path and fails gracefully if no backend is running.
20. Confirm no TypeScript errors.
```

---

## Final acceptance criteria

The UI is backend-ready when:

```text
- uploaded audio File is preserved for upload
- there is a single backend payload contract
- chunk roles support guide, avoid, patch, guide+patch, and ignore
- process action is routed through a backend-ready handler
- a visible process action exists and is disabled correctly
- mock processing still works without backend
- real backend call can be enabled with VITE_USE_MOCK_PROCESSING=false
- backend API helper exists but does not require backend by default
- project JSON includes schema/session/pass/settings metadata
- project import is defensive
- Save CH 03 is no longer misleading
- selected chunk export is track-aware or explicitly labels fallback behavior
- response application function exists for future backend outputs
- active selection and pinned/highlighted selection semantics are explicit
- CH 02 / CH 03 mock outputs are clearly labeled as mock/preview until backend is real
- all current UI behavior still works
- npm run build passes
```

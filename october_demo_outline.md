# EZTrack Clinical Demo

Outline for EMU operations staff, EMU fellows, neurologists, and neuroscientists.

## Why EZTrack matters

State the problem that EZTrack solves. Show an unsorted EEG. Show the same EEG with sorted electrodes. Show which ones
were actually resected in a success case. Show a failure case and discuss how EZTrack might best add value by confirming
a clinical suspicion that the patient doesn't have focal epilepsy and isn't an ideal candidate for resection surgery.

## Why we're meeting with you

We'd like to get your critical feedback about our current understanding of how EZTrack will fit into your workflow.

Start with setting expectations: We're here to get feedback on a candidate workflow to use EZTrack to get
these results.

We're talking to each of the main EZTrack stakeholders to give this system the best chance of succeeding:
Clinical Data Team, IT Infrastructure, EMU Operations, Neurology / Neurosurgery.


## Patient onboarding

### Viewing the patient's EEG in the EMU

As is done today, the EMU will still use the NK interface as the primary monitoring tool.

We'll use EDFBrowser for PY13N003 or a mock-up to show something representative of what the NK EEG
viewer will look like.


### Add the patient to EZTrack

Start with data entry of a current patient.

When?
By whom?

• patient id
• lobe of interest (known in advance?)


## Data acquisition

After an event is observed in the Nihon Kohden interface, seizure onset time is known.

Input this onset time. (Who? How long after the seizure occurs?)

The system searches for the appropriate MEF collection corresponding to the patient id and time and copies the MEF file
collection to EZTrack.

Once the data is acquired, the system renders the EEG view for validation.

Get channel and label information automatically, if possible.
• This data is in the MEF files, but at what point is this information entered in the NK system? By whom?
  Is it always verified and known to be accurate?

If the EEG view and channel / electrode information looks correct, the user clicks the "Score Channels" button.


## EZTrack's Electrode Ranking and Heatmap

_Includes implementation details about what's happening behind the scenes. This may or may not be interesting for the
demo, but this section could include the implementation detail slides describing the electrode classification algorithm.
I'm including it here just for sake of documenting the system orchestration._

• edf2eeg will be used in the demo to produce the intermediate .mat files as seen in tools/output/PY12N008/*.mat.

• mef2eeg will be used in the future. eeg2fsv extracts the FSV values to use in the final scores. We have these cached
  already for each patient of interest in case there is a problem here. fsv2heatmap produces the CSV of final electrode
  weight and heat map scores.

Once the CSV is ready, we show the results in the EEG viewer, and sort the electrodes. Show the before and after for the
successful resection and failed resection case.


## Clinical Application

EZTrack, like an EEG, is a tool that supplements patient history and examination. It isn't a substitute for clinical
judgment, but can act as a signaling mechanism that further examination, analysis, or sampling is necessary before
moving forward with a resection.

We expect that clinicians will select the channels / regions that they want to resect based on weights above a
threshold.

Review the success case.

Alternately, if there is no clear region of interest, resection might not be successful. EZTrack was able to predict
failed surguries with 100% accuracy.

Review the failure case.

Discuss.


## Reviewing Previous Patient Results

• Define terminology. How will clinicians want data organized in EZTrack?
  Patient ID -> Study -> EEG + Heatmap, for example?

• Search / browse interface?

• At what point do clinicians return to these results?

• How would these be used differently in the EMU vs. in grand rounds?

• Do clinicians need to compare multiple patients?


## Clinical Validation and Feedback

Is EZTrack having a positive impact on patient outcomes?

Retrospective studies are difficult compared to clinical feedback given as close to the time of patient treatment as
possible.

We need to keep track of EZTrack's electrode scores, what the clinician did with the information, and what the outcome
was.

Discuss how we can fit this into the clinical workflow. Could this step be completed right in the operating room or in a
near-term follow-up?

• Would a section in EZTrack for patient notes be helpful? Something right under the viewer?

• Should observations and results be shared with colleagues directly from EZTrack, e.g. by mailing a link to a comment
  or discussion?


## Next Steps: Project Roadmap at JHH

From Initial Traction to Clinical Validation

• What is next to help EZTrack gain traction with clinicians?
    • Review of current project timeline to prompt the conversation.

• Summary of feedback received so far.

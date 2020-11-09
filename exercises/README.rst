Deliverables
------------

You should copy the following files from your :code:`output` directory
following a fuzzing session to the appropriate evidence subdirectory
(e.g., :code:`baseline`, :code:`improved`).

* :code:`crashes`: the crashing inputs, if any, that were discovered
  during fuzzing for this configuration.
* :code:`fuzzer_stats`: provides a set of summary statistics that
  describe the entire fuzzing session.
* :code:`plot_data`: a comma separated file that tracks basic
  fuzzing statistics at a regular interval over the course of a fuzzing session.
* :code:`fuzzer_setup`: describes how the fuzzer was setup for a
  particular session in terms of the command and environment variables that
  were used.

Additionally, you should use :code:`afl-plot` to obtain the following
files:

* :code:`exec_speed.png`
* :code:`high_freq.png`
* :code:`index.html`
* :code:`low_freq.png`

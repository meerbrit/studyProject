# studyProject
Code and needed resources for the experiment

The experiment is run via 
- Experiment_StudyProject.m
- Or Experiment_PAUSE.m
The Pause duration can be adjusted in either script by changing the pause variable

The short test scripts without the second ungrammatical condition are:
- TEST_experiment.m
- TEST_experiment_PAUSE.m


Run --> AudioDeviceCheck.m to check which is the correct sound device
- Open the created matlab object ‘devices’
   - Use DeviceIndex of this file in --> soundTest.m
   - Line 7: audio_port =
   - Run the file and see if sound was played
        - Adjust volume on amplifier (should be sticker marked) if necessary
        - Change ID until you hear sound
!!Use the same ID in --> Experiment_StudyProject.m (or Experiment_PAUSE.m)!!


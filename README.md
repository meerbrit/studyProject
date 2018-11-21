# studyProject
Code and needed resources for the experiment.
Active buttons for testphase are currently the bottom keys on DE keyboard: x c v b n = 1 2 3 4 5 

The experiment is run via 
- Experiment_StudyProject.m
The Pause duration can be adjusted by changing the value for the pause variable
--> make sure you are located in the correct directory when starting, otherwise the log file will be saved somewhere else
--> make sure the cursor is not located in the script when starting as the responses will be written in the code.

The short test scripts without the second ungrammatical condition are:
- TEST_experiment.m

Run --> AudioDeviceCheck.m to check which is the correct sound device
- Open the created matlab object ‘devices’
   - Use DeviceIndex of this file in --> soundTest.m
   - Line 7: audio_port =
   - Run the file and see if sound was played
        - Adjust volume on amplifier (should be sticker marked) if necessary
        - Change ID until you hear sound
!!Use the same ID in --> Experiment_StudyProject.m !!


clear all;
pe_=transpose(psychwavread('wavs/pe.wav'));
pe_ = resample(pe_,44100,22050);
InitializePsychSound(0); %initializing sound driver
audio_port = 7; %specifying audio port
pa_handle = PsychPortAudio('Open', audio_port, 1, [],[],1,[], [], []); %open audioport
PsychPortAudio('FillBuffer', pa_handle, pe_); 
PsychPortAudio('Start', pa_handle, 1); %starts sound immediatley
PsychPortAudio('Stop', pa_handle, 1); 
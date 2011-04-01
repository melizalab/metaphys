function [data, Fs] = LoadStimulusWaveform(stimfile, samplerate, targetrate)
% LOADSTIMULUSWAVEFORM Load a stimulus waveform from a file
%
% S,Fs = LOADSTIMULUSWAVEFORM(stimfile, samplerate, targetrate)
%
% Load sampled data from <stimfile>. Data can be stored in one of four
% formats: ASCII text, raw PCM, WAV, or MAT.  WAV files contain information
% about sampling rate; otherwise the <samplerate> argument can be used to
% specify it.  Sampling rate only matters if the data need to be resampled
% to <targetrate>.
%
% For a MAT file, the data are assumed to be in a variable called 'data'
%
% Copyright (C) 2011 Daniel Meliza <dmeliza@dylan.uchicago.edu>
% Created 2011-02-22

error(nargchk(1,3,nargin));

[~,~,ext] = fileparts(stimfile);

switch lower(ext)
 case '.pcm'
  fp = fopen(stimfile, 'rb', 'ieee-le');
  data = fread(fp,inf,'int16');
  data = double(data) / 2^15;
 case '.wav'
  [data,samplerate,bits] = wavread(stimfile);
  data = double(data) / 2^(bits-1);
 case '.mat'
  z = load(stimfile,'-mat');
  data = z.data;
 otherwise
  data = load(stimfile,'-ascii');
end

if nargin > 2 && samplerate~=targetrate
    data = resample(data, targetrate, samplerate);
    Fs = targetrate;
else
    Fs = samplerate;
end
    
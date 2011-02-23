function [data] = LoadStimulusWaveform(stimfile, samplerate)
% LOADSTIMULUSWAVEFORM Load a stimulus waveform from a file
%
% The stimulus can be stored in four formats: ASCII text, raw PCM,
% WAV, or MAT.  For the first two cases, the data are assumed to be sampled at
% the target rate.  For WAV files, if <samplerate> is defined the
% data are resampled to match it, if necessary.  For a MAT file, the data
% are assumed to be in a variable called 'data'
%
% Copyright (C) 2011 Daniel Meliza <dmeliza@dylan.uchicago.edu>
% Created 2011-02-22

[pn,fn,ext] = fileparts(stimfile);

switch lower(ext)
 case '.pcm'
  fp = fopen(stimfile, 'rb', 'ieee-le');
  data = fread(fp,inf,'int16');
  data = double(data) / 2^15;
 case '.wav'
  [data,fs,bits] = wavread(stimfile);
  data = double(data) / 2^(bits-1);
  if nargin > 1
    warning('Resampling not yet implemented');
  end
 case '.mat'
  z = load(stimfile,'-mat');
  data = z.data;
 otherwise
  data = load(stimfile,'-ascii');
end

function X = preprocess(samples)

% 2000 Hz sampling rate (samples/sec)
fs = 2000;
% 50 Hz power line noise, normalized for notch filter
w0 = 50 / (fs / 2);
% Quality factor
Q = 1;
% Width of notch filter
bw = w0 / Q;

[bNotch, aNotch] = designNotchPeakIIR(Response="notch", FilterOrder=2, CenterFrequency=w0, Bandwidth=bw);

% 500 Hz lowpass filter
wn = 500 / (fs / 2);
[bLP, aLP] = butter(1, wn);

S = length(samples);
X = cell(S, 1);
for i = 1:S
    X{i} = filter(bNotch, aNotch, samples{i}, [], 1);
    X{i} = filter(bLP, aLP, X{i}, [], 1);
    X{i} = wdenoise(X{i}, 8, 'Wavelet', 'db44');
end

end
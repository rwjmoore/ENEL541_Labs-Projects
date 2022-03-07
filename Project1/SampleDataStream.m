function [Ddata, t]  = SampleDataStream(SimData, Ts)
% [Ddata, t]  = SampleDataStream(SimData, Ts);
% Takes a Simulink output structure and returns data sampled with 
% sample time Ts.
% 
% Ddata is a cell array, with one element per outport in the block diagram
% Ddata{1} will will be a Nxm matrix, where N is the data length and m is
% the number of signals that go through outport 1.

% DW 03/20
% 27/03/20 -- ability to deal with different length outport signals.
% 20/02/21 -- replaced spline with interp1, to handle sudden
%             changes better.


% Figure out how many outports there were in the system
NumPorts = SimData.yout.numElements;
Ddata = cell(NumPorts,1);  % one cell per out port


% get the sample times from Simulink
tt = SimData.tout;
tend = max(tt);
tstart = min(tt);
t = [tstart:Ts:tend]';
DataLen = length(t);


for i = 1:NumPorts
    Sdat = SimData.yout{i}.Values.Data;
    tt = SimData.yout{i}.Values.Time;
    [~,m] = size(Sdat);
    Y = zeros(DataLen,m);
    for j = 1:m
        yy = Sdat(:,j);
%        y = spline(tt,yy,t); 
        y = interp1(tt,yy,t);
        Y(:,j) = y;
    end
    Ddata{i,1} = Y;
end
    
function varargout = TriggerBuilder(varargin)
%                     ____            __           
%                      /  _ '_ _ _ _ / _)  '/_/_ _ 
%                     (  / /(/(/(-/ /(_)(//((/(-/  
%                          _/_/                    
% 
% Description
% ===========--------------------------------------------------------------
% Builds arrays of triggers to output from DAQ cards to control and
% synchronise experiments 
%
% Input
% =====--------------------------------------------------------------------
% None             : opens an interactive GUI
% Name-value pairs : runs core script using passed parameters (no GUI)
%
% Output
% ======-------------------------------------------------------------------
% out_array : 1d array or { 1d arrays } if creating more than one channel
%             with the GUI
%
% Note: if 'save_result' is true, 'out_array' is saved to file with the
% following naming scheme:
%    "NamePrefix_XTriggers_EveryXms_TrainXRepsEveryXms_XmsDuration...
%        _XmsShift_XmsJitter_XHzSampleRate_XV.dat"
%
% Example
% =======------------------------------------------------------------------
% out_array = TriggerBuilder('name_prefix',        'name',...
%                            'total_num_triggers', 10,...
%                            'trigger_every_ms',   1000,...
%                            'trigger_dur_ms',     20,...
%                            'train_num_reps',     1,...
%                            'train_rep_every_ms', 0,...
%                            'shift_by_ms',        0,...
%                            'tail_to_add_ms',     0,...
%                            'jitter_ms',          0,...
%                            'trigger_amp_v',      5,...
%                            'sample_rate_hz',     1000,...
%                            'to_blank',           0,...
%                            'to_blank_train',     0,...
%                            'plot_result',        true,...
%                            'save_result',        true...
%                           );
%
% Author
% ======-------------------------------------------------------------------
% Lloyd Russell 2016 (@llerussell)


% parse inputs
p = inputParser;
p.addParameter('name_prefix',        'ForPV');
p.addParameter('total_num_triggers', 10);
p.addParameter('trigger_every_ms',   10000);
p.addParameter('trigger_dur_ms',     20);
p.addParameter('train_num_reps',     1);
p.addParameter('train_rep_every_ms', 0);
p.addParameter('shift_by_ms',        0);
p.addParameter('tail_to_add_ms',     0);
p.addParameter('jitter_ms',          0);
p.addParameter('trigger_amp_v',      5);
p.addParameter('sample_rate_hz',     1000);
p.addParameter('to_blank',           0);
p.addParameter('to_blank_train',     0);
p.addParameter('plot_result',        true);
p.addParameter('save_result',        true);
parse(p, varargin{:});


% nothing passed as input, start the GUI and load default values
if size(varargin) == 0
    if nargout
        out_array = TriggerBuilderGUI(p.Results);
    else
        TriggerBuilderGUI(p.Results);
    end
    
    
% name-value pairs were passed, do main function
else
    % extract parameter values
    name_prefix        = p.Results.name_prefix;
    total_num_triggers = p.Results.total_num_triggers;
    trigger_every_ms   = p.Results.trigger_every_ms;
    trigger_dur_ms     = p.Results.trigger_dur_ms;
    train_num_reps     = p.Results.train_num_reps;
    train_rep_every_ms = p.Results.train_rep_every_ms;
    shift_by_ms        = p.Results.shift_by_ms;
    tail_to_add_ms     = p.Results.tail_to_add_ms;
    jitter_ms          = p.Results.jitter_ms;
    trigger_amp_v      = p.Results.trigger_amp_v;
    sample_rate_hz     = p.Results.sample_rate_hz;
    to_blank           = p.Results.to_blank;
    to_blank_train     = p.Results.to_blank_train;
    plot_result        = p.Results.plot_result;
    save_result        = p.Results.save_result;

    % sample rate conversion
    samples_per_ms = sample_rate_hz / 1000;

    % build output segment to be repeated
    out_segment = zeros(round(trigger_every_ms * samples_per_ms), 1);
    for i = 1:train_num_reps
        if ~any(i == to_blank_train)
            for j = 1:trigger_dur_ms * samples_per_ms
                out_segment((i-1)*(train_rep_every_ms * samples_per_ms) + j) = trigger_amp_v;
            end
        end
    end

    % repeat segment
    out_array = [];
    for i = 1:total_num_triggers
        if ~any(i == to_blank)
            if i > 1  && jitter_ms > 0
                out_array = [out_array(1:end-randi(round(jitter_ms/2))*samples_per_ms);
                    zeros(randi(round(jitter_ms/2))*samples_per_ms, 1); out_segment];
            else
                out_array = [out_array; out_segment];
            end
        else
            out_array = [out_array; zeros(size(out_segment))];
        end
    end

    % apply shift
    out_array = [zeros(shift_by_ms * samples_per_ms, 1); out_array];
    out_array(end-shift_by_ms * samples_per_ms : end) = [];

    % add tail to end
    out_array = [out_array; zeros(tail_to_add_ms * samples_per_ms, 1)];

    % visualise
    if plot_result
        if exist('h1', 'var') && isvalid(h1)
            figure(h1)
        else
            h1 = figure;
            hold on
        end
        plot(out_array)
    end

    % save
    if save_result
        filename = [name_prefix '_' num2str(total_num_triggers) 'Triggers_Every' ...
            num2str(trigger_every_ms) 'ms_Train' num2str(train_num_reps) ...
            'RepsEvery' num2str(train_rep_every_ms) 'ms_' num2str(trigger_dur_ms) ...
            'msDuration_' num2str(shift_by_ms) 'msShift_' num2str(jitter_ms) 'msJitter_' ...
            num2str(sample_rate_hz) 'HzSampleRate_' num2str(trigger_amp_v) 'V'];
        fid = fopen([filename '.dat'], 'w', 'l');
        fwrite(fid, out_array, 'double');
        fclose(fid);
    end
end


% if output is requested
if nargout
    varargout{1} = out_array;
end
        
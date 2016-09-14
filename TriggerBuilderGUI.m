function varargout = TriggerBuilderGUI(defaults)
% Lloyd Russell 2016
% Interactive GUI called by main TriggerBuilder function

% make figure and panel
fig = figure('name','TriggerBuilder', 'numbertitle','off', 'menubar','none', 'toolbar','none', 'position',[500 500 550 350]);
config_panel = uipanel('Title','Configuration', 'Position',[1/20 10/20 18/20 9/20]);

% add labels
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 6/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Name prefix: ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 5/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Total num triggers: ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 4/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Trigger every (ms): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 3/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Train num reps: ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 2/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Train rep every (ms): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 1/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Trigger duration (ms): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[0 0/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Trigger amplitude (V): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[1/2 6/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Shift by (ms): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[1/2 5/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Add tail (ms): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[1/2 4/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Jitter (ms): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[1/2 3/7 1/4 1/7], 'HorizontalAlignment','right', 'String','To blank: ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[1/2 2/7 1/4 1/7], 'HorizontalAlignment','right', 'String','To blank (train): ');
uicontrol(config_panel,'Style','text', 'Units','normalized', 'Position',[1/2 1/7 1/4 1/7], 'HorizontalAlignment','right', 'String','Sample rate (Hz): ');

% add user input boxes
name_prefix        = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 6/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.name_prefix);
total_num_triggers = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 5/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.total_num_triggers);
trigger_every_ms   = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 4/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.trigger_every_ms);
train_num_reps     = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 3/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.train_num_reps);
train_rep_every_ms = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 2/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.train_rep_every_ms);
trigger_dur_ms     = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 1/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.trigger_dur_ms);
trigger_amp_v      = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[1/4 0/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.trigger_amp_v);
shift_by_ms        = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[3/4 6/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.shift_by_ms);
tail_to_add_ms     = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[3/4 5/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.tail_to_add_ms);
jitter_ms          = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[3/4 4/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.jitter_ms);
to_blank           = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[3/4 3/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.to_blank);
to_blank_train     = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[3/4 2/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.to_blank_train);
sample_rate_hz     = uicontrol(config_panel,'Style','edit', 'Units','normalized', 'Position',[3/4 1/7 1/4 1/7], 'Callback',@update_values, 'String',defaults.sample_rate_hz);

% add save button
save_button        = uicontrol(config_panel,'Style','pushbutton', 'Units','normalized', 'Position',[2/4 0/7 1/2 1/7], 'Callback',@update_values_and_save, 'String','Save');

% add multiple output channels
add_button    = uicontrol(fig,'Style','pushbutton', 'Units','normalized', 'Position',[17/20 19/20 1/20 1/20], 'Callback',@add_channel, 'String','+');
remove_button = uicontrol(fig,'Style','pushbutton', 'Units','normalized', 'Position',[18/20 19/20 1/20 1/20], 'Callback',@remove_channel, 'String','-');
select_channel_popup = uicontrol(fig,'Style','popup', 'Units','normalized', 'Position',[15/20 19/20 2/20 1/20], 'Callback',@select_channel, 'String',{1});

% initialise
out_array = {};
values = {};
num_channels  = 1;
selected_channel = 1;
max_num_chans = 10;

% add plot axes
ax = axes(fig, 'Position',[2/20 3/20 17/20 6/20]);
hold on
for idx = 1:max_num_chans
    h{idx} = plot(ax, 0,0, 'linewidth',2);
end
update_values();

% if output is requested
if nargout > 0
    uiwait
    varargout{1} = out_array;
    varargout{2} = filename; % NB HD added this line
end

% callbacks
    function update_values(varargin)

        update(false);
    end

    function update_values_and_save(varargin)
        update(true);
    end

    function update(save_flag)        
        % store values
        values{selected_channel}.name_prefix        = name_prefix.String;
        values{selected_channel}.total_num_triggers = str2double(total_num_triggers.String);
        values{selected_channel}.trigger_every_ms   = str2double(trigger_every_ms.String);
        values{selected_channel}.trigger_dur_ms     = str2double(trigger_dur_ms.String);
        values{selected_channel}.train_num_reps     = str2double(train_num_reps.String);
        values{selected_channel}.train_rep_every_ms = str2double(train_rep_every_ms.String);
        values{selected_channel}.shift_by_ms        = str2double(shift_by_ms.String);
        values{selected_channel}.tail_to_add_ms     = str2double(tail_to_add_ms.String);
        values{selected_channel}.jitter_ms          = str2double(jitter_ms.String);
        values{selected_channel}.trigger_amp_v      = str2double(trigger_amp_v.String);
        values{selected_channel}.sample_rate_hz     = str2double(sample_rate_hz.String);
        values{selected_channel}.to_blank           = eval(to_blank.String);
        values{selected_channel}.to_blank_train     = eval(to_blank_train.String);
        
        % make output array
        [out_array{selected_channel},filename] = TriggerBuilder(...             % NB HD added filename to output
            'name_prefix',        values{selected_channel}.name_prefix,...
            'total_num_triggers', values{selected_channel}.total_num_triggers,...
            'trigger_every_ms',   values{selected_channel}.trigger_every_ms,...
            'trigger_dur_ms',     values{selected_channel}.trigger_dur_ms,...
            'train_num_reps',     values{selected_channel}.train_num_reps,...
            'train_rep_every_ms', values{selected_channel}.train_rep_every_ms,...
            'shift_by_ms',        values{selected_channel}.shift_by_ms,...
            'tail_to_add_ms',     values{selected_channel}.tail_to_add_ms,...
            'jitter_ms',          values{selected_channel}.jitter_ms,...
            'trigger_amp_v',      values{selected_channel}.trigger_amp_v,...
            'sample_rate_hz',     values{selected_channel}.sample_rate_hz,...
            'to_blank',           values{selected_channel}.to_blank,...
            'to_blank_train',     values{selected_channel}.to_blank_train,...
            'plot_result',        false,...
            'save_result',        save_flag...
            );
        
        % update plot
        set(h{selected_channel}, 'Ydata', out_array{selected_channel}, 'Xdata', 1:length(out_array{selected_channel}));
        set(ax, 'xlim',[0 max(cellfun(@length, out_array))+1]);
        set(ax, 'ylim',[floor(min(cellfun(@min, out_array))) ceil(max(cellfun(@max, out_array)))]);
        set(ax, 'xticklabel',get(ax,'xtick') / str2double(sample_rate_hz.String));
        set(ax, 'box','off', 'tickdir','out')
        xlabel(ax, 'Time (s)')
        ylabel(ax, 'Amplitude (V)')
    end

    function add_channel(varargin)
        if num_channels < max_num_chans
            num_channels = num_channels+1;
            old_items = get(select_channel_popup, 'string');
            new_items = [old_items; num_channels];
            set(select_channel_popup, 'string',new_items);
            set(select_channel_popup, 'value',num_channels);
            selected_channel = num_channels;
    
            % set new channel values to defaults
            values{selected_channel}.name_prefix        = defaults.name_prefix;
            values{selected_channel}.total_num_triggers = defaults.total_num_triggers;
            values{selected_channel}.trigger_every_ms   = defaults.trigger_every_ms;
            values{selected_channel}.trigger_dur_ms     = defaults.trigger_dur_ms;
            values{selected_channel}.train_num_reps     = defaults.train_num_reps;
            values{selected_channel}.train_rep_every_ms = defaults.train_rep_every_ms;
            values{selected_channel}.shift_by_ms        = defaults.shift_by_ms;
            values{selected_channel}.tail_to_add_ms     = defaults.tail_to_add_ms;
            values{selected_channel}.jitter_ms          = defaults.jitter_ms;
            values{selected_channel}.trigger_amp_v      = defaults.trigger_amp_v;
            values{selected_channel}.sample_rate_hz     = defaults.sample_rate_hz;
            values{selected_channel}.to_blank           = defaults.to_blank;
            values{selected_channel}.to_blank_train     = defaults.to_blank_train;
            
            populate_gui(selected_channel)
            update(false)
        end
    end

    function remove_channel(varargin)
        if num_channels > 1
            set(h{num_channels}, 'Ydata',0, 'Xdata',0);
            out_array = out_array(1:end-1);
            num_channels = num_channels-1;
            selected_channel = num_channels;
            old_items = get(select_channel_popup, 'string');
            new_items = old_items(1:end-1);
            set(select_channel_popup, 'value',1);
            set(select_channel_popup, 'string',new_items);
            populate_gui(selected_channel)
            update(false)
        end
    end

    function select_channel(source, ~)
        selected_channel = source.Value;
        populate_gui(selected_channel)
    end

    function populate_gui(selected_channel)
        % set ui control values to stored values
        name_prefix.String        = values{selected_channel}.name_prefix;
        total_num_triggers.String = values{selected_channel}.total_num_triggers;
        trigger_every_ms.String   = values{selected_channel}.trigger_every_ms;
        trigger_dur_ms.String     = values{selected_channel}.trigger_dur_ms;
        train_num_reps.String     = values{selected_channel}.train_num_reps;
        train_rep_every_ms.String = values{selected_channel}.train_rep_every_ms;
        shift_by_ms.String        = values{selected_channel}.shift_by_ms;
        tail_to_add_ms.String     = values{selected_channel}.tail_to_add_ms;
        jitter_ms.String          = values{selected_channel}.jitter_ms;
        trigger_amp_v.String      = values{selected_channel}.trigger_amp_v;
        sample_rate_hz.String     = values{selected_channel}.sample_rate_hz;
        to_blank.String           = values{selected_channel}.to_blank;
        to_blank_train.String     = values{selected_channel}.to_blank_train;
    end

end
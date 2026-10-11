local volume = "~/.config/hypr/scripts/volume"

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. " --inc"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. " --dec"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(volume .. " --toggle-mic"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(volume .. " --toggle"))
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd(volume .. " --next"))
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd(volume .. " --prev"))
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd(volume .. " --playpause"))

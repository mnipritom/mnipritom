(define listApplications "rofi -show drun")
(define runCommands "rofi -show run")
(define closeCurrentWindow "xdo close")
(define quitCurrentApplication "xdo kill")

(xbindkey (quote (Mod4 r)) listApplications)
(xbindkey (quote (Mod4 t)) runCommands)
(xbindkey (quote (Mod4 w)) closeCurrentWindow)
(xbindkey (quote (Mod4 q)) quitCurrentApplication)

; [TODO] implement media key controls
;(xbindkey (quote (XF86AudioPrev)) " ")
;(xbindkey (quote (XF86AudioNext)) " ")
;(xbindkey (quote (XF86AudioPlay)) " ")
;(xbindkey (quote (XF86AudioStop)) " ")
;(xbindkey (quote (XF86AudioMute)) " ")
;(xbindkey (quote (XF86AudioMicMute)) " ")
;(xbindkey (quote (XF86AudioRaiseVolume)) " ")
;(xbindkey (quote (XF86AudioLowerVolume)) " ")

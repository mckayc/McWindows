#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!,::Media_Prev 
!.::Media_Next 
!Space::Media_Play_Pause 
!0::Volume_Mute 
!-::Volume_Down 
!=::Volume_Up


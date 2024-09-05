# TI-84 Plus CE / 83 PCE Hook Template

This repository serves as a template for creating simple hooks for the TI-84 Plus CE
and TI-83 Premium CE calculators (along with their variants). While the best method
for creating hooks is to use an app, this is more complicated and less feasible. A
good alternative is to create an AppVar with the hook code which resides in the
calculator's archive, meaning the hook is more stable than if it was stored in the
RAM. However, hooks using this method will be destroyed and require reinstalling
after a garbage collect.

## About this template

The template provides an installer part (**main.asm**) and a file for the hook's
code (**hook.asm**). The installer will check if its specific hook is installed,
and if it is not, removes any possible conflicting hooks and then creates an
archived AppVar with the code in **hook.asm**. It then sets the hook pointer to the
start of the hook's code. If the installer is ran when its specific hook is already
installed, it will instead remove it, serving as an uninstaller as well. Once the
hook is removed, it will also delete the associated AppVar.

## Usage
 **⚠️ Please read all instructions carefully before using this template.**
 **This assumes you already have at least a general familiarity with eZ80 assembly.**

To begin using this template, you'll first need to decide which hook type you plan
on using. WikiTI has documentation on the various types of hooks
[here](https://wikiti.brandonw.net/index.php?title=Category:83Plus:Hooks:By_Name) and
[here](https://wikiti.brandonw.net/index.php?title=Category:83PCE:Hooks:By_Name).
Next, open **main.asm** and look for the following lines of code which are commented
out:

```asm
; bit <hook flag>, (iy + <hook flag group>)
...

; ld hl, (<hook pointer location>)
...

; call <clear hook>
...

; jp <set hook>
```

Replace these lines with the the equates associated with the hook you have chosen. For
example, a parser hook would look like this:

```asm
bit ti.parserHookActive, (iy + ti.hookflags4)
...

ld hl, (ti.parserHookPtr)
...

call ti.ClrParserHook
...

jp ti.SetParserHook
```

Now that the installer is set up, open **hook.asm** and place your hook's code in
the commented space between the `db $83` and `ret`. The `db $83` header is
necessary for TI-OS to detect that the code is supposed to be used for a hook.

Once both **main.asm** and **hook.asm** are ready, you can build the program using
[fasmg](https://flatassembler.net/download.php). If you do not already have fasmg
set up on your system, you can follow the guide 
[here](https://ezce.github.io/ez80-docs/basics/getting-started/).

The most important thing is to run check_design after the compile step.   Most synthesis issues flagged at this point have to be fixed.  The check_design run before the compile tends to flag more issues, though the major ones tend to stay.  Likewise warnings after the read are critical, as is timing UNMET.

Another good source about warnings...https://www.coursehero.com/file/p65sjbr/Did-you-look-at-the-warnings-and-errors-after-the-read-statement-6-Did-you-look/

This covers just a few of the errors and warnings Synopsys can report on.  The full list can be found in alphabetical order in the following 8,000 page manual

https://www.wolftech.ncsu.edu/manuals/

In addition once you get the error message code you can type in "man <code>" within design compiler to get more about that error or warning.   i.e. much like the standard Unix man command.
Also if you run check_design before compile and get errors they can often be ignored.  What is more important are the errors and warnings issued just after read and errors and warnings reported by check_error AFTER compile.

Major Synthesis Issues:

Major synthesis issues include: Unintentional Latch, Timing Arcs, Wired-Or, Incomplete Sensitive Lists, No connection to Input Port(LINT-34, typically).  Note, this is not a complete list but these are the most common ones.

Some less common major issues include

-LINT-34 (related to improper use of tri-state drivers); 

-LINT-3 and LINT-58 undriven inputs (indicating a poorly structed design)

- (LINK-3) about port mismatches are usually indicating bugs in your code

- (LINT-38) multiple drivers is a wanring about "wired-or" logic

- LINT-6  "input clock and reset drives wired logic" implies you are connecting clock and/or reset to something besides flip-flop ports.  This also occurs if you are not consistent in the widths of your ports.

Minor Synthesis Issues:

-Unreachable default case

-Undeclared logic

-No reset

Ignorable Warnings:

-Output Port not connected or has no loads, e.g. LINT-2

-Warning: Design rule attributes from the driving cell will be set on 
the port. (UID-401) 
-Warning: Cell xxxx conflicts with xxxx in the target library. (OPT-106) .  This usually happens on translate.

- A similar warning is (OPT-187)  Warning: There are conflicts between cells in libraries

-Warning: Design 'hist_calc' contains 1 high-fanout nets. A fanout number of 1000 will be used for delay calculations involving these nets. (TIM-134)  (This is usually the reset net which is not in a timing path).

-Warning: /afs/bp/dist/synopsys_syn/dw/sim_ver/DW02_cos_function.inc:360: Function 'DWF_cos' with non-empty body is mapped to 'COS_TC_OP'; body will be ignored. (VER-136)

-Warning: /afs/bp/dist/synopsys_syn/dw/sim_ver/DW02_cos_function.inc:374: Function 'cos' with non-empty body is mapped to 'COS_TC_OP'; body will be ignored. (VER-136)
-Warning: Design 'counter' inherited license information from design 'DW02_cos_8_8'. (DDB-74)
-Warning: Design 'counter' is being converted to a limited design. (DDB-75)
-Warning: Current design named counter is hidden.  (UID-408)
-Warning: Verilog 'assign' or 'tran' statements are written out. (VO-4)

-Warning: signed to unsigned conversion occurs(VER_318)

- When using DesignWare, Lint 32 "pin connected to logic 0 or 1" might appear.  This is OK, if this is going to an input signal in the DW module that it is safe to tie to a logic value permanently

LINT-1, LINT-2, LINT-28, LINT-29, LINT-31, LINT-52, LINT-99 are usually OK

LINT-3 and LINT-58 can be caused also by certain cells in the cell library and desiugnware.  However, you cant assume that if you see these warnings - you still need to verify that your design is NOT causing them.

When using DesignWare, Lint 32 "pin connected to logic 0 or 1" might appear.  This is OK, if this is going to an input signal in the DW module that it is safe to tie to a logic value permanently
function draw_scale_HBM()
%%



%%
global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb tb bb scale_H promptW promptH; % rating scale
global lb1 rb1 lb2 rb2;
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors
%%
xy = [lb lb lb rb rb rb; H/2 H/2+scale_H H/2+scale_H/2 H/2+scale_H/2 H/2 H/2+scale_H];
Screen(theWindow,'DrawLines', xy, 5, 255);
Screen(theWindow,'DrawText','0',lb-10,anchor_y,255);
% Screen(theWindow,'DrawText','at all',lb-50,anchor_y2,255);
% Screen(theWindow,'DrawText','Worst',rb-50,anchor_y,255);
Screen(theWindow,'DrawText','100',rb-10,anchor_y2,255);
DrawFormattedText(theWindow, double('Level of stress'), 'center', 'center', white, [], [], [], 1.2);
end
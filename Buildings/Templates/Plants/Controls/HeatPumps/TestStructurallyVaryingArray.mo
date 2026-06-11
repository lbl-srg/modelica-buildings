within Buildings.Templates.Plants.Controls.HeatPumps;
model TestStructurallyVaryingArray
  model Component
    parameter Boolean have_input;
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1 if have_input;
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1;
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant cst(k=false) if not have_input;
  equation
    connect(u1, y1);
    connect(cst.y, y1);
  end Component;
  Component c[2](have_input={false, true});
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cst(k=true);
equation
  connect(cst.y, c[2].u1);

end TestStructurallyVaryingArray;

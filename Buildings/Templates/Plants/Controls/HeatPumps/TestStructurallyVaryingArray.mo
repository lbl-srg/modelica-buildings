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
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal extBooSig(
    nin=2,
    nout=3,
    extract={1,2,2})
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](k={true,false})
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(cst.y, c[2].u1);

  connect(con.y, extBooSig.u)
    annotation (Line(points={{-38,0},{-2,0}}, color={255,0,255}));
end TestStructurallyVaryingArray;

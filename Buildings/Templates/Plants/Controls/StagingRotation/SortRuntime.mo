within Buildings.Templates.Plants.Controls.StagingRotation;
block SortRuntime "Sort equipment by increasing staging runtime"
  parameter Integer nin=nin
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Run[nin]
    "Boolean signal used to assess equipment runtime"
    annotation (Placement(
        transformation(extent={{-200,20},{-160,60}}),  iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating runTim[nin]
    "Compute staging runtime"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdx[nin]
    "Indices of the sorted vector with respect to the original vector"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not off[nin]
    "Return true if equipment off"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Res[nin](each k=false)
    "FIXME: Add input signal for reset"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Utilities.SortWithIndices sor(final ascending=true, nin=nin)
    "Sort equipment by increasing weighted runtime"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal weiOffAva[nin](each final
            realTrue=1E10, each final realFalse=1)
    "Weight to be applied to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply appWeiOffAva[nin]
    "Apply weigths to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply appWeiUna[nin]
    "Apply weight to runtime of equipment unavailable"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nin]
    "Equipment available signal" annotation (Placement(transformation(extent={{-200,
            -60},{-160,-20}}),  iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And offAva[nin]
    "Return true if equipment off and available"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nin]
    "Return true if equipment unavailable"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal weiUna[nin](each final
      realTrue=1E20, each final realFalse=1)
    "Weight to be applied to runtime of equipment unavailable"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(u1Run, runTim.u)
    annotation (Line(points={{-180,40},{-140,40},{-140,0},{-52,0}},
                                                color={255,0,255}));
  connect(u1Run, off.u) annotation (Line(points={{-180,40},{-132,40}},
                     color={255,0,255}));
  connect(u1Res.y, runTim.reset) annotation (Line(points={{-128,-80},{-60,-80},
          {-60,-8},{-52,-8}},     color={255,0,255}));
  connect(weiOffAva.y, appWeiOffAva.u1) annotation (Line(points={{-28,40},{-20,
          40},{-20,6},{-12,6}},      color={0,0,127}));
  connect(appWeiUna.y, sor.u)
    annotation (Line(points={{52,-20},{68,-20}},   color={0,0,127}));
  connect(off.y, offAva.u1)
    annotation (Line(points={{-108,40},{-92,40}},color={255,0,255}));
  connect(u1Ava, offAva.u2) annotation (Line(points={{-180,-40},{-100,-40},{
          -100,32},{-92,32}},
                          color={255,0,255}));
  connect(offAva.y, weiOffAva.u)
    annotation (Line(points={{-68,40},{-52,40}}, color={255,0,255}));
  connect(u1Ava, una.u)
    annotation (Line(points={{-180,-40},{-92,-40}},  color={255,0,255}));
  connect(una.y, weiUna.u) annotation (Line(points={{-68,-40},{-52,-40}},
                            color={255,0,255}));
  connect(runTim.y, appWeiOffAva.u2) annotation (Line(points={{-28,0},{-20,0},{
          -20,-6},{-12,-6}},      color={0,0,127}));
  connect(appWeiOffAva.y, appWeiUna.u1) annotation (Line(points={{12,0},{20,0},
          {20,-14},{28,-14}},        color={0,0,127}));
  connect(weiUna.y, appWeiUna.u2) annotation (Line(points={{-28,-40},{20,-40},{
          20,-26},{28,-26}},    color={0,0,127}));
  connect(sor.yIdx, yIdx) annotation (Line(points={{92,-26},{120,-26},{120,0},{
          180,0}}, color={255,127,0}));
  annotation (
   defaultComponentName="sorRunTim",
 Icon(
  coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}),
  graphics={
    Line(
      points={{-90,-80.3976},{68,-80.3976}},
      color={192,192,192}),
    Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,
            160}})),
    Documentation(info="<html>
FIXME: Add input signal for staging runtime reset.
FIXME: Add timer to capture 
\"the equipment that alarmed most recently is sent to last position...
Equipment in alarm can only automatically move up on the staging order 
if another equipment goes into alarm.\"
<p>
This block implements the rotation logic for identical parallel 
staged equipment that be lead/lag alternated.
When more than one equipment is off or more than one is on,
the equipment with the most operating hours as determined by 
Staging Runtime is made the last stage equipment and the one 
with the least number of hours is made the lead stage equipment.
</p>
</html>"));
end SortRuntime;

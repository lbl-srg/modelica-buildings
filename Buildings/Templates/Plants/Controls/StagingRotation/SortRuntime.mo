within Buildings.Templates.Plants.Controls.StagingRotation;
block SortRuntime "Sort equipment by increasing staging runtime"
  parameter Integer nin=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Run[nin]
    "Boolean signal used to assess equipment runtime"
    annotation (Placement(
        transformation(extent={{-300,-20},{-260,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating runTim[nin]
    "Compute staging runtime"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdx[nin]
    "Indices of the sorted vector with respect to the original vector"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not off[nin]
    "Return true if equipment off"
    annotation (Placement(transformation(extent={{-230,-10},{-210,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Res[nin](each k=false)
    "FIXME: Add input signal for reset"
    annotation (Placement(transformation(extent={{-250,-130},{-230,-110}})));
  Utilities.SortWithIndices sor(final ascending=true, nin=nin)
    "Sort equipment by increasing weighted runtime"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal weiOffAva[nin](each final
            realTrue=1E10, each final realFalse=1)
    "Weight to be applied to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply appWeiOffAva[nin]
    "Apply weigths to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply appWeiUna[nin]
    "Apply weight to runtime of equipment unavailable"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nin]
    "Equipment available signal" annotation (Placement(transformation(extent={{-300,
            -100},{-260,-60}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And offAva[nin]
    "Return true if equipment off and available"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nin]
    "Return true if equipment unavailable"
    annotation (Placement(transformation(extent={{-190,-90},{-170,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal weiUna[nin](each final
      realTrue=1E20, each final realFalse=1)
    "Weight to be applied to runtime of equipment unavailable"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
equation
  connect(u1Run, runTim.u)
    annotation (Line(points={{-280,0},{-240,0},{-240,-40},{-152,-40}},
                                                color={255,0,255}));
  connect(u1Run, off.u) annotation (Line(points={{-280,0},{-232,0}},
                     color={255,0,255}));
  connect(u1Res.y, runTim.reset) annotation (Line(points={{-228,-120},{-160,-120},
          {-160,-48},{-152,-48}}, color={255,0,255}));
  connect(weiOffAva.y, appWeiOffAva.u1) annotation (Line(points={{-128,0},{-120,
          0},{-120,-34},{-112,-34}}, color={0,0,127}));
  connect(appWeiUna.y, sor.u)
    annotation (Line(points={{-48,-80},{-32,-80}}, color={0,0,127}));
  connect(off.y, offAva.u1)
    annotation (Line(points={{-208,0},{-192,0}}, color={255,0,255}));
  connect(u1Ava, offAva.u2) annotation (Line(points={{-280,-80},{-200,-80},{-200,
          -8},{-192,-8}}, color={255,0,255}));
  connect(offAva.y, weiOffAva.u)
    annotation (Line(points={{-168,0},{-152,0}}, color={255,0,255}));
  connect(u1Ava, una.u)
    annotation (Line(points={{-280,-80},{-192,-80}}, color={255,0,255}));
  connect(una.y, weiUna.u) annotation (Line(points={{-168,-80},{-160,-80},{-160,
          -80},{-152,-80}}, color={255,0,255}));
  connect(runTim.y, appWeiOffAva.u2) annotation (Line(points={{-128,-40},{-120,-40},
          {-120,-46},{-112,-46}}, color={0,0,127}));
  connect(appWeiOffAva.y, appWeiUna.u1) annotation (Line(points={{-88,-40},{-80,
          -40},{-80,-74},{-72,-74}}, color={0,0,127}));
  connect(weiUna.y, appWeiUna.u2) annotation (Line(points={{-128,-80},{-80,-80},
          {-80,-86},{-72,-86}}, color={0,0,127}));
  connect(sor.yIdx, yIdx) annotation (Line(points={{-8,-86},{20,-86},{20,0},{220,
          0}}, color={255,127,0}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-160},{260,160}})),
    Documentation(info="<html>
FIXME: Add logic for faulty equipment.
FIXME: Add input signal for staging runtime reset.
</html>"));
end SortRuntime;

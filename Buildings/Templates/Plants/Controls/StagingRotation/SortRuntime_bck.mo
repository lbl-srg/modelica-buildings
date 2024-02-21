within Buildings.Templates.Plants.Controls.StagingRotation;
block SortRuntime_bck "Sort equipment by increasing staging runtime"
  parameter Integer nin
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Run[nin]
    "Boolean signal used to assess equipment runtime"
    annotation (Placement(
        transformation(extent={{-216,-20},{-176,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating runTim[nin]
    "Compute staging runtime"
    annotation (Placement(transformation(extent={{-106,-50},{-86,-30}})));
  Utilities.SortWithIndices sorOff(final ascending=true, nin=nin)
    "Sort equipment off by increasing runtime"
    annotation (Placement(transformation(extent={{2,-50},{22,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdx[nin]
    "Indices of the sorted vector with respect to the original vector"
    annotation (Placement(transformation(extent={{182,-20},{222,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Utilities.CountTrue couOn(nin=nin)
    "Count number of equipment that is on"
    annotation (Placement(transformation(extent={{-112,30},{-92,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not off[nin]
    "Return true if equipment off"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Utilities.CountTrue couOff(nin=nin) "Count number of equipment that is off"
    annotation (Placement(transformation(extent={{-112,70},{-92,90}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isNOffMorOne(final t=1)
    "Return true if number of equipment off more than 1"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isNOnMorOne(final t=1)
    "Return true if number of equipment on more than 1"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Utilities.Pre yIdxPre[nin](final pre_u_start={i for i in 1:nin})
    "Left limit of sorted indices in discrete time"
    annotation (Placement(transformation(extent={{152,-70},{132,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Res[nin](each k=false)
    "FIXME: Add input signal for reset"
    annotation (Placement(transformation(extent={{-150,-70},{-130,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal[nin](each final k=
        false) "Constant"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(final
      nout=nin) "Replicate signal"
    annotation (Placement(transformation(extent={{12,70},{32,90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwiOff[nin]
    "Switch to new order for equipment off"
    annotation (Placement(transformation(extent={{112,10},{132,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(final
      nout=nin) "Replicate signal"
    annotation (Placement(transformation(extent={{12,30},{32,50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwiOn[nin]
    "Switch to new order for equipment on"
    annotation (Placement(transformation(extent={{112,-30},{132,-10}})));
  Utilities.SortWithIndices sorOn(final ascending=true, nin=nin)
    "Sort equipment on by increasing runtime"
    annotation (Placement(transformation(extent={{2,-86},{22,-66}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nin]
    annotation (Placement(transformation(extent={{-170,70},{-190,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul[nin]
    annotation (Placement(transformation(extent={{-38,-50},{-18,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxRev[nin](final k={nin +
        1 - i for i in 1:nin})
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual lesEqu[nin]
    annotation (Placement(transformation(extent={{2,130},{22,150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(final
      nout=nin)
    annotation (Placement(transformation(extent={{-60,98},{-40,118}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nin]
    annotation (Placement(transformation(extent={{48,90},{68,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nin](each final
            realTrue=1.0, each final realFalse=1E60)
    annotation (Placement(transformation(extent={{-220,-10},{-240,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1[nin]
    annotation (Placement(transformation(extent={{-38,-86},{-18,-66}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(final
      nout=nin)
    annotation (Placement(transformation(extent={{108,112},{128,132}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx[nin](final k={i for
        i in 1:nin})
    annotation (Placement(transformation(extent={{82,130},{102,150}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual lesEqu1
                                                      [nin]
    annotation (Placement(transformation(extent={{142,130},{162,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nin]
    annotation (Placement(transformation(extent={{62,-30},{82,-10}})));
equation
  connect(u1Run, runTim.u)
    annotation (Line(points={{-196,0},{-156,0},{-156,-40},{-108,-40}},
                                                color={255,0,255}));
  connect(u1Run, off.u) annotation (Line(points={{-196,0},{-156,0},{-156,80},{
          -152,80}}, color={255,0,255}));
  connect(off.y, couOff.u1)
    annotation (Line(points={{-128,80},{-114,80}},
                                                 color={255,0,255}));
  connect(u1Run, couOn.u1) annotation (Line(points={{-196,0},{-156,0},{-156,40},
          {-114,40}},
                color={255,0,255}));
  connect(couOff.y, isNOffMorOne.u)
    annotation (Line(points={{-90,80},{-62,80}}, color={255,127,0}));
  connect(yIdx, yIdxPre.u) annotation (Line(points={{202,0},{162,0},{162,-60},{
          154,-60}},
                 color={255,127,0}));
  connect(u1Res.y, runTim.reset) annotation (Line(points={{-128,-60},{-116,-60},
          {-116,-48},{-108,-48}}, color={255,0,255}));
  connect(intSwiOn.y, intSwiOff.u3) annotation (Line(points={{134,-20},{142,-20},
          {142,0},{102,0},{102,12},{110,12}},
                                           color={255,127,0}));
  connect(yIdxPre.y, intSwiOn.u3) annotation (Line(points={{130,-60},{102,-60},
          {102,-28},{110,-28}},
                             color={255,127,0}));
  connect(intSwiOff.y, yIdx) annotation (Line(points={{134,20},{162,20},{162,0},
          {202,0}}, color={255,127,0}));
  connect(couOn.y, isNOnMorOne.u)
    annotation (Line(points={{-90,40},{-62,40}}, color={255,127,0}));
  connect(off.y, booToRea.u)
    annotation (Line(points={{-128,80},{-168,80}}, color={255,0,255}));
  connect(runTim.y, mul.u2) annotation (Line(points={{-84,-40},{-72,-40},{-72,
          -46},{-40,-46}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-192,80},{-210,80},{
          -210,-34},{-40,-34}}, color={0,0,127}));
  connect(mul.y, sorOff.u)
    annotation (Line(points={{-16,-40},{0,-40}},   color={0,0,127}));
  connect(sorOff.yIdx, intSwiOff.u1) annotation (Line(points={{24,-46},{92,-46},
          {92,28},{110,28}},color={255,127,0}));
  connect(couOff.y, intScaRep.u) annotation (Line(points={{-90,80},{-80,80},{
          -80,108},{-62,108}},
                           color={255,127,0}));
  connect(intScaRep.y, lesEqu.u2) annotation (Line(points={{-38,108},{-16,108},
          {-16,132},{0,132}},  color={255,127,0}));
  connect(idxRev.y, lesEqu.u1)
    annotation (Line(points={{-38,140},{0,140}},   color={255,127,0}));
  connect(lesEqu.y, and3.u1) annotation (Line(points={{24,140},{42,140},{42,100},
          {46,100}}, color={255,0,255}));
  connect(booScaRep.y, and3.u2) annotation (Line(points={{34,80},{42,80},{42,92},
          {46,92}}, color={255,0,255}));
  connect(u1Run, booToRea1.u)
    annotation (Line(points={{-196,0},{-218,0}}, color={255,0,255}));
  connect(runTim.y, mul1.u1) annotation (Line(points={{-84,-40},{-76,-40},{-76,
          -70},{-40,-70}},
                      color={0,0,127}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{-242,0},{-248,0},{
          -248,-82},{-40,-82}},
                           color={0,0,127}));
  connect(mul1.y, sorOn.u)
    annotation (Line(points={{-16,-76},{0,-76}},   color={0,0,127}));
  connect(sorOn.yIdx, intSwiOn.u1) annotation (Line(points={{24,-82},{98,-82},{
          98,-12},{110,-12}}, color={255,127,0}));
  connect(couOn.y, intScaRep1.u)
    annotation (Line(points={{-90,40},{-90,122},{106,122}},color={255,127,0}));
  connect(idx.y, lesEqu1.u1)
    annotation (Line(points={{104,140},{140,140}},color={255,127,0}));
  connect(intScaRep1.y, lesEqu1.u2) annotation (Line(points={{130,122},{136,122},
          {136,132},{140,132}}, color={255,127,0}));
  connect(lesEqu1.y, and4.u1) annotation (Line(points={{164,140},{164,40},{50,
          40},{50,-20},{60,-20}},
                              color={255,0,255}));
  connect(booScaRep1.y, and4.u2) annotation (Line(points={{34,40},{40,40},{40,
          -28},{60,-28}},
                     color={255,0,255}));
  connect(and3.y, intSwiOff.u2) annotation (Line(points={{70,100},{102,100},{
          102,20},{110,20}},
                    color={255,0,255}));
  connect(and4.y, intSwiOn.u2)
    annotation (Line(points={{84,-20},{110,-20}},color={255,0,255}));
  connect(isNOffMorOne.y, booScaRep.u)
    annotation (Line(points={{-38,80},{10,80}}, color={255,0,255}));
  connect(isNOnMorOne.y, booScaRep1.u)
    annotation (Line(points={{-38,40},{10,40}}, color={255,0,255}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,
            100}})),
    Documentation(info="<html>
FIXME: Add logic for faulty equipment.
FIXME: Add input signal for staging runtime reset.
</html>"));
end SortRuntime_bck;

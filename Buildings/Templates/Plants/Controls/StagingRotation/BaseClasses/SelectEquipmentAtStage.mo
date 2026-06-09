within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses;
block SelectEquipmentAtStage
  parameter Integer nEqu
    "Number of equipment"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReq[nEqu](
    each final t=0.9999)
    "Return true if equipment required without lead/lag alternate"
    annotation(Placement(transformation(extent={{-68,30},{-48,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAndAva[nEqu]
    "Return true if equipment required without lead/lag alternate and available"
    annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReqOrAlt[nEqu](
    each final t=1E-4)
    "Return true if equipment required (with or without lead/lag alternate)"
    annotation(Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold notReqOrAlt[nEqu](each final t
      =0.9999)
    "Return true if equipment not required or indexed as lead/lag alternate"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isAltAndAva[nEqu](
    each final nin=3)
    "Return true if indexed as lead/lag alternate and available"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.CountTrue nReqCou(nin=nEqu)
    "Count the number of required units without lead/lag alternates, not necessarily available"
    annotation(Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uEquSta[nEqu]
    "Equipment required at current stage (row of staging matrix)"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nTotRea(nin=nEqu)
    "Return total equipment count at stage"
    annotation(Placement(transformation(extent={{-68,70},{-48,90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nTotInt
    "Total equipment count at stage as integer"
    annotation(Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nTot
    "Total equipment count at current stage"
    annotation(Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nReq
    "Number of units required excluding lead/lag alternates"
    annotation(Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nAlt
    "Number of lead/lag alternate units"
    annotation(Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract nAltCou
    "Number of lead/lag alternate units to run to meet stage requirement"
    annotation(Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ReqAndAva[nEqu]
    "True if unit is required and available (excluding lead/lag alternates)"
    annotation(Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AltAndAva[nEqu]
    "True if unit is indexed as lead/lag alternate and available"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqOrAltAndAva[nEqu]
    "Return true if equipment required with or without lead/lag alternate, and available"
    annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ReqOrAltAndAva[nEqu]
    "True if unit is required or indexed as lead/lag alternate and available"
    annotation(Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not notReqNorAlt[nEqu]
    "Return true if equipment not required (with or without lead/lag alternate)"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
equation
  connect(isReq.y, isReqAndAva.u1)
    annotation(Line(points={{-46,40},{-12,40}},
      color={255,0,255}));
  connect(u1Ava, isReqAndAva.u2)
    annotation(Line(points={{-120,-40},{-20,-40},{-20,32},{-12,32}},
      color={255,0,255}));
  connect(isReq.y, nReqCou.u1)
    annotation(Line(points={{-46,40},{-20,40},{-20,60},{18,60}},
      color={255,0,255}));
  connect(uEquSta, isReqOrAlt.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,-60},{-72,-60}},
      color={0,0,127}));
  connect(uEquSta, notReqOrAlt.u)
    annotation (Line(points={{-120,0},{-72,0}}, color={0,0,127}));
  connect(uEquSta, isReq.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,40},{-70,40}},
      color={0,0,127}));
  connect(nTotRea.y, nTotInt.u)
    annotation(Line(points={{-46,80},{-12,80}},
      color={0,0,127}));
  connect(uEquSta, nTotRea.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,80},{-70,80}},
      color={0,0,127}));
  connect(isReqOrAlt.y, isAltAndAva.u[1])
    annotation(Line(points={{-48,-60},{-40,-60},{-40,-2.33333},{-12,-2.33333}},
      color={255,0,255}));
  connect(notReqOrAlt.y, isAltAndAva.u[2])
    annotation (Line(points={{-48,0},{-12,0}}, color={255,0,255}));
  connect(u1Ava, isAltAndAva.u[3])
    annotation(Line(points={{-120,-40},{-20,-40},{-20,2.33333},{-12,2.33333}},
      color={255,0,255}));
  connect(nReqCou.y, nReq)
    annotation(Line(points={{42,60},{120,60}},
      color={255,127,0}));
  connect(nTotInt.y, nTot)
    annotation(Line(points={{12,80},{120,80}},
      color={255,127,0}));
  connect(nAltCou.y, nAlt)
    annotation(Line(points={{92,40},{120,40}},
      color={255,127,0}));
  connect(nTotInt.y, nAltCou.u1)
    annotation(Line(points={{12,80},{60,80},{60,46},{68,46}},
      color={255,127,0}));
  connect(nReqCou.y, nAltCou.u2)
    annotation(Line(points={{42,60},{50,60},{50,34},{68,34}},
      color={255,127,0}));
  connect(isReqAndAva.y, y1ReqAndAva)
    annotation(Line(points={{12,40},{20,40},{20,20},{120,20}},
      color={255,0,255}));
  connect(isAltAndAva.y, y1AltAndAva)
    annotation(Line(points={{12,0},{120,0}},
      color={255,0,255}));
  connect(isReqOrAltAndAva.y, y1ReqOrAltAndAva)
    annotation(Line(points={{12,-40},{120,-40}},
      color={255,0,255}));
  connect(isReqOrAlt.y, notReqNorAlt.u) annotation (Line(points={{-48,-60},{-40,
          -60},{-40,-80},{-12,-80}}, color={255,0,255}));
  connect(u1Ava, isReqOrAltAndAva.u1)
    annotation (Line(points={{-120,-40},{-12,-40}}, color={255,0,255}));
  connect(isReqOrAlt.y, isReqOrAltAndAva.u2) annotation (Line(points={{-48,-60},
          {-40,-60},{-40,-48},{-12,-48}}, color={255,0,255}));
annotation(defaultComponentName="selEquSta",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end SelectEquipmentAtStage;

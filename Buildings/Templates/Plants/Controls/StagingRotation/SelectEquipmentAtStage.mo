within Buildings.Templates.Plants.Controls.StagingRotation;
block SelectEquipmentAtStage
  parameter Integer nEqu
    "Number of equipment"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReq[nEqu](
    each final t=0.9999)
    "Return true if equipment required without lead/lag alternate"
    annotation(Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAndAva[nEqu]
    "Return true if equipment required without lead/lag alternate and available"
    annotation(Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReqOrAlt[nEqu](
    each final t=1E-4)
    "Return true if equipment required (with or without lead/lag alternate)"
    annotation(Placement(transformation(extent={{-72,-70},{-52,-50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isNotReqOrAlt[nEqu](
    each final t=0.9999)
    "Return true if equipment not required or required with lead/lag alternate"
    annotation(Placement(transformation(extent={{-72,-30},{-52,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isAltAndAva[nEqu](
    each final nin=3)
    "Return true if indexed as lead/lag alternate and available"
    annotation(Placement(transformation(extent={{-10,-30},{10,-10}})));
  Utilities.CountTrue nReqCou(nin=nEqu)
    "Count the number of required units without lead/lag alternates, not necessarily available"
    annotation(Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
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
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AltAndAva[nEqu]
    "True if unit is indexed as lead/lag alternate and available"
    annotation(Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqOrAltAndAva[nEqu]
    "Return true if equipment required with or without lead/lag alternate, and available"
    annotation(Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ReqOrAltAndAva[nEqu]
    "True if unit is required or indexed as lead/lag alternate and available"
    annotation(Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
equation
  connect(isReq.y, isReqAndAva.u1)
    annotation(Line(points={{-48,20},{-12,20}},
      color={255,0,255}));
  connect(u1Ava, isReqAndAva.u2)
    annotation(Line(points={{-120,-80},{-20,-80},{-20,12},{-12,12}},
      color={255,0,255}));
  connect(isReq.y, nReqCou.u1)
    annotation(Line(points={{-48,20},{-20,20},{-20,60},{18,60}},
      color={255,0,255}));
  connect(uEquSta, isReqOrAlt.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,-60},{-74,-60}},
      color={0,0,127}));
  connect(uEquSta, isNotReqOrAlt.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,-20},{-74,-20}},
      color={0,0,127}));
  connect(uEquSta, isReq.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,20},{-72,20}},
      color={0,0,127}));
  connect(nTotRea.y, nTotInt.u)
    annotation(Line(points={{-46,80},{-12,80}},
      color={0,0,127}));
  connect(uEquSta, nTotRea.u)
    annotation(Line(points={{-120,0},{-80,0},{-80,80},{-70,80}},
      color={0,0,127}));
  connect(isReqOrAlt.y, isAltAndAva.u[1])
    annotation(Line(points={{-50,-60},{-40,-60},{-40,-22.3333},{-12,-22.3333}},
      color={255,0,255}));
  connect(isNotReqOrAlt.y, isAltAndAva.u[2])
    annotation(Line(points={{-50,-20},{-12,-20}},
      color={255,0,255}));
  connect(u1Ava, isAltAndAva.u[3])
    annotation(Line(points={{-120,-80},{-20,-80},{-20,-17.6667},{-12,-17.6667}},
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
    annotation(Line(points={{12,20},{80,20},{80,0},{120,0}},
      color={255,0,255}));
  connect(isAltAndAva.y, y1AltAndAva)
    annotation(Line(points={{12,-20},{120,-20}},
      color={255,0,255}));
  connect(isReqOrAlt.y, isReqOrAltAndAva.u1)
    annotation(Line(points={{-50,-60},{-12,-60}},
      color={255,0,255}));
  connect(isReqOrAltAndAva.y, y1ReqOrAltAndAva)
    annotation(Line(points={{12,-60},{80,-60},{80,-40},{120,-40}},
      color={255,0,255}));
  connect(u1Ava, isReqOrAltAndAva.u2)
    annotation(Line(points={{-120,-80},{-20,-80},{-20,-68},{-12,-68}},
      color={255,0,255}));
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

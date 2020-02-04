within ;
model Unnamed2
  parameter Integer reset_const = 1;

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt(y_reset=reset_const)
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt1
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt(k2=-1)
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal                 intEqu
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(period=1,
      startTime=0)
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri1(period=1,
      startTime=0.5)
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=reset_const)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
      threshold=10)
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Pre preRes
    "Breaks algebraic loop for the counter and integrator reset"
    annotation (Placement(transformation(extent={{180,80},{200,100}})));
equation
  connect(onCouInt.y, addInt.u1) annotation (Line(points={{-118,150},{-110,150},
          {-110,116},{-102,116}},
                        color={255,127,0}));
  connect(onCouInt1.y, addInt.u2) annotation (Line(points={{-118,50},{-110,50},{
          -110,104},{-102,104}},
                          color={255,127,0}));
  connect(samTri.y, onCouInt.trigger)
    annotation (Line(points={{-158,150},{-142,150}},
                                                 color={255,0,255}));
  connect(samTri1.y, onCouInt1.trigger)
    annotation (Line(points={{-158,50},{-142,50}}, color={255,0,255}));
  connect(addInt.y, intEqu.u1)
    annotation (Line(points={{-78,110},{-62,110}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-78,70},{-68,70},{-68,102},
          {-62,102}}, color={255,127,0}));
  connect(maxInt.y, intGreEquThr.u)
    annotation (Line(points={{82,90},{98,90}}, color={255,127,0}));
  connect(onCouInt.y, maxInt.u1) annotation (Line(points={{-118,150},{48,150},{48,
          96},{58,96}}, color={255,127,0}));
  connect(onCouInt1.y, maxInt.u2) annotation (Line(points={{-118,50},{50,50},{50,
          84},{58,84}}, color={255,127,0}));
  connect(intGreEquThr.y, and2.u1)
    annotation (Line(points={{122,90},{138,90}}, color={255,0,255}));
  connect(intEqu.y, and2.u2) annotation (Line(points={{-38,110},{20,110},{20,44},
          {130,44},{130,82},{138,82}}, color={255,0,255}));
  connect(and2.y, preRes.u)
    annotation (Line(points={{162,90},{178,90}}, color={255,0,255}));
  connect(preRes.y, onCouInt.reset) annotation (Line(points={{202,90},{214,90},{
          214,132},{-130,132},{-130,138}}, color={255,0,255}));
  connect(preRes.y, onCouInt1.reset) annotation (Line(points={{202,90},{214,90},
          {214,30},{-130,30},{-130,38}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,0},{260,180}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,0},{260,180}})),
    uses(Buildings(version="7.0.0")),
    experiment(StopTime=30));
end Unnamed2;

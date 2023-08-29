within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block NextCoil "Find next coil to turn on"
  parameter Integer nCoi
    "Number of coils";
  CDL.Interfaces.BooleanInput                        uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-180,-120},{-140,-80}})));
  CDL.Interfaces.BooleanInput                        uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-180,-60},{-140,-20}})));
  CDL.Logical.And alrEna[nCoi] "Already enabled"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Logical.Sources.Constant con[nCoi](k=fill(true, nCoi))
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  CDL.Logical.Not notAlrEna[nCoi] "Not already enabled"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  CDL.Interfaces.BooleanInput uStaUp "Stage up signal" annotation (Placement(
        transformation(extent={{-180,20},{-140,60}}), iconTransformation(extent=
           {{-180,20},{-140,60}})));
  CDL.Logical.Not not1[nCoi] "Not available"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Interfaces.IntegerInput uNexCoi "Next coil to be enabled" annotation (
      Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-180,80},{-140,120}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nCoi)
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  CDL.Integers.Sources.Constant conInt[nCoi](k={1:nCoi})
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Integers.Equal intEqu[nCoi] "Identify index of coil that was passed over"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  CDL.Routing.BooleanScalarReplicator booScaRep(nout=nCoi)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  CDL.Logical.Latch latSkiOve[nCoi] "List of coils skipped over"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  CDL.Logical.And3 and3[nCoi]
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  CDL.Logical.Edge edg[nCoi]
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.BooleanOutput yDXCoiInt[nCoi]
    "Coil status signal used for internal staging index calculations"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{140,40},{180,80}})));
  CDL.Logical.Or orDXCoiInt[nCoi]
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Interfaces.BooleanOutput yDXCoiSkiOve[nCoi]
    "Vector of coils that have been skipped over" annotation (Placement(
        transformation(extent={{140,40},{180,80}}), iconTransformation(extent={{140,-20},
            {180,20}})));
  CDL.Interfaces.BooleanOutput yNotAva
    "Signal indicating current coil is not available" annotation (Placement(
        transformation(extent={{140,-80},{180,-40}}), iconTransformation(extent={{140,-80},
            {180,-40}})));
  CDL.Logical.Edge edg1[nCoi]
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  CDL.Logical.MultiOr mulOr(nin=2)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  connect(con.y, alrEna.u2) annotation (Line(points={{-98,-70},{-90,-70},{-90,-48},
          {-82,-48}}, color={255,0,255}));
  connect(uDXCoi, alrEna.u1)
    annotation (Line(points={{-160,-40},{-82,-40}}, color={255,0,255}));
  connect(alrEna.y, notAlrEna.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(uDXCoiAva, not1.u) annotation (Line(points={{-160,0},{-130,0},{-130,10},
          {-122,10}}, color={255,0,255}));
  connect(uNexCoi, intScaRep.u)
    annotation (Line(points={{-160,80},{-122,80}}, color={255,127,0}));
  connect(conInt.y, intEqu.u1) annotation (Line(points={{-98,110},{-90,110},{-90,
          100},{-82,100}}, color={255,127,0}));
  connect(intScaRep.y, intEqu.u2) annotation (Line(points={{-98,80},{-90,80},{-90,
          92},{-82,92}}, color={255,127,0}));
  connect(uStaUp, booScaRep.u)
    annotation (Line(points={{-160,40},{-122,40}}, color={255,0,255}));
  connect(intEqu.y, and3.u1) annotation (Line(points={{-58,100},{-50,100},{-50,48},
          {-42,48}}, color={255,0,255}));
  connect(booScaRep.y, and3.u2)
    annotation (Line(points={{-98,40},{-42,40}}, color={255,0,255}));
  connect(not1.y, and3.u3) annotation (Line(points={{-98,10},{-50,10},{-50,32},{
          -42,32}}, color={255,0,255}));
  connect(and3.y, latSkiOve.u)
    annotation (Line(points={{-18,40},{18,40}}, color={255,0,255}));
  connect(uDXCoi, edg.u) annotation (Line(points={{-160,-40},{-130,-40},{-130,-20},
          {-122,-20}}, color={255,0,255}));
  connect(edg.y, latSkiOve.clr) annotation (Line(points={{-98,-20},{-8,-20},{-8,
          34},{18,34}}, color={255,0,255}));
  connect(latSkiOve.y, orDXCoiInt.u1) annotation (Line(points={{42,40},{60,40},{
          60,0},{78,0}}, color={255,0,255}));
  connect(uDXCoi, orDXCoiInt.u2) annotation (Line(points={{-160,-40},{-88,-40},{
          -88,-8},{78,-8}}, color={255,0,255}));
  connect(orDXCoiInt.y, yDXCoiInt)
    annotation (Line(points={{102,0},{160,0}}, color={255,0,255}));
  connect(latSkiOve.y, yDXCoiSkiOve) annotation (Line(points={{42,40},{60,40},{60,
          60},{160,60}}, color={255,0,255}));
  connect(latSkiOve.y, edg1.u) annotation (Line(points={{42,40},{60,40},{60,-60},
          {68,-60}}, color={255,0,255}));
  connect(edg1.y, mulOr.u[1:nCoi]) annotation (Line(points={{92,-60},{96,-60},{
          96,-60},{98,-60}},
                       color={255,0,255}));
  connect(mulOr.y, yNotAva)
    annotation (Line(points={{122,-60},{160,-60}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},
            {140,140}}), graphics={Rectangle(
          extent={{-140,140},{140,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end NextCoil;

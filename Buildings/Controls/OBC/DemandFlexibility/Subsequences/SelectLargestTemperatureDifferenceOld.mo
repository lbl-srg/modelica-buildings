within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SelectLargestTemperatureDifferenceOld "temDifSelectionMax"
             parameter Integer nZones=3
    "Number of values to compare";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonTemDif[nZones]
    annotation (Placement(transformation(extent={{-140,16},{-100,56}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(nin=nZones)
    annotation (Placement(transformation(extent={{36,-26},{56,-6}})));
  Buildings.Controls.OBC.CDL.Reals.Less    les[nZones]
    annotation (Placement(transformation(extent={{112,22},{132,42}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=
        nZones)
    annotation (Placement(transformation(extent={{72,-26},{92,-6}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nZones]
    annotation (Placement(transformation(extent={{150,22},{170,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAcnFla[nZones]
    "action flag" annotation (Placement(transformation(extent={{190,-20},{230,
            20}}), iconTransformation(extent={{190,-20},{230,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uIgnFla[nZones]
    "ignore flag" annotation (Placement(transformation(extent={{-142,-86},{-102,
            -46}}), iconTransformation(extent={{-140,-78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nZones]
    annotation (Placement(transformation(extent={{-46,30},{-26,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nZones](k=-1000)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2[nZones]
    annotation (Placement(transformation(extent={{-12,-12},{8,8}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nZones](k=0.000001)
    annotation (Placement(transformation(extent={{-54,-92},{-34,-72}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const[nZones](k=1:1:nZones)
    annotation (Placement(transformation(extent={{-90,-92},{-70,-72}})));
equation
  connect(mulMax.y, reaScaRep.u) annotation (Line(points={{58,-16},{70,-16}},
                         color={0,0,127}));
  connect(reaScaRep.y,les. u2) annotation (Line(points={{94,-16},{102,-16},{102,
          24},{110,24}},
                     color={0,0,127}));
  connect(les.y, not1.u)
    annotation (Line(points={{134,32},{148,32}},
                                               color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{-68,80},{-56,80},{-56,48},{
          -48,48}}, color={0,0,127}));
  connect(TZonTemDif, swi.u3) annotation (Line(points={{-120,36},{-58,36},{-58,
          32},{-48,32}},              color={0,0,127}));
  connect(gai.y, add2.u2) annotation (Line(points={{-32,-82},{-14,-82},{-14,-8}},
                               color={0,0,127}));
  connect(const.y, gai.u) annotation (Line(points={{-68,-82},{-56,-82}},
                      color={0,0,127}));
  connect(swi.y, add2.u1) annotation (Line(points={{-24,40},{-14,40},{-14,4}},
                            color={0,0,127}));
  connect(add2.y, les.u1) annotation (Line(points={{10,-2},{30,-2},{30,32},{110,
          32}},                       color={0,0,127}));
  connect(add2.y, mulMax.u) annotation (Line(points={{10,-2},{24,-2},{24,-16},{
          34,-16}},  color={0,0,127}));
  connect(swi.u2, uIgnFla) annotation (Line(points={{-48,40},{-62,40},{-62,-66},
          {-122,-66}}, color={255,0,255}));
  connect(not1.y, yAcnFla) annotation (Line(points={{172,32},{184,32},{184,0},{
          210,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {190,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{190,100}},
        grid={2,2})));
end SelectLargestTemperatureDifferenceOld;

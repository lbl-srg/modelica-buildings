within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block MinTemperatureDifferenceSelection "temDifSelectionMin"
             parameter Integer nZones=3
    "Number of values to compare";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonTemDif[nZones]
    annotation (Placement(transformation(extent={{-140,16},{-100,56}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(nin=nZones)
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre[nZones]
    annotation (Placement(transformation(extent={{92,20},{112,40}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=
        nZones)
    annotation (Placement(transformation(extent={{64,-30},{84,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nZones]
    annotation (Placement(transformation(extent={{138,20},{158,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAcnFla[nZones]
    "action flag" annotation (Placement(transformation(extent={{190,-18},{230,
            22}}), iconTransformation(extent={{190,-18},{230,22}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uIgnFla[nZones]
    "ignore flag" annotation (Placement(transformation(extent={{-142,-90},{-102,
            -50}}), iconTransformation(extent={{-140,-78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nZones]
    annotation (Placement(transformation(extent={{-56,30},{-36,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nZones](k=1000)
    annotation (Placement(transformation(extent={{-88,62},{-68,82}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const[nZones](k=1:1:nZones)
    annotation (Placement(transformation(extent={{-78,-70},{-58,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nZones](k=0.000001)
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2[nZones]
    annotation (Placement(transformation(extent={{-14,-16},{6,4}})));
equation
  connect(mulMin.y, reaScaRep.u) annotation (Line(points={{54,-20},{62,-20}},
                         color={0,0,127}));
  connect(reaScaRep.y, gre.u2) annotation (Line(points={{86,-20},{90,-20},{90,
          22}},      color={0,0,127}));
  connect(gre.y, not1.u)
    annotation (Line(points={{114,30},{136,30}},
                                               color={255,0,255}));
  connect(uIgnFla, swi.u2) annotation (Line(points={{-122,-70},{-94,-70},{-94,
          40},{-58,40}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{-66,72},{-58,72},{-58,48}},
                    color={0,0,127}));
  connect(TZonTemDif, swi.u3) annotation (Line(points={{-120,36},{-62,36},{-62,
          32},{-58,32}},              color={0,0,127}));
  connect(const.y, gai.u) annotation (Line(points={{-56,-60},{-48,-60}},
                      color={0,0,127}));
  connect(gai.y, add2.u2) annotation (Line(points={{-24,-60},{-18,-60},{-18,-12},
          {-16,-12}},           color={0,0,127}));
  connect(swi.y, add2.u1) annotation (Line(points={{-34,40},{-20,40},{-20,0},{
          -16,0}},          color={0,0,127}));
  connect(add2.y, gre.u1)
    annotation (Line(points={{8,-6},{22,-6},{22,-4},{80,-4},{80,30},{90,30}},
                                                          color={0,0,127}));
  connect(add2.y, mulMin.u) annotation (Line(points={{8,-6},{22,-6},{22,-20},{
          30,-20}},            color={0,0,127}));
  connect(not1.y, yAcnFla) annotation (Line(points={{160,30},{184,30},{184,2},{
          210,2}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {190,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{190,100}},
        grid={2,2})),
    Documentation(info="<html>
hello
</html>"));
end MinTemperatureDifferenceSelection;

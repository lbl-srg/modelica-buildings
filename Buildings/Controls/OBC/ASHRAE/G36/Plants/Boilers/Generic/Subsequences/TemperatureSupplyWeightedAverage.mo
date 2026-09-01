within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences;
block TemperatureSupplyWeightedAverage
  "Calculate weighted average of boiler supply temperatures"

  parameter Integer nBoi
    "Total number of boilers";

  parameter Real boiDesFlo[nBoi](
    final min=fill(0,nBoi),
    final unit=fill("m3/s",nBoi),
    displayUnit=fill("m3/s",nBoi),
    final quantity=fill("VolumeFlowRate",nBoi),
    final start=fill(0,nBoi))
    "Vector of design flowrates for all boilers in plant";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[nBoi]
    "Boiler status vector"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatBoiSup[nBoi](
    final unit=fill("K",nBoi),
    displayUnit=fill("K",nBoi),
    final quantity=fill("ThermodynamicTemperature",nBoi))
    "Measured hot water temperature at boiler supply"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupAveWei
    "Weighted average supply temperature"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum1(
    final k=fill(1, nBoi),
    final nin=nBoi)
    "Weighted average of boiler supply temperatures"
    annotation (Placement(transformation(extent={{86,-10},{106,10}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi]
    "Boolean to Real converter"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nBoi](
    final k=boiDesFlo)
    "Vector of boiler design flowrates"
    annotation (Placement(transformation(extent={{-110,0},{-90,20}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1[nBoi]
    "Vector of design flowrates only for enabled boilers; Zero for disabled boilers"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(final k=fill(1, nBoi),
    final nin=nBoi)
    "Sum of flowrates of all enabled boilers"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nBoi)
    "Real replicator"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div[nBoi]
    "Calculate weights for average based on design flowrate"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro[nBoi]
    "Calculate weighted boiler supply temperatures"
    annotation (Placement(transformation(extent={{70,32},{90,52}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Pass non-zero divisor in case sum is zero"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

equation

  connect(uBoiSta, booToRea.u)
    annotation (Line(points={{-140,60},{-112,60}},   color={255,0,255}));

  connect(booToRea.y, pro1.u1) annotation (Line(points={{-88,60},{-82,60},{-82,46}},
                           color={0,0,127}));

  connect(con.y, pro1.u2) annotation (Line(points={{-88,10},{-82,10},{-82,34}},
                      color={0,0,127}));

  connect(reaRep.y, div.u2) annotation (Line(points={{32,-10},{36,-10},{36,34},{
          38,34}},   color={0,0,127}));

  connect(pro1.y, div.u1) annotation (Line(points={{-58,40},{28,40},{28,46},{38,
          46}},      color={0,0,127}));

  connect(div.y, pro.u1) annotation (Line(points={{62,40},{64,40},{64,48},{68,48}},
                 color={0,0,127}));

  connect(THotWatBoiSup, pro.u2) annotation (Line(points={{-140,-60},{68,-60},{68,
          36}},               color={0,0,127}));

  connect(mulSum1.u[1:nBoi], pro.y) annotation (Line(points={{84,0},{80,0},{80,28},
          {102,28},{102,42},{92,42}},
                          color={0,0,127}));

  connect(mulSum.y, addPar.u)
    annotation (Line(points={{-28,-10},{-22,-10}}, color={0,0,127}));
  connect(reaRep.u, addPar.y)
    annotation (Line(points={{8,-10},{2,-10}},   color={0,0,127}));
  connect(pro1.y, mulSum.u[1:nBoi]) annotation (Line(points={{-58,40},{-54,40},{
          -54,-10},{-52,-10}},
                           color={0,0,127}));

  connect(mulSum1.y, TSupAveWei)
    annotation (Line(points={{108,0},{140,0}}, color={0,0,127}));
annotation (
  defaultComponentName="TWeiAve",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
  graphics={
    Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-100,150},{100,110}},
      textColor={0,0,255},
      textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
Documentation(info="<html>
<p>
When there is no single temperature sensor in the primary loop and instead there
are temperature sensors at each boiler supply outlet <code>THotWatBoiSup</code>,
thios block calculates the primary loop temperature as the weighted average of
<code>THotWatBoiSup</code>, weighted by the boiler design flowrates <code>boiDesFlo</code>
of the enabled boilers <code>uBoiSta</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 3, 2025, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemperatureSupplyWeightedAverage;

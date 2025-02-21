within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.Validation;
model PlantRequests
  "Validation model for subsequence for calculating the plant requests"

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests plaReq
    "Calculate plant request"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests plaReq1(
    final have_hotWatCoi=false)
    "Calculate plant request"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests plaReq2(
    final have_chiWatCoi=false)
    "Calculate plant request"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse fanSpe(
    final width=0.8,
    final period=3600)
    "Fan speed signal"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse fanSpe1(
    final width=0.8,
    final period=3600)
    "Fan speed signal"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse fanSpe2(
    final width=0.8,
    final period=3600)
    "Fan speed signal"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supTem(
    final height=16,
    final offset=273.15 + 15,
    final duration=3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supTemSet(
    final height=6,
    final offset=273.15 + 14.5,
    final duration=3600)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp cooCoi(
    final height=-0.3,
    final offset=0.96,
    final duration=3600,
    final startTime=1000)
    "Cooling coil position"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp heaCoi(
    final height=-0.3,
    final offset=0.96,
    final duration=3600,
    final startTime=1000)
    "Heating coil position"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supTem1(
    final height=8,
    final offset=273.15 + 12,
    final duration=3600)
    "Cooling supply air temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supTemSet1(
    final height=25,
    final offset=273.15 + 20,
    final duration=3600)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooCoi1(
    final k=0)
    "Cooling coil position"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supTem3(
    final height=8,
    final offset=273.15 + 15,
    final duration=3600)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supTemSet2(
    final height=6,
    final offset=273.15 + 14.5,
    final duration=3600)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp heaCoi2(
    final height=-0.3,
    final offset=0.96,
    final duration=3600,
    final startTime=1000)
    "Heating coil position"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));

equation
  connect(supTem.y, plaReq1.TAirSup) annotation (Line(points={{-58,-40},{20,-40},
          {20,-66},{58,-66}}, color={0,0,127}));
  connect(cooCoi.y, plaReq1.uCooCoiSet) annotation (Line(points={{-58,-80},{20,-80},
          {20,-73.8},{58,-73.8}}, color={0,0,127}));
  connect(supTem1.y, plaReq.TAirSup) annotation (Line(points={{-58,80},{0,80},{0,
          64},{58,64}},   color={0,0,127}));
  connect(cooCoi1.y, plaReq.uCooCoiSet) annotation (Line(points={{-58,40},{10,40},
          {10,56.2},{58,56.2}}, color={0,0,127}));
  connect(heaCoi.y, plaReq.uHeaCoiSet) annotation (Line(points={{-58,0},{30,0},{
          30,52},{58,52}}, color={0,0,127}));
  connect(supTemSet1.y, plaReq.TAirSupSet) annotation (Line(points={{-18,60},{0,
          60},{0,60},{58,60}}, color={0,0,127}));
  connect(supTemSet.y, plaReq1.TAirSupSet) annotation (Line(points={{-18,-60},{0,
          -60},{0,-70},{58,-70}}, color={0,0,127}));
  connect(fanSpe.y, plaReq.uFan) annotation (Line(points={{32,80},{50,80},{50,
          68},{58,68}}, color={0,0,127}));
  connect(fanSpe1.y, plaReq1.uFan) annotation (Line(points={{42,-20},{52,-20},
          {52,-62},{58,-62}}, color={0,0,127}));
  connect(supTem3.y, plaReq2.TAirSup) annotation (Line(points={{-58,-120},{20,-120},
          {20,-146},{58,-146}},         color={0,0,127}));
  connect(supTemSet2.y, plaReq2.TAirSupSet) annotation (Line(points={{-18,-140},
          {0,-140},{0,-150},{58,-150}}, color={0,0,127}));
  connect(fanSpe2.y, plaReq2.uFan) annotation (Line(points={{42,-100},{52,-100},
          {52,-142},{58,-142}}, color={0,0,127}));
  connect(heaCoi2.y, plaReq2.uHeaCoiSet) annotation (Line(points={{-58,-160},{52,
          -160},{52,-158},{58,-158}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/FanCoilUnit/Subsequences/Validation/PlantRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests</a>
for fan coil units. The three instances of the controller are as follows:
</p>
<ul>
<li>
<code>plaReq</code> represents a controller instance for a system with both 
heating and cooling coils.
</li>
<li>
<code>plaReq1</code> represents a controller instance for a system with just a 
cooling coil.
</li>
<li>
<code>plaReq2</code> represents a controller instance for a system with just a 
heating coil.
</li>
</ul>
<p>
Each instance is subjected to an increasing deviation of the measured supply 
temperature <code>TAirSup</code> from the supply temperature setpoint <code>TSupSet</code>
that results in an increasing number of requests from the controllers.
</p>
</html>", revisions="<html>
<ul>
<li>
May 5,2022 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-180},{100,100}})));
end PlantRequests;

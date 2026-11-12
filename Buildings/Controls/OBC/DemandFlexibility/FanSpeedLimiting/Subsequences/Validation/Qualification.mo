within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Validation;
model Qualification "Qualification"

  Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Qualification
    qua(
    nAHU=5,
    fanSpeMin=fill(0.5, 5),
    VMin_flow=fill(0.2, 5),
    TZonMax=fill(301.15, 5),
    fanSpeHys=0.01,
    VHys_flow=0.01,
    TZonHys(displayUnit="K") = 0.5)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon[5](k={273.15 + 20,273.15 + 23,273.15 + 21,273.15
         + 29,273.15 + 24}) "Zone temperature values for Zone 1 through 5"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant V_flow2345[4](k=fill(0.42, 4))
    "Volumetric air flow for air handling unit number 2 through 5"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin                        V_flow1(
    amplitude=0.05,
    freqHz=1/43200,
    offset=0.2) "Volumetric air flow for air handling unit number 1"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fanSpe1234[4](k=fill(0.6, 4))
    "fan speed for air handling unit number 1 through 4"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin                        fanSpe5(
    amplitude=0.1,
    freqHz=1/43200,
    phase=3.1415926535898,
    offset=0.5)  "Volumetric air flow for air handling unit number 1"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(TZon.y, qua.TZon) annotation (Line(points={{-18,-70},{40,-70},{40,4},{
          58,4}}, color={0,0,127}));
  connect(V_flow2345.y, qua.V_flow[2:5]) annotation (Line(points={{-58,30},{0,30},
          {0,16.8},{58,16.8}}, color={0,0,127}));
  connect(V_flow1.y, qua.V_flow[1]) annotation (Line(points={{-58,70},{0,70},{0,
          15.2},{58,15.2}}, color={0,0,127}));
  connect(fanSpe1234.y, qua.fanSpe[1:4]) annotation (Line(points={{-58,-10},{0,-10},
          {0,10.4},{58,10.4}}, color={0,0,127}));
  connect(fanSpe5.y, qua.fanSpe[5]) annotation (Line(points={{-58,-50},{0,-50},{
          0,10.8},{58,10.8}}, color={0,0,127}));
annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/FanSpeedLimiting/Subsequences/Validation/Qualification.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Qualification\">
Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Qualification</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end Qualification;

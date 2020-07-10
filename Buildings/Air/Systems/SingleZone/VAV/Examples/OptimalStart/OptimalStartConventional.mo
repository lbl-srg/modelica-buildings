within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart;
model OptimalStartConventional
  "Example model using optimal start with a conventional controller for a single-zone system"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooHea(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15 +
        273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    y(unit="K",displayUnit="degC"))
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSetRooCoo(
    table=[0,30 + 273.15; 8*3600,24 + 273.15; 18*3600,30 + 273.15; 24*3600,30 +
        273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    y(unit="K",displayUnit="degC"))
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optSta(
    computeHeating=true,
    computeCooling=true,
    thrOptOn(displayUnit="s")) "Optimal start for heating and cooling system "
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  Modelica.Blocks.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=-6)
    "Boolean to Real"
    annotation (Placement(transformation(extent={{0,36},{20,56}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=5)
    "Boolean to Real"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(final k1=+1, final k2=+1)
    "New cooling setpoint schedule for room"
    annotation (Placement(transformation(extent={{40,34},{60,54}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(final k1=+1, final k2=+1)
    "New heating setpoint schedule for room"
    annotation (Placement(transformation(extent={{40,68},{60,88}})));
  BaseClasses.ZoneWithAHUConventional zonAHUCon1
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  BaseClasses.ZoneWithAHUConventional zonAHUCon2
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
equation
  connect(TSetHeaOn.y, optSta.TSetZonHea) annotation (Line(points={{-79,70},{-72,
          70},{-72,78},{-42,78}},   color={0,0,127}));
  connect(TSetRooHea.y[1], add4.u1) annotation (Line(points={{-18,-50},{28,-50},
          {28,84},{38,84}},  color={0,0,127}));
  connect(TSetRooCoo.y[1], add3.u2) annotation (Line(points={{-18,-80},{32,-80},
          {32,38},{38,38}},color={0,0,127}));
  connect(occSch.tNexOcc, optSta.tNexOcc) annotation (Line(points={{-79,0},{-66,
          0},{-66,62},{-42,62}},     color={0,0,127}));
  connect(booToRea.y, add3.u1) annotation (Line(points={{22,46},{32,46},{32,50},
          {38,50}},      color={0,0,127}));
  connect(TSetCooOn.y, optSta.TSetZonCoo) annotation (Line(points={{-79,30},{-70,
          30},{-70,73},{-42,73}},    color={0,0,127}));
  connect(optSta.optOn, booToRea.u) annotation (Line(points={{-18,66},{-6,66},{-6,
          46},{-2,46}},           color={255,0,255}));
  connect(add4.y, zonAHUCon1.TSetRooHea) annotation (Line(points={{62,78},{72,
          78},{72,65.2},{78,65.2}}, color={0,0,127}));
  connect(add3.y, zonAHUCon1.TSetRooCoo) annotation (Line(points={{62,44},{72,
          44},{72,55},{78,55}}, color={0,0,127}));
  connect(TSetRooHea.y[1], zonAHUCon2.TSetRooHea) annotation (Line(points={{-18,
          -50},{54,-50},{54,-54.8},{78,-54.8}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], zonAHUCon2.TSetRooCoo) annotation (Line(points={{-18,
          -80},{54,-80},{54,-65},{78,-65}}, color={0,0,127}));
  connect(zonAHUCon1.TRoo, optSta.TZon) annotation (Line(points={{102,60},{104,
          60},{104,30},{-58,30},{-58,67},{-42,67}}, color={0,0,127}));
  connect(optSta.optOn, booToRea1.u) annotation (Line(points={{-18,66},{-6,66},{
          -6,80},{-2,80}}, color={255,0,255}));
  connect(booToRea1.y, add4.u2) annotation (Line(points={{22,80},{24,80},{24,72},
          {38,72}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}}),
                    graphics={
        Rectangle(
          extent={{-108,96},{106,-18}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{40,-2},{92,-20}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start"),
        Rectangle(
          extent={{-108,-28},{106,-94}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{40,-80},{98,-96}},
          lineColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System without optimal start")}),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This model shows an example on how to use the block <a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>
with a simple HVAC system and a single-zone floor building.
</p>
</html>", revisions="<html>
<ul>
<li>
December 9, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end OptimalStartConventional;

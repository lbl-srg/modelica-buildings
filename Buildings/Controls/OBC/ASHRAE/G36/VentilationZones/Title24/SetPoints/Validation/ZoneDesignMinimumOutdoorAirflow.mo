within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.Validation;
model ZoneDesignMinimumOutdoorAirflow
  "Validates zone design outdoor airflow setpoint"

  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneDesignMinimumOutdoorAirflow
    VOutMinZonDes
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneDesignMinimumOutdoorAirflow
    VOutMinZonDes1(have_winSwi=false, have_occSen=true)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneDesignMinimumOutdoorAirflow
    VOutMinZonDes2(have_winSwi=true, have_occSen=true)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneDesignMinimumOutdoorAirflow
    VOutMinZonDes3(have_winSwi=false,
                   have_occSen=false)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  CDL.Logical.Sources.Pulse occSig(period=60) "Occupancy signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Logical.Sources.Pulse winSig(period=120, startTime=30)
    "Window open or closed signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation

  connect(winSig.y, VOutMinZonDes.uWin) annotation (Line(points={{-18,70},{0,70},
          {0,77},{18,77}}, color={255,0,255}));
  connect(winSig.y, VOutMinZonDes2.uWin) annotation (Line(points={{-18,70},{-2,
          70},{-2,-23},{18,-23}}, color={255,0,255}));
  connect(occSig.y, VOutMinZonDes2.uOcc) annotation (Line(points={{-18,30},{-6,
          30},{-6,-37},{18,-37}}, color={255,0,255}));
  connect(occSig.y, VOutMinZonDes1.uOcc) annotation (Line(points={{-18,30},{-6,
          30},{-6,23},{18,23}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/VentilationZones/Title24/SetPoints/Validation/ZoneDesignMinimumOutdoorAirflow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-80,-100},{80,100}})));
end ZoneDesignMinimumOutdoorAirflow;

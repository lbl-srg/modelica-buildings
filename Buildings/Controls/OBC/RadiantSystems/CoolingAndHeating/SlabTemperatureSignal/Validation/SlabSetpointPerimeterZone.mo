within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.Validation;
model SlabSetpointPerimeterZone
  "Validation model for slab setpoint for a perimeter zone"
  final parameter Real TOut(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=294.3
    "Outdoor air temperature";
  Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.SlabSetpointPerimeter slaSetPer
    "Slab temperature setpoint for the perimeter zone"
    annotation (Placement(transformation(extent={{-4,20},{16,40}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(table=[0,274.8166667;
        86400,274.8167222; 172800,280.3722222; 259200,280.3727778; 345600,
        285.9277778; 432000,285.9283333; 518400,291.4833333; 604800,291.4838889;
        691200,292.5944444; 777600,292.5945; 864000,293.15; 950400,293.1500556;
        1036800,295.3722222; 1123200,295.3722778; 1209600,295.9277778; 1296000,
        295.9278333; 1382400,299.8166667; 1468800,299.8172222; 1555200,
        302.5944444], extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Table"
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
equation
  connect(timTab.y[1], slaSetPer.TFor) annotation (Line(points={{-38,28},{-22,28},{
          -22,30},{-6,30}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This validates the slab setpoint for a perimeter zone based on forecast outdoor air temperature <code>TOut</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation. 
</li>
</ul>
</html>"),experiment(StartTime=0, StopTime=1641600.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/SlabTemperatureSignal/Validation/SlabSetpointPerimeterZone.mos"
        "Simulate and plot"),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SlabSetpointPerimeterZone;

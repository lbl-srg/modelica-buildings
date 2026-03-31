within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Validation;
model ZoneSetpointSource
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource
    annotation (Placement(transformation(extent={{-8,-12},{12,8}})));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource\">
Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource</a>.</p>
</html>"));
end ZoneSetpointSource;

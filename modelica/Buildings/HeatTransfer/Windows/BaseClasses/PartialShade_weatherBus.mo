within Buildings.HeatTransfer.Windows.BaseClasses;
partial model PartialShade_weatherBus
  "Partial model to implement overhang and side fins with weather bus connector"
  import Buildings;
  extends Modelica.Blocks.Interfaces.BlockIcon;

//  parameter Modelica.SIunits.Angle lat "Latitude";
//  parameter Modelica.SIunits.Angle azi
//    "Surface azimuth; 0 (South), -45 (SouthEast), 45 (SouthWest)";
  // Window dimensions
  parameter Modelica.SIunits.Length winHt "Window height"
    annotation(Dialog(tab="General",group="Window"));
  parameter Modelica.SIunits.Length winWid "Window width"
    annotation(Dialog(tab="General",group="Window"));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput incAng(quantity="Angle",
                                              unit="rad",
                                              displayUnit="rad")
    "Solar incidence angle"
    annotation (Placement(transformation(extent={{-140,-68},{-100,-28}})));

  Modelica.Blocks.Interfaces.RealOutput frc(final min=0,
                                            final max=1,
                                            final unit="1")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

// Other calculation variables
protected
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Wall solar azimuth"            annotation (Placement(transformation(extent={{0,40},{
            20,60}})));
equation
  connect(weaBus.sol.alt, walSolAzi.alt) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,54.8},{-2,54.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(walSolAzi.incAng, incAng) annotation (Line(
      points={{-2,45.2},{-20,45.2},{-20,20},{-39,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), 
Documentation(info="<html>
<p>
Partial model to implement overhang and side fin model with weather bus as a connector.
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb 25, 2012, by Michael Wetter:<br>
First implementation. 
</li>
</ul>
</html>"));
end PartialShade_weatherBus;

within Buildings.HeatTransfer.Windows.BaseClasses;
partial model ShadeInterface_weatherBus
  "Base class for models of window shade and overhangs"
  extends Modelica.Blocks.Icons.Block;

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput incAng(quantity="Angle",
                                              unit="rad",
                                              displayUnit="rad")
    "Solar incidence angle"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput HDirTilUns(
                         quantity="RadiantEnergyFluenceRate",
                         unit="W/m2")
    "Direct solar irradiation on tilted, unshaded surface"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput HDirTil(
                         quantity="RadiantEnergyFluenceRate",
                         unit="W/m2")
    "Direct solar irradiation on tilted, shaded surface"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput fraSun(final min=0,
                                               final max=1,
                                               final unit="1")
    "Fraction of the area that is unshaded"
  annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  annotation (Documentation(info="<html>
<p>
Partial model to implement overhang and side fin model with weather bus as a connector.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShadeInterface_weatherBus;

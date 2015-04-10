within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model InteriorConvection
  "Test model for the interior heat transfer due to convection"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Ramp uSha(
    duration=1,
    height=1,
    offset=0) "Control signal for shade"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.HeatTransfer.Windows.BaseClasses.InteriorConvection con(til=
        Buildings.Types.Tilt.Wall, conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    A=1)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TGla(T=295.15)
    "Glass temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TRoo(T=293.15)
    "Room air temperature"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
equation
  connect(uSha.y, con.u) annotation (Line(
      points={{-59,70},{-50,70},{-50,18},{-21,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TGla.port, con.solid) annotation (Line(
      points={{-60,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.fluid, heaFloSen.port_a) annotation (Line(
      points={{0,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFloSen.port_b, TRoo.port) annotation (Line(
      points={{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/InteriorConvection.mos"
        "Simulate and plot"),
 Documentation(info="<html>
<p>
This is a test model for the interior side convective heat transfer.
During the simulation, the shading control signal is changed, which
causes a change in the convective heat flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InteriorConvection;

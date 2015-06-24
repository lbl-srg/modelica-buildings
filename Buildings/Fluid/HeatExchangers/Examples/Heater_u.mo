within Buildings.Fluid.HeatExchangers.Examples;
model Heater_u "Example model for the heater with prescribed heat input"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater;

  HeaterCooler_u hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(fan.port_b, hea.port_a) annotation (Line(
      points={{-50,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_b, THeaOut.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conPI.y, hea.u) annotation (Line(
      points={{-39,30},{-30,30},{-30,-34},{-22,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This example illustrates how to use the heater model that takes as an
input the heat added to the medium.
</p>
<p>
The model consist of an air volume with heat loss to the ambient.
The set point of the air temperature is different between night and day.
The heater tracks the set point temperature, except for the periods in
which the air temperature is above the set point.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.Heater_T\">
Buildings.Fluid.HeatExchangers.Examples.Heater_T</a>
for a model that takes the leaving air temperature as an input.
</p>
</html>", revisions="<html>
<ul>
<li>
November 12, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/Heater_u.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-05));
end Heater_u;

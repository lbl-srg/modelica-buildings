within Buildings.Fluid.HeatExchangers.Examples;
model Heater_T
  "Example model for the heater with prescribed outlet temperature"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater;

  Buildings.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_maxCool=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_maxHeat=Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Controls.SetPoints.Table tab(table=[0,273.15 + 15; 1,273.15 + 30])
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
equation
  connect(fan.port_b, hea.port_a) annotation (Line(
      points={{-50,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_b, THeaOut.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conPI.y, tab.u) annotation (Line(
      points={{-39,30},{-32,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tab.y, hea.TSet) annotation (Line(
      points={{-9,30},{-6,30},{-6,-20},{-32,-20},{-32,-34},{-22,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This example illustrates how to use the heater model that takes as an
input the leaving fluid temperature.
</p>
<p>
The model consist of an air volume with heat loss to the ambient.
The set point of the air temperature is different between night and day.
The heater tracks the set point temperature, except for the periods in
which the air temperature is above the set point.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.Heater_u\">
Buildings.Fluid.HeatExchangers.Examples.Heater_u</a>
for a model that takes the heating power as an input.
</p>
</html>", revisions="<html>
<ul>
<li>
November 12, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/Heater_T.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-05));
end Heater_T;

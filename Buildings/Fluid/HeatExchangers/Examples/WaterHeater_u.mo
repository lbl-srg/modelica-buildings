within Buildings.Fluid.HeatExchangers.Examples;
model WaterHeater_u
  "Example model for the heater with prescribed heat input and water as the medium"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=V*1000/3600,
    Q_flow_nominal=100,
    conPI(k=10),
    vol(V=V/1000),
    mov(nominalValuesDefineDefaultPressureCurve=true));

  HeaterCooler_u hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=10*Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(hea.port_b, THeaOut.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conPI.y, hea.u) annotation (Line(
      points={{-39,30},{-30,30},{-30,-34},{-22,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mov.port_b, hea.port_a) annotation (Line(points={{-50,-40},{-35,-40},
          {-20,-40}}, color={0,127,255}));
  annotation ( Documentation(info="<html>
<p>
This example illustrates how to use the heater model that takes as an
input the heat added to the medium.
</p>
<p>
The model consist of a water volume with heat loss to the ambient.
The set point of the water temperature is different between night and day.
The heater tracks the set point temperature, except for the periods in
which the water temperature is above the set point.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WaterHeater_T\">
Buildings.Fluid.HeatExchangers.Examples.WaterHeater_T</a>
for a model that takes the leaving water temperature as an input.
</p>
</html>", revisions="<html>
<ul>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>
January 27, 2016, by Michael Wetter;<br/>
Removed algorithm specification in experiment annotation.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
March 16, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WaterHeater_u.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-6),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            120,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})));
end WaterHeater_u;

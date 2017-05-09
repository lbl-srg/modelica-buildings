within Buildings.Fluid.HeatExchangers.Examples;
model AirHeater_T
  "Example model for the heater with prescribed outlet temperature and air as the medium"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater(
    redeclare package Medium = Buildings.Media.Air,
    m_flow_nominal=V*1.2*6/3600,
    Q_flow_nominal=30*6*6,
    mov(dp_nominal=1200, nominalValuesDefineDefaultPressureCurve=true));

  Heater_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    QMax_flow=Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Controls.SetPoints.Table tab(table=[0,273.15 + 15; 1,273.15 + 30])
    "Temperature set point"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
equation
  connect(hea.port_b, THeaOut.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={0,127,255}));
  connect(conPI.y, tab.u) annotation (Line(
      points={{-39,30},{-32,30}},
      color={0,0,127}));
  connect(tab.y, hea.TSet) annotation (Line(
      points={{-9,30},{-6,30},{-6,-20},{-32,-20},{-32,-32},{-22,-32}},
      color={0,0,127}));
  connect(mov.port_b, hea.port_a) annotation (Line(points={{-50,-40},{-35,-40},
          {-20,-40}}, color={0,127,255}));
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
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.AirHeater_u\">
Buildings.Fluid.HeatExchangers.Examples.AirHeater_u</a>
for a model that takes the heating power as an input.
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
January 6, 2015, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
November 12, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/AirHeater_T.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08),
    Diagram(coordinateSystem(extent={{-100,-100},{120,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})));
end AirHeater_T;

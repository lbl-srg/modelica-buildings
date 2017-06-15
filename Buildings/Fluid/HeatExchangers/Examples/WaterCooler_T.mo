within Buildings.Fluid.HeatExchangers.Examples;
model WaterCooler_T
  "Example model for the sensible cooler with prescribed outlet temperature and water as the medium"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=V*1000/3600,
    Q_flow_nominal=1000,
    vol(V=V/1000),
    mov(nominalValuesDefineDefaultPressureCurve=true),
    TOut(y=273.15 + 22 - 5*cos(time/86400*2*Modelica.Constants.pi)));

  SensibleCooler_T coo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    QMin_flow=-Q_flow_nominal) "Cooler"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Controls.SetPoints.Table tab(table=[
    0, 273.15 + 10;
    1, 273.15 + 30])
    "Table to compute temperature set points"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
equation
  connect(coo.port_b, THeaOut.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conPI.y, tab.u) annotation (Line(
      points={{-39,30},{-32,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tab.y,coo. TSet) annotation (Line(
      points={{-9,30},{-6,30},{-6,-20},{-32,-20},{-32,-34},{-22,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mov.port_b,coo. port_a) annotation (Line(points={{-50,-40},{-35,-40},
          {-20,-40}}, color={0,127,255}));
  annotation ( Documentation(info="<html>
<p>
This example illustrates how to use the sensible cooler model that takes as an
input the leaving fluid temperature.
</p>
<p>
The model consist of a water volume with heat gain from the ambient.
The set point of the water temperature is different between night and day.
The heater tracks the set point temperature, except for the periods in
which the water temperature is above the set point.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WaterHeater_u\">
Buildings.Fluid.HeatExchangers.Examples.WaterHeater_u</a>
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
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WaterCooler_T.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-8),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,
            100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})));
end WaterCooler_T;

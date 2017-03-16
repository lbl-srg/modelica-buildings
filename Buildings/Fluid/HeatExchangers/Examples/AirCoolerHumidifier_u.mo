within Buildings.Fluid.HeatExchangers.Examples;
model AirCoolerHumidifier_u
  "Example model for the heater/cooler/humidifier with prescribed heat input and air as the medium"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater(
    redeclare package Medium = Buildings.Media.Air,
    m_flow_nominal=V*1.2*6/3600,
    Q_flow_nominal=30*6*6,
    mov(nominalValuesDefineDefaultPressureCurve=true, dp_nominal=1200));

  Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u hea(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    Q_flow_nominal=Q_flow_nominal,
    mWat_flow_nominal=m_flow_nominal*0.005,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal)
    "Heater"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Blocks.Sources.Constant humSrc(k=0.1) "Source for humidification"
    annotation (Placement(transformation(extent={{-24,20},{-4,40}})));

equation
  connect(hea.port_b, THeaOut.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={0,127,255}));
  connect(conPI.y, hea.u1) annotation (Line(
      points={{-39,30},{-30,30},{-30,-49},{-22,-49}},
      color={0,0,127}));
  connect(mov.port_b, hea.port_a) annotation (Line(points={{-50,-40},{-36,-40},
          {-20,-40}}, color={0,127,255}));
  connect(humSrc.y, hea.u) annotation (Line(points={{-3,30},{2,30},{2,6},{-28,6},
          {-28,-34},{-22,-34}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
<p>
This example illustrates how to use the heater/cooler/humidifier model that
takes as an input the heat added to the medium.
</p>
<p>
The model consist of an air volume with heat loss to the ambient.
The set point of the air temperature is different between night and day.
The heater tracks the set point temperature, except for the periods in
which the air temperature is above the set point.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.AirHeater_T\">
Buildings.Fluid.HeatExchangers.Examples.AirHeater_T</a>
for a model that takes the leaving air temperature as an input.
</p>
</html>", revisions="<html>
<ul>
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
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/AirHeater_u.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-05),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end AirCoolerHumidifier_u;

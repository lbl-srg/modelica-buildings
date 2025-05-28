within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.Validation;
model SpeedControlled
  "Test model for the enthalpy recovery wheel with a variable speed drive"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air
    "Air";
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.ASHRAE
    per(
    mSup_flow_nominal=5,
    mExh_flow_nominal=5,
    relMotEff(uSpe={0.1,0.6,0.8,1}, eta={0.3,0.8,0.9,1}),
    have_latHEX=true,
    use_defaultMotorEfficiencyCurve=false)
    "Performance record for the enthalpy wheel"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.ASHRAE
    perDefMotCur(
    mSup_flow_nominal=5,
    mExh_flow_nominal=5,
    have_latHEX=true,
    use_defaultMotorEfficiencyCurve=true)
    "Performance record for the enthalpy wheel with default motor curve"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium,
    p(displayUnit="Pa")=101325,
    T(displayUnit="K")=273.15+10,
    nPorts=2)
    "Exhaust air sink"
    annotation (Placement(transformation(extent={{-78,-50},{-58,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium,
    p(displayUnit="Pa")=101325+500,
    T(displayUnit="K")=293.15,
    nPorts=2)
    "Exhaust air source"
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15+30,
    startTime=60)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium,
    T=273.15+30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa")=101325-500,
    nPorts=2)
    "Supply air sink"
    annotation (Placement(transformation(extent={{90,20},{70,40}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium,
    T=273.15+50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa")=101325,
    nPorts=2)
    "Supply air source"
    annotation (Placement(transformation(extent={{-40,26},{-20,46}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.SpeedControlled
    wheUseDefCur(
    redeclare package Medium = Medium,
    per=per)
    "Wheel with a user-defined curve"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.SpeedControlled wheDefCur(
    redeclare package Medium = Medium,
    per=perDefMotCur)
    "Wheel with a default curve"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.Ramp wheSpe(
    height=0.3,
    duration=160,
    offset=0.7,
    startTime=200)
    "Wheel speed"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senExhTem(
    redeclare package Medium = Medium,
    m_flow_nominal=5)
    "Temperature of the exhaust air"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senSupTem(
    redeclare package Medium = Medium,
    m_flow_nominal=5)
    "Temperature of the supply air"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-59,40},{-42,40}}, color={0,0,127}));
  connect(sou_1.ports[2], wheUseDefCur.port_a1)
    annotation (Line(points={{-20,37},{-14,37},{-14,37.8},{0,37.8}},
    color={0,127,255}));
  connect(wheUseDefCur.port_a2, sou_2.ports[1])
    annotation (Line(points={{20,22},{30,22},{30,-41},{70,-41}},
    color={0,127,255}));
  connect(wheSpe.y, wheUseDefCur.uSpe)
    annotation (Line(points={{-59,0},{-10,0},{-10,30},{-2,30}},
    color={0,0,127}));
  connect(senExhTem.port_b, sin_2.ports[1])
    annotation (Line(points={{-40,-40},{-50,-40},{-50,-41},{-58,-41}},
    color={0,127,255}));
  connect(senExhTem.port_a, wheUseDefCur.port_b2)
    annotation (Line(points={{-20,-40},{-4,-40},{-4,22},{0,22}},
    color={0,127,255}));
  connect(senSupTem.port_b, sin_1.ports[2])
    annotation (Line(points={{60,30},{66,30},{66,31},{70,31}},
    color={0,127,255}));
  connect(senSupTem.port_a, wheUseDefCur.port_b1)
    annotation (Line(points={{40,30},{30,30},{30,38},{20,38}},
    color={0,127,255}));
  connect(wheDefCur.port_a1, sou_1.ports[1])
    annotation (Line(points={{0,-2.2},{-16,-2.2},{-16,35},{-20,35}},
    color={0,127,255}));
  connect(wheDefCur.port_b2, sin_2.ports[2])
    annotation (Line(points={{0,-18},{-50,-18},{-50,-39},{-58,-39}}, color={0,127,255}));
  connect(wheDefCur.port_a2, sou_2.ports[2])
    annotation (Line(points={{20,-18},{60,-18},{60,-39},{70,-39}}, color={0,127,255}));
  connect(wheDefCur.port_b1, sin_1.ports[1])
    annotation (Line(points={{20,-2},{62,-2},{62,29},{70,29}}, color={0,127,255}));
  connect(wheDefCur.uSpe, wheSpe.y)
    annotation (Line(points={{-2,-10},{-10,-10},{-10,0},{-59,0}},
                                                               color={0,0,127}));
annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/Latent/Validation/SpeedControlled.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Example for the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.SpeedControlled\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.SpeedControlled</a>.
</p>
<p>
This example considers two wheels:
<code>wheUseDefCur</code> employs a user-defined efficiency curve;
<code>wheDefCur</code> employs a default efficiency curve
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The supply air temperature <i>TSup</i> changes from <i>273.15 + 30 K</i> to
<i>273.15 + 40 K</i> during the period from 60 seconds to 120 seconds.
The exhaust air temperature remains constant.
</li>
<li>
The wheel speed <i>uSpe</i> changes from <i>0.7</i> to <i>1</i>
during the period from 200 seconds to 360 seconds.
</li>
<li>
The supply air flow rate and the exhaust air flow rate are constant.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The sensible heat exchanger effectiveness <code>epsSen</code> and the latent effectiveness
<code>epsLat</code>, keep constant before the 200 seconds.
After 200 seconds, both <code>epsSen</code> and <code>epsLat</code> increase.
</li>
<li>
The leaving supply air temperature and the leaving exhaust air temperature
follow the change of <i>TSup</i> before the 200 seconds.
After 200 seconds, the leaving supply air temperature decreases
and the leaving exhaust air temperature increases.
</li>
<li>
The power consumption of the instance <code>wheUseDefCur</code> is higher than that of the instance <code>wheDefCur</code>
when <i>uSpe</i> is less than 1.
The power consumption of those two instances are identical when <i>uSpe</i> equals <i>1</i>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;

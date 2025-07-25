within Buildings.Fluid.Dehumidifiers.Desiccant.Validation;
model BypassDampers
  "Model that demonstrates the usage of a desiccant dehumidifier model with bypass dampers"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air
    "Air";
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 - 500,
    nPorts=1)
    "Regeneration air sink"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    T(displayUnit="K") = 273.15 + 50,
    nPorts=1)
    "Regeneration air source"
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Modelica.Blocks.Sources.Ramp TProEnt(
    height=10,
    duration=600,
    offset=273.15 + 30,
    startTime=600)
    "Temperature of the process air"
    annotation (Placement(transformation(extent={{-98,-70},{-78,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 - 520,
    nPorts=1)
    "Process air sink"
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium,
    T=273.15 + 50,
    X={0.025,1 - 0.025},
    use_T_in=true,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Process air source"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BypassDampers deh(
    redeclare package Medium = Medium,
    per=perDat)
    "Dehumidifier"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.Data.EnergyPlus perDat(
    have_varSpe=false,
    mPro_flow_nominal=1,
    mReg_flow_nominal=1,
    TRegEnt_nominal(displayUnit="K"),
    TProEnt_max(displayUnit="K"),
    TProEnt_min(displayUnit="K"))
    "Performance data"
    annotation (Placement(transformation(extent={{20,72},{40,92}})));
  Modelica.Blocks.Sources.Step uBypDamPos(
    height=0.5,
    offset=0,
    startTime=600)
    "Bypass damper position signal"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Sources.BooleanPulse uRot(
    period=1200,
    startTime=300)
    "Wheel operating signal"
    annotation (Placement(transformation(extent={{-90,-16},{-70,4}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senX_w_ProEnt(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    tau=10)
    "Humidity sensor of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-34,-40},{-14,-20}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senX_w_ProLea(
    redeclare package Medium = Medium, m_flow_nominal=0.5)
    "Humidity sensor of the process air leaving the dehumidifier"
    annotation (Placement(transformation(extent={{26,-18},{46,2}})));
equation
  connect(sou_2.ports[1], deh.port_a2)
    annotation (Line(points={{40,50},{18,50},
    {18,8},{10,8}}, color={0,127,255}));
  connect(sin_2.ports[1], deh.port_b2)
    annotation (Line(points={{-40,50},{-20,50},
    {-20,8},{-10,8}}, color={0,127,255}));
  connect(TProEnt.y, sou_1.T_in)
    annotation (Line(points={{-77,-60},{-68,-60},
    {-68,-26},{-62,-26}}, color={0,0,127}));
  connect(uBypDamPos.y, deh.uBypDamPos)
    annotation (Line(points={{-69,30},{-22,30},
    {-22,0},{-12,0}}, color={0,0,127}));
  connect(uRot.y, deh.uRot)
    annotation (Line(points={{-69,-6},{-12,-6}}, color={255,0,255}));
  connect(deh.port_b1, senX_w_ProLea.port_a)
    annotation (Line(points={{10,-8},{26,-8}}, color={0,127,255}));
  connect(senX_w_ProLea.port_b, sin_1.ports[1])
    annotation (Line(points={{46,-8},
    {60,-8},{60,-40},{70,-40}}, color={0,127,255}));
  connect(sou_1.ports[1], senX_w_ProEnt.port_a)
    annotation (Line(points={{-40,-30},{-34,-30}}, color={0,127,255}));
  connect(senX_w_ProEnt.port_b, deh.port_a1)
    annotation (Line(points={{-14,-30},
    {-6,-30},{-6,-16},{-16,-16},{-16,-8},{-10,-8}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Dehumidifiers/Desiccant/Validation/BypassDampers.mos"
    "Simulate and Plot"), Documentation(revisions="<html>
<ul>
<li>
March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BypassDampers\">
Buildings.Fluid.Dehumidifiers.Desiccant.ElectricCoilBypassDampers</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The dehumidification signal <i>uRot</i> changes from
<code>false</code> to <code>true</code> and from
<code>true</code> to <code>false</code> at 300 seconds
and 900 seconds, respectively.
</li>
<li>
The bypass damper position signal, <i>uBypDamPos</i>, changes from
0 to 0.5 at 600 seconds.
</li>
<li>
The temperature of the process air entering the dehumidifier, <i>TProEnt</i>, keeps constant
until 600 seconds, and then it increases from 273.15 + 30 K to 273.15 + 40 K  at 1200 seconds.
<br>
The temperature of the regeneration air entering the dehumidifier and the humidity ratio of the
process air entering the dehumidifier are constant.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
Before 300 seconds and after 900 seconds, the humidity ratio of the process air entering the dehumidifier,
<i>X_w_ProEnt</i>, is equal to that of the process air leaving the dehumidifier, <i>X_w_ProLea</i>.
</li>
<li>
During the rest time, <i>X_w_ProEnt > X_w_ProLea</i>.
After 600 seconds, <i>X_w_ProLea</i> increases as <i>uBypDamPos</i> increases.
</li>
</ul>
</html>"));
end BypassDampers;

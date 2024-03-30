within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Validation;
model Performance
  "Validate the performance calculation for a desiccant dehumidifier"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance dehumPer(
    vPro_nominal=2,
    VPro_flow_nominal=1,
    vReg_nominal=4,
    VReg_flow_nominal=1,
    QReg_flow_nominal=50000,
    per=perDat)
    "Performance calculation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanStep onDeh(startTime=50, startValue=false)
    "Dehumidification signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.Data.Default perDat
    "Performance data"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));
  Modelica.Blocks.Sources.Ramp TProEnt(
    height=10,
    duration=100,
    offset=273.15 + 20)
    "Temperature of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Ramp X_w_ProEnt(
    height=0.005,
    duration=100,
    offset=0.02)
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Ramp TRegEnt(
    height=-10,
    duration=100,
    offset=273.15 + 80)
    "Temperature of the regeneration air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp VPro_flow(
    height=0.5,
    duration=100,
    offset=0.5)
    "Volumetric flow rate of the process air"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Gain gai(k=1.2)
    "Converts the volumetric flow rate to the mass flow rate"
    annotation (Placement(transformation(extent={{-22,-86},{-10,-74}})));
equation
  connect(onDeh.y, dehumPer.onDeh) annotation (Line(points={{-59,80},{-44,80},{
          -44,8.2},{-11,8.2}}, color={255,0,255}));
  connect(TProEnt.y, dehumPer.TProEnt) annotation (Line(points={{-59,40},{-20,
          40},{-20,4.2},{-11,4.2}}, color={0,0,127}));
  connect(TRegEnt.y, dehumPer.TRegEnt)
    annotation (Line(points={{-59,0},{-11,0}}, color={0,0,127}));
  connect(dehumPer.X_w_ProEnt, X_w_ProEnt.y) annotation (Line(points={{-11,-4},
          {-40,-4},{-40,-40},{-59,-40}}, color={0,0,127}));
  connect(VPro_flow.y, dehumPer.VPro_flow) annotation (Line(points={{-59,-80},{
          -34,-80},{-34,-8.2},{-11,-8.2}}, color={0,0,127}));
  connect(gai.u, VPro_flow.y)
    annotation (Line(points={{-23.2,-80},{-59,-80}}, color={0,0,127}));
  connect(gai.y, dehumPer.mPro_flow) annotation (Line(points={{-9.4,-80},{0,-80},
          {0,-11}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=100),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Dehumidifiers/Desiccant/BaseClasses/Validation/Performance.mos"
        "Simulate and Plot"), Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The dehumidification signal <i>onDeh</i> is changes from
<code>false</code> to <code>true</code> at 50 seconds.
</li>
<li>
The temperature of the process air entering the dehumidifier, <i>TProEnt</i>, and the
Temperature of the regeneration air entering the dehumidifier, <i>TRegEnt</i>, change from 
273 + 20 K to 273 + 30 K and 273 + 80 K to 273 + 70 K, respectively, during the period from 
0 to 100 seconds. 
During the same period, the humidity ratio of the process air entering the dehumidifier,
<i>X_w_ProEnt</i> and the volumetric flow rate of the process air, <i>VPro_flow</i>, change from
0.02 to 0.025, and 0.5 to 1 m3/s, respectively.
<br>
Default operation curve
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.Data.Default\">
Buildings.Fluid.Dehumidifiers.Desiccant.Data.Default</a> is also employed.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
Before 50 seconds, the temperature of the process air leaving the dehumidifier,
<i>TProLea</i>, is equal to <i>TProEnt</i>.
Likewise, the humidity ratio of the process air entering the dehumidifier,
<i>X_w_ProLea</i>, is equal to <i>X_w_ProEnt</i>.
</li>
<li>
<i>TProLea</i> and <i>X_w_ProEnt</i> change dramatically when the dehumidification begins at 50 seconds.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>First implementation. </li>
</ul>
</html>"));
end Performance;

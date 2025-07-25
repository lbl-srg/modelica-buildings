within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Validation;
model Performance
  "Validate the performance calculation for a desiccant dehumidifier"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Dehumidifiers.Desiccant.Data.EnergyPlus perDat(
    mReg_flow_nominal=1,
     vPro_nominal=2,
     mPro_flow_nominal=1)
    "Performance data"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance dehPer(
    per=perDat)
    "Performance calculation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanStep onDeh(
    startTime=50,
    startValue=false)
    "Dehumidification signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp TProEnt(
    height=10,
    duration=100,
    offset=273.15 + 20)
    "Temperature of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp X_w_ProEnt(
    height=0.005,
    duration=100,
    offset=0.02)
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Ramp mPro_flow(
    height=0.5,
    duration=100,
    offset=0.5)
    "Mass flow rate of the process air"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SensibleHeat senHea
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant hPro(k=2446*1000)
    "Vaporization enthalpy of water in process air"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Constant TRegEnt(k=273.15 + 60)
    "Temperature of the regeneration air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,-18},{-60,2}})));
equation
  connect(onDeh.y, dehPer.uRot) annotation (Line(points={{-59,70},{-46,70},{-46,
          8.2},{-11,8.2}}, color={255,0,255}));
  connect(TProEnt.y, dehPer.TProEnt) annotation (Line(points={{-59,30},{-40,30},
          {-40,4.2},{-11,4.2}}, color={0,0,127}));
  connect(dehPer.X_w_ProEnt, X_w_ProEnt.y) annotation (Line(points={{-11,-3.8},
          {-40,-3.8},{-40,-40},{-59,-40}}, color={0,0,127}));
  connect(mPro_flow.y, dehPer.mPro_flow) annotation (Line(points={{-59,-80},{
          -20,-80},{-20,-8.2},{-11,-8.2}}, color={0,0,127}));
  connect(senHea.mPro_flow, mPro_flow.y) annotation (Line(points={{39,4},{20,4},
          {20,30},{-34,30},{-34,-80},{-59,-80}}, color={0,0,127}));
  connect(senHea.X_w_ProEnt, X_w_ProEnt.y) annotation (Line(points={{39,0},{16,0},
          {16,24},{-28,24},{-28,-40},{-59,-40}}, color={0,0,127}));
  connect(dehPer.X_w_ProLea, senHea.X_w_ProLea)
    annotation (Line(points={{11,4},{14,4},{14,-4},{39,-4}}, color={0,0,127}));
  connect(senHea.hReg, dehPer.hReg)
    annotation (Line(points={{39,-8},{11,-8}}, color={0,0,127}));
  connect(hPro.y, senHea.hPro)
    annotation (Line(points={{1,70},{30,70},{30,8},{39,8}}, color={0,0,127}));
  connect(TRegEnt.y, dehPer.TRegEnt) annotation (Line(points={{-59,-8},{-48,-8},
          {-48,0},{-11,0}}, color={0,0,127}));
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
The dehumidification signal <i>onDeh</i> changes from
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
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.Data.EnergyPlus\">
Buildings.Fluid.Dehumidifiers.Desiccant.Data.EnergyPlus</a> is employed.
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
<i>TProLea</i> and <i>X_w_ProEnt</i> change dramatically when the dehumidification begins at 50 seconds,
and keep relatively constant afterward.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Performance;

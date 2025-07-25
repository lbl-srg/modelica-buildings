within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Validation;
model PerformanceCorrection
  "Validate the performance correction calculation for a desiccant dehumidifier"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Dehumidifiers.Desiccant.Data.EnergyPlus perDat(
    mReg_flow_nominal=1,
      vPro_nominal=2,
      mPro_flow_nominal=1)
    "Performance data"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PerformanceCorrection
     dehPerCor(per = perDat)
    "Performance calculation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp uSpe(
    height=1,
    duration=40,
    startTime=40) "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
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
  Modelica.Blocks.Sources.Ramp mPro_flow(
    height=0.5,
    duration=100,
    offset=0.5)
    "Mass flow rate of the process air"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Sources.Constant TRegEnt(k=273.15 + 60)
    "Temperature of the regeneration air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(TProEnt.y, dehPerCor.TProEnt) annotation (Line(points={{-59,40},{-28,40},
          {-28,4.2},{-11,4.2}}, color={0,0,127}));
  connect(dehPerCor.X_w_ProEnt, X_w_ProEnt.y) annotation (Line(points={{-11,-3.8},
          {-40,-3.8},{-40,-40},{-59,-40}}, color={0,0,127}));
  connect(mPro_flow.y, dehPerCor.mPro_flow) annotation (Line(points={{-59,-80},{
          -20,-80},{-20,-8.2},{-11,-8.2}}, color={0,0,127}));
  connect(uSpe.y, dehPerCor.uSpe) annotation (Line(points={{-59,80},{-16,80},{-16,
          8.2},{-11,8.2}}, color={0,0,127}));
  connect(TRegEnt.y, dehPerCor.TRegEnt)
    annotation (Line(points={{-59,0},{-11,0}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=100),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Dehumidifiers/Desiccant/BaseClasses/Validation/PerformanceCorrection.mos"
        "Simulate and Plot"), Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PerformanceCorrection\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PerformanceCorrection</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The Wheel speed ratio <i>uSpe</i> changes from
<code>0</code> to <code>1</code> from 40 seconds to 80 seconds.
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
Buildings.Fluid.Dehumidifiers.Desiccant.Data.Default</a> is employed.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
Before 40 seconds, the temperature of the process air leaving the dehumidifier,
<i>TProLea</i>, is equal to <i>TProEnt</i>.
Likewise, the humidity ratio of the process air entering the dehumidifier,
<i>X_w_ProLea</i>, is equal to <i>X_w_ProEnt</i>.
</li>
<li>
<i>TProLea</i> and <i>X_w_ProEnt</i> change dramatically when the dehumidification begins at 40 seconds,
and keep relatively constant after 80 seconds.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PerformanceCorrection;

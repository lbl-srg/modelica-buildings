within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Examples;
model ModificationFactor
   extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant const1(k=20) "Constant input signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp ramp(height=0.0792, duration=1)
    "Ramp input signal"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp ramp1(height=0.094, duration=1)
    "Ramp input signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=27.8,
    duration=1,
    offset=20) "Ramp input signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.ModificationFactor mod(
    nBeams=1,
    per(
      Q_flow_nominal=0.094*2*4200,
      mAir_flow_nominal=0.0792,
      mWat_flow_nominal=0.094,
      dT_nominal=27.8,
      dpWat_nominal=10000,
      dpAir_nominal=100)) "Modification factor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(ramp.y, mod.mAir_flow) annotation (Line(points={{-59,30},{-59,30},{-52,
          30},{-52,3},{-12,3}}, color={0,0,127}));
  connect(ramp1.y, mod.mWat_flow) annotation (Line(points={{-59,70},{-40,70},{-40,
          9},{-12,9}}, color={0,0,127}));
  connect(ramp2.y, mod.TWat) annotation (Line(points={{-59,-30},{-40,-30},{-40,-3},
          {-12,-3}}, color={0,0,127}));
  connect(const1.y, mod.TRoo) annotation (Line(points={{-59,-70},{-20,-70},{-20,
          -8.8},{-12,-8.8}}, color={0,0,127}));
  annotation (            experiment(Tolerance=1e-6, StopTime=1.0),
            __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/BaseClasses/Examples/ModificationFactor.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
This example tests the implementation of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.ModificationFactor\">
Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.ModificationFactor</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModificationFactor;

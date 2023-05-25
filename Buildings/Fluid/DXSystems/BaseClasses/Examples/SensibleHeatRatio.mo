within Buildings.Fluid.DXSystems.BaseClasses.Examples;
model SensibleHeatRatio "Test model for SensibleHeatRatio"
 extends Modelica.Icons.Example;
 package Medium =
      Buildings.Media.Air;
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.BooleanStep onOff(
    startTime=600) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Sources.Ramp hEvaIn(
    duration=600,
    startTime=2400,
    offset=60000,
    height=-10000) "Specific enthalpy of air entering the coil"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 29) "Inlet air temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Fluid.DXSystems.BaseClasses.SensibleHeatRatio shr(
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant XADP(k=0.01) "Mass fraction"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant hADP(k=35000) "Specific enthalpy"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(onOff.y, shr.on) annotation (Line(
      points={{1,60},{10,60},{10,10},{19,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(hEvaIn.y, shr.hEvaIn) annotation (Line(
      points={{-59,40},{-40,40},{-40,3.3},{19,3.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, shr.TEvaIn) annotation (Line(
      points={{-59,80},{-34,80},{-34,7.2},{19,7.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, shr.p) annotation (Line(
      points={{-59,6.10623e-16},{-20,-3.36456e-22},{-20,6.10623e-16},{19,
          6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XADP.y, shr.XADP) annotation (Line(
      points={{-59,-40},{-40,-40},{-40,-4},{19,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hADP.y, shr.hADP) annotation (Line(
      points={{-59,-80},{-34,-80},{-34,-8},{19,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/BaseClasses/Examples/SensibleHeatRatio.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates calculation of sensible heat ratio in block
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.SensibleHeatRatio\">
Buildings.Fluid.DXSystems.BaseClasses.SensibleHeatRatio</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Aug 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end SensibleHeatRatio;

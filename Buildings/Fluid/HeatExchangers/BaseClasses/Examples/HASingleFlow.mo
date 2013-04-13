within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HASingleFlow
  extends Modelica.Icons.Example;

  HASingleFlow hASingleFlow(
    UA_nominal=13,
    m_flow_nominal_w=0.063,
    A_2=1) annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.1,
    amplitude=0.063,
    offset=0.063)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=10,
    freqHz=0.1,
    offset=273.15 + 50)
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  Modelica.Blocks.Sources.Sine sine2(
    amplitude=2,
    freqHz=0.1,
    offset=3)
    annotation (Placement(transformation(extent={{-80,-44},{-60,-24}})));
equation
  connect(sine.y, hASingleFlow.m1_flow) annotation (Line(
      points={{-59,30},{-40,30},{-40,7},{-15,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, hASingleFlow.T_1) annotation (Line(
      points={{-59,-2},{-40,-2},{-40,3},{-15,3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine2.y, hASingleFlow.h_2) annotation (Line(
      points={{-59,-34},{-34,-34},{-34,-4},{-15,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HASingleFlow.mos"
        "Simulate and Plot"));
end HASingleFlow;

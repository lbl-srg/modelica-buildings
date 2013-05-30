within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HASingleFlow "Test model for HASingleFlow"
  import Buildings;
  extends Modelica.Icons.Example;

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
  Buildings.Fluid.HeatExchangers.BaseClasses.HASingleFlow hASin(
    UA_nominal=13,
    m_flow_nominal_w=0.063,
    A_2=1) annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
equation
  connect(sine.y, hASin.m1_flow) annotation (Line(
      points={{-59,30},{-28,30},{-28,11},{-13,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, hASin.T_1) annotation (Line(
      points={{-59,-2},{-28,-2},{-28,7},{-13,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine2.y, hASin.h_2) annotation (Line(
      points={{-59,-34},{-22,-34},{-22,0},{-13,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HASingleFlow.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        Test model for <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HASingleFlow\">
        Buildings.Fluid.HeatExchanger.BaseClassess.HASingleFlow</a>.
        </p>
        </html>"));
end HASingleFlow;

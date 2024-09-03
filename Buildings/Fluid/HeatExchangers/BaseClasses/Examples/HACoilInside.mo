within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HACoilInside "Test model for HACoilInside"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine sine(
    f=0.1,
    amplitude=0.063,
    offset=0.063) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=10,
    f=0.1,
    offset=273.15 + 50) "Temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HACoilInside hASin(
    hA_nominal=13*(0.5+1)/0.5,
    m_flow_nominal=0.063) "Model for convection coefficient"
                                       annotation (Placement(transformation(extent={{-12,-6},
            {8,14}})));
equation
  connect(sine1.y, hASin.T) annotation (Line(
      points={{-59,30},{-36,30},{-36,8},{-13,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, hASin.m_flow) annotation (Line(
      points={{-59,6.66134e-16},{-36,6.66134e-16},{-36,0},{-13,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HACoilInside.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=15),
        Documentation(info="<html>
        <p>
        Test model for <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HACoilInside\">
        Buildings.Fluid.HeatExchanger.BaseClassess.HACoilInside</a>.
        </p>
        </html>", revisions="<html>
<ul>
<li>
May 11, 2013, by Michael Wetter:<br/>
First version.
</li>
</ul>
</html>"));
end HACoilInside;

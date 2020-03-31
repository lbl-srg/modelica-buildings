within Buildings.Electrical.Utilities.Examples;
model TestVoltageCTRL
  "This test check the correctness of the voltage controller model"
  extends Modelica.Icons.Example;
  VoltageControl voltageControl(
  redeclare Buildings.Electrical.DC.Interfaces.Terminal_p terminal,
    redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.TwoConductor,
    V_nominal=120,
    tDelay=2) "Voltage controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  DC.Sources.VoltageSource sou "Varriable voltage source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-70,-36},{-50,-16}})));
  Modelica.Blocks.Sources.Sine cosine(
    amplitude=20,
    f=0.1,
    phase=0,
    offset=120) "Variable voltage signal"
    annotation (Placement(transformation(extent={{-94,-4},{-74,16}})));
  Modelica.Blocks.Sources.Constant Vtr_high(k=120*(1 + 0.1))
    "Voltage threshold high"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(sou.terminal, voltageControl.terminal) annotation (Line(
      points={{-40,0},{-10,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ground.p, sou.n) annotation (Line(
      points={{-60,-16},{-60,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cosine.y, sou.V_in) annotation (Line(
      points={{-73,6},{-60,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 10, 2015, by Marco Bonvini:<br/>
Revised image of the example after modification to the voltage controller
(added first order dynamics in the switch).
</li>
<li>
Oct 14, 2014, by Marco Bonvini:<br/>
Added model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows the use of the voltage controller.
</p>
<p>
The voltage controller is connected to a variable voltage source
that oscillates between <i>140</i> and <i>100</i> V. The nominal voltage is
<i>V<sub>nom</sub> = 120 </i> V. The controller has the following settings:
</p>
<ul>
<li>Nominal voltage <i>V<sub>nom</sub> = 120 </i> V,</li>
<li>Threshold <i>V<sub>tr</sub> = 0.1 (10%)</i>,</li>
<li>tdelay <i>T<sub>delay</sub> = 2 </i> s.</li>
</ul>
<p>
Therefore, when the voltage controller measures a voltage that
is 10% higher that 120 V (that is 132 V), it sets its output signal <code>y</code> to zero.
The output signal stays at zero for <i>T<sub>delay</sub></i>,
after which it expires.
Then, the controllers check again if the voltage is within the
accepted thresholds.
</p>
<p>
The image below shows how the signal becomes equal to zero when the measured
voltage exceeds the threshold.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Utilities/Examples/VoltCTRL.png\"/>
</p>
<p>
The figure shows that the signal <code>y</code> becomes zero around <i>t = 1</i> s. After
<i>T<sub>delay</sub></i> the voltage is still higher that 123 V and thus the controller waits until
<i>t = 5</i> s to change the signal to one.
</p>
</html>"),    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/Utilities/Examples/TestVoltageCTRL.mos"
        "Simulate and plot"),
    experiment(
      StopTime=10,
      Tolerance=1e-6));
end TestVoltageCTRL;

within Buildings.Obsolete.Controls.Continuous.Examples;
model PIDHysteresis "Example model for PID controller with hysteresis"
  extends Modelica.Icons.Example;

  Buildings.Obsolete.Controls.Continuous.PIDHysteresis con(
    pre_y_start=false,
    yMin=0.3,
    Ti=600,
    Td=60)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 40, y(unit="K")) "Set point"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap(C=1000000, T(start=
         313.15, fixed=true))
    annotation (Placement(transformation(extent={{38,30},{58,50}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBC
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20)
    annotation (Placement(transformation(extent={{38,60},{58,80}})));
  Modelica.Blocks.Math.Gain gain(k=2000)
    annotation (Placement(transformation(extent={{-12,20},{8,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Q_flow
    annotation (Placement(transformation(extent={{16,20},{36,40}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/86400,
    offset=273.15,
    amplitude=20,
    phase=-1.5707963267949,
    y(unit="K"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  connect(TSet.y, con.u_s) annotation (Line(
      points={{-59,30},{-42,30}},
      color={0,0,127}));
  connect(TBC.port, theCon.port_a) annotation (Line(
      points={{20,70},{38,70}},
      color={191,0,0}));
  connect(theCon.port_b, cap.port) annotation (Line(
      points={{58,70},{66,70},{66,30},{48,30}},
      color={191,0,0}));
  connect(con.y, gain.u) annotation (Line(
      points={{-19,30},{-14,30}},
      color={0,0,127}));
  connect(cap.port, temSen.port) annotation (Line(
      points={{48,30},{70,30}},
      color={191,0,0}));
  connect(temSen.T, con.u_m) annotation (Line(
      points={{90,30},{94,30},{94,6},{-30,6},{-30,18}},
      color={0,0,127}));
  connect(gain.y, Q_flow.Q_flow) annotation (Line(
      points={{9,30},{16,30}},
      color={0,0,127}));
  connect(Q_flow.port, cap.port) annotation (Line(
      points={{36,30},{48,30}},
      color={191,0,0}));
  connect(sine.y, TBC.T) annotation (Line(
      points={{-59,70},{-2,70}},
      color={0,0,127}));
 annotation (                      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/Continuous/Examples/PIDHysteresis.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
    Documentation(info="<html>
<p>
Example that demonstrates the use of the PID controller
with hysteresis. The control objective is to keep
the temperature of the energy storage <code>cap</code>
at <i>40</i>&deg;C.
The controller <code>con</code> is parameterized to
switch on if the control error is bigger than
<i>e<sub>on</sub>=1</i>.
The output of the controller remains above <i>y<sub>min</sub>=0.3</i> until the control
error is smaller than <i>e<sub>off</sub>=-1</i>, at which
time the controller outputs <i>y=0</i> until the
control error is again bigger than <i>1</i>.
The figure below shows the control error
<code>con.feeBac.y</code> and the control signal
<code>con.y</code>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/Continuous/Examples/PIDHysteresis.png\" border=\"1\" alt=\"Control error.\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end PIDHysteresis;

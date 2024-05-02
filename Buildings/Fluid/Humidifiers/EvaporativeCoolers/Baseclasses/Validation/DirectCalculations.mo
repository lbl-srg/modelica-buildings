within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Validation;
model DirectCalculations
  "Validation of the DirectCalculations block"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Area padAre = 0.6
    "Area of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length dep = 0.2
    "Depth of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length pAtm = 101325
    "Atmospheric pressure";

  parameter Modelica.Units.SI.ThermodynamicTemperature TDryBulSup_nominal = 296.15
    "Nominal supply air drybulb temperature";

  parameter Modelica.Units.SI.ThermodynamicTemperature TWetBulSup_nominal = 289.3
    "Nominal supply air wetbulb temperature";

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal = 1
    "Nominal supply air volume flowrate";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    dirEvaCoo(
    redeclare package Medium = Buildings.Media.Air,
    final padAre=padAre,
    final dep=dep)
    "Instance with time-varying volume flowrate signal"
    annotation (Placement(transformation(origin={30,50}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    dirEvaCoo1(
    redeclare package Medium = Buildings.Media.Air,
    final padAre=padAre,
    final dep=dep)
    "Instance with time-varying wetbulb temperature signal"
    annotation (Placement(transformation(origin={30,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    dirEvaCoo2(
    redeclare package Medium = Buildings.Media.Air,
    final padAre=padAre,
    final dep=dep)
    "Instance with time-varying drybulb temperature signal"
    annotation (Placement(transformation(origin={30,-50}, extent={{-10,-10},{10,10}})));

protected
  Modelica.Blocks.Sources.Constant TWetBulSupCon(
    final k=TWetBulSup_nominal)
    "Constant wet bulb temperature signal"
    annotation (Placement(transformation(origin={-80,80}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant TDryBulSupCon(
    final k=TDryBulSup_nominal)
    "Constant drybulb temperature signal"
    annotation (Placement(transformation(origin={-80,30}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Ramp TWetBulSupRam(
    final duration=60,
    final height=5,
    final offset=TWetBulSup_nominal,
    final startTime=0)
    "Ramp signal for wet-bulb temperature"
    annotation (Placement(transformation(origin={-10,20}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Ramp TDryBulSupRam(
    final duration=60,
    final height=15,
    final offset=TDryBulSup_nominal,
    final startTime=0)
    "Ramp signal for drybulb temperature"
    annotation (Placement(transformation(origin={-10,-26}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant V_flowCon(
    final k=V_flow_nominal)
    "Constant volume flowrate signal"
    annotation (Placement(transformation(origin={-80,-30}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Ramp V_flowRam(
    final duration=60,
    final height=0.5,
    final offset=V_flow_nominal,
    final startTime=0)
    "Ramp signal for volume flowrate"
    annotation (Placement(transformation(origin={-10,80}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant pCon(
    final k=pAtm)
    "Constant pressure signal"
    annotation (Placement(transformation(origin={-80,-80}, extent={{-10,-10},{10,10}})));

equation
  connect(TWetBulSupCon.y, dirEvaCoo.TWetBulIn) annotation (Line(points={{-69,80},
          {-40,80},{-40,56},{18,56}}, color={0,0,127}));
  connect(TDryBulSupCon.y, dirEvaCoo.TDryBulIn) annotation (Line(points={{-69,30},
          {-30,30},{-30,52},{18,52}}, color={0,0,127}));
  connect(V_flowRam.y, dirEvaCoo.V_flow) annotation (Line(points={{1,80},{10,80},
          {10,48},{18,48}}, color={0,0,127}));
  connect(TWetBulSupRam.y, dirEvaCoo1.TWetBulIn)
    annotation (Line(points={{1,20},{10,20},{10,6},{18,6}}, color={0,0,127}));
  connect(V_flowCon.y, dirEvaCoo1.V_flow) annotation (Line(points={{-69,-30},{-60,
          -30},{-60,-2},{18,-2}}, color={0,0,127}));
  connect(pCon.y, dirEvaCoo.p) annotation (Line(points={{-69,-80},{-50,-80},{-50,
          44},{18,44}}, color={0,0,127}));
  connect(TDryBulSupRam.y, dirEvaCoo2.TDryBulIn) annotation (Line(points={{1,-26},
          {10,-26},{10,-48},{18,-48}}, color={0,0,127}));
  connect(TWetBulSupCon.y, dirEvaCoo2.TWetBulIn) annotation (Line(points={{-69,80},
          {-40,80},{-40,-44},{18,-44}}, color={0,0,127}));
  connect(TDryBulSupCon.y, dirEvaCoo1.TDryBulIn) annotation (Line(points={{-69,30},
          {-30,30},{-30,2},{18,2}}, color={0,0,127}));
  connect(V_flowCon.y, dirEvaCoo2.V_flow) annotation (Line(points={{-69,-30},{-60,
          -30},{-60,-52},{18,-52}}, color={0,0,127}));
  connect(pCon.y, dirEvaCoo1.p) annotation (Line(points={{-69,-80},{-50,-80},{-50,
          -6},{18,-6}}, color={0,0,127}));
  connect(pCon.y, dirEvaCoo2.p) annotation (Line(points={{-69,-80},{-50,-80},{-50,
          -56},{18,-56}}, color={0,0,127}));

annotation (Documentation(info="<html>
<p>
This model implements a validation of the block
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations</a>
that applies the peformance curve to calculate the water mass flow rate of a
direct evaporative cooler.
</p>
<p>
This model considers three validation instances with:
</p>
<ul>
<li>
Time-varying inlet air dry bulb temperature <code>TDryBulIn</code>.
</li>
<li>
Time-varying inlet air wet bulb temperature <code>TWetBulIn</code>.
</li>
<li>
Time-varying inlet air volume flow rate <code>V_flow</code>.
</li>
</ul>
<p>
The pressure <code>p</code> is the atmospheric pressure for all the three validation
instances.
</p>
<p>
The plots generated by the validation scripts show that the mass of water vapour
added <code>dmWat_flow</code>, and hence the cooling rate, changes as follows.
</p>
<ul>
<li>
On plot 1, with constant values of <code>TWetBulIn</code>,
<code>TDryBulIn</code>, and <code>p</code>, an increasing <code>V_flow</code>
leads to decreasings in <code>eff</code> and <code>XiOut</code>. Since <code>V_flow</code>
is the dominant term in the equations, this leads to an increase in <code>dmWat_flow</code>.
</li>
<li>
On plot 2, with constant values of <code>TDryBulIn</code>, <code>p</code>,
and <code>V_flow</code>, an increasing <code>TWetBulIn</code> leads to an increase
in <code>XiIn</code>. Based on the performance curve, <code>TDryBulOut</code> and
<code>XiOut</code> keep constant.This results in an increase of <code>dmWat_flow</code>.
</li>
<li>
On plot 3, with constant values of <code>TWetBulIn</code>, <code>p</code>,
and <code>V_flow</code>, an increasing <code>TDryBulIn</code> leads to a decrease
in <code>XiIn</code>. Based on the performance curve, <code>TDryBulOut</code> and
<code>XiOut</code> keep constant. This results in an increase of
<code>dmWat_flow</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
Semptember 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
    StopTime=60,
    Interval=1,
      Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/Baseclasses/Validation/DirectCalculations.mos"
        "Simulate and plot"));
end DirectCalculations;

within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples.BaseClasses;
model TransformerExample
  "This example represents the basic test for a transformer model"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Voltage V_primary=12470
    "RMS Voltage on the primary side of the transformer";
  parameter Modelica.Units.SI.Voltage V_secondary=4160
    "RMS Voltage on the secondary side of the transformer";
  Sources.FixedVoltage sou(
    f=60,
    V=V_primary) "Voltage source"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  replaceable
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter
    tra "Transformer model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Loads.Resistive load(
    loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
    P_nominal=-1800e3,
    V_nominal=V_secondary,
    linearized=true)       "Load model"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Sensors.ProbeWye probe_Y_1(perUnit=false, V_nominal = V_primary)
    "Probe that measures the voltage in Y configuration, primary side"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Sensors.ProbeDelta probe_D_1(perUnit=false, V_nominal = V_primary)
    "Probe that measures the voltage in D configuration, primary side"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-50}})));
  replaceable Sensors.BaseClasses.GeneralizedProbe probe_2 constrainedby
    Sensors.BaseClasses.GeneralizedProbe(perUnit=false,
    V_nominal=V_secondary)
    "Probe that measures the voltage at the secondary side"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

equation
  connect(sou.terminal, tra.terminal_n) annotation (Line(
      points={{-50,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(probe_Y_1.term, tra.terminal_n) annotation (Line(
      points={{-30,31},{-30,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(probe_D_1.term, tra.terminal_n) annotation (Line(
      points={{-30,-31},{-30,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra.terminal_p, load.terminal) annotation (Line(
      points={{10,0},{50,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Documentation(revisions="<html>
<ul>
<li>
November 3, 2016, by Michael Wetter:<br/>
Linearized load to avoid large nonlinear system of equations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/568\">issue 568</a>.
</li>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model is the base classes used by the examples that are part of the package
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples</a>.
</p>
<p>
The model has a voltage source, a transformer and a load. The transformer
model is replaceable so that different types of transformers can easily be tested.
</p>
</html>"));
end TransformerExample;

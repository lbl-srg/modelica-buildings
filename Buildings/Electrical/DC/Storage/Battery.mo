within Buildings.Electrical.DC.Storage;
model Battery "Simple model of a battery"
  parameter Modelica.Units.SI.Efficiency etaCha(max=1) = 0.9
    "Efficiency during charging";
  parameter Modelica.Units.SI.Efficiency etaDis(max=1) = 0.9
    "Efficiency during discharging";
 parameter Real SOC_start(min=0, max=1, unit="1")=0.1 "Initial state of charge";
  parameter Modelica.Units.SI.Energy EMax(min=0, displayUnit="kW.h")
    "Maximum available charge";
  parameter Modelica.Units.SI.Voltage V_nominal
    "Nominal voltage (V_nominal >= 0)";
 Modelica.Blocks.Interfaces.RealInput P(unit="W")
    "Power stored in battery (if positive), or extracted from battery (if negative)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput SOC(min=0, max=1, unit="1")
    "State of charge"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Electrical.DC.Interfaces.Terminal_p terminal "Generalized terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  Buildings.Electrical.DC.Storage.BaseClasses.Charge cha(
    final EMax=EMax,
    final SOC_start=SOC_start,
    final etaCha=etaCha,
    final etaDis=etaDis) "Charge model"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Loads.Conductor bat(
    final mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    final V_nominal=V_nominal) "Power exchanged with battery pack"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain gain(final k=-1)
    annotation (Placement(transformation(extent={{22,10},{42,30}})));

equation
  connect(cha.SOC, SOC)    annotation (Line(
      points={{61,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cha.P, P)    annotation (Line(
      points={{38,60},{0,60},{0,108},{8.88178e-16,108}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(bat.terminal, terminal) annotation (Line(
      points={{40,0},{-100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(P, gain.u) annotation (Line(
      points={{8.88178e-16,108},{8.88178e-16,20},{20,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, bat.Pow) annotation (Line(
      points={{43,20},{68,20},{68,8.88178e-16},{60,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{-62,40},{-62,-40},{72,-40},{72,40},{-62,40}},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{58,32},{58,-30},{32,-30},{10,32},{58,32}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,32},{-12,-30},{-32,-30},{-54,32},{-34,32}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,32},{20,-30},{0,-30},{-22,32},{-2,32}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,12},{-74,-12},{-62,-12},{-62,12},{-74,12}},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-50,68},{-20,100}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Line(
          points={{-74,0},{-100,0},{-100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-150,70},{-50,20}},
          textColor={0,0,0},
          textString="+"),
        Text(
          extent={{-150,-12},{-50,-62}},
          textColor={0,0,0},
          textString="-"),
        Text(
          extent={{44,70},{100,116}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="SOC"),
        Text(
          extent={{44,154},{134,112}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Simple model of a battery.
</p>
<p>
This model takes as an input the power that should be stored in the battery (if <i>P &gt; 0</i>)
or that should be extracted from the battery.
The model uses a fictitious conductance
(see <a href=\"modelica://Buildings.Electrical.DC.Loads.Conductor\">Buildings.Electrical.DC.Loads.Conductor</a>) <i>G</i> such that
<i>P = u &nbsp; i</i> and <i>i = u &nbsp; G,</i> where
<i>u</i> is the voltage difference across the pins and
<i>i</i> is the current at the positive pin.
</p>
<p>
The output connector <code>SOC</code> is the state of charge of the battery.
This model does not enforce that the state of charge is between zero and one.
However, each time the state of charge crosses zero or one, a warning will
be written to the simulation log file.
The model also does not limit the current through the battery. The user should
provide a control so that only a reasonable amount of power is exchanged,
and that the state of charge remains between zero and one.
</p>
</html>",
        revisions="<html>
<ul>
<li>
December 6, 2021, by Michael Wetter:<br/>
Corrected wrong unit string.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2798\">issue 2798</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Removed binding of <code>P_nominal</code> as
this parameter is disabled and assigned a value
in the <code>initial equation</code> section.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
<li>
March 19, 2015, by Michael Wetter:<br/>
Removed redeclaration of phase system in <code>Terminal_n</code> and
<code>Terminal_p</code> as it is already declared to the be the same
phase system, and it is not declared to be replaceable.
This avoids a translation error in OpenModelica.
</li>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Battery;

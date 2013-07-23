within Districts.Electrical.DC.Storage;
model Battery "Simple model of a battery"
  import Districts;
 parameter Real etaCha(min=0, max=1, unit="1") = 0.9
    "Efficiency during charging";
 parameter Real etaDis(min=0, max=1, unit="1") = 0.9
    "Efficiency during discharging";
 parameter Real SOC_start=0 "Initial charge";
 parameter Modelica.SIunits.Energy EMax(min=0, displayUnit="kWh")
    "Maximum available charge";
 parameter Modelica.SIunits.Energy E_start(min=0, displayUnit="kWh")=0
    "Initial charge";
  Modelica.Blocks.Interfaces.RealInput P(unit="W")
    "Power stored in battery (if positive), or extracted from battery (if negative)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput SOC "State of charge"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Districts.Electrical.DC.Interfaces.Terminal_p
                                             terminal(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor)
    "Generalised terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  Districts.Electrical.DC.Storage.BaseClasses.Charge cha(
    EMax=EMax,
    SOC_start=SOC_start,
    etaCha=etaCha,
    etaDis=etaDis) "Charge model"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Loads.Conductor                                       bat(
    P_nominal=0,
    mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    "Power exchanged with battery pack"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(cha.SOC, SOC)    annotation (Line(
      points={{61,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cha.P, P)    annotation (Line(
      points={{38,60},{0,60},{0,108},{8.88178e-16,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P, bat.Pow) annotation (Line(
      points={{8.88178e-16,108},{8.88178e-16,20},{68,20},{68,8.88178e-16},{60,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(bat.terminal, terminal) annotation (Line(
      points={{40,0},{-100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
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
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Line(
          points={{-74,0},{-100,0},{-100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-150,70},{-50,20}},
          lineColor={0,0,255},
          textString="+"),
        Text(
          extent={{-150,-12},{-50,-62}},
          lineColor={0,0,255},
          textString="-"),
        Text(
          extent={{44,70},{100,116}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="SOC"),
        Text(
          extent={{44,154},{134,112}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Simple model of a battery.
</p>
<p>
This model takes as an input the power that should be stored in the battery (if <i>P &gt; 0</i>)
or that should be extracted from the battery.
The model computes a fictitious conductance <i>G</i> such that
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
January 8, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Battery;

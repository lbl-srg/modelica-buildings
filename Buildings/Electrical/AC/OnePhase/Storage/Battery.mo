within Buildings.Electrical.AC.OnePhase.Storage;
model Battery "Simple model of a battery"
 extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
 replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.OnePhase constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Efficiency etaCha(max=1) = 0.9
    "Efficiency during charging";
  parameter Modelica.Units.SI.Efficiency etaDis(max=1) = 0.9
    "Efficiency during discharging";
  parameter Real SOC_start(start=0.1) "Initial charge";
  parameter Modelica.Units.SI.Energy EMax(min=0, displayUnit="kW.h")
    "Maximum available charge";
  parameter Modelica.Units.SI.Voltage V_nominal(start=110)
    "Nominal voltage (V_nominal >= 0)";
  parameter Boolean linearized=false
    "If =true introduce a linearization in the load";
  parameter Buildings.Electrical.Types.InitMode initMode(
  min=Buildings.Electrical.Types.InitMode.zero_current,
  max=Buildings.Electrical.Types.InitMode.linearized) = Buildings.Electrical.Types.InitMode.zero_current
    "Initialization mode for homotopy operator"  annotation(Dialog(tab = "Initialization"));
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
  replaceable Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_p
     terminal "Generalized terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

protected
  Buildings.Electrical.DC.Storage.BaseClasses.Charge cha(
    final EMax=EMax,
    final SOC_start=SOC_start,
    final etaCha=etaCha,
    final etaDis=etaDis) "Charge model"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Resistive bat
    constrainedby Buildings.Electrical.Interfaces.Load(
    final initMode = initMode,
    final mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    final V_nominal=V_nominal,
    final linearized=linearized) "Power exchanged with battery pack"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain gain(final k=-1)
    "Gain that invert sign of the power (P<0 -> the load is consumed)"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Modelica.Blocks.Math.Gain acdc_con_dis(final k = 2 - eta_DCAC)
    "Losses when P < 0"
    annotation (Placement(transformation(extent={{-68,10},{-48,30}})));
  Buildings.Utilities.Math.Splice spl(deltax=1e-2)
    "Splice function that attributes the losses due to AC/DC conversion"
    annotation (Placement(transformation(extent={{-36,30},{-16,50}})));
  Modelica.Blocks.Math.Gain acdc_con_cha(final k=eta_DCAC) "Losses when P > 0"
    annotation (Placement(transformation(extent={{-68,50},{-48,70}})));
equation
  connect(cha.SOC, SOC)    annotation (Line(
      points={{61,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(gain.y, bat.Pow) annotation (Line(
      points={{41,20},{68,20},{68,8.88178e-16},{60,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bat.terminal, terminal) annotation (Line(
      points={{40,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(P, acdc_con_dis.u) annotation (Line(
      points={{8.88178e-16,108},{0,108},{0,80},{-80,80},{-80,20},{-70,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P, acdc_con_cha.u) annotation (Line(
      points={{8.88178e-16,108},{8.88178e-16,80},{-80,80},{-80,60},{-70,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(acdc_con_cha.y, spl.u1) annotation (Line(
      points={{-47,60},{-42,60},{-42,46},{-38,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(acdc_con_dis.y, spl.u2) annotation (Line(
      points={{-47,20},{-42,20},{-42,34},{-38,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P, spl.x) annotation (Line(
      points={{8.88178e-16,108},{8.88178e-16,80},{-80,80},{-80,40},{-38,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(spl.y, cha.P) annotation (Line(
      points={{-15,40},{20,40},{20,60},{38,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P, gain.u)
    annotation (Line(points={{0,108},{0,20},{18,20}}, color={0,0,127}));
  annotation (
defaultComponentName="bat",
 Icon(coordinateSystem(
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
          extent={{44,70},{100,116}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="SOC"),
        Text(
          extent={{44,154},{134,112}},
          textColor={0,0,0},
          textString="%name")}),
    Documentation(
info="<html>
<p>
Simple model of a battery.
</p>
<p>
This model takes as an input the power to be extracted from the AC line and
stored in the battery (if <i>P &gt; 0</i>)
or to be fed into the AC line after being extracted from the battery.
The actual power stored or extracted in the battery differs from <i>P</i> due
to AC/DC conversion losses and battery charge and discharge efficiencies.
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
April 2, 2020 by Michael Wetter:<br/>
Corrected model and improved the documentation. The previous model extracted from
the AC connector the input power <code>P</code> plus the AC/DC conversion losses, but <code>P</code>
should be the power exchanged at the AC connector. Conversion losses are now only
accounted for in the energy exchange at the battery.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1865\">issue 1865</a>.
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
September 4, 2014, by Michael Wetter:<br/>
Corrected problem, the losses due to AC/DC conversion have to
affect both during the charge and the discharge. The input P is the
power that is taken, due to conversions the actual power drain
from the battery is higher.
</li>
<li>
September 4, 2014, by Michael Wetter:<br/>
Revised model.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Battery;

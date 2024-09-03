within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACConverter "AC AC converter single phase systems"
  extends Buildings.Electrical.Icons.RefAngleConversion;
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n
      constrainedby Interfaces.Terminal_n(
      i(start = zeros(PhaseSystem_n.n),
      each stateSelect = StateSelect.prefer)),
    redeclare replaceable Interfaces.Terminal_p terminal_p
      constrainedby Interfaces.Terminal_p(
      i(start = zeros(PhaseSystem_p.n),
      each stateSelect = StateSelect.prefer)));
  parameter Real conversionFactor(min = Modelica.Constants.eps)
    "Ratio of QS rms voltage on side 2 / QS rms voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * Ptr";
  parameter Boolean ground_1 = false
    "If true, connect side 1 of converter to ground"
     annotation(Evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true
    "If true, connect side 2 of converter to ground"
    annotation(Evaluate=true, Dialog(tab = "Ground", group="side 2"));
  Modelica.Units.SI.Power LossPower[2] "Loss power";
protected
  Modelica.Units.SI.Power P_p[2]=PhaseSystem_p.phasePowers_vi(terminal_p.v,
      terminal_p.i) "Power transmitted at pin p";
  Modelica.Units.SI.Power P_n[2]=PhaseSystem_n.phasePowers_vi(terminal_n.v,
      terminal_n.i) "Power transmitted at pin n";
equation

  // Ideal transformation
  terminal_p.v = conversionFactor*terminal_n.v;

  // Power loss term
  terminal_p.i[1] = terminal_n.i[1]/conversionFactor*
    Buildings.Utilities.Math.Functions.spliceFunction(eta-2, 1/(eta-2), P_p[1], deltax=0.1);
  terminal_p.i[2] = terminal_n.i[2]/conversionFactor*
    Buildings.Utilities.Math.Functions.spliceFunction(eta-2, 1/(eta-2), P_p[1], deltax=0.1);
  LossPower = P_p + P_n;

  // The two sides have the same reference angle
  terminal_p.theta = terminal_n.theta;

  if ground_1 then
    Connections.potentialRoot(terminal_n.theta);
  end if;
  if ground_2 then
    Connections.root(terminal_p.theta);
  end if;

  annotation (
  defaultComponentName="conACAC",
 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{2,60},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-60}},
          color={0,120,120},
          smooth=Smooth.None),
        Line(
          points={{-2,60},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},{
              -2,-60}},
          color={11,193,87},
          smooth=Smooth.None),
        Text(
          extent={{-100,92},{100,60}},
          textColor={0,0,0},
          textString="%name"),
        Text(
          extent={{-100,-60},{100,-92}},
          textColor={0,0,0},
          textString="%conversionFactor"),
        Text(
          extent={{-100,-100},{100,-132}},
          textColor={0,120,120},
          textString="%eta"),
        Text(
          extent={{-132,78},{-72,38}},
          textColor={11,193,87},
          textString="1"),
        Text(
          extent={{-88,52},{-28,12}},
          textColor={11,193,87},
          textString="AC"),
        Text(
          extent={{32,52},{92,12}},
          textColor={0,120,120},
          textString="AC"),
        Text(
          extent={{70,78},{130,38}},
          textColor={0,120,120},
          textString="2")}),
    Documentation(info="<html>
<p>
This is an AC/AC converter, based on a power balance between both circuit sides.
The parameter <i>conversionFactor</i> defines the ratio between the RMS voltages
as
</p>

<p align=\"center\" style=\"font-style:italic;\">
V<sub>2</sub> = conversionFactor  V<sub>1</sub>
</p>

<p>
where <i>V<sub>1</sub></i> and <i>V<sub>2</sub></i> are the RMS voltages
at the primary and secondary sides of the transformer, i.e., the
connector N and P, respectively.
</p>

<p>
The loss of the converter is proportional to the power transmitted.
The parameter <code>eta</code> is the efficiency of the transfer.
The loss is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
P<sub>loss</sub> = (1-&eta;) P<sub>tr</sub>,
</p>
<p>
where <i>P<sub>tr</sub></i> is the power transmitted. The model is bi-directional
and the power can flow from the primary to the secondary side and vice-versa.
Furthermore, reactive power on both side are set to zero.
</p>
<h4>Note:</h4>
<p>
This model is derived from
<a href=\"modelica://Modelica.Electrical.QuasiStatic.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStatic.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 30, 2019, by Michael Wetter:<br/>
Added missing <code>replaceable</code> for the terminal.
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
June 9, 2014, by Marco Bonvini:<br/>
Revised implementation and added <code>stateSelect</code> statement to use
the current <code>i[:]</code> on the connectors as iteration variable for the
initialization problem.
</li>
<li>
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACConverter;

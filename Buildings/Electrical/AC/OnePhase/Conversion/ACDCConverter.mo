within Buildings.Electrical.AC.OnePhase.Conversion;
model ACDCConverter "AC DC converter"
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n
      constrainedby Interfaces.Terminal_n(
        i(start = zeros(PhaseSystem_n.n),
        each stateSelect = StateSelect.prefer)),
    redeclare DC.Interfaces.Terminal_p terminal_p(
        i(start = zeros(PhaseSystem_p.n),
        each stateSelect = StateSelect.prefer)));
  parameter Real conversionFactor(min = Modelica.Constants.eps)
    "Ratio of DC voltage / AC RMS voltage";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * Ptr";
  Modelica.Units.SI.Power PLoss "Loss power";
  parameter Boolean ground_AC = false "Connect AC side of converter to ground" annotation(Evaluate=true, Dialog(tab = "Ground", group="AC side"));
  parameter Boolean ground_DC = true "Connect DC side of converter to ground" annotation(Evaluate=true, Dialog(tab = "Ground", group="DC side"));
protected
  PhaseSystem_p.Current i_dc "DC current";
  PhaseSystem_p.Voltage v_dc "DC voltage";
  Modelica.Units.SI.Power P_p[2]=PhaseSystem_p.phasePowers_vi(terminal_p.v,
      terminal_p.i) "Power transmitted at pin p (secondary)";
  Modelica.Units.SI.Power P_n[2](each start=0) = PhaseSystem_n.phasePowers_vi(
    terminal_n.v, terminal_n.i) "Power transmitted at pin n (primary)";
equation
  //voltage relation
  v_p = v_n*conversionFactor;

  // Power losses
  PLoss = (1-eta)*
    Buildings.Utilities.Math.Functions.spliceFunction(P_p[1], P_n[1], i_p, deltax=0.1);
  P_n + P_p = {PLoss, 0};

  if ground_AC then
    Connections.potentialRoot(terminal_n.theta);
  end if;

  if ground_DC then
    v_dc = 0;
    Connections.root(terminal_p.theta);
  else
    i_dc = 0;
    Connections.potentialRoot(terminal_p.theta);
  end if;

  v_dc = terminal_p.v[2];
  sum(terminal_p.i) + i_dc = 0;

  annotation (
defaultComponentName="conACDC",
 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{2,60},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{36,54},{96,14}},
          textColor={0,0,255},
          textString="DC"),
        Line(
          points={{-2,60},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},{
              -2,-60}},
          color={0,120,120},
          smooth=Smooth.None),
        Text(
          extent={{-100,52},{-40,12}},
          textColor={0,120,120},
          textString="AC"),
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
          textColor={0,0,0},
          textString="%eta"),
        Line(visible = ground_DC == true,
          points={{100,-100},{100,-12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = ground_DC == true,
          points={{80,-100},{120,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = ground_DC == true,
          points={{88,-106},{112,-106}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = ground_DC == true,
          points={{94,-112},{108,-112}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = ground_AC == true,
          points={{-80,-40},{-120,-40}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(visible = ground_AC == true,
          points={{-80,-40},{-106,-14}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(visible = ground_AC == true,
          points={{-102,-16},{-114,-24},{-118,-42}},
          color={0,120,120},
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
<p>
This is an AC/DC converter, based on a power balance between both circuit sides.
The parameter <code>conversionFactor</code> defines the ratio between the RMS voltages
as
</p>

<p align=\"center\" style=\"font-style:italic;\">
V<sub>DC</sub> = conversionFactor V<sub>AC</sub>,
</p>

<p>
where <i>V<sub>DC</sub></i> is the voltage of the DC circuit and <i>V<sub>AC</sub></i>
is the RMS voltage at the primary side of the transformer.
</p>

<p>
The loss of the converter is proportional to the power transmitted.
The parameter <code>eta</code> is the efficiency of the transfer.
The loss is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
P<sub>loss</sub> = (1-&eta;) P<sub>tr</sub>
</p>
<p>
where <i>P<sub>tr</sub></i> is the power transmitted. The model is bi-directional
and the power can flow from both the primary to the secondary side and vice-versa.
Furthermore, reactive power on both side are set to <i>0</i>.
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
March 30, 2015, by Michael Wetter:<br/>
Added missing <code>each</code>.
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
January 4, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;

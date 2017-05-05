within Buildings.Electrical.DC.Conversion;
model DCDCConverter "DC DC converter"
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  parameter Modelica.SIunits.Voltage VHigh
    "DC voltage on side 1 of the transformer (primary side)";
  parameter Modelica.SIunits.Voltage VLow
    "DC voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.SIunits.Efficiency eta(max=1) "Converter efficiency";
  parameter Boolean ground_1 = true "Connect side 1 of converter to ground" annotation(Evaluate=true, Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(Evaluate=true, Dialog(tab = "Ground", group="side 2"));
  Modelica.SIunits.Power LossPower "Loss power";
protected
  parameter Real conversionFactor = VLow/VHigh
    "Ratio of high versus low voltage";
  Modelica.SIunits.Current i1,i2;
  Modelica.SIunits.Voltage v1,v2;
  Modelica.SIunits.Power P_p "Power at terminal p";
  Modelica.SIunits.Power P_n "Power at terminal n";
equation
  Connections.potentialRoot(terminal_n.theta);
  Connections.potentialRoot(terminal_p.theta);

  if not ground_1 then
    i1 = 0;
  else
    v1 = 0;
  end if;
  if not ground_2 then
    i2 = 0;
  else
    v2 = 0;
  end if;

  P_p = PhaseSystem_p.activePower(terminal_p.v, terminal_p.i);
  P_n = PhaseSystem_n.activePower(terminal_n.v, terminal_n.i);

  v1 = terminal_n.v[2];
  v2 = terminal_p.v[2];
  sum(terminal_n.i) + i1 = 0;
  sum(terminal_p.i) + i2 = 0;

  // Voltage relation
  v_p = v_n*conversionFactor;

  // OLD equations that take into account the power at the secondary
  // power balance
  // LossPower = (1-eta) * abs(P_p);
  // P_n + P_p - LossPower = 0;

  // Symmetric and linear version
  LossPower = P_p + P_n;
  if i_n >=0 then
    i_p = i_n/conversionFactor/(eta - 2);
  else
    i_n = conversionFactor*i_p/(eta - 2);
  end if;

  annotation ( Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{30,54},{90,14}},
          lineColor={0,0,255},
          textString="DC"),
        Line(
          points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},
              {-2,-100}},
          color={85,170,255},
          smooth=Smooth.None),
        Text(
          extent={{-88,54},{-28,14}},
          lineColor={85,170,255},
          textString="DC"),
        Text(
          extent={{-100,92},{100,60}},
          lineColor={0,0,0},
          textString="%name"),
        Text(
          extent={{-120,-60},{-2,-90}},
          lineColor={0,0,0},
          textString="%VHigh"),
        Text(
          extent={{-100,-100},{100,-132}},
          lineColor={0,0,255},
          textString="%eta"),
        Text(
          extent={{-132,80},{-72,40}},
          lineColor={85,170,255},
          textString="1"),
        Text(
          extent={{70,80},{130,40}},
          lineColor={0,0,255},
          textString="2"),
        Line(visible = (ground_1 == true),
          points={{-120,-100},{-80,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_1 == true),
          points={{-112,-106},{-88,-106}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_1 == true),
          points={{-106,-112},{-92,-112}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_1 == true),
          points={{-100,-100},{-100,-12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_2 == true),
          points={{100,-100},{100,-12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_2 == true),
          points={{80,-100},{120,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_2 == true),
          points={{88,-106},{112,-106}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(visible = (ground_2 == true),
          points={{94,-112},{108,-112}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{2,-60},{120,-90}},
          lineColor={0,0,0},
          textString="%VLow")}),
    Documentation(info="<html>
<p>
This is a DC/DC converter, based on a power balance between the two DC sides.
The parameter <i>conversionFactor</i> defines the ratio between the two averaged DC voltages.
The loss of the converter is proportional to the power transmitted at the second DC side.
The parameter <code>eta</code> is the efficiency of the transfer.
The loss is computed as
<p align=\"center\" style=\"font-style:italic;\">
P<sub>loss</sub> = (1-&eta;) P<sub>DC</sub>,
</p>
<p>
where <i>P<sub>DC</sub></i> is the power transmitted. This model is symmetric and the power
can be transmitted in both directions. The loss is computed depending on the direction
of the power flow.
</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2015, by Michael Wetter:<br/>
Removed redeclaration of phase system in <code>Terminal_n</code> and
<code>Terminal_p</code> as it is already declared to the be the same
phase system, and it is not declared to be replaceable.
This avoids a translation error in OpenModelica.
</li>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised model and documentation. Changed parameter sof the model,
now the user specify <code>VHigh</code> and <code>VLow</code>
instead of <code>conversionFactor</code>.
</li>
<li>
January 28, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end DCDCConverter;

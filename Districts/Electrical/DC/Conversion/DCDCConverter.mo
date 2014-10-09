within Districts.Electrical.DC.Conversion;
model DCDCConverter "DC DC converter"
  extends Districts.Electrical.Interfaces.PartialConversion(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_n
                                                           terminal_n,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_p
                                                           terminal_p);
  // fixme: add example. Consider adding a constant loss therm for

  parameter Real conversionFactor
    "Ratio of DC voltage on side 2 / DC voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * pDC2";
  parameter Boolean ground_1 = true "Connect side 1 of converter to ground" annotation(evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="side 2"));
  Modelica.SIunits.Power LossPower "Loss power";
protected
  Real i1,i2,v1,v2;
  Modelica.SIunits.Power Pow_p;
  Modelica.SIunits.Power Pow_n;
equation

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

  Pow_p = PhaseSystem_p.activePower(terminal_p.v, terminal_p.i);
  Pow_n = PhaseSystem_n.activePower(terminal_n.v, terminal_n.i);

  v1 = terminal_n.v[2];
  v2 = terminal_p.v[2];
  sum(terminal_n.i) + i1 = 0;
  sum(terminal_p.i) + i2 = 0;

  //voltage relation
  v_p = v_n*conversionFactor;

  // OLD equations that take into account the power at the secondary
  // power balance
  // LossPower = (1-eta) * abs(Pow_p);
  // Pow_n + Pow_p - LossPower = 0;

  // Symmetric and linear version
  LossPower = Pow_p + Pow_n;
  if i_n >=0 then
    i_p = i_n/conversionFactor/(eta - 2);
  else
    i_n = conversionFactor*i_p/(eta - 2);
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
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
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,0,255},
          textString="%conversionFactor"),
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
        Line(
          points={{-120,-100},{-80,-100}},
          color=DynamicSelect({0,0,255}, if ground_1 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-112,-106},{-88,-106}},
          color=DynamicSelect({0,0,255}, if ground_1 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-106,-112},{-92,-112}},
          color=DynamicSelect({0,0,255}, if ground_1 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-100,-100},{-100,-12}},
          color=DynamicSelect({0,0,255}, if ground_1 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{100,-100},{100,-12}},
          color=DynamicSelect({0,0,255}, if ground_2 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{80,-100},{120,-100}},
          color=DynamicSelect({0,0,255}, if ground_2 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{88,-106},{112,-106}},
          color=DynamicSelect({0,0,255}, if ground_2 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{94,-112},{108,-112}},
          color=DynamicSelect({0,0,255}, if ground_2 then {0,0,255} else {255,255,
              255}),
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>
This is an DC DC converter, based on a power balance between DC and DC side.
The paramater <i>conversionFactor</i> defines the ratio between the two averaged DC voltages
The loss of the converter is proportional to the power transmitted to the second DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC2</sub>|</i>,
where <i>|P<sub>DC2</sub>|</i> is the power transmitted on the second DC side.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealDCDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealDCDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end DCDCConverter;

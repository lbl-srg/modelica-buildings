within Buildings.HeatTransfer.Radiosity;
model OpaqueSurface "Model for an opaque surface"
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.RadiosityOneSurface;
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.ParametersOneSurface(
      final tauIR=1 - rhoIR - absIR, final rhoIR=1 - absIR);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port of this surface" annotation (Placement(transformation(extent={{-10,
            -108},{10,-88}}), iconTransformation(extent={{-2,-108},{18,-88}})));
protected
  final parameter Real T03(
    min=0,
    final unit="K3") = T0^3 "3rd power of temperature T0";
  final parameter Real T04(
    min=0,
    final unit="K4") = T0^4 "4th power of temperature T0";
  Real T4(
    min=1E8,
    start=293.15^4,
    nominal=1E10,
    final unit="K4") "4th power of temperature";

equation
  T4 = if linearize then 4*T03*heatPort.T - 3*T04 else heatPort.T^4;
  JOut = A*absIR*Modelica.Constants.sigma*T4 + rhoIR*JIn;
  0 = heatPort.Q_flow + JIn - JOut;

  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-34,94},{8,-94}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{18,8},{54,8},{46,14},{54,8},{48,2}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{18,8},{40,-20},{32,-20},{40,-20},{40,-12},{40,-12}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{18,0},{-18,0},{-10,-6},{-18,0},{-12,6}},
          color={127,0,0},
          smooth=Smooth.None,
          origin={18,-8},
          rotation=90),
        Line(
          points={{18,8},{40,36},{32,36},{40,36},{40,28},{40,28}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-18,0},{18,0},{10,6},{18,0},{12,-6}},
          color={127,0,0},
          smooth=Smooth.None,
          origin={18,26},
          rotation=90)}),
    defaultComponentName="sur",
    Documentation(info="<html>
Model for the emissive power of an opaque surface.
</html>", revisions="<html>
<ul>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
February 10, 2012, by Wangda Zuo:<br/>
Fixed a bug for temperature linearization.
</li>
<li>
August 18, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpaqueSurface;

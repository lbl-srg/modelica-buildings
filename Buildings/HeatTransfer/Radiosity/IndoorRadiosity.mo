within Buildings.HeatTransfer.Radiosity;
model IndoorRadiosity "Model for indoor radiosity"
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.RadiosityOneSurface;
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.ParametersOneSurface(
    final absIR=1,
    final tauIR=0,
    final rhoIR=0);
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port of this surface" annotation (Placement(transformation(extent={{-10,
            -108},{10,-88}}), iconTransformation(extent={{-2,-108},{18,-88}})));
protected
  final parameter Real T03(
    min=0,
    unit="K3") = T0^3 "3rd power of temperature T0" annotation (Evaluate=true);
  final parameter Real T04(
    min=0,
    unit="K4") = T0^4 "4th power of temperature T0" annotation (Evaluate=true);
  Real T4(
    min=1E8,
    start=293.15^4,
    nominal=1E10,
    unit="K4") "4th power of temperature";
equation
  T4 = if linearize then 4*T03*heatPort.T - 3*T04 else heatPort.T^4;
  JOut = -A*Modelica.Constants.sigma*T4;
  0 = heatPort.Q_flow + JIn + JOut;
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-80,80},{-60,-80}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{50,0},{86,0},{78,6},{86,0},{80,-6}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{50,0},{72,-28},{64,-28},{72,-28},{72,-20},{72,-20}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{18,0},{-18,0},{-10,-6},{-18,0},{-12,6}},
          color={127,0,0},
          smooth=Smooth.None,
          origin={50,-16},
          rotation=90),
        Line(
          points={{50,0},{72,28},{64,28},{72,28},{72,20},{72,20}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-18,0},{18,0},{10,6},{18,0},{12,-6}},
          color={127,0,0},
          smooth=Smooth.None,
          origin={50,18},
          rotation=90),
        Rectangle(
          extent={{52,-60},{-60,-80}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{48,80},{-60,60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    defaultComponentName="radInd",
    Documentation(info="<html>
Model for the indoor emissive power that hits a window.
The computation is according to TARCOG 2006.

<h4>References</h4>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</html>", revisions="<html>
<ul>
<li>
February 10, 2012, by Wangda Zuo:<br/>
Fixed a bug for temperature linearization.
</li>
<li>
November 3, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end IndoorRadiosity;

within Districts.Electrical.QuasiStationary.SinglePhase.Loads;
model VariableResistor "Model of a variable resistive load"
extends Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort;

  Modelica.Blocks.Interfaces.RealInput P(unit="W", min=0)
    "Dissipated electrical power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,60})));

protected
  Modelica.SIunits.Resistance R(start=1) "Resistance";

equation
  P = Modelica.ComplexMath.real(v*Modelica.ComplexMath.conj(i));
  v = R*i;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Text(
          extent={{14,140},{104,98}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{26,44},{46,72}},
          lineColor={0,0,255},
          textString="P"),
          Rectangle(
            extent={{-70,30},{70,-30}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={0,2},
          rotation=180),
          Line(points={{-10,0},{10,0}},  color={0,0,0},
          origin={80,0},
          rotation=180),
          Line(points={{-10,0},{10,0}},color={0,0,0},
          origin={-80,0},
          rotation=180),
        Line(
          points={{0,40},{0,32}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash)}),
          Documentation(info="<html>
<p>
Model of a resistive load that takes as an input the dissipated power.
It may be used to model a load that has a power factor of one.
The input power <i>P</i> must be positive for a resistor.
</p>
<p>
The model computes the power as
<i>P = real(v &sdot; i<sup>*</sup>)</i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
Complex voltage and complex current are related as <i>v = R &nbsp; i</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end VariableResistor;

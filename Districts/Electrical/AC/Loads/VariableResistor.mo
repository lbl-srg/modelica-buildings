within Districts.Electrical.AC.Loads;
model VariableResistor "Model of a variable resistive load"
  extends Districts.Electrical.AC.Loads.BaseClasses.SingleOnePhaseModel;

  Modelica.Blocks.Interfaces.RealInput P(unit="W", min=0)
    "Dissipated electrical power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));

protected
  Modelica.SIunits.Resistance R(start=1) "Resistance";

equation
  P = Modelica.ComplexMath.real(v*Modelica.ComplexMath.conj(i));
  v = R*i;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Text(
          extent={{-120,100},{120,60}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{90,22},{110,50}},
          lineColor={0,0,255},
          textString="P"),
          Rectangle(
            extent={{-80,40},{80,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={0,3.55271e-15},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{12,1.46953e-15}},
                                       color={0,0,0},
          origin={-80,0},
          rotation=180)}),
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

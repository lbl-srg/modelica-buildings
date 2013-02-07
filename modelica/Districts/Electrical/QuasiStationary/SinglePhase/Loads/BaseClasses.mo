within Districts.Electrical.QuasiStationary.SinglePhase.Loads;
package BaseClasses "Package with base classes for load models"
  extends Modelica.Icons.BasesPackage;
  model InductorResistor "Model of an inductive and resistive load"
  extends Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort(
      v(re(start=1), im(start=1)));

    parameter Modelica.SIunits.Power P_nominal(min=0)
      "Nominal power (P_nominal >= 0)";
    parameter Real pf(min=0, max=1) = 0.8 "Power factor";

    Modelica.SIunits.ComplexPower S "Complex power into the component";
    Modelica.SIunits.Angle phi "Phase shift";
  protected
    constant Boolean lagging = true
      "Set to true for inductive loads (motor, transformer), or false otherwise";

  equation
    phi = Districts.Electrical.QuasiStationary.SinglePhase.BaseClasses.powerFactor(pf=
       pf, lagging=lagging);
    S = Modelica.ComplexMath.fromPolar(max(100*Modelica.Constants.eps, P_nominal/pf), phi);
    S = v * Modelica.ComplexMath.conj(i);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
              lineColor={255,255,255}),
            Line(points={{-10,0},{10,0}},  color={0,0,0},
            origin={-80,0},
            rotation=180),
          Text(
            extent={{14,140},{104,98}},
            lineColor={0,0,255},
            textString="%name"),
          Rectangle(
            extent={{-11.5,29.5},{11.5,-29.5}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            origin={-41.5,0.5},
            rotation=90)}),        Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      Documentation(info="<html>
<p>
Model of an inductive load. It may be used to model an inductive motor.
</p>
<p>
A parameter or input to the model is the real power <i>P</i>, and a parameter
is the power factor <i>pf=cos(&phi;)</i>.
In this model, current lags voltage, as is the case for an inductive motor.
For a capacitive load, use
<a href=\"modelica://Districts.Electrical.QuasiStationary.SinglePhase.Loads.CapacitorResistor\">
Districts.Electrical.QuasiStationary.Loads.SinglePhase.CapacitorResistor</a>.
</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 2, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end InductorResistor;

  model VariableInductorResistor
    "Model of an inductive and resistive load with actual power as an input signal"
  extends Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort;

    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Control signal" annotation (Placement(
          transformation(extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,80}),                                iconTransformation(
            extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,100})));

    parameter Modelica.SIunits.Power P_nominal(min=0)
      "Nominal power (P_nominal >= 0)"
      annotation (Dialog(group="Nominal conditions"));

    parameter Real pf(min=0, max=1)=0.8
      "Power factor. fixme: this should be a spline";

    Modelica.SIunits.ComplexPower S "Complex power into the component";
    Modelica.SIunits.Angle phi "Phase shift";
  protected
    constant Boolean lagging = true
      "Set to true for inductive loads (motor, transformer), or false otherwise";
    constant Real eps = 1E-12
      "Small number used to avoid a singularity if the power is zero";
    constant Real oneEps = 1-eps
      "Small number used to avoid a singularity if the power is zero";
    constant Boolean isLoad = true
      "Flag, set to true if component is a load, or false if it generates power";
    Real yInt(min=eps)
      "Internal representation of control signal, used to avoid singularity";
  equation
    phi =
      Districts.Electrical.QuasiStationary.SinglePhase.BaseClasses.powerFactor(pf=
       pf, lagging=lagging);
    yInt =  eps + oneEps * y;
    S = if isLoad then
      Modelica.ComplexMath.fromPolar(yInt*P_nominal/pf, phi)
   else
      -Modelica.ComplexMath.fromPolar(yInt*P_nominal/pf, phi);

    S = v * Complex(i.re, -i.im);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                           graphics={Rectangle(extent={{-100,100},{100,-100}},
              lineColor={255,255,255}),
          Text(
            extent={{14,140},{104,98}},
            lineColor={0,0,255},
            textString="%name"),
          Text(
            extent={{18,110},{44,78}},
            lineColor={0,0,127},
            textString="y"),
          Line(
            points={{0,82},{0,0}},
            color={0,0,255},
            smooth=Smooth.None,
            pattern=LinePattern.Dash),
          Rectangle(
            extent={{-11.5,29.5},{11.5,-29.5}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            origin={-41.5,0.5},
            rotation=90),
            Line(points={{-10,0},{10,0}},  color={0,0,0},
            origin={-80,0},
            rotation=180)}),       Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      Documentation(info="<html>
<p>
Model of an inductive load that takes as an input signal the actual power.
It may be used to model an inductive motor.
</p>
<p>
An input to the model is the control signal <i>y</i> which is defined such that
the real power <i>P</i> consumed by this model is equal to <i>P = y &nbsp; P<sub>nom</sub></i>,
where <i>P<sub>nom</sub></i> is a parameter that is equal to the nominal power.
The parameter  <i>pf<sub>nom</sub>=cos(&phi;<sub>nom</sub>)</i>
is the power factor at nominal power <i>P<sub>nom</sub></i>.
</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
</p>
<p>
In this model, current lags voltage, as is the case for an inductive motor.
For a capacitive load, use
<a href=\"modelica://Districts.Electrical.QuasiStationary.SinglePhase.Loads.VariableCapacitorResistor\">
Districts.Electrical.QuasiStationary.Loads.SinglePhase.VariableCapacitorResistor</a>.
</p>
<h4>Implementation</h4>
<p>
To avoid a singularity if the control input signal <i>y</i> is zero, the model uses internally
the signal <i>y<sub>int</sub> = 1E-12 + y * (1 - 1E-12)</i>.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 3, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end VariableInductorResistor;
end BaseClasses;

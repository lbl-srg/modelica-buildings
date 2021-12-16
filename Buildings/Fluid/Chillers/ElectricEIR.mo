within Buildings.Fluid.Chillers;
model ElectricEIR "Electric chiller based on the DOE-2.1 model"
  extends Buildings.Fluid.Chillers.BaseClasses.PartialElectric(
  final QEva_flow_nominal = per.QEva_flow_nominal,
  final COP_nominal= per.COP_nominal,
  final PLRMax= per.PLRMax,
  final PLRMinUnl= per.PLRMinUnl,
  final PLRMin= per.PLRMin,
  final etaMotor= per.etaMotor,
  final mEva_flow_nominal= per.mEva_flow_nominal,
  final mCon_flow_nominal= per.mCon_flow_nominal,
  final TEvaLvg_nominal= per.TEvaLvg_nominal);

  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{40,80},{60,100}})));

protected
  final parameter Modelica.Units.NonSI.Temperature_degC TConEnt_nominal_degC=
      Modelica.Units.Conversions.to_degC(per.TConEnt_nominal)
    "Temperature of fluid entering condenser at nominal condition";

  Modelica.Units.NonSI.Temperature_degC TConEnt_degC
    "Temperature of fluid entering condenser";
initial equation
  // Verify correctness of performance curves, and write warning if error is bigger than 10%
  Buildings.Fluid.Chillers.BaseClasses.warnIfPerformanceOutOfBounds(
     Buildings.Utilities.Math.Functions.biquadratic(a=per.capFunT,
     x1=TEvaLvg_nominal_degC, x2=TConEnt_nominal_degC),
     "Capacity as function of temperature ",
     "per.capFunT");
equation
  TConEnt_degC=Modelica.Units.Conversions.to_degC(TConEnt);

  if on then
    // Compute the chiller capacity fraction, using a biquadratic curve.
    // Since the regression for capacity can have negative values (for unreasonable temperatures),
    // we constrain its return value to be non-negative. This prevents the solver to pick the
    // unrealistic solution.
    capFunT = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = 1E-6,
       x2 = Buildings.Utilities.Math.Functions.biquadratic(a=per.capFunT, x1=TEvaLvg_degC, x2=TConEnt_degC),
       deltaX = 1E-7);
/*    assert(capFunT > 0.1, "Error: Received capFunT = " + String(capFunT)  + ".\n"
           + "Coefficient for polynomial seem to be not valid for the encountered temperature range.\n"
           + "Temperatures are TConEnt_degC = " + String(TConEnt_degC) + " degC\n"
           + "                 TEvaLvg_degC = " + String(TEvaLvg_degC) + " degC");
*/
    // Chiller energy input ratio biquadratic curve.
    EIRFunT = Buildings.Utilities.Math.Functions.biquadratic(a=per.EIRFunT, x1=TEvaLvg_degC, x2=TConEnt_degC);
    // Chiller energy input ratio quadratic curve
    EIRFunPLR   = per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;
  else
    capFunT   = 0;
    EIRFunT   = 0;
    EIRFunPLR = 0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-99,-54},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,66},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
Model of an electric chiller, based on the DOE-2.1 chiller model and
the EnergyPlus chiller model <code>Chiller:Electric:EIR</code>.
</p>
<p> This model uses three functions to predict capacity and power consumption:
</p>
<ul>
<li>
A biquadratic function is used to predict cooling capacity as a function of
condenser entering and evaporator leaving fluid temperature.
</li>
<li>
A quadratic functions is used to predict power input to cooling capacity ratio with respect to the part load ratio.
</li>
<li>
A biquadratic functions is used to predict power input to cooling capacity ratio as a function of
condenser entering and evaporator leaving fluid temperature.
</li>
</ul>
<p>
These curves are stored in the data record <code>per</code> and are available from
<a href=\"Buildings.Fluid.Chillers.Data.ElectricEIR\">
Buildings.Fluid.Chillers.Data.ElectricEIR</a>.
Additional performance curves can be developed using
two available techniques (Hydeman and Gillespie, 2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques. A detailed description of both techniques can be found in
Hydeman and Gillespie (2002).
</p>
<p>
The model takes as an input the set point for the leaving chilled water temperature,
which is met if the chiller has sufficient capacity.
Thus, the model has a built-in, ideal temperature control.
The model has three tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test<pre>
  PLR1 =min(QEva_flow_set/QEva_flow_ava, per.PLRMax);
</pre>
ensures that the chiller capacity does not exceed the chiller capacity specified
by the parameter <code>per.PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a chiller would run if it were to cycle because its load is smaller than the
minimal load at which it can operate.
Note that this model continuously operates even if the part load ratio is below the minimum part load ratio.
Its leaving evaporator and condenser temperature can therefore be considered as an
average temperature between the modes where the compressor is off and on.
</li>
<li>
The test <pre>
  PLR2 = max(per.PLRMinUnl, PLR1);
</pre>
computes the part load ratio of the compressor.
The assumption is that for a part load ratio below <code>per.PLRMinUnl</code>,
the chiller uses hot gas bypass to reduce the capacity, while the compressor
power draw does not change.
</li>
</ol>
<p>
The electric power only contains the power for the compressor, but not any power for pumps or fans.
</p>
<p>
The model can be parametrized to compute a transient
or steady-state response.
The transient response of the boiler is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The chiller outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
<h4>References</h4>
<ul>
<li>
Hydeman, M. and K.L. Gillespie. 2002. Tools and Techniques to Calibrate Electric Chiller
Component Models. <i>ASHRAE Transactions</i>, AC-02-9-1.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 12, 2015, by Michael Wetter:<br/>
Refactored model to make it once continuously differentiable.
This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/373\">373</a>.
</li>
<li>
Jan. 9, 2011, by Michael Wetter:<br/>
Added input signal to switch chiller off.
</li>
<li>
Sep. 8, 2010, by Michael Wetter:<br/>
Revised model and included it in the Buildings library.
</li>
<li>
October 13, 2008, by Brandon Hencey:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricEIR;

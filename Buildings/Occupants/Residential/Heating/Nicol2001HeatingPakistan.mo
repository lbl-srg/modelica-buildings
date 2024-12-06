within Buildings.Occupants.Residential.Heating;
model Nicol2001HeatingPakistan "A model to predict occupants' heating behavior with outdoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A(final unit="1/K") = -0.345 "Slope of the logistic relation";
  parameter Real B(final unit="1") = 2.73 "Intercept of the logistic relation";
  parameter Integer localSeed = 5001
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC") "Outdoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.BooleanOutput on "State of heater"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real p(
    final unit="1",
    final min=0,
    final max=1) "Probability of heating being on";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  discrete Real ran(min=0, max=1) "Random number";

initial equation
  t0 = time;
  p = Modelica.Math.exp(A*(TOut - 273.15)+B)/(Modelica.Math.exp(A*(TOut - 273.15)+B) + 1);

  (ran, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(
    stateIn=Modelica.Math.Random.Generators.Xorshift1024star.initialState(
      localSeed = localSeed, 
      globalSeed = globalSeed));
  on = ran < p;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    (ran, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
    if occ then
      p = Modelica.Math.exp(A*(TOut - 273.15)+B)/(Modelica.Math.exp(A*(TOut - 273.15)+B) + 1);
      on = ran < p;
    else
      p = 0;
      on = false;
    end if;
  end when;

  annotation (Icon(graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            textColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Heater_Tout")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model predicting the state of the heater with the outdoor temperature
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the heater is always off. When the
space is occupied, the lower the outdoor temperature is, the higher
the chance to turn on the heater.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Nichol, J., 2001.
Characterizing occupant behavior in buildings: towards a stochastic
model of occupant use of windows, lights, blinds heaters and fans. In
Proceedings of building simulation 01, an IBPSA Conference.&quot;
</p>
<p>
The model parameters are regressed from the field study in Pakistan in 1999.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 6, 2024, by Michael Wetter:<br/>
Refactored implementation of random number calculations, transfering the local state of
the random number generator from one call to the next.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4069\">#4069</a>.
</li>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Nicol2001HeatingPakistan;

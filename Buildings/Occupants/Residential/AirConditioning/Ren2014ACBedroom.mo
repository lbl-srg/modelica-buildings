within Buildings.Occupants.Residential.AirConditioning;
model Ren2014ACBedroom
  "A model to predict occupants' AC behavior in bedroom with indoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Modelica.Units.SI.Temperature u1 = 304.40
    "Threshold for turning off the AC of the Weibull Distribution";
  parameter Modelica.Units.SI.Temperature u2 = 301.90
    "Threshold for turning on the AC of the Weibull Distribution";
  parameter Modelica.Units.SI.TemperatureDifference L1 = 13.34
    "Normalization factor for turning off the AC of the Weibull Distribution";
  parameter Modelica.Units.SI.TemperatureDifference L2 = 42.86
    "Normalization factor for turning on the AC of the Weibull Distribution";
  parameter Real k1 = 1.73 "Shape factor for turning off the AC of the Weibull Distribution";
  parameter Real k2 = 1.80 "Shape factor for turning on the AC of the Weibull Distribution";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";
  parameter Integer localSeed = 10
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit="degC") "Indoor air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.BooleanOutput on "State of AC"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pOn(
    final unit="1",
    final min=0,
    final max=1) "Probability of turning on the AC";
  Real pOff(
    final unit="1",
    final min=0,
    final max=1) "Probability of turning off the AC";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  Boolean dummy
    "Dummy variable for state of the heater (used as random number has two return arguments, and hence negation in the call is not possible)";

initial equation
  t0 = time;
  state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(
    localSeed = localSeed, 
    globalSeed = globalSeed);

  on = false "The initial state of AC is off";
  dummy = true;
  pOn = 0;
  pOff = 0;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    pOff = if TIn <= u1 then 1 - Modelica.Math.exp(-((u1-TIn)/L1)^k1*samplePeriod) else 0;
    pOn = if TIn >= u2 then 1 - Modelica.Math.exp(-((TIn-u2)/L2)^k2*samplePeriod) else 0;
    
    // Call only weibull1DOff, but swap arguments if pre(on) == false, which effectively
    // renders a call to weibull1DON.
    // This is done to have only one state for the random number generator.
    (dummy, state) = Buildings.Occupants.BaseClasses.weibull1DOFF(
      x=if pre(on) then TIn else u2,
      u=if pre(on) then u1 else TIn,
      L=if pre(on) then L1 else L2,
      k=if pre(on) then k1 else k2,
      dt=samplePeriod,
      stateIn=pre(state));
 
    if occ then
      if pre(on) then
        on = not dummy;
      else
        on = dummy;
      end if;
    else
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
            textString="AC_Tin")}),
defaultComponentName="ac",
Documentation(info="<html>
<p>
Model predicting the state of the AC with the indoor temperature
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the AC is always off. When the
space is occupied, the lower the indoor temperature is, the lower
the chance to turn on the AC and higher the chance to turn off the AC.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Ren, X., Yan, D. and Wang, C.,
2014. Air-conditioning usage conditional probability model for residential
buildings. Building and Environment, 81, pp.172-182.&quot;
</p>
<p>
The model parameters are regressed from the field study in China in 2014.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Ren2014ACBedroom;

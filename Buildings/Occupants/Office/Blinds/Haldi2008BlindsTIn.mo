within Buildings.Occupants.Office.Blinds;
model Haldi2008BlindsTIn
  "A model to predict occupants' blinds behavior with indoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A(final unit="1/K") = 0.425 "Slope of indoor temperature";
  parameter Real B(final unit="1") = -11.37 "Intercept";
  parameter Integer localSeed = 1000
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit="degC") "Indoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput blindState(
    final min=0,
    final max=1,
    final unit="1")
    "State of blinds, 1 being blinds down"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pDown(
    final unit="1",
    final min=0,
    final max=1) "The probability of lowering the blinds";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  Boolean ran "Random number";

initial equation
  t0 = time;
  blindState = 0;
  pDown = 0;
  state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(
    localSeed = localSeed, 
    globalSeed = globalSeed);
  ran = false;


equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    (ran, state) = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pre(pDown), stateIn=pre(state));
    if occ then
      pDown = 1-Modelica.Math.exp(A*(TIn-273.15)+B)/(Modelica.Math.exp(A*(TIn-273.15)+B)+1);
      if ran then
        blindState = 0;
      else
        blindState = 1;
      end if;
    else
      pDown = 0;
      blindState = 1;
    end if;
  end when;

  annotation (Icon(graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            textColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Blinds_TIn")}),
defaultComponentName="bli",
Documentation(info="<html>
<p>
Model predicting the state of the blinds with the indoor temperature.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds are always down. When the
space is occupied, the lower <code>TIn</code> is, the higher
the chance that the blind is up.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Haldi, F. and Robinson, D., 2008.
On the behaviour and adaptation of office occupants. Building and environment,
43(12), pp.2163-2177.&quot;
</p>
<p>
The model parameters are regressed from the field study in eight Swiss office
buildings in 2006.
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
August 31, 2018, by Zhe Wang:<br/>
First revision.
</li>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Haldi2008BlindsTIn;

within Buildings.Occupants.Office.Windows;
model Yun2008WindowsTOut "A model to predict occupants' window behavior with outdoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AOpen = 0.009 "Slope of the logistic relation for opening the window";
  parameter Real BOpen = -0.115 "Intercept of the logistic relation for opening the window";
  parameter Real AClose = 0 "Slope of the logistic relation for closing the window";
  parameter Real BClose = -0.040 "Intercept of the logistic relation for closing the window";
  parameter Integer localSeed = 3009
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
  Modelica.Blocks.Interfaces.BooleanOutput on "State of window, true for open"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pOpen(
    unit="1",
    min=0,
    max=1) "Probability of opening the window";
  Real pClose(
    unit="1",
    min=0,
    max=1) "Probability of closing the window";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  discrete Real ran(min=0, max=1) "Random number";

initial equation
  t0 = time;
  state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(
    localSeed = localSeed, 
    globalSeed = globalSeed);

  on = false;
  pOpen = Modelica.Math.exp(AOpen*(TOut - 273.15)+BOpen)/(Modelica.Math.exp(AOpen*(TOut - 273.15)+BOpen) + 1);
  pClose = Modelica.Math.exp(AClose*(TOut - 273.15)+BClose)/(Modelica.Math.exp(AClose*(TOut - 273.15)+BClose) + 1);
  ran = 0.5;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    (ran, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
    if occ then
      pOpen = Modelica.Math.exp(AOpen*(TOut - 273.15)+BOpen)/(Modelica.Math.exp(AOpen*(TOut - 273.15)+BOpen) + 1);
      pClose = Modelica.Math.exp(AClose*(TOut - 273.15)+BClose)/(Modelica.Math.exp(AClose*(TOut - 273.15)+BClose) + 1);
      if pre(on) then
        on = not ran < pClose;
      elseif pre(on) == false and TOut > 288.15 then
        on = ran < pOpen;
      else
        on = pre(on);
      end if;
    else
      pOpen = 0;
      pClose = 0;
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
            textString="WindowAll_TOut")}),
defaultComponentName="win",
Documentation(info="<html>
<p>
Model predicting the state of the window with the outdoor air temperature 
and occupancy through Markov approach.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the window is always closed. When the 
space is occupied, the Probability of closing or opening the window 
depends on the outdoor air temperature.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Yun, G.Y. and Steemers, K., 
2008. Time-dependent occupant behaviour models of window control in 
summer. Building and Environment, 43(9), pp.1471-1482.&quot;
</p>
<p>
The model parameters are regressed from the field study in offices without
night ventilation, located in Cambridge, UK in summer time (13 Jun. to 15 
Sep., 2006).
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
July 26, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Yun2008WindowsTOut;

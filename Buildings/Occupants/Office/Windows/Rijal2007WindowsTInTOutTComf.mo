within Buildings.Occupants.Office.Windows;
model Rijal2007WindowsTInTOutTComf "A model to predict occupants' window behavior with indoor, outdoor and comfort temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AIn = 0.171 "Slope of the indoor temperature in the logistic relation";
  parameter Real AOut = 0.166 "Slope of the outdoor temperature in the logistic relation";
  parameter Real B = -6.4 "Intercept of the logistic relation";
  parameter Integer localSeed = 3007
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit="degC") "Indoor air temperature" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC") "Outdoor air temperature" annotation (Placement(transformation(extent={{-140,
            -60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TComf(
    final unit="K",
    displayUnit="degC") "Comfort temperature" annotation (Placement(transformation(extent={{-140,
            -104},{-100,-64}}),
      iconTransformation(extent={{-140,-104},{-100,-64}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "State of window, true for open"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real p(
    unit="1",
    min=0,
    max=1) "Probability of window opened";

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

  p = Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B)/(Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B) + 1);
  on = false;
  ran = 0.5;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    (ran, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
    if occ then
      if TIn > TComf+2 then
        if not pre(on) then
          p = Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B)/(Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B) + 1);
          on = ran < p;
        else
          p = -0.3;
          on = true;
        end if;
      elseif TIn < TComf-2 then
        if pre(on) then
          p = Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B)/(Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B) + 1);
          on = ran < p;
        else
          p = -0.5;
          on = false;
        end if;
      else
        p = -0.1;
        on = pre(on);
      end if;
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
            textString="WindowAll_TInToutTComf")}),
defaultComponentName="win",
Documentation(info="<html>
<p>
Model predicting the state of the window with the indoor, outdoor and comfort temperature 
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the window is always closed. When the 
space is occupied, the window state is determined by the indoor, outdoor
and comfort temperature.
</p>
<p>
When the indoor temperature is within the comfort temperature plus and minus
2 degC, the window state will not be changed.
</p>
<p>
When the indoor temperature is above the comfort temperature plus 2 degC, 
if the window is open, it would be kept open; if the window is closed, it might
be opened, the probability to open the window is determined by the indoor and 
outdoor temperature.
</p>
<p>
When the indoor temperature is below the comfort temperature minus 2 degC, 
if the window is closed, it would be kept closed; if the window is open, it might
be closed, the probability to close the window is determined by the indoor and 
outdoor temperature.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Rijal, H.B., Tuohy, P., Humphreys, 
M.A., Nicol, J.F., Samuel, A. and Clarke, J., 2007. Using results from field 
surveys to predict the effect of open windows on thermal comfort and energy 
use in buildings. Energy and buildings, 39(7), pp.823-836.&quot;
</p>
<p>
The model parameters are regressed from the field study conducted in 15 office 
buildings in UK between March 1996 and September 1997. Nine of the buildings 
were in the Oxford area in the central south of England (seven naturally 
ventilated (NV) and two air conditioned (AC)). Six of the buildings were in 
Aberdeen on the north-east coast of Scotland (three NV and three AC). 
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
July 25, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Rijal2007WindowsTInTOutTComf;

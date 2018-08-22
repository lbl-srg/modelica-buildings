within Buildings.Occupants.Office.Windows;
model Rijal2007WindowsTInTOutTComf "A model to predict occupants' window behavior with indoor, outdoor and comfort temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AIn = 0.171 "Slope of the indoor temperature in the logistic relation";
  parameter Real AOut = 0.166 "Slope of the outdoor temperature in the logistic relation";
  parameter Real B = -6.4 "Intercept of the logistic relation";
  parameter Integer seed = 30 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TIn(
    unit="K",
    displayUnit="degC") "Indoor air temperature" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TOut(
    unit="K",
    displayUnit="degC") "Outdoor air temperature" annotation (Placement(transformation(extent={{-140,
            -60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TComf(
    unit="K",
    displayUnit="degC") "Comfort temperature" annotation (Placement(transformation(extent={{-140,
            -104},{-100,-64}}),
      iconTransformation(extent={{-140,-104},{-100,-64}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "State of window"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real p(
    unit="1",
    min=0,
    max=1) "Probability of window opened";

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;
  p = Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B)/(Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B) + 1);
  on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=seed);
equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    p = Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B)/(Modelica.Math.exp(AIn*(TIn - 273.15)+AOut*(TOut - 273.15)+B) + 1);
    if occ then
      if TIn > TComf+2 then
        if not pre(on) then
          on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=seed);
        else
          on = true;
        end if;
      elseif TIn < TComf-2 then
        if pre(on) then
          on = not Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=seed);
        else
          on = false;
        end if;
      else
        on = pre(on);
      end if;
    else
      on = false;
    end if;
  end when;

  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="WindowAll_TInToutTComf")},
defaultComponentName="win",
Documentation(info="<html>
<p>
Model predicting the state of the window with the indoor, outdoor and comfort temperature 
and occupancy.
</p>
<h4>Inputs</h4>
<p>
Indoor temperature: should be input with the unit of K.
</p>
<p>
Outdoor temperature: should be input with the unit of K.
</p>
<p>
Comfort temperature: should be input with the unit of K.
</p>
<p>
Occupancy: a boolean variable, true indicates the space is occupied, 
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of window: a boolean variable, true indicates the window 
is open, false indicates the window is closed.
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
be opened, the probability to open the window is determiend by the indoor and 
outdoor temperature.
</p>
<p>
When the indoor temperature is below the comfort temperature minus 2 degC, 
if the window is closed, it would be kept closed; if the window is open, it might
be closed, the probability to open the window is determiend by the indoor and 
outdoor temperature.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Rijal, H.B., Tuohy, P., Humphreys, 
M.A., Nicol, J.F., Samuel, A. and Clarke, J., 2007. Using results from field 
surveys to predict the effect of open windows on thermal comfort and energy 
use in buildings. Energy and buildings, 39(7), pp.823-836.&quot;.
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
July 25, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Rijal2007WindowsTInTOutTComf;

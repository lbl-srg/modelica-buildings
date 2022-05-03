within Buildings.Occupants.Office.Windows;
model Haldi2009WindowsTInTout "A model to predict occupants' window behavior with indoor and outdoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AOpenIn = 0.263 "Slope of indoor temp of the logistic relation for the opening probability";
  parameter Real AOpenOut = 0.039 "Slope of outdoor temp of the logistic relation for the opening probability";
  parameter Real BOpen = -11.78 "Intercept of the logistic relation for the opening probability";
  parameter Real ACloseIn = 0.026 "Slope of indoor temp of the logistic relation for the closing probability";
  parameter Real ACloseOut = -0.065 "Slope of outdoor temp of the logistic relation for the closing probability";
  parameter Real BClose = -4.14 "Intercept of the logistic relation for the closing probability";
  parameter Integer seed = 10 "Seed for the random number generator";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit="degC") "Indoor air temperature" annotation (Placement(transformation(extent={{-140,
            -40},{-100,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
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
    max=1) "Probability of opening windows";
  Real pClose(
    unit="1",
    min=0,
    max=1) "Probability of closing windows";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Real curSeed "Current value for seed as a real-valued variable";

initial equation
  t0 = time;
  curSeed = t0*seed;
  on = false;
  pOpen = Modelica.Math.exp(AOpenIn*(TIn - 273.15)+AOpenOut*(TOut - 273.15)+BOpen)/(Modelica.Math.exp(AOpenIn*(TIn - 273.15)+AOpenOut*(TOut - 273.15)+BOpen) + 1);
  pClose = Modelica.Math.exp(ACloseIn*(TIn - 273.15)+ACloseOut*(TOut - 273.15)+BClose)/(Modelica.Math.exp(ACloseIn*(TIn - 273.15)+ACloseOut*(TOut - 273.15)+BClose) + 1);

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    curSeed = seed*time;
    if occ then
      pOpen = Modelica.Math.exp(AOpenIn*(TIn - 273.15)+AOpenOut*(TOut - 273.15)+BOpen)/(Modelica.Math.exp(AOpenIn*(TIn - 273.15)+AOpenOut*(TOut - 273.15)+BOpen) + 1);
      pClose = Modelica.Math.exp(ACloseIn*(TIn - 273.15)+ACloseOut*(TOut - 273.15)+BClose)/(Modelica.Math.exp(ACloseIn*(TIn - 273.15)+ACloseOut*(TOut - 273.15)+BClose) + 1);
      if pre(on) then
        on = not Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pClose, globalSeed=integer(curSeed));
      else
        on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pOpen, globalSeed=integer(curSeed));
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
            textString="WindowAll_TInTout")}),
defaultComponentName="win",
Documentation(info="<html>
<p>
Model predicting the state of the window with the indoor, outdoor air temperature 
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the window is always closed. When the 
space is occupied, Markov method was utilized to determine the state 
of the window. The probability of opening and closing the window
depends on both the indoor and outdoor temperature.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Haldi, F. and Robinson, D., 
2009. Interactions with window openings by office occupants. Building 
and Environment, 44(12), pp.2378-2395.&quot;
</p>
<p>
The model parameters are regressed from the field study in the Solar 
Energy and Building Physics Laboratory (LESO-PB) experimental building, 
located in the suburb of Lausanne, Switzerland for a period covering 
19 December 2001–15 November 2008.
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
end Haldi2009WindowsTInTout;

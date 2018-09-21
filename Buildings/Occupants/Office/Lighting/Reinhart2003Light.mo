within Buildings.Occupants.Office.Lighting;
model Reinhart2003Light "A model to predict occupants' lighting behavior with illuminance"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AArriv = -0.00238 "upon arrival";
  parameter Real BArriv = -3.0965 "upon arrival";
  parameter Real CArriv = 1.0157 "upon arrival";
  parameter Real MArriv = 1.8536 "upon arrival";
  parameter Real AInter = 0.0027 "intermediate";
  parameter Real BInter = -64.19 "intermediate";
  parameter Real CInter = 0.017 "intermediate";
  parameter Real MInter = 2.41 "intermediate";
  parameter Integer seed = 30 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput Illu "Illuminance on the working plane, unit:" annotation (
       Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "State of Lighting"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pArriv(
    unit="1",
    min=0,
    max=1) "Probability of switch on the lighting upon arrival";
  Real pInter(
    unit="1",
    min=0,
    max=1) "Intermediate robability of switch on the lighting";

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
initial equation
  t0 = time;
  on = false;
equation
  pArriv = AArriv + CArriv/(1+Modelica.Math.exp(-BArriv*(Modelica.Math.log10(Illu)-MArriv)));
  pInter = AInter + CInter/(1+Modelica.Math.exp(-BInter*(Modelica.Math.log10(Illu)-MInter)));
  sampleTrigger = sample(t0,samplePeriod);
  when {occ,sampleTrigger} then
    if sampleTrigger then
      if occ then
        if not pre(on) then
          on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pInter, globalSeed=integer(seed*time));
        else
          on = true;
        end if;
      else
        on = false;
      end if;
    else
      on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pArriv, globalSeed=integer(seed*time));
    end if;
  end when;


  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Light_Illu")},
defaultComponentName="lig",
Documentation(info="<html>
<p>
Model predicting the state of the lighting with the illuminance on the working plane
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the light is always off. When the 
space is occupied, the probability to switch on the light depends
on the illuminance level on the working plane. The lower the
illuminance level, the higher the chance to switch on the lighting.
</p>
<p>
The probability to switch on the lighting is different when subjects just arrived and when
subjects have stayed indoor for a while. The probability to switch lights is higher when 
subjects just arrived. Accordingly, two different probability functions 
have been applied.
</p>
<p>
The switch-off probability is found to be very low in this research, which 
is might because occupants failed to notice the lighting is on when the indoor
daylight illuminance levels were high. Therefore, in this model, the lighting would
be switched off only when the space is unoccupied.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Reinhart, C.F. and Voss, K., 2003. Monitoring 
manual control of electric lighting and blinds. Lighting research &amp; technology, 35(3), 
pp.243-258.&quot;
</p>
<p>
The model parameters are regressed from the field study in 10 offices in Germany from
Mar. to Dec. 2000.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 26, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-98,98},{94,-96}},
          lineColor={28,108,200},
          textString="ob.office
Light")}));
end Reinhart2003Light;

within Buildings.Occupants.Office.Lighting;
model Hunt1979Light "A model to predict occupants' lighting behavior with illuminance"
 extends Modelica.Blocks.Icons.DiscreteBlock;
 parameter Real AArriv = -0.0175 "Upon arrival";
 parameter Real BArriv = -4.0835 "Upon arrival";
 parameter Real CArriv = 1.0361 "Upon arrival";
 parameter Real MArriv = 1.8223 "Upon arrival";
 parameter Integer localSeed = 10 "Local seed for the random number generator";
  parameter Integer globalSeed = 30129 "Global seed for the random number generator";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

 Modelica.Blocks.Interfaces.RealInput ill "Illuminance on the working planein units of lux" annotation (
      Placement(transformation(extent={{-140,-80},{-100,-40}}),
     iconTransformation(extent={{-140,-80},{-100,-40}})));
 Modelica.Blocks.Interfaces.BooleanInput occ
   "Indoor occupancy, true for occupied"
   annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
 Modelica.Blocks.Interfaces.BooleanOutput on "State of lighting"
   annotation (Placement(transformation(extent={{100,-10},{120,10}})));

 Real pArriv(
   unit="1",
   min=0,
   max=1) "Probability of switch on the lighting upon arrival";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";

  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  discrete Real ran(min=0, max=1) "Random number";

initial equation
 t0 = time;
 state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);

 on = false;
 ran = 0.5;

equation
 if ill > 657.7 then
   pArriv =0;
 elseif ill < 7.0 then
   pArriv =1;
 else
   pArriv =AArriv + CArriv/(1 + Modelica.Math.exp(-BArriv*(
     Modelica.Math.log10(ill) - MArriv)));
 end if;
 sampleTrigger = sample(t0, samplePeriod);
 when {occ, sampleTrigger} then
   (ran, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
   if sampleTrigger then
     if occ then
       on = pre(on);
     else
       on = false;
     end if;
   else
     on = ran < pArriv;
   end if;
 end when;
 annotation (Icon(graphics={
           Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
           extent={{-40,20},{40,-20}},
           textColor={28,108,200},
           fillColor={0,0,255},
           fillPattern=FillPattern.Solid,
           textStyle={TextStyle.Bold},
           textString="Light_Illu")}),
    defaultComponentName="lig",
    Documentation(info=
                  "<html>
<p>
Model predicting the state of the lighting with the minimum illuminance on the working plane
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
In this model, it was found people tend to switch on the lights-if needed- only at times when
entering a space, and they rarely switch off the lights until the space becomes completely empty.
</p>
<p>
The probability to switch on the lights upon arrival would depend on the minimum illuminance level
on their working plane.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Hunt, D.R.G., 1980. Predicting artificial
lighting use-a method based upon observed patterns of behaviour. Lighting Research &amp; Technology,
12(1), pp.7-14.&quot;
</p>
<p>
The model parameters are regressed from the field study in 10 offices in Germany from
Mar. to Dec. 2000.
</p>
</html>", revisions=
         "<html>
<ul>
<li>
July 26, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Hunt1979Light;

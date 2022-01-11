within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation;
model TemporalSuperposition "This validation case applies temporal superposition with truncated vectors"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.TemperatureDifference supPos=
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.temporalSuperposition(
      i=6,
      QAgg_flow={2,1e6,3,1e6,1e6},
      kappa={0.4,0,0.2,1,0},
      curCel=3) "Temporal superposition";
  Modelica.Units.SI.TemperatureDifference supPosErr;

equation
  supPosErr = abs((2*0.4+3*0.2)-supPos);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/LoadAggregation/Validation/TemporalSuperposition.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case uses a fictional load profile and weighting factors to ensure
that the temporal superposition is correctly done. The <code>curCel</code> input to
the function called truncates the vectors involved in the scalar product such that
the large load in the <code>QAgg_flow</code> vector mustn't affect the final result.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemporalSuperposition;

within Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.Validation;
model TemporalSuperposition
  "This validation case applies temporal superposition with truncated vectors"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.TemperatureDifference[2] supPos=
      Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.temporalSuperposition(
      i=5,
      nSeg=2,
      QAgg_flow={ {2,0,3,1e6,1e6}, {0,1,0,1e6,1e6}},
      kappa={ { {0.4,0,0.2,1,10},
                {0.1,0.15,0,0,20}},
              { {0.1,0.15,0,0,20},
                {0.2,1,0.3,0,10}}},
      curCel=3) "Temporal superposition";
  Modelica.Units.SI.TemperatureDifference[2] supPosErr;

equation
  supPosErr = abs({2*0.4+3*0.2+0.15, 2*0.1+1}-supPos);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedThermalStorage/BaseClasses/HeatTransfer/Validation/TemporalSuperposition.mos"
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
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemporalSuperposition;

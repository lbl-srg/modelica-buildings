within Buildings.BoundaryConditions.GroundTemperature.Examples;
model CorrectedNFactors
  "Example model for undisturbed soil temperature with n-factors correction"
  extends UndisturbedSoilTemperature(
    TSoi(each useNFac=true, each nFacTha=1.7, each nFacFre=0.66));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 21, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example model showcases the use of n-factors, which are used
to correct the surface temperature given the ratio of freezing/thawing
degree days (FDD/TDD) between the air and the ground.
</p>

<h4>References</h4>
<p>
The values used in this example are equivalent to the use-case
presented in the \"Heat Transfer at Ground Surface\" section of the
<i>District Cooling Guide</i> (ASHRAE, 2013). 
</p>
</html>"),
experiment(StopTime=31536000, Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/GroundTemperature/Examples/CorrectedNFactors.mos"
        "Simulate and plot"));
end CorrectedNFactors;

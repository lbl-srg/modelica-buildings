within Buildings.BoundaryConditions.GroundTemperature.Examples;
model CorrectedConvection
  "Example model for undisturbed soil temperature with surface convection correction"
  extends UndisturbedSoilTemperature(TSoi(each useCon=true, each hSur=5));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 21, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example model showcases the use of the convection coefficient
correction, which allows to specify the heat transfer rate between
the air and the surface temperature.
</p>
</html>"),
experiment(StopTime=31536000, Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/GroundTemperature/Examples/CorrectedConvection.mos"
        "Simulate and plot"));
end CorrectedConvection;

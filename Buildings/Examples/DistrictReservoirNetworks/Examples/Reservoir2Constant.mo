within Buildings.Examples.DistrictReservoirNetworks.Examples;
model Reservoir2Constant "Reservoir network with simple control and dp=125 Pa/m"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.Examples.Reservoir1Constant(
    datDes(
      RDisPip=125));

  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir2Constant.mos"
        "Simulate and plot"),
    experiment(StopTime=31536000,
    Tolerance=1e-06, __Dymola_NumberOfIntervals=8760),
    Documentation(info="<html>
<p>
Model of reservoir network,
</p>
<p>
This model is identical to
<a href=\"Buildings.Examples.DistrictReservoirNetworks.Examples.Reservoir1Constant\">
Buildings.Examples.DistrictReservoirNetworks.Examples.Reservoir1Constant</a>
except that the pipes of the main loop are designed for a pressure drop
of <i>125</i> Pa/m at the design flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Reservoir2Constant;

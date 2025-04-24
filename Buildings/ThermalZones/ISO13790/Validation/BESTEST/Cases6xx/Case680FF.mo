within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case680FF
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600FF(zonHVAC(
    UWal=0.15,
    URoo=0.1));

 annotation (
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
 experiment(Tolerance=1e-06, Interval=3600, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case680FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 680FF of the BESTEST validation suite.
Case 680FF is a light-weight building with increased exterior wall and roof insulation.
The room temperature is free floating.
</p>
</html>", revisions="<html>
<ul>
<li>
March 10, 2025, by Michael Wetter:<br/>
Added missing semi-colon.</br>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1987\">IBPSA, #1987</a>.
</li>
<li>May 3, 2024, Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case680FF;

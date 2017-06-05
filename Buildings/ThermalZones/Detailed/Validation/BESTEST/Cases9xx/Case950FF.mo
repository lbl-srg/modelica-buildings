within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case950FF
  "Case 900, but no heating, no cooling, and ventilation as in case 650"
  extends Case900FF(
  staRes(
      minT( Min=-20.2+273.15, Max=-18.6+273.15, Mean=-19.6+273.15),
      maxT( Min=35.5+273.15, Max=38.5+273.15, Mean=36.5+273.15),
      meanT(Min=14.0+273.15, Max=15.0+273.15, Mean=14.4+273.15)),
  multiSum(nu=2));

  BaseClasses.DaySchedule vent(table=[      0, -1703.16/3600;
                                       7*3600, -1703.16/3600;
                                       7*3600,             0;
                                      18*3600,             0;
                                      18*3600, -1703.16/3600;
                                      24*3600, -1703.16/3600])
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{-88,-68},{-80,-60}})));
equation
  connect(multiSum.u[2],vent.y[1]) annotation (Line(
      points={{-72,-44},{-76,-44},{-76,-64},{-79.6,-64}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case950FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 950FF of the BESTEST validation suite.
Case 950FF is identical to case 950, except that there is no
heating and no cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
July 16, 2012, by Michael Wetter:<br/>
Revised implementation to extend from base case to avoid duplicate code.
Merged model into the Buildings library.
</li>
<li>
June 26, 2012, by Markus Nurschinger and Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case950FF;

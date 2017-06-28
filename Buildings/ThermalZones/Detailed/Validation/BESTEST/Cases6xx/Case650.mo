within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case650
  "Case 600, but cooling based on schedule, night venting, and no heating"
  extends Case600(
    TSetHea(table=[0, 273.15 -200]),
    TSetCoo(table=[      0, 273.15+100;
                    7*3600, 273.15+100;
                    7*3600, 273.15+27;
                   18*3600, 273.15+27;
                   18*3600, 273.15+100;
                   24*3600, 273.15+100]),
  staRes(
    annualHea(Min=0*3.6e9, Max=0*3.6e9, Mean=0*3.6e9),
    annualCoo(Min=-4.816*3.6e9, Max=-6.545*3.6e9, Mean=-5.482*3.6e9),
    peakHea(Min = 0*1000, Max = 0*1000, Mean = 0 * 1000),
    peakCoo(Min= -5.831*1000, Max = -6.679*1000, Mean= -6.321*1000)),
    gaiHea(k=0),
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
  connect(multiSum.u[2], vent.y[1]) annotation (Line(
      points={{-78,-74},{-76,-74},{-76,-64},{-79.6,-64}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case650.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2012, by Michael Wetter:<br/>
Revised implementation to extend from base case to avoid duplicate code.
Merged model into the Buildings library.
</li>
<li>
June 5, 2012, by Vladimir Vukovic:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used for the test case 650 of the BESTEST validation suite.
Case650 is the same as Case600, but with the following modifications:
</p>
<ul>
<li>
From 1800 hours to 0700 hours, vent fan = on
</li>
<li>
From 0700 hours to 1800 hours, vent fan = off
</li>
<li>
Heating is always off
</li>
<li>
From 0700 hours to 1800 hours, cooling is on if zone temperature &gt; 27&deg;C,
otherwise cool = off.
</li>
<li>
From 1800 hours to 0700 hours, cooling is always off.
</li>
<li>
Ventilation fan capacity is 1703.16 standard m<sup>3</sup>/h (in addition to specified
infiltration rate).
</li>
<li>
No waste heat from fan.
</li>
</ul>
</html>"));
end Case650;

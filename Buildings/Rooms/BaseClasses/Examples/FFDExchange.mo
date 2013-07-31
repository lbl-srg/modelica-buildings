within Buildings.Rooms.BaseClasses.Examples;
model FFDExchange "Test model for FFDExchange block"
  import Buildings;
  extends Modelica.Icons.Example;

  parameter Integer nWri = 3 "Number of values to write";
  Buildings.Rooms.BaseClasses.FFDExchange ffd(
    activateInterface=false,
    nWri=nWri,
    uStart=fill(0, nWri),
    nRea=3,
    surIde=surIde,
    nSur=nWri,
    samplePeriod=2,
    flaWri={0,1,2}) "Block for data exchange with FFD"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Clock u[nWri] "Input to FFD"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  parameter Buildings.Rooms.BaseClasses.FFDSurfaceIdentifier surIde[nWri](
    name={"a","b","c"},
    A={1,2,4},
    til={0,1.5707963267949,3.1415926535898},
    each bouCon=Buildings.Rooms.Types.CFDBoundaryConditions.Temperature)
    "Surface identifier"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(u.y, ffd.u) annotation (Line(
      points={{-39,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>
This example tests the FFD exchange block for the configuration where 
the actual exchange with FFD is disabled.
</p>
</html>", revisions="<html>
<ul>
<li>
July 26, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=10),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/BaseClasses/Examples/FFDExchange.mos"
        "Simulate and plot"));
end FFDExchange;

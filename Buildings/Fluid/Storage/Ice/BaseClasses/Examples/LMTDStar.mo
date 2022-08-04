within Buildings.Fluid.Storage.Ice.BaseClasses.Examples;
model LMTDStar "Example that tests the LMTDStar model"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Storage.Ice.BaseClasses.LMTDStar lmtdSta "LMTD star"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Modelica.Blocks.Sources.Cosine TIn(
    amplitude=4,
    f=1/3600,
    offset=273.15 + 2) "Inlet temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Cosine TOut(
    amplitude=4,
    f=1/3600,
    offset=273.15 + 2,
    phase=3.1415926535898) "Outlet temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
equation
  connect(TIn.y, lmtdSta.TIn) annotation (Line(points={{-19,20},{8,20},{8,4},{
          30,4}},   color={0,0,127}));
  connect(TOut.y, lmtdSta.TOut) annotation (Line(points={{-19,-20},{8,-20},{8,
          -4},{30,-4}},      color={0,0,127}));
  annotation (
    experiment(StartTime=0,
              StopTime=3600,
              Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/BaseClasses/Examples/LMTDStar.mos"
        "Simulate and Plot"),
        Documentation(info=
     "<html>
      <p>This example is to validate the <code>LMTDStar</code>.</p>
      </html>",
    revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
</html>"));
end LMTDStar;

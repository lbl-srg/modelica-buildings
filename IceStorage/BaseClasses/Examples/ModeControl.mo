within IceStorage.BaseClasses.Examples;
model ModeControl
  extends Modelica.Icons.Example;

  IceStorage.BaseClasses.ModeControl
    stoCon(
    dTif_min=0.5,
    smaLoa=10,
    TFre=273.15,
    waiTim=0) "Storage model controller"
              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable mod(table=[0,1; 3600,1; 3601,2; 5400,2;
        5401,3; 7200,3]) "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Step locLoa(
    height=2000,
    offset=-1000,
    startTime=5400) "Thermal load"
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  Modelica.Blocks.Sources.TimeTable TIn(table=[0,273.15; 3600,273.15; 5400,
        268.15; 5400,278.15; 7200,278.15]) "Inlet temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.TimeTable fraCha(table=[0,0.5; 3600,0.5; 5400,0.8; 7200,
        0.4]) "Fraction of charge"
    annotation (Placement(transformation(extent={{-60,-72},{-40,-52}})));
equation
  connect(mod.y, stoCon.u) annotation (Line(points={{-39,40},{-26,40},{-26,8},{
          -12,8}}, color={255,127,0}));
  connect(locLoa.y, stoCon.locLoa)
    annotation (Line(points={{-39,4},{-12,4}}, color={0,0,127}));
  connect(TIn.y, stoCon.TIn) annotation (Line(points={{-39,-30},{-26,-30},{-26,
          0},{-12,0}}, color={0,0,127}));
  connect(fraCha.y, stoCon.fraCha) annotation (Line(points={{-39,-62},{-20,-62},
          {-20,-4},{-12,-4}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "modelica://IceStorage/Resources/scripts/dymola/BaseClasses/Examples/ModeControl.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the controller of storage mode. </p>
</html>", revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
</html>"),
    experiment(
      StartTime=0,
      StopTime=7200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end ModeControl;

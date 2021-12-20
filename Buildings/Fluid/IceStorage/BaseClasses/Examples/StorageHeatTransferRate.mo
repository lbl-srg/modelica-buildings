within Buildings.Fluid.IceStorage.BaseClasses.Examples;
model StorageHeatTransferRate "Example to calculate qStar"
  extends Modelica.Icons.Example;
  parameter Real coeCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for charging curve";
  parameter Real coeDisCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for discharging curve";
  parameter Real dt = 3600 "Time step used in the samples for curve fitting";

  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/7200) "Fraction of charge"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IceStorage.BaseClasses.StorageHeatTransferRate norQSta(
    coeCha=coeCha,
    dtCha=dt,
    coeDisCha=coeDisCha,
    dtDisCha=dt) "Storage heat transfer rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.IntegerStep mod(
    startTime=3600,
    height=-1,
    offset=3) "Mode"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Modelica.Blocks.Sources.Step lmtd(
    startTime=3600,
    offset=1,
    height=-0.5)
               "lmtd start"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(fra.y, norQSta.fraCha) annotation (Line(points={{-19,0},{38,0}},
                      color={0,0,127}));
  connect(mod.y, norQSta.u) annotation (Line(points={{-19,50},{20,50},{20,6},{38,
          6}}, color={255,127,0}));
  connect(lmtd.y, norQSta.lmtdSta) annotation (Line(points={{-19,-50},{20,-50},{
          20,-6},{38,-6}}, color={0,0,127}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=7200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/IceStorage/BaseClasses/Examples/StorageHeatTransferRate.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
</html>", info="<html>
<p>This example is to validate the <a href=IceStorage.BaseClasses.StorageHeatTransferRate>IceStorage.BaseClasses.StorageHeatTransferRate</a>.</p>
</html>"));
end StorageHeatTransferRate;

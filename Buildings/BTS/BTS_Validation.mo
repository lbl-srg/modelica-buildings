within Buildings.BTS;
model BTS_Validation
  "Validation model comparing BuildingTimeSeries with MixedAir"
  //fixme: to be renamed
  extends Modelica.Icons.Example;



  Buildings.BTS.ChillerDXHeatingEconomizerDuplicate
    chillerDXHeatingEconomizer
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.CouplingTimeSeries
    couplingTimeSeries(bui(
    filNam    ="modelica://Buildings/Resources/Data/BTS/BTS_validation_test.mos"))
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  annotation(experiment(
      StartTime=11145600,
      StopTime=11750400,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BTS/BTS_Validation.mos"
        "Simulate and plot"));
end BTS_Validation;

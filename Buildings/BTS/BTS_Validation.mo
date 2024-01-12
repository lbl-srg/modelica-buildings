within Buildings.BTS;
model BTS_Validation
  "Validation model comparing BuildingTimeSeries with MixedAir"
  extends Modelica.Icons.Example;

  Buildings.BTS.ChillerDXHeatingEconomizerDuplicate
    chillerDXHeatingEconomizer
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.BTS.CouplingTimeSeriesDuplicate
    couplingTimeSeries(bui(
    filNam    ="modelica://Buildings/Resources/Data/BTS/BTS_validation_test.mos",
    T_aChiWat_nominal = chillerDXHeatingEconomizer.TSupChi_nominal))
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  annotation(experiment(
      StartTime=11145600,
      StopTime=11750400,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BTS/BTS_Validation.mos"
        "Simulate and plot"));
end BTS_Validation;

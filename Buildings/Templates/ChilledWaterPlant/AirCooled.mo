within Buildings.Templates.ChilledWaterPlant;
model AirCooled
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled,
    final have_eco = eco.have_eco,
    dat(eco(
        typ = eco.typ,
        have_valChiWatEcoByp = eco.have_valChiWatEcoByp)));

  Buildings.Templates.ChilledWaterPlant.Components.Economizer.None eco(
      redeclare final package MediumChiWat = MediumChiWat,
      final dat=dat.eco)
    "Waterside economizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-50})));

equation
  connect(VSecRet_flow.port_a,eco. port_a2)
    annotation (Line(points={{80,-70},{6,-70},{6,-60}}, color={0,127,255}));
  connect(eco.port_b2, chiSec.port_a2)
    annotation (Line(points={{6,-40},{6,-18}}, color={0,127,255}));

end AirCooled;

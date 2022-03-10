within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheatHotWaterG36
  extends VAVBoxCoolingOnly(redeclare
      UserProject.ZoneEquipment.VAVBoxReheatHotWaterG36 ter(dat(damVAV(
            dp_nominal=50), coiHea(dpAir_nominal=70))));
  Fluid.Sources.Boundary_pT bou2(redeclare final package Medium = MediumHea,
      nPorts=1)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = MediumHea,
      nPorts=1)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  UserProject.AirHandlersFans.VAVMultiZoneControlPoints sigAHU
    "Control signals from AHU"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  UserProject.ZoneControlPoints sigZon
    "Control signals from zone-level equipment"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(bou2.ports[1],ter.port_coiHeaSup)  annotation (Line(points={{-60,-40},
          {-2,-40},{-2,-19.8}}, color={0,127,255}));
  connect(ter.port_coiHeaRet, bou3.ports[1]) annotation (Line(points={{2,-19.8},
          {2,-80},{-60,-80},{-60,-80}}, color={0,127,255}));
  connect(sigAHU.busTer[1], ter.bus) annotation (Line(
      points={{-60,80},{-24,80},{-24,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
  connect(sigZon.bus, ter.bus) annotation (Line(
      points={{-60,40},{-40,40},{-40,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVBoxReheatHotWaterG36;

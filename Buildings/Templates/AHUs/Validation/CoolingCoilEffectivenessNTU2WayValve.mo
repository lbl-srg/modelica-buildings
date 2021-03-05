within Buildings.Templates.AHUs.Validation;
model CoolingCoilEffectivenessNTU2WayValve
  extends BaseNoEquipment(ahu(redeclare record RecordCoiCoo =
          Coils.Data.WaterBased (redeclare
            Buildings.Templates.AHUs.Coils.HeatExchangers.Data.DryCoilEffectivenessNTU
            datHex, redeclare
            Buildings.Templates.AHUs.Coils.Actuators.Data.TwoWayValve datAct(
              dpValve_nominal=5000)), redeclare Coils.WaterBased coiCoo(
          redeclare Buildings.Templates.AHUs.Coils.Actuators.TwoWayValve act,
          redeclare
          Buildings.Templates.AHUs.Coils.HeatExchangers.DryCoilEffectivenessNTU
          coi)));

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo,
      nPorts=2)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(bou2.ports[1], ahu.port_coiCooSup)
    annotation (Line(points={{-40,-48},{-2,-48},{-2,-20}}, color={0,127,255}));
  connect(bou2.ports[2], ahu.port_coiCooRet)
    annotation (Line(points={{-40,-52},{2,-52},{2,-20}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoolingCoilEffectivenessNTU2WayValve;

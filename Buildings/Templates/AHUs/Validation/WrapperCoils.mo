within Buildings.Templates.AHUs.Validation;
model WrapperCoils
  extends BaseNoEquipment(
    redeclare UserProject.AHUs.WrapperCoils ahu(coiCoo(dx(hex(mul(redeclare
                Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_KCA120S4
                datCoi), var(redeclare
                Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_KCA120S4
                datCoi))))));

  Fluid.Sources.Boundary_pT bou2(redeclare final package Medium = MediumHea,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = MediumHea,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(bou2.ports[1], ahu.port_coiHeaSup) annotation (Line(points={{-40,-40},
          {-7,-40},{-7,-19.8}}, color={0,127,255}));
  connect(ahu.port_coiHeaRet, bou3.ports[1]) annotation (Line(points={{-3,-19.8},
          {-3,-70},{-40,-70}}, color={0,127,255}));
end WrapperCoils;

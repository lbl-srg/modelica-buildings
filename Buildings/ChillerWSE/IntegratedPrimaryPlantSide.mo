within Buildings.ChillerWSE;
model IntegratedPrimaryPlantSide
  "Integrated WSE on the load side in a primary-only chilled water System"
  extends Buildings.ChillerWSE.BaseClasses.PartialIntegratedPrimary(
    final nVal=7,
    final m_flow_nominal={mChiller1_flow_nominal,mChiller2_flow_nominal,mWSE1_flow_nominal,
      mWSE2_flow_nominal,mChiller2_flow_nominal,mWSE2_flow_nominal,mChiller2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});
  extends Buildings.ChillerWSE.BaseClasses.PartialOperationSequenceInterface;

  Modelica.Blocks.Interfaces.RealInput yPum[nChi]
    "Constant normalized rotational speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput wseMod
    "=true, activate fully wse mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
equation
  connect(wseMod, booToRea.u) annotation (Line(points={{-120,80},{-92,80},{-92,74},
          {-81.2,74}}, color={255,0,255}));
  connect(booToRea.y, val2.y) annotation (Line(points={{-67.4,74},{-28,74},{-28,
          0},{-50,0},{-50,-8}}, color={0,0,127}));
  connect(booToRea.y, inv.u2)
    annotation (Line(points={{-67.4,74},{-8,74},{-8,89.2}}, color={0,0,127}));
  connect(inv.y, val1.y) annotation (Line(points={{-2.6,94},{8,94},{8,0},{50,0},
          {50,-8}}, color={0,0,127}));
  connect(val1.port_b, val2.port_a)
    annotation (Line(points={{40,-20},{0,-20},{-40,-20}}, color={0,127,255}));
end IntegratedPrimaryPlantSide;

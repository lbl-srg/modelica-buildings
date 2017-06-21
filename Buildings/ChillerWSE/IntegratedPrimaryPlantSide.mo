within Buildings.ChillerWSE;
model IntegratedPrimaryPlantSide
  "Integrated WSE on the load side in a primary-only chilled water System"
  extends Buildings.ChillerWSE.BaseClasses.PartialIntegratedPrimary(
    final nVal=6,
    final m_flow_nominal={mChiller1_flow_nominal,mChiller2_flow_nominal,mWSE1_flow_nominal,
      mWSE2_flow_nominal,nChi*mChiller2_flow_nominal,mWSE2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});
  extends Buildings.ChillerWSE.BaseClasses.PartialOperationSequenceInterface;

  Modelica.Blocks.Sources.BooleanExpression wseMod(y=if Modelica.Math.BooleanVectors.anyTrue(on[1:nChi]) then false else true)
   "If any chiller is on then the plant is not in free cooling mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
equation
  connect(booToRea.y,val6.y)  annotation (Line(points={{-47.4,74},{-28,74},{-28,
          0},{-50,0},{-50,-8}}, color={0,0,127}));
  connect(booToRea.y, inv.u2)
    annotation (Line(points={{-47.4,74},{-8,74},{-8,89.2}}, color={0,0,127}));
  connect(inv.y,val5.y)  annotation (Line(points={{-2.6,94},{8,94},{8,0},{50,0},
          {50,-8}}, color={0,0,127}));
  connect(val5.port_b,val6.port_a)
    annotation (Line(points={{40,-20},{0,-20},{-40,-20}}, color={0,127,255}));
  connect(wseMod.y, booToRea.u) annotation (Line(points={{-79,80},{-70,80},{-70,
          74},{-61.2,74}}, color={255,0,255}));
end IntegratedPrimaryPlantSide;

within Buildings.ChillerWSE.Validation;
model ElectricChillerParallel "Model that test electric chiller parallel"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      P_nominal=-per[1].QEva_flow_nominal/per[1].COP_nominal,
      mEva_flow_nominal=per[1].mEva_flow_nominal,
      mCon_flow_nominal=per[1].mCon_flow_nominal,
      sou1(nPorts=1, m_flow=2*mCon_flow_nominal),
      sou2(nPorts=1, m_flow=2*mEva_flow_nominal));

  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per[2] "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  ElectricChilerParallel chiPar(
    n=2,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    per=per,
    m1_flow_nominal=mEva_flow_nominal,
    m2_flow_nominal=mCon_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    dpValve_nominal={6000,6000})    "Identical chillers"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
  connect(chiPar.port_b1, res1.port_a) annotation (Line(points={{10,16},{20,16},
          {20,40},{32,40}}, color={0,127,255}));
  connect(chiPar.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,16},{-26,16},{-40,16}}, color={0,127,255}));
  connect(res2.port_a, chiPar.port_b2) annotation (Line(points={{-20,-20},{-16,-20},
          {-16,4},{-10,4}}, color={0,127,255}));
  connect(chiPar.port_a2, sou2.ports[1])
    annotation (Line(points={{10,4},{26,4},{40,4}}, color={0,127,255}));
  connect(greaterThreshold.y, chiPar.on[1]) annotation (Line(points={{-19,90},{-16,
          90},{-16,13},{-12,13}}, color={255,0,255}));
  connect(greaterThreshold.y, chiPar.on[2]) annotation (Line(points={{-19,90},{-16,
          90},{-16,15},{-12,15}}, color={255,0,255}));
  connect(TSet.y, chiPar.TSet) annotation (Line(points={{-59,60},{-28,60},{-28,
          10},{-12,10}},
                    color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ChillerWSE/Validation/ElectricChillerParallel.mos"
        "Simulate and Plot"));
end ElectricChillerParallel;

within Buildings.Fluid.Storage.Plant.Validation;
model OpenTank "Validation model for NetworkConnection with an open tank"
  extends ClosedTank(
    nom(useReturnPump=true),
    netCon(perRet(pressure(V_flow=preDroRet.m_flow_nominal/1000*{0,1,2},
                           dp=preDroRet.dp_nominal*{1.14,1,0.42}))));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 101325,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-90})));
  Buildings.Fluid.Storage.Plant.Controls.RemoteChargingReturn conRemChaRet
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(bou2.ports[1], mTanSup_flow.port_a) annotation (Line(points={{-20,-90},
          {-12,-90},{-12,0},{-70,0},{-70,10}}, color={0,127,255}));
  connect(conRemChaRet.y, netCon.yRet)
    annotation (Line(points={{-19,70},{14,70},{14,11}}, color={0,0,127}));
  connect(uAva.y, conRemChaRet.uAva) annotation (Line(points={{-79,110},{-60,110},
          {-60,76},{-42,76}}, color={255,0,255}));
  connect(uRemCha.y, conRemChaRet.uRemCha) annotation (Line(points={{-119,90},{-56,
          90},{-56,72},{-42,72}}, color={255,0,255}));
  connect(mTanSet_flow.y, conRemChaRet.mTanSet_flow) annotation (Line(points={{-79,
          70},{-52,70},{-52,68},{-41,68}}, color={0,0,127}));
  connect(mTanRet_flow.m_flow, conRemChaRet.mTan_flow) annotation (Line(points={
          {-59,-20},{-44,-20},{-44,64},{-41,64}}, color={0,0,127}));
annotation(experiment(Tolerance=1e-06, StopTime=3600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/OpenTank.mos"
        "Simulate and plot"));
end OpenTank;

within Buildings.Fluid.Storage.Plant;
model IdealConnection
  "Idealised hydraulic connection between the storage plant and the district network"
  extends BaseClasses.PartialBranchPorts;
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSouSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=nom.m_flow_nominal*1E-6,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source on the supply line"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSouRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=nom.m_flow_nominal*1E-6,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source on the return line"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow(
    final quantity = "MassFlowRate",
    final unit = "kg/s")
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-90,110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-20,110})));
  Modelica.Blocks.Interfaces.RealInput mChiSet_flow(
    final quantity = "MassFlowRate",
    final unit = "kg/s")
    "Flow rate setpoint of the chiller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPreSup(
    redeclare final package Medium = Medium)
    "Pressure rise on the supply line"
    annotation (Placement(transformation(extent={{10,20},{-10,0}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPreRet(
    redeclare final package Medium = Medium)
    "Pressure rise on the return line"
    annotation (Placement(transformation(extent={{10,-20},{-10,-40}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloSup(
    redeclare final package Medium = Medium)
    "Mass flow rate on the supply line"
    annotation (Placement(transformation(extent={{-60,70},{-40,50}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloRet(
    redeclare final package Medium = Medium)
    "Mass flow rate on the return line"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Fluid.Storage.Plant.Controls.IdealPumpPower idePumPowSup
    "Ideal pump power on the supply line"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.Storage.Plant.Controls.IdealPumpPower idePumPowRet
    "Ideal pump power on the return line"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Interfaces.RealOutput PEleSup(
    final quantity="Power",
    final unit="W") "Estimated power consumption of the supply pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,30}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,20})));
  Modelica.Blocks.Interfaces.RealOutput PEleRet(final quantity="Power", final
      unit="W") "Estimated power consumption of the return pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-10}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-20})));
  Buildings.Fluid.BaseClasses.ActuatorFilter fil(
    f=20/(2*Modelica.Constants.pi*60),
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final n=2,
    final normalized=true) "Second order filter to improve numerics"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,10})));
equation
  connect(add2.u2, mTanSet_flow)
    annotation (Line(points={{-82,4},{-90,4},{-90,110}}, color={0,0,127}));
  connect(add2.u1, mChiSet_flow)
    annotation (Line(points={{-82,16},{-84,16},{-84,28},{-70,28},{-70,110}},
                                                           color={0,0,127}));
  connect(port_aFroChi, senMasFloSup.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(senMasFloSup.port_b, ideSouSup.port_a)
    annotation (Line(points={{-40,60},{-10,60}}, color={0,127,255}));
  connect(port_bToNet, ideSouSup.port_b)
    annotation (Line(points={{100,60},{10,60}}, color={0,127,255}));
  connect(ideSouRet.port_b, senMasFloRet.port_b)
    annotation (Line(points={{-10,-60},{-40,-60}}, color={0,127,255}));
  connect(senMasFloRet.port_a, port_bToChi)
    annotation (Line(points={{-60,-60},{-100,-60}}, color={0,127,255}));
  connect(port_aFroNet, ideSouRet.port_a)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(senRelPreSup.p_rel, idePumPowSup.dpMachine)
    annotation (Line(points={{0,19},{0,26},{39,26}}, color={0,0,127}));
  connect(idePumPowSup.m_flow, senMasFloSup.m_flow)
    annotation (Line(points={{39,34},{-50,34},{-50,49}}, color={0,0,127}));
  connect(senMasFloRet.m_flow, idePumPowRet.m_flow)
    annotation (Line(points={{-50,-49},{-50,-6},{39,-6}}, color={0,0,127}));
  connect(senRelPreRet.p_rel, idePumPowRet.dpMachine)
    annotation (Line(points={{0,-21},{0,-14},{39,-14}}, color={0,0,127}));
  connect(idePumPowRet.PEle, PEleRet) annotation (Line(points={{61,-10},{110,-10}},
                               color={0,0,127}));
  connect(idePumPowSup.PEle, PEleSup) annotation (Line(points={{61,30},{110,30}},
                             color={0,0,127}));
  connect(senRelPreSup.port_a, ideSouSup.port_b) annotation (Line(points={{10,
          10},{14,10},{14,60},{10,60}}, color={0,127,255}));
  connect(senRelPreSup.port_b, ideSouSup.port_a) annotation (Line(points={{-10,
          10},{-14,10},{-14,60},{-10,60}}, color={0,127,255}));
  connect(senRelPreRet.port_a, ideSouRet.port_a) annotation (Line(points={{10,
          -30},{14,-30},{14,-60},{10,-60}}, color={0,127,255}));
  connect(senRelPreRet.port_b, ideSouRet.port_b) annotation (Line(points={{-10,
          -30},{-14,-30},{-14,-60},{-10,-60}}, color={0,127,255}));
  connect(add2.y, fil.u)
    annotation (Line(points={{-58,10},{-52,10}}, color={0,0,127}));
  connect(fil.y, ideSouSup.m_flow_in) annotation (Line(points={{-29,10},{-20,10},
          {-20,74},{-6,74},{-6,68}}, color={0,0,127}));
  connect(fil.y, ideSouRet.m_flow_in) annotation (Line(points={{-29,10},{-20,10},
          {-20,-44},{6,-44},{6,-52}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This ideal model is a simplified version of
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>.
In this model, both sides of the connection has an ideal flow source
(<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.IdealSource\">
Buildings.Fluid.Movers.BaseClasses.IdealSource</a>)
to force a flow rate to maintain the flow rate setpoint of at the tank.
</p>
<p>
Because the open tank forces the storage plant to be at atmospheric temperature,
on both supply and return sides:
</p>
<ul>
<li>
A pump is needed to generate a flow from the tank to the pressurised network,
both when the plant is outputting CHW or being charged by a remote plant.
</li>
<li>
A valve is needed to throttle the flow from the pressurised network to the tank
at atmospheric pressure.
</li>
</ul>
</html>"));
end IdealConnection;

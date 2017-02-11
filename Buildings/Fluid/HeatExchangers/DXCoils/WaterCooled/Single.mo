within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model Single "Single speed water-cooled DX coils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters(
         redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi);

  replaceable package Medium1 =Buildings.Media.Air;
  replaceable package Medium2 =Buildings.Media.Water;


  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Pressure drop at m_flow_nominal in the evaporator";

  parameter Modelica.SIunits.PressureDifference dpCon_nominal
    "Pressure drop at mCon_flow_nominal in the condenser";

  AirCooled.SingleSpeed sinSpeDX(
    redeclare package Medium = Medium1,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
    dxCoo(redeclare WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
          wetCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity2 cooCap,
                 redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDewPt(redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per))),
          dryCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity2 cooCap,
                 redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDryPt(redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per)))),
    eva(nomVal=Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
                                             Q_flow_nominal=datCoi.sta[nSta].nomVal.Q_flow_nominal,
                                             COP_nominal=datCoi.sta[nSta].nomVal.COP_nominal,
                                             SHR_nominal=datCoi.sta[nSta].nomVal.SHR_nominal,
                                             m_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
                                             TEvaIn_nominal=datCoi.sta[nSta].nomVal.TEvaIn_nominal,
                                             TConIn_nominal=datCoi.sta[nSta].nomVal.TConIn_nominal,
                                             phiIn_nominal=datCoi.sta[nSta].nomVal.phiIn_nominal,
                                             p_nominal=datCoi.sta[nSta].nomVal.p_nominal,
                                             tWet= datCoi.sta[nSta].nomVal.tWet,
                                             gamma=datCoi.sta[nSta].nomVal.gamma)),
    final use_mCon_flow=true,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  HeaterCooler_u watCooCon(
        redeclare package Medium=Medium2,
        m_flow_nominal = datCoi.sta[nSta].nomVal.mCon_flow_nominal,
        dp_nominal = dpCon_nominal,
        Q_flow_nominal=-datCoi.sta[nSta].nomVal.Q_flow_nominal*(1+1/datCoi.sta[nSta].nomVal.COP_nominal))
                                    "Water-cooled condenser"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));

protected
  Modelica.SIunits.HeatFlowRate QCon_flow_nominal(min=0)
    "Nominal heat rejection (positive number)";

  Modelica.Blocks.Sources.RealExpression u(y=(sinSpeDX.dxCoo.Q_flow + sinSpeDX.P)
        /(-datCoi.sta[nSta].nomVal.Q_flow_nominal*(1+1/datCoi.sta[nSta].nomVal.COP_nominal))) "Signal of total heat flow removed by condenser"
                                                                    annotation (
     Placement(transformation(
        extent={{-13,-10},{13,10}},
        rotation=0,
        origin={-67,0})));
public
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium=Medium1)
    "Fluid connector b for evaporator(positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium=Medium1)
    "Fluid connector a for evaporator(positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium=Medium2)
    "Fluid connector a for condenser (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium=Medium2)
    "Fluid connector b for condenser (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
protected
  Modelica.Blocks.Sources.RealExpression mCon(final y=port_a2.m_flow)
    "Inlet water mass flow rate at the condenser"
    annotation (Placement(transformation(extent={{-80,10},{-54,30}})));
public
  Sensors.TemperatureTwoPort senTem(redeclare package Medium=Medium2,
      m_flow_nominal=datCoi.sta[nSta].nomVal.mCon_flow_nominal)
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
equation
  connect(u.y, watCooCon.u) annotation (Line(points={{-52.7,0},{20,0},{20,-34},{
          12,-34}}, color={0,0,127}));
  connect(sinSpeDX.port_b, port_b1) annotation (Line(points={{10,40},{80,40},{80,
          80},{100,80}}, color={0,127,255}));
  connect(sinSpeDX.port_a, port_a1) annotation (Line(points={{-10,40},{-80,40},{
          -80,80},{-100,80}}, color={0,127,255}));
  connect(watCooCon.port_b, port_b2) annotation (Line(points={{-10,-40},{-80,-40},
          {-80,-80},{-100,-80}}, color={0,127,255}));
  connect(watCooCon.port_a, senTem.port_b)
    annotation (Line(points={{10,-40},{40,-40},{30,-40}}, color={0,127,255}));
  connect(senTem.port_a, port_a2) annotation (Line(points={{50,-40},{80,-40},{80,
          -80},{100,-80}}, color={0,127,255}));
  connect(senTem.T, sinSpeDX.TConIn) annotation (Line(points={{40,-29},{40,-29},
          {40,60},{-40,60},{-40,43},{-11,43}}, color={0,0,127}));
  connect(mCon.y, sinSpeDX.mCon_flow) annotation (Line(points={{-52.7,20},{-40,20},
          {-40,36.8},{-11,36.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Single;

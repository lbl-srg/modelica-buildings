within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model SingleSpeed "Single speed water-cooled DX coils"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters(
         redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi);
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
         redeclare replaceable package Medium1=Buildings.Media.Air,
         redeclare replaceable package Medium2=Buildings.Media.Water,
         final m1_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
         final m2_flow_nominal=datCoi.sta[nSta].nomVal.mCon_flow_nominal);

  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Pressure drop at nominal flowrate in the evaporator";

  parameter Modelica.SIunits.PressureDifference dpCon_nominal
    "Pressure drop at nominal flowrate in the condenser";

public
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
        iconTransformation(extent={{-120,72},{-100,92}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput QEvaSen_flow
    "Sensible heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,24},{120,44}})));
  Modelica.Blocks.Interfaces.RealOutput QEvaLat_flow
    "Latent heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed sinSpeDX(
    redeclare package Medium = Medium1,
    redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
    dxCoo(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
          wetCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity2 cooCap,
                 redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDewPt(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per))),
          dryCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity2 cooCap,
                 redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDryPt(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
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
    final dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u watCooCon(
        redeclare package Medium=Medium2,
        final m_flow_nominal = datCoi.sta[nSta].nomVal.mCon_flow_nominal,
        final dp_nominal = dpCon_nominal,
        final Q_flow_nominal=-datCoi.sta[nSta].nomVal.Q_flow_nominal*(1+1/datCoi.sta[nSta].nomVal.COP_nominal))
                                    "Water-cooled condenser"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));

  Modelica.Blocks.Sources.RealExpression u(final y=(-sinSpeDX.dxCoo.Q_flow + sinSpeDX.P)
        /(-datCoi.sta[nSta].nomVal.Q_flow_nominal*(1+1/datCoi.sta[nSta].nomVal.COP_nominal)))
        "Signal of total heat flow removed by condenser"
        annotation (
     Placement(transformation(
        extent={{-13,-10},{13,10}},
        rotation=0,
        origin={-67,0})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium=Medium2,
      m_flow_nominal=datCoi.sta[nSta].nomVal.mCon_flow_nominal)
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));

protected
  Modelica.Blocks.Sources.RealExpression mCon(final y=port_a2.m_flow)
    "Inlet water mass flow rate at the condenser"
    annotation (Placement(transformation(extent={{-80,10},{-54,30}})));

equation
  connect(u.y, watCooCon.u) annotation (Line(points={{-52.7,0},{20,0},{20,-34},{
          12,-34}}, color={0,0,127}));
  connect(sinSpeDX.port_b, port_b1) annotation (Line(points={{10,40},{80,40},{80,
          60},{100,60}}, color={0,127,255}));
  connect(sinSpeDX.port_a, port_a1) annotation (Line(points={{-10,40},{-80,40},{
          -80,60},{-100,60}}, color={0,127,255}));
  connect(watCooCon.port_b, port_b2) annotation (Line(points={{-10,-40},{-80,-40},
          {-80,-60},{-100,-60}}, color={0,127,255}));
  connect(watCooCon.port_a, senTem.port_b)
    annotation (Line(points={{10,-40},{40,-40},{30,-40}}, color={0,127,255}));
  connect(senTem.port_a, port_a2) annotation (Line(points={{50,-40},{80,-40},{80,
          -60},{100,-60}}, color={0,127,255}));
  connect(senTem.T, sinSpeDX.TConIn) annotation (Line(points={{40,-29},{40,-29},
          {40,0},{-20,0},{-20,43},{-11,43}},   color={0,0,127}));
  connect(mCon.y, sinSpeDX.mCon_flow) annotation (Line(points={{-52.7,20},{-20,20},
          {-20,36.8},{-11,36.8}}, color={0,0,127}));
  connect(sinSpeDX.on, on) annotation (Line(points={{-11,48},{-60,48},{-60,80},{
          -112,80}}, color={255,0,255}));
  connect(sinSpeDX.P, P) annotation (Line(points={{11,49},{62,49},{62,80},{110,80}},
        color={0,0,127}));
  connect(sinSpeDX.QSen_flow, QEvaSen_flow) annotation (Line(points={{11,47},{58,
          47},{58,34},{110,34}}, color={0,0,127}));
  connect(sinSpeDX.QLat_flow, QEvaLat_flow) annotation (Line(points={{11,45},{54,
          45},{54,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-78,74},{80,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-107,66},{94,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,56},{94,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,12},{98,-8}},
          lineColor={0,0,127},
          textString="QEvaLat"),Text(
          extent={{54,50},{98,30}},
          lineColor={0,0,127},
          textString="QEvaSen"),
        Rectangle(
          extent={{6,-66},{106,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,-56},{106,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,-66},{94,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,100},{98,80}},
          lineColor={0,0,127},
          textString="P")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleSpeed;

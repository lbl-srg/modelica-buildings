within Buildings.Experimental.DHC.Loads.DHW;
model HeatPumpWaterHeaterWithTank
  "A model for domestic water heating served by heat pump water heater and local storage tank"
  extends Buildings.Experimental.DHC.Loads.DHW.BaseClasses.PartialFourPortDHW(
     final have_PEle=true, mDH_flow_nominal=heaPum.QEva_flow_nominal/
        cp2_default/heaPum.dTEva_nominal);
  constant Modelica.Units.SI.SpecificHeatCapacity cp2_default=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(p=Medium.p_default,
      T=Medium.T_default)) "Specific heat capacity of the fluid";
  parameter
    Buildings.Experimental.DHC.Loads.DHW.Data.GenericHeatPumpWaterHeater datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{-96,-96},{-84,-84}})));
  parameter Real k=0.1 "Proportioanl gain of circulation pump controller";
  parameter Real Ti=60 "Integrator time constant of circulation pump controller";
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTankOut(redeclare package
      Medium = Medium, m_flow_nominal=mHw_flow_nominal)
    annotation (Placement(transformation(extent={{-20,44},{0,64}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=datWatHea.mHex_flow_nominal,
    m2_flow_nominal=mDH_flow_nominal,
    dTEva_nominal=datWatHea.dTEva_nominal,
    dTCon_nominal=datWatHea.dTCon_nominal,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    QCon_flow_max = datWatHea.QCon_flow_max,
    QCon_flow_nominal=datWatHea.QCon_flow_nominal,
    dp1_nominal=datWatHea.dp1_nominal,
    dp2_nominal=datWatHea.dp2_nominal)
              "Domestic hot water heater"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemHPOut(redeclare package Medium =
        Medium, m_flow_nominal=datWatHea.mHex_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,6})));
  Fluid.Movers.FlowControlled_m_flow pumHex(
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    redeclare package Medium = Medium,
    m_flow_nominal=datWatHea.mHex_flow_nominal,
    riseTime=10,
    massFlowRates={0,0.5,1}*datWatHea.mHex_flow_nominal)
    "Pump with m_flow input"
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  Fluid.Storage.StratifiedEnhancedInternalHex
    tanSte(
    T_start=datWatHea.TTan_nominal,
           energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium,
    redeclare package MediumHex = Medium,
    hTan=datWatHea.hTan,
    dIns=datWatHea.dIns,
    VTan=datWatHea.VTan,
    nSeg=datWatHea.nSeg,
    hHex_a=datWatHea.hHex_a,
    hHex_b=datWatHea.hHex_b,
    Q_flow_nominal=datWatHea.QTan_flow_nominal,
    TTan_nominal=datWatHea.TTan_nominal,
    THex_nominal=datWatHea.THex_nominal,
    mHex_flow_nominal=datWatHea.mHex_flow_nominal,
    show_T=true,
    m_flow_nominal=mHw_flow_nominal)
    "Tank with steady-state heat exchanger balance"
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemSen
    "Temperature of the hot water tank"
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter
                                   dTTanHex2(k=datWatHea.mHex_flow_nominal)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Controls.OBC.CDL.Reals.PID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electric power required for pumping equipment"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow
    "Actual heat pump heating heat flow rate added to fluid"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
equation
  connect(heaPum.port_b1, senTemHPOut.port_a)
    annotation (Line(points={{10,6},{40,6}},              color={0,127,255}));
  connect(senTemTankOut.port_b, port_b1)
    annotation (Line(points={{0,54},{20,54},{20,60},{100,60}},
                                                color={0,127,255}));
  connect(port_b2, heaPum.port_b2) annotation (Line(points={{-100,-60},{-10,-60},
          {-10,-6}},                   color={0,127,255}));
  connect(heaPum.P,PHea)  annotation (Line(points={{11,0},{24,0},{24,-14},{76,-14},
          {76,0},{110,0}},          color={0,0,127}));
  connect(pumHex.port_a, senTemHPOut.port_b) annotation (Line(points={{60,40},{
          70,40},{70,6},{60,6}},
                              color={0,127,255}));
  connect(pumHex.port_b, tanSte.portHex_a) annotation (Line(points={{40,40},{-30,
          40},{-30,46.2},{-40,46.2}}, color={0,127,255}));
  connect(tanSte.portHex_b, heaPum.port_a1) annotation (Line(points={{-40,42},{-40,
          20},{-10,20},{-10,6}}, color={0,127,255}));
  connect(tanSte.port_a, senTemTankOut.port_a) annotation (Line(points={{-40,50},
          {-30,50},{-30,54},{-20,54}}, color={0,127,255}));
  connect(tanSte.port_b, port_a1) annotation (Line(points={{-60,50},{-80,50},{-80,
          60},{-100,60}}, color={0,127,255}));
  connect(bou.ports[1], senTemHPOut.port_b) annotation (Line(points={{80,40},{
          70,40},{70,6},{60,6}}, color={0,127,255}));
  connect(dTTanHex2.y, pumHex.m_flow_in)
    annotation (Line(points={{42,90},{50,90},{50,52}}, color={0,0,127}));
  connect(heaPum.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,
          -60},{100,-60}}, color={0,127,255}));
  connect(conPI.y, dTTanHex2.u)
    annotation (Line(points={{12,90},{18,90}}, color={0,0,127}));
  connect(TSetHw, conPI.u_s) annotation (Line(points={{-110,0},{-88,0},{-88,90},
          {-12,90}}, color={0,0,127}));
  connect(tanTemSen.T, conPI.u_m) annotation (Line(points={{-19,72},{-8,72},{-8,
          70},{0,70},{0,78}}, color={0,0,127}));
  connect(pumHex.P, PPum) annotation (Line(points={{39,49},{32,49},{32,-20},{110,
          -20}}, color={0,0,127}));
  connect(heaPum.QCon_flow, QCon_flow) annotation (Line(points={{11,9},{20,9},{
          20,20},{110,20}}, color={0,0,127}));
  connect(TSetHw, heaPum.TSet) annotation (Line(points={{-110,0},{-20,0},{-20,9},
          {-12,9}}, color={0,0,127}));
  connect(tanTemSen.port, tanSte.heaPorVol[4])
    annotation (Line(points={{-40,72},{-50,72},{-50,50}}, color={191,0,0}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model is an example of a domestic hot water (DHW) substation for an  
ultra-low-temperature district heating (ULTDH) network. It includes a micro heat 
pump and storage tank with direct thermostatic mixing rather than heat exchange.
</p>
<p>
For more info, please see Fig. 3 in <i>Evaluations of different domestic hot water 
preparing methods with ultra-low-temperature district heating</i> by X. Yang, 
H. Li, and S. Svendsen at <a href=https:/doi.org/10.1016/j.energy.2016.04.109> 
doi.org/10.1016/j.energy.2016.04.109</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 7, 2022 by Dre Helmns:<br/>
Created generation model.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,-60},{20,-40}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,22},{20,-48}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,10},{20,30}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,50},{20,20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,40},{20,60}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,50},{-20,-50}},
          color={95,95,95},
          thickness=1),
        Line(
          points={{20,50},{20,-50}},
          color={95,95,95},
          thickness=1),
        Polygon(
          points={{-140,86},{-140,86}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag),
        Polygon(
          points={{20,40},{18,38},{14,36},{8,34},{8,26},{14,28},{18,30},{20,32},
              {20,40}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag)}),                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterWithTank;

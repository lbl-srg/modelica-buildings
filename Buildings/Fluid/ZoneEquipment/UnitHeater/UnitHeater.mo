within Buildings.Fluid.ZoneEquipment.UnitHeater;
model UnitHeater "System model for a zonal unit heater"

  extends Buildings.Fluid.ZoneEquipment.BaseClasses1.EquipmentInterfaces(final
      cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses1.Types.CooSou.noCoo,
      final oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses1.Types.OAPorts.noOA);

  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal(
    final min = 0)
    "Heat flow rate of electric heating coil at full power"
    annotation(Dialog(enable=not has_HW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(enable=has_HW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(group="Cooling coil parameters"));

  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow heaCoiHW(
    redeclare final package Medium1 = MediumHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mHotWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UAHeaCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if
       has_HW "Hot water heating coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={60,-30})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal)
    "Supply fan"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{0,140},{20,160}})),
      Dialog(group="Fan parameters"));
  Buildings.Fluid.FixedResistances.PressureDrop totRes(
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
    final allowFlowReversal=false,
    redeclare final package Medium = MediumA) "Total resistance"
    annotation (Placement(transformation(extent={{156,-10},{176,10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if not has_HW
    "Electric heating coil"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Find normalized fan signal by dividing actual fan mass flowrate by nominal flowrate"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

equation
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{1,80},{2,80},{2,12}},    color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{13,5},{28,5},
          {28,80},{100,80},{100,110},{298,110}},
                                        color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,120},{-202,120},{-202,80},{-22,80}},
                                                  color={0,0,127}));
  connect(uHea, valHW.y) annotation (Line(points={{-380,-80},{-60,-80},{-60,-80},
          {-48,-80}}, color={0,0,127}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-380,-80},{-60,-80},{-60,
          36},{48,36}},  color={0,0,127}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-380,-40},{-80,-40},{-80,-148},
          {80,-148},{80,-80},{92,-80}}, color={0,0,127}));
  connect(valHW.port_b, heaCoiHW.port_b1) annotation (Line(points={{-36,-70},{
          -36,-36},{50,-36}},
                           color={0,127,255}));
  connect(heaCoiHW.port_a1, VHW_flow.port_b)
    annotation (Line(points={{70,-36},{78,-36},{78,-52},{4,-52},{4,-80}},
                                                       color={0,127,255}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{370,110}}, color={0,0,127}));
  if not has_ven then
  end if;
  connect(vAirMix.port_b, fan.port_a) annotation (Line(points={{-80,0},{-40,0},{
          -40,0},{-8,0}},  color={0,127,255}));
  connect(fan.port_b, heaCoiEle.port_a) annotation (Line(points={{12,0},{40,0},
          {40,30},{50,30}}, color={0,127,255}));
  connect(fan.port_b, heaCoiHW.port_a2) annotation (Line(points={{12,0},{40,0},
          {40,-24},{50,-24}}, color={0,127,255}));
  connect(totRes.port_b, TAirLvg.port_a)
    annotation (Line(points={{176,0},{240,0},{240,0}},   color={0,127,255}));
  connect(heaCoiEle.port_b, totRes.port_a) annotation (Line(points={{70,30},{
          140,30},{140,0},{156,0}}, color={0,127,255}));
  connect(heaCoiHW.port_b2, totRes.port_a) annotation (Line(points={{70,-24},{
          140,-24},{140,0},{156,0}}, color={0,127,255}));
  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-360,-180},{360,180}})),
    Documentation(info="<html>
    <p>
    This is a zonal unit heater system model. The system contains
    a supply fan, an electric or hot-water heating coil, and a mixing box. 
    </p>
    The control module for the system is implemented separately in
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.UnitHeater.Controls\">
    Buildings.Fluid.ZoneEquipment.UnitHeater.Controls</a>:
    <ul>
    <li>
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.ConstantFanVariableHeating\">
    ConstantFanVariableHeating</a>:
    Modulate the heating coil valve position/electric heater signal to regulate the zone temperature
    at or above the heating setpoint temperature. The fan is enabled and operated at the 
    maximum speed when there are zone heating or cooling loads. It is run at minimum speed when
    zone is occupied but there are no loads.
    </li>
    </ul>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    December 15, 2022 by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end UnitHeater;

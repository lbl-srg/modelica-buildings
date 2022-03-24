within Buildings.Experimental.DHC.EnergyTransferStations.Cooling;
model DirectUncontrolled "Direct cooling ETS model for district energy systems 
  without in-building pumping or deltaT control"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final typ=DHC.Types.DistrictSystemType.Cooling,
    final have_weaBus=false,
    final have_chiWat=true,
    final have_heaWat=false,
    final have_hotWat=false,
    final have_eleHea=false,
    final nFue=0,
    final have_eleCoo=false,
    final have_pum=false,
    final have_fan=false,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  // Pressure drops
  parameter Modelica.Units.SI.PressureDifference dpSup(
    final min=0,
    displayUnit="Pa")=5000
    "Pressure drop in the ETS supply side";
  parameter Modelica.Units.SI.PressureDifference dpRet(
    final min=0,
    displayUnit="Pa")=5000
    "Pressure drop in the ETS return side";
  Buildings.Fluid.FixedResistances.PressureDrop pipSup(
    redeclare final package Medium=MediumSer,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpSup)
    "Supply pipe"
    annotation (Placement(transformation(extent={{20,-290},{40,-270}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipRet(
    redeclare final package Medium=MediumSer,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpRet)
    "Return pipe"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=m_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=m_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{-178,210},{-158,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=m_flow_nominal)
    "Building supply temperature sensor"
    annotation (Placement(transformation(extent={{240,190},{260,210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=m_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{240,-270},{260,-290}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=MediumSer)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-78,-290},{-58,-270}})));
  Modelica.Blocks.Math.Add dTdis(
  final k1=-1,
  final k2=1)
    "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Modelica.Blocks.Math.Gain cp(
  final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="Power",
    final unit="W",
    displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(
        transformation(extent={{300,-130},{340,-90}}), iconTransformation(
          extent={{300,-130},{340,-90}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
     annotation (Placement(transformation(
          extent={{300,-170},{340,-130}}), iconTransformation(extent={{300,-130},
            {340,-90}})));
  Modelica.Blocks.Continuous.Integrator int(
    final k=1)
    "Integration"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
protected
  final parameter MediumSer.ThermodynamicState sta_default=MediumSer.setState_pTX(
    T=MediumSer.T_default,
    p=MediumSer.p_default,
    X=MediumSer.X_default)
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=MediumSer.specificHeatCapacityCp(
    sta_default)
    "Specific heat capacity of the fluid";
equation
  connect(ports_aChiWat[1],senTBuiRet. port_a)
    annotation (Line(points={{-300,200},{-178,200}}, color={0,127,255}));
  connect(senTBuiRet.T, dTdis.u1)
    annotation (Line(points={{-168,189},{-200,189},{-200,-104},{-162,-104}}, color={0,0,127}));
  connect(port_aSerCoo, senTDisSup.port_a)
    annotation (Line(points={{-300,-280},{-140,-280}}, color={0,127,255}));
  connect(senTDisSup.T, dTdis.u2)
    annotation (Line(points={{-130,-269},{-130,-258},{-200,-258},{-200,-116},{-162,-116}}, color={0,0,127}));
  connect(pro.y, cp.u)
    annotation (Line(points={{-59,-110},{-2,-110}}, color={0,0,127}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-120,-280},{-78,-280}}, color={0,127,255}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-68,-269},{-98,-269},{-98,-116},{-82,-116}}, color={0,0,127}));
  connect(dTdis.y, pro.u1)
    annotation (Line(points={{-139,-110},{-110,-110},{-110,-104},{-82,-104}}, color={0,0,127}));
  connect(senTBuiRet.port_b, pipRet.port_a)
    annotation (Line(points={{-158,200},{20,200}}, color={0,127,255}));
  connect(cp.y, Q_flow)
    annotation (Line(points={{21,-110},{320,-110}}, color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{21,-110},{70.5,-110},{70.5,-150},{118,-150}}, color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{141,-150},{320,-150}},                           color={0,0,127}));
  connect(senMasFlo.port_b, pipSup.port_a)
    annotation (Line(points={{-58,-280},{20,-280}}, color={0,127,255}));
  connect(pipSup.port_b, senTBuiSup.port_a)
    annotation (Line(points={{40,-280},{140,-280},{140,-260},{220,-260},{220,200},{240,200}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1])
    annotation (Line(points={{260,200},{300,200}}, color={0,127,255}));
  connect(pipRet.port_b, senTDisRet.port_a)
    annotation (Line(points={{40,200},{180,200},{180,-280},{240,-280}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerCoo)
    annotation (Line(points={{260,-280},{300,-280}}, color={0,127,255}));
  annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Direct cooling energy transfer station (ETS) model without in-building pumping or 
deltaT control. The design is based on a typical district cooling ETS described in 
ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>. 
As shown in the figure below, the district and building piping are hydronically 
coupled. This direct ETS connection relies on individual thermostatic control 
valves at each individual in-building terminal unit for control. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/DirectUncontrolled.PNG\" alt=\"DHC.ETS.DirectUncontrolled\"/> 
</p>
<h4>
Reference
</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2019). 
Chapter 5: End User Interface. In <i>District Cooling Guide</i>, Second Edition and 
<i>Owner's Guide for Buildings Served by District Cooling</i>. 
</p>
</html>",
      revisions="<html>
<ul>
<li>March 20, 2022, by Chengnan Shi:<br/>Update with base class partial model.</li>
<li>Novermber 13, 2019, by Kathryn Hinklman:<br/>First implementation. </li>
</ul>
</html>"));
end DirectUncontrolled;

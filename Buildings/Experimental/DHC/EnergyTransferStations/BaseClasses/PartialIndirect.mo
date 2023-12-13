within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
model PartialIndirect
  "Partial indirect energy transfer station for district energy systems"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final have_weaBus=false,
    final have_hotWat=false,
    final have_eleHea=false,
    final nFue=0,
    final have_eleCoo=false,
    final have_pum=false,
    final have_fan=false);
  // mass flow rates
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal(
    final min=0)
    "Nominal mass flow rate of district side"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal(
    final min=0)
    "Nominal mass flow rate of building side"
    annotation(Dialog(group="Nominal condition"));
  // Primary supply control valve
  parameter Modelica.Units.SI.PressureDifference dpConVal_nominal(
    final min=0,
    displayUnit="Pa")=6000
    "Nominal pressure drop of fully open control valve"
    annotation(Dialog(group="Nominal condition"));
  // Heat exchanger
  parameter Modelica.Units.SI.PressureDifference dp1_nominal(
    final min=0,
    displayUnit="Pa")
    "Nominal pressure difference on primary side"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(
    final min=0,
    displayUnit="Pa")
    "Nominal pressure difference on secondary side"
    annotation (Dialog(group="Heat exchanger"));
  parameter Boolean use_Q_flow_nominal=true
    "Set to true to specify Q_flow_nominal and temeratures, or to false to specify effectiveness"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal heat transfer (positive for heat transfer from district to building)"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a1_nominal(
    final min=273.15,
    final max=373.15)
    "Nominal temperature at port a1 (district supply)"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a2_nominal(
    final min=273.15,
    final max=373.15)
    "Nominal temperature at port a2 (building return)"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Efficiency eta(
    final min=0,
    final max=1)=0.8
    "Constant effectiveness"
    annotation (Dialog(group="Heat exchanger"));
   //Controller parameters
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(
    final min=0,
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Units.SI.Time Ti(
    final min=Modelica.Constants.small)=120
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    final min=0)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="PID controller"));
  parameter Real yMin=0.01
    "Lower limit of output"
    annotation (Dialog(group="PID controller"));
  Modelica.Blocks.Interfaces.RealInput TSetBuiSup
    "Setpoint temperature for building supply"
    annotation (Placement(transformation(extent={{-340,-20},{-300,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW")
    "Measured heating demand at the ETS"
    annotation (Placement(
        transformation(extent={{300,-140},{340,-100}}),iconTransformation(extent={{300,
            -140},{340,-100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
     annotation (Placement(transformation(extent={{300,-180},{340,-140}}),
     iconTransformation(extent={{300,-130},{340,-90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-220,-290},{-200,-270}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=MediumSer)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-160,-290},{-140,-270}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage conVal(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal,
    final dpValve_nominal=dpConVal_nominal,
    riseTime(displayUnit="s") = 10,
    y_start=0)
    "Control valve"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare package Medium1 = MediumSer,
    redeclare package Medium2 = MediumBui,
    final m1_flow_nominal=mDis_flow_nominal,
    final m2_flow_nominal=mBui_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{0,-200},{20,-220}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{180,-290},{200,-270}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare final package Medium=MediumBui,
    final m_flow_nominal=mBui_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{-218,190},{-198,210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium=MediumBui,
    final m_flow_nominal=mBui_flow_nominal)
    "Building supply temperature sensor"
    annotation (Placement(transformation(extent={{-16,-214},{-36,-194}})));
  Controls.OBC.CDL.Reals.PID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin)
    "Building supply temperature controller"
    annotation (Placement(transformation(extent={{-130,-230},{-110,-210}})));

  Modelica.Blocks.Math.Add dTDis(
    final k1=-1)
  "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{20,-124},{40,-104}})));
  Modelica.Blocks.Math.Product pro
  "product"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Modelica.Blocks.Math.Gain cp(
    final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));
  Modelica.Blocks.Continuous.Integrator int(
    final k=1)
    "Integration"
    annotation (Placement(transformation(extent={{240,-170},{260,-150}})));
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
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-200,-280},{-160,-280}}, color={0,127,255}));
  connect(senMasFlo.port_b, conVal.port_a)
    annotation (Line(points={{-140,-280},{-100,-280}}, color={0,127,255}));
  connect(conVal.port_b, hex.port_a1)
    annotation (Line(points={{-80,-280},{-10,-280},{-10,-216},{0,-216}},
                                color={0,127,255}));
  connect(hex.port_b1, senTDisRet.port_a)
    annotation (Line(points={{20,-216},{60,
          -216},{60,-280},{180,-280}}, color={0,127,255}));
  connect(senTBuiRet.port_b, hex.port_a2)
    annotation (Line(points={{-198,200},{60,
          200},{60,-204},{20,-204}}, color={0,127,255}));
  connect(hex.port_b2, senTBuiSup.port_a)
    annotation (Line(points={{0,-204},{-16,-204}},        color={0,127,255}));
  connect(senTBuiSup.T, con.u_m)
    annotation (Line(points={{-26,-193},{-26,-180},{-140,-180},{-140,-240},{-120,
          -240},{-120,-232}},
                          color={0,0,127}));
  connect(TSetBuiSup, con.u_s)
    annotation (Line(points={{-320,0},{-240,0},{-240,-220},{-132,-220}},
                                                 color={0,0,127}));
  connect(con.y, conVal.y)
    annotation (Line(points={{-108,-220},{-90,-220},{-90,-268}},
                                                           color={0,0,127}));
  connect(senTDisSup.T,dTDis. u2)
    annotation (Line(points={{-210,-269},{-210,-120},{18,-120}},
                      color={0,0,127}));
  connect(senTBuiRet.T,dTDis. u1)
    annotation (Line(points={{-208,211},{-208,240},{0,240},{0,-108},{18,-108}},
                                  color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-150,-269},{-150,-140},{100,-140},{100,-126},{118,
          -126}},                                        color={0,0,127}));
  connect(dTDis.y, pro.u1)
    annotation (Line(points={{41,-114},{118,-114}},
                       color={0,0,127}));
  connect(pro.y, cp.u)
    annotation (Line(points={{141,-120},{178,-120}}, color={0,0,127}));
  connect(cp.y, Q_flow)
    annotation (Line(points={{201,-120},{320,-120}}, color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{201,-120},{228,-120},{228,-160},{238,-160}},
                       color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{261,-160},{320,-160}},
                       color={0,0,127}));
  annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Indirect cooling energy transfer station (ETS) model that controls the
building chilled water supply temperature by modulating a primary control valve 
on the district supply side. The design is based on a typical district cooling 
ETS described in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>. 
As shown in the figure below, the building pumping design (constant/variable) 
is specified on the building side and not within the ETS. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Indirect.png\" alt=\"DHC.ETS.Indirect\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2019).
Chapter 5: End User Interface. In <i>District Cooling Guide</i>, Second Edition and 
<i>Owner's Guide for Buildings Served by District Cooling</i>. 
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 7, 2023, by David Blum:<br/>
Changed to partial base class for indirect so can extend to heating and cooling ETS.
</li>
<li>
January 11, 2023, by Michael Wetter:<br/>
Changed controls to use CDL. Changed PID to PI as default for controller.
</li>
<li>
March 21, 2022, by Chengnan Shi:<br/>
Update with base class partial model.
</li>
<li>Novermber 13, 2019, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialIndirect;

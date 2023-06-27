within Buildings.Experimental.DHC.EnergyTransferStations.Cooling;
model Direct "Direct cooling ETS model for district energy systems with in-building 
  pumping and deltaT control"
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
  // Mass flow rate
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of building cooling side"
    annotation(Dialog(group="Nominal condition"));
  // Pressure drops
  parameter Modelica.Units.SI.PressureDifference dpConVal_nominal(
    final min=0,
    displayUnit="Pa")=50
    "Nominal pressure drop in the control valve"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCheVal_nominal(
    final min=0,
    displayUnit="Pa")=6000
    "Nominal pressure drop in the check valve"
    annotation(Dialog(group="Nominal condition"));
  // Controller parameters
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(
    final min=0,
    final unit="1")=0.1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Units.SI.Time Ti(
    final min=Modelica.Constants.small)=60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    final min=0)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax(
    final start=1)=1
    "Upper limit of output"
    annotation (Dialog(group="PID controller"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="PID controller"));
  // Advanced parameters
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Advanced"));
  parameter Real bandwidth=0.2
    "Bandwidth around reference signal for on/off controller"
    annotation (Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TSetDisRet
    "Setpoint for the minimum district return temperature"
    annotation (Placement(transformation(extent={{-338,-20},{-298,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW")
    "Measured heating demand at the ETS"
    annotation (Placement(
        transformation(extent={{300,-140},{340,-100}}),iconTransformation(
          extent={{300,-140},{340,-100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
     annotation (Placement(transformation(
          extent={{300,-180},{340,-140}}), iconTransformation(extent={{300,-130},
            {340,-90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mBui_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=MediumSer)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-120,-290},{-100,-270}})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=MediumSer,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mBui_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Bypass junction"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-290}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mBui_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{30,190},{50,210}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare final package Medium=MediumSer,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mBui_flow_nominal*{1,-1,-1},
    final dp_nominal={0,0,0})
    "Bypass junction, splitter"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage conVal(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mBui_flow_nominal,
    final dpValve_nominal=dpConVal_nominal,
    use_inputFilter=true,
    riseTime(displayUnit="s") = 60)
    "Control valve"
    annotation (Placement(transformation(extent={{-10,190},{10,210}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=mBui_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Fluid.FixedResistances.CheckValve cheVal(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mBui_flow_nominal,
    final dpValve_nominal=dpCheVal_nominal)
    "Check valve (backflow preventer)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Blocks.Math.Add dTDis(
    final k1=-1)
    "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{80,-114},{100,-94}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Modelica.Blocks.Math.Gain cp(
    final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  Modelica.Blocks.Continuous.Integrator int(
    final k=1)
    "Integration"
    annotation (Placement(transformation(extent={{260,-170},{280,-150}})));
  Controls.OBC.CDL.Continuous.PID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    reverseActing=false)
    "District return temperature controller"
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=mBui_flow_nominal)
    "Building supply temperature sensor"
    annotation (Placement(transformation(extent={{230,190},{250,210}})));
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
  connect(port_aSerCoo, senTDisSup.port_a)
    annotation (Line(points={{-300,-280},{-180,-280}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-160,-280},{-120,-280}}, color={0,127,255}));
  connect(senMasFlo.port_b, jun.port_1)
    annotation (Line(points={{-100,-280},{-60,-280}}, color={0,127,255}));
  connect(ports_aChiWat[1], senTBuiRet.port_a)
    annotation (Line(points={{-300,200},{-220,200}}, color={0,127,255}));
  connect(senTBuiRet.port_b, spl.port_1)
    annotation (Line(points={{-200,200},{-60,200}}, color={0,127,255}));
  connect(spl.port_2, conVal.port_a)
    annotation (Line(points={{-40,200},{-10,200}}, color={0,127,255}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-110,-269},{-110,-192},
          {90,-192},{90,-116},{118,-116}}, color={0,0,127}));
  connect(pro.y, cp.u)
    annotation (Line(points={{141,-110},{178,-110}}, color={0,0,127}));
  connect(cp.y, Q_flow)
    annotation (Line(points={{201,-110},{248,-110},{248,-120},{320,-120}},
                                                     color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{201,-110},{248,-110},{248,-160},{258,-160}},
                       color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{281,-160},{320,-160}}, color={0,0,127}));
  connect(dTDis.y, pro.u1)
    annotation (Line(points={{101,-104},{118,-104}},color={0,0,127}));
  connect(conVal.port_b, senTDisRet.port_a)
    annotation (Line(points={{10,200},{30,200}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerCoo)
    annotation (Line(points={{50,200},{162,200},{162,-240},{262,-240},{262,-280},{300,-280}}, color={0,127,255}));
  connect(senTDisRet.T,dTDis. u1)
    annotation (Line(points={{40,211},{40,226},{60,226},{60,-98},{78,-98}},
                                                          color={0,0,127}));
  connect(senTDisSup.T,dTDis. u2)
    annotation (Line(points={{-170,-269},{-172,-269},{-172,-184},{60,-184},{60,-110},
          {78,-110}},                                            color={0,0,127}));
  connect(TSetDisRet, con.u_s)
    annotation (Line(points={{-318,0},{-272,0},{-272,250},{-222,250}},
                                                                     color={0,0,127}));
  connect(senTBuiRet.T, con.u_m)
    annotation (Line(points={{-210,211},{-210,238}},color={0,0,127}));
  connect(jun.port_2, senTBuiSup.port_a)
    annotation (Line(points={{-40,-280},{220,-280},{220,200},{230,200}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1])
    annotation (Line(points={{250,200},{300,200}}, color={0,127,255}));
  connect(spl.port_3, cheVal.port_a)
    annotation (Line(points={{-50,190},{-50,0}}, color={0,127,255}));
  connect(cheVal.port_b, jun.port_3)
    annotation (Line(points={{-50,-20},{-50,-270}}, color={0,127,255}));
  connect(con.y, conVal.y)
    annotation (Line(points={{-198,250},{0,250},{0,212}},
                                                        color={0,0,127}));
 annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Direct cooling energy transfer station (ETS) model with in-building pumping and 
deltaT control. The design is based on a typical district cooling ETS described 
in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>. 
As shown in the figure below, the district and building piping are hydronically 
coupled. The control valve ensures that the return temperature to the district 
cooling network is at or above the minimum specified value. This configuration 
naturally results in a fluctuating building supply tempearture. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Direct.PNG\" alt=\"DC ETS Direct\"/> 
</p>
<h4>
Reference
</h4>
<p>American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2019). 
Chapter 5: End User Interface. In <i>District Cooling Guide</i>, Second Edition and 
<i>Owner's Guide for Buildings Served by District Cooling</i>. 
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 5, 2023, by David Blum:<br/>
Removed assignment of check valve <code>allowFlowReversal=false</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3389\">#3389</a>.
</li>
<li>
January 11, 2023, by Michael Wetter:<br/>
Changed controls to use CDL. Changed PID to PI as default for controller.
</li>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Set pressure drops at junctions to 0 and removed parameter <code>dp_nominal</code>
</li>
<li>
December 28, 2022, by Kathryn Hinkelman:<br/>
Simplified the control implementation for the district return stream. Improved default control parameters.
</li>
<li>
December 23, 2022, by Kathryn Hinkelman:<br/>
Removed extraneous <code>m*_flow_nominal</code> parameters because 
<code>mBui_flow_nominal</code> can be used across all components.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912\">#2912</a>.
</li> 
<li>
November 11, 2022, by Michael Wetter:<br/>
Changed check valve to use version of <code>Buildings</code> library, and hence no outer <code>system</code> is needed.
</li>      
<li>March 20, 2022, by Chengnan Shi:<br/>Update with base class partial model and standard PI control.</li>
<li>Novermber 13, 2019, by Kathryn Hinkelman:<br/>First implementation. </li>
</ul>
</html>"));
end Direct;

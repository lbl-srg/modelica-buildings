within Buildings.Experimental.DHC.EnergyTransferStations.Cooling;
model DirectControlled "Direct cooling ETS model for district energy systems with in-building 
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
  // Mass flow rates
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of district cooling side"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of building cooling side"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mByp_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate through the bypass segment"
    annotation(Dialog(group="Nominal condition"));
  // Pressure drops
  parameter Modelica.Units.SI.PressureDifference dpConVal_nominal(
    final min=0,
    displayUnit="Pa")=6000
    "Nominal pressure drop in the control valve"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCheVal_nominal(
    final min=0,
    displayUnit="Pa")=6000
    "Nominal pressure drop in the check valve"
    annotation(Dialog(group="Nominal condition"));
  // Controller parameters
  parameter Real k(
    final min=0,
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Units.SI.Time Ti(
    final min=Modelica.Constants.small)=120
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    final min=0)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  parameter Real yMax(
    final start=1)=1
    "Upper limit of output"
    annotation (Dialog(group="PID controller"));
  parameter Real yMin=0.01
    "Lower limit of output"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  // Advanced parameters
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state";
  parameter Modelica.Units.SI.PressureDifference[3] dp_nominal=500*{1,-1,1}
    "Nominal pressure drop in pipe junctions";
  Modelica.Blocks.Interfaces.RealInput TSetDisRet
    "Setpoint for the minimum district return temperature"
    annotation (Placement(transformation(extent={{-338,-20},{-298,20}})));
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
    "Measured energy consumption at the ETS";
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=MediumSer)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-120,-290},{-100,-270}})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=MediumSer,
    final energyDynamics=energyDynamics,
    final m_flow_nominal={mDis_flow_nominal,-mBui_flow_nominal,mByp_flow_nominal},
    final dp_nominal=dp_nominal)
    "Bypass junction"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-290}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{30,210},{50,190}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare final package Medium=MediumSer,
    final energyDynamics=energyDynamics,
    final m_flow_nominal={mBui_flow_nominal,-mDis_flow_nominal,-mByp_flow_nominal},
    final dp_nominal=dp_nominal)
    "Bypass junction, splitter"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage conVal(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal,
    final dpValve_nominal=dpConVal_nominal,
    use_inputFilter=true,
    riseTime(displayUnit="s") = 60)
    "Control valve"
    annotation (Placement(transformation(extent={{-10,210},{10,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=mBui_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{-220,210},{-200,190}})));
  Modelica.Fluid.Valves.ValveIncompressible cheVal(
    redeclare final package Medium=MediumSer,
    final allowFlowReversal=false,
    final dp_nominal=dpCheVal_nominal,
    final m_flow_nominal=mByp_flow_nominal,
    final filteredOpening=true,
    riseTime(
      displayUnit="s")=60,
    final checkValve=true)
    "Check valve (backflow preventer)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Blocks.Math.Add dTdis(
    final k1=-1,
    final k2=+1)
    "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{60,-114},{80,-94}})));
  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Modelica.Blocks.Math.Gain cp(
    final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{182,-120},{202,-100}})));
  Modelica.Blocks.Continuous.Integrator int(
    final k=1)
    "Integration"
    annotation (Placement(transformation(extent={{260,-160},{280,-140}})));
  Modelica.Blocks.Sources.Constant ope(
    final k=1)
    "Check valve is always open in the positive flow direction"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.Continuous.LimPID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    reverseActing=false,
    y_reset=0)
    "District return temperature controller"
    annotation (Placement(transformation(extent={{-220,10},{-200,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=mBui_flow_nominal)
    "Building supply temperature sensor"
    annotation (Placement(transformation(extent={{230,190},{250,210}})));
  Modelica.Blocks.Logical.OnOffController onOffCon(bandwidth=0.2)
    "On off control for the control valve"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Modelica.Blocks.Logical.Switch swi
    "Switch between full opening and PI control signal."
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    "Full opening of the control valve."
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Modelica.Blocks.Logical.Not notCon
    "Reverse the on/off signal"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
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
    annotation (Line(points={{141,-110},{180,-110}}, color={0,0,127}));
  connect(cp.y, Q_flow)
    annotation (Line(points={{203,-110},{320,-110}}, color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{203,-110},{204,-110},{204,-150},
          {258,-150}}, color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{281,-150},{320,-150}}, color={0,0,127}));
  connect(dTdis.y, pro.u1)
    annotation (Line(points={{81,-104},{118,-104}}, color={0,0,127}));
  connect(conVal.port_b, senTDisRet.port_a)
    annotation (Line(points={{10,200},{30,200}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerCoo)
    annotation (Line(points={{50,200},{162,200},{162,-240},{262,-240},{262,-280},{300,-280}}, color={0,127,255}));
  connect(senTDisRet.T, dTdis.u1)
    annotation (Line(points={{40,189},{40,-98},{58,-98}}, color={0,0,127}));
  connect(senTDisSup.T, dTdis.u2)
    annotation (Line(points={{-170,-269},{-170,-110},{58,-110}}, color={0,0,127}));
  connect(ope.y, cheVal.opening)
    annotation (Line(points={{-79,-10},{-58,-10}}, color={0,0,127}));
  connect(TSetDisRet, con.u_s)
    annotation (Line(points={{-318,0},{-222,0}},                     color={0,0,127}));
  connect(senTBuiRet.T, con.u_m)
    annotation (Line(points={{-210,189},{-210,12}}, color={0,0,127}));
  connect(jun.port_2, senTBuiSup.port_a)
    annotation (Line(points={{-40,-280},{220,-280},{220,200},{230,200}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1])
    annotation (Line(points={{250,200},{300,200}}, color={0,127,255}));
  connect(spl.port_3, cheVal.port_a)
    annotation (Line(points={{-50,190},{-50,0},{-50,0}}, color={0,127,255}));
  connect(cheVal.port_b, jun.port_3)
    annotation (Line(points={{-50,-20},{-50,-270}}, color={0,127,255}));
  connect(const.y, swi.u1)
    annotation (Line(points={{-139,130},{-110,130},{
          -110,80},{-82,80},{-82,78}}, color={0,0,127}));
  connect(notCon.y, swi.u2)
    annotation (Line(points={{-119,70},{-82,70}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-199,0},{-110,0},{-110,62},
          {-82,62}}, color={0,0,127}));
  connect(swi.y, conVal.y)
    annotation (Line(points={{-59,70},{0,70},{0,188}}, color={0,0,127}));
  connect(senTBuiRet.T, onOffCon.u)
    annotation (Line(points={{-210,189},{-210,
          64},{-182,64}}, color={0,0,127}));
  connect(TSetDisRet, onOffCon.reference)
    annotation (Line(points={{-318,0},{
          -260,0},{-260,76},{-182,76}}, color={0,0,127}));
  connect(onOffCon.y, notCon.u)
    annotation (Line(points={{-159,70},{-142,70}}, color={255,0,255}));
 annotation (Placement(transformation(
          extent={{300,-170},{340,-130}}), iconTransformation(extent={{300,-130},
            {340,-90}})),
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
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/DirectControlled.PNG\" alt=\"DHC.ETS.DirectControlled\"/> 
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
<li>March 20, 2022, by Chengnan Shi:<br/>Update with base class partial model and standard PI control.</li>
<li>Novermber 13, 2019, by Kathryn Hinkelman:<br/>First implementation. </li>
</ul>
</html>"));
end DirectControlled;

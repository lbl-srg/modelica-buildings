within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model SubsystemHRChiller "Central subsystem based on heat recovery chiller"
    package Medium = Buildings.Media.Water "Medium model";

    final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
        max(mSecHea_flow_nominal,mSecCoo_flow_nominal)
    "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecHea_flow_nominal
      "Secondary(building side) heatng circuit nominal water flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecCoo_flow_nominal
      "Secondary(building side) cooling circuit nominal water flow rate";
    parameter Modelica.SIunits.TemperatureDifference dTChi=2
      "Temperature difference between entering and leaving water of EIR chiller(+ve)";
    parameter Modelica.Fluid.Types.Dynamics fixedEnergyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
      "Formulation of energy balance for mixing volume at inlet and outlet"
      annotation (Dialog(group="Dynamics"));
    parameter Boolean show_T=true
      "= true, if actual temperature at port is computed"
      annotation (Dialog(tab="Advanced"));

    final parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=1000
      "Pressure difference at nominal flow rate"
        annotation (Dialog(group="Design Parameter"));

  //----------------------water to water chiller or heat pump system-----------------
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=datChi.mEva_flow_nominal
     "Condenser nominal water flow rate" annotation (Dialog(group="EIR CHILLER system"));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=datChi.mEva_flow_nominal
     "Evaporator nominal water flow rate" annotation (Dialog(group="EIR Chiller system"));
    parameter Modelica.SIunits.PressureDifference dpCon_nominal
      "Pressure difference accross the condenser"
        annotation (Dialog(group="EIR Chiller system"));
    parameter Modelica.SIunits.PressureDifference dpEva_nominal
      "Pressure difference accross the evaporator"
        annotation (Dialog(group="EIR Chiller system"));
//---------------------------------Buffer tanks-------------------
    final parameter Modelica.SIunits.Volume VTan = 5*60*mCon_flow_nominal/1000
      "Tank volume, ensure at least 5 minutes buffer flow"
      annotation (Dialog(group="Water Buffer Tank"));
    final parameter Modelica.SIunits.Length hTan = 5
      "Height of tank (without insulation)"
      annotation (Dialog(group="Water Buffer Tank"));
    final parameter Modelica.SIunits.Length dIns = 0.3
      "Thickness of insulation"
        annotation (Dialog(group="Water Buffer Tank"));
    final parameter Integer nSegTan=10   "Number of volume segments"
        annotation (Dialog(group="Water Buffer Tank"));
    parameter Modelica.SIunits.TemperatureDifference THys
      "Temperature hysteresis"
        annotation (Dialog(group="Water Buffer Tank"));
 //----------------------------Borefield system----------------------------------
    parameter Modelica.SIunits.TemperatureDifference dTGeo
      "Temperature difference between entering and leaving water of the borefield (+ve)"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.MassFlowRate mGeo_flow_nominal= m_flow_nominal*dTChi/dTGeo
      "Borefiled nominal water flow rate"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal= mGeo_flow_nominal/(nXBorHol*nYBorHol)
      "Borefiled nominal water flow rate"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Length xBorFie
      "Borefield length"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Length yBorFie
      "Borefield width"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.Length dBorHol = 5
      "Distance between two boreholes"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Pressure dpBorFie_nominal
      "Pressure losses for the entire borefield"
        annotation (Dialog(group="Borefield"));
    final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
      "Number of boreholes in x-direction"
        annotation(Dialog(group="Borefield"));
    final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
      "Number of boreholes in y-direction"
        annotation(Dialog(group="Borefield"));
    final parameter  Integer nBorHol = nXBorHol*nYBorHol
     "Number of boreholes"
        annotation(Dialog(group="Borefield"));
    parameter Modelica.SIunits.Radius rTub =  0.05
     "Outer radius of the tubes"
        annotation(Dialog(group="Borefield"));
    parameter Boolean allowFlowReversal = false
      "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

//---------------------------DistrictHeatExchanger----------
    final parameter Modelica.SIunits.MassFlowRate mHex_flow_nominal= m_flow_nominal*dTChi/dTHex
      "District heat exhanger nominal water flow rate"
      annotation (Dialog(group="DistrictHeatExchanger"));
    parameter Real eps_nominal=0.71
      "Heat exchanger effectiveness"
      annotation (Dialog(group="DistrictHeatExchanger"));
   final parameter  Modelica.SIunits.PressureDifference dpHex_nominal(displayUnit="Pa")=50000
      "Pressure difference across heat exchanger"
      annotation (Dialog(group="DistrictHeatExchanger"));
    parameter Modelica.SIunits.TemperatureDifference dTHex
      "Temperature difference between entering and leaving water of the district heat exchanger(+ve)"
      annotation (Dialog(group="DistrictHeatExchanger"));
 //----------------------------Performance data records-----------------------------
    parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "EIR chiller performance data."
      annotation (Placement(transformation(extent={{-292,-280},{-272,-260}})));
  // IO CONNECTORS
  // COMPONENTS
  Fluid.Chillers.ElectricEIR chi(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    show_T=true,
    from_dp1=true,
    dp1_nominal=dpCon_nominal,
    linearizeFlowResistance1=true,
    from_dp2=true,
    dp2_nominal=dpEva_nominal,
    linearizeFlowResistance2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=datChi,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
      annotation (Placement(transformation(extent={{-10,116},{10,136}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCon(
    redeclare final package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpCon_nominal,0}, V_flow={0,mCon_flow_nominal/1000})),
    allowFlowReversal=false)
    "Condenser variable speed pump-primary circuit"
      annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
   Buildings.Fluid.Movers.SpeedControlled_y pumEva(
    redeclare final package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpEva_nominal,0}, V_flow={0,mEva_flow_nominal/1000})),
    allowFlowReversal=false)
    "Evaporator variable speed pump-primary circuit"
      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-100,80})));
  //// TANKS
  //// BOREFIELD
  //// DISTRICT HX
  //// CONTROLLERS
  Controls.HRChiller conChi "Chiller controller"
    annotation (Placement(transformation(extent={{-240,258},{-220,278}})));
  Controls.PrimaryPumpsConstantSpeed conPumPri "Primary pumps controller"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  //// SENSORS
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0) "Condenser water leaving temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={40,160})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0) "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=0) "Evaporator water entering temperature" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TEvaLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-50,70},{-70,90}})));
//------hydraulic header------------------------------------------------------------
  Fluid.FixedResistances.Junction splEva(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=fill(0, 3),
    from_dp=false,
    tau=1,
    m_flow_nominal=mEva_flow_nominal .* {1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter for the evaporator water circuit"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-140,80})));
  Fluid.FixedResistances.Junction splCon(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=fill(0, 3),
    from_dp=false,
    tau=1,
    m_flow_nominal=mCon_flow_nominal .* {1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter for the condenser water circuit"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={120,160})));
 //-----------------------------Valves----------------------------------------------
  Fluid.Actuators.Valves.TwoWayLinear valSupHea(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dp_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal)
    "Two way modulating valve"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  Fluid.Actuators.Valves.TwoWayLinear valSupCoo(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dp_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal)
    "Two way modulating valve"
      annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEva(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mEva_flow_nominal,
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the evaporator"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
                                        rotation=180,
                                        origin={120,80})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCon(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mCon_flow_nominal,
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the condenser"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},
      rotation=0,
      origin={-140,160})));
equation
  connect(splCon.port_3, valCon.port_3) annotation (Line(points={{120,170},{120,
          200},{-140,200},{-140,170}}, color={0,127,255}));
  connect(senTConLvg.port_b, splCon.port_1)
    annotation (Line(points={{50,160},{110,160}}, color={0,127,255}));
  connect(chi.port_b1, senTConLvg.port_a) annotation (Line(points={{10,132},{20,
          132},{20,160},{30,160}}, color={0,127,255}));
  connect(valCon.port_2, pumCon.port_a)
    annotation (Line(points={{-130,160},{-110,160}}, color={0,127,255}));
  connect(pumCon.port_b, senTConEnt.port_a)
    annotation (Line(points={{-90,160},{-50,160}}, color={0,127,255}));
  connect(senTConEnt.port_b, chi.port_a1) annotation (Line(points={{-30,160},{
          -20,160},{-20,132},{-10,132}}, color={0,127,255}));
  connect(valEva.port_2, senTEvaEnt.port_a)
    annotation (Line(points={{110,80},{70,80}}, color={0,127,255}));
  connect(senTEvaEnt.port_b, chi.port_a2) annotation (Line(points={{50,80},{20,
          80},{20,120},{10,120}}, color={0,127,255}));
  connect(chi.port_b2, TEvaLvg.port_a) annotation (Line(points={{-10,120},{-20,
          120},{-20,80},{-50,80}}, color={0,127,255}));
  connect(TEvaLvg.port_b, pumEva.port_a)
    annotation (Line(points={{-70,80},{-90,80}}, color={0,127,255}));
  connect(pumEva.port_b, splEva.port_1)
    annotation (Line(points={{-110,80},{-130,80}}, color={0,127,255}));
  connect(splEva.port_3, valEva.port_3) annotation (Line(points={{-140,70},{
          -140,40},{120,40},{120,70}}, color={0,127,255}));
  connect(splEva.port_2, valSupCoo.port_a) annotation (Line(points={{-150,80},{
          -180,80},{-180,-60},{-90,-60}}, color={0,127,255}));
  connect(splCon.port_2, valSupHea.port_a) annotation (Line(points={{130,160},{
          180,160},{180,-60},{90,-60}}, color={0,127,255}));
  connect(valSupCoo.port_b, valSupHea.port_b)
    annotation (Line(points={{-70,-60},{70,-60}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false),
   graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,60},{62,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
       Text(
          extent={{-150,146},{150,106}},
          textString="%name",
          lineColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash)}),
        defaultComponentName="ets",
Documentation(info="<html>
<p>
This models represents an energy transfer station (ETS) for fifth generation 
district heating and cooling systems. 
The control logic is based on five operating modes:
</p>
<ul>
<li>
heating only,
</li>
<li>
cooling only,
</li>
<li>
simultaneous heating and cooling,
</li>
<li>
part surplus heat or cold rejection,
</li>
<li>
full surplus heat or cold rejection.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image the 5th generation of district heating and cooling substation\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/SubstationModifiedLayout.png\"/>
<p>
The substation layout consists in three water circuits:
</p>
<ol>
<li>
the heating water circuit, which is connected to the building heating water
distribution system,
</li>
<li>
the chilled water circuit, which is connected to the building chilled water
distribution system,
</li>
<li>
the ambient water circuit, which is connected to the district heat exchanger 
(and optionally to the geothermal borefield).
</li>
</ol>
<h4>Heating water circuit</h4>
<p>
It satisfies the building heating requirements and consists in:
</p>
<ol>
<li>
the heating/cooling generating source, where the EIR chiller i.e. condenser heat exchanger operates to satisfy the heating setpoint
<code>TSetHea</code>.
</li>
<li>
The constant speed condenser water pump <code>pumCon</code>.
</li>
<li>
The hot buffer tank, is implemented to provide hydraulic decoupling between the primary (the ETS side) and secondary (the building side)
water circulators i.e. pumps and to eliminate the cycling of the heat generating source machine i.e EIR chiller.
</li>
<li>
Modulating mixing three way valve <code>valCon</code> to control the condenser entering water temperature.
</li>
</ol>
<h4>Chilled water circuit</h4>
<p>
It operates to satisfy the building cooling requirements and consists of
</p>
<ol>
<li>
The heating/cooling generating source, where the  EIR chiller i.e evaporator heat
exchanger operates to satisfy the cooling setpoint <code>TSetCoo</code>.
</li>
<li>
The constant speed evaporator water pump <code>pumEva</code>.
</li>
<li>
The chilled water buffer tank, is implemented obviously for the same mentioned reasons of the hot buffer tank.
</li>
<li>
Modulating mixing three way valve <code>valEva</code> to control the evaporator entering water temperature.
</li>
</ol>
<p>
For more detailed description of
</p>
<p>
The controller of heating/cooling generating source, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController.</a>
</p>
<p>
The evaporator pump <code>pumEva</code> and the condenser pump <code>pumCon</code>, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed\">
Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed.</a>
</p>
<h4>Ambient water circuit</h4>
<p>
The ambient water circuit operates to maximize the system exergy by rejecting surplus i.e. heating or cooling energy
first to the borefield system and second to either or both of the borefield and the district systems.
It consists of
</p>
<ol>
<li>
The borefield component model <code>borFie</code>.
</li>
<li>
The borefield pump <code>pumBor</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Modulating mixing three way valve <code>valBor</code> to control the borefield entering water temperature.
</li>
<li>
The heat exchanger component model <code>hex</code>.
</li>
<li>
The heat exchanger district pump <code>pumHexDis</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Two on/off 2-way valves <code> valHea</code>, <code>valCoo</code>
which separates the ambient from the chilled water and heating water circuits.
</ol>
<p>
For more detailed description of the ambient circuit control concept see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController.</a>
</p>
<h4>Notes</h4>
<p>
For more detailed description of the finite state machines which transitions the ETS between
different operational modes, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a> and
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
January 18, 2020, by Hagar Elarga: <br/>
First implementation
</li>
</ul>
</html>"));
end SubsystemHRChiller;

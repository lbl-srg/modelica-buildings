within Buildings.Fluid.CHPs.DistrictCHP.Validation;
model BottomCycle
  "Model validation for the bottoming cycle subsystem"
  extends Modelica.Icons.Example;

  // Medium declarations
  package MediumS = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumW = Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  // Parameters for the calculation blocks
  parameter Real a[:]={-0.23380344533,0.220477944738,-0.01476897980}
    "Coefficients for bottoming cycle exergy efficiency function"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real a_SteMas[:]={0.1140,0,0}
    "Coefficients for bottoming cycle steam mass flow function"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real TSta(
    unit="K",
    displayUnit="degC")=455.636
    "HRSG stack temperature";

  // Advanced tab: parameters for the fluid systems
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=56.9972
    "Nominal mass flow rate in fluid ports";
  parameter Real TSte(
    unit="K",
    displayUnit="degC")=823.15
    "Superheated steam temperature in Celsius used for correlation function";
  parameter Modelica.Units.SI.AbsolutePressure p_a_nominal=30000
    "Nominal inlet pressure for predefined pump characteristics";
  parameter Modelica.Units.SI.AbsolutePressure p_b_nominal=3000000
    "Nominal outlet pressure, fixed if not control_m_flow and not use_p_set";
  parameter Modelica.Units.SI.Volume V=12.4
    "Total volume of evaporator";

  // Advanced tab: parameters for PI controller
  parameter Modelica.Units.SI.Volume VWat_set=V*0.8
    "Water volume setpoint in for PI controller";
  parameter Real k(min=0)=2
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=300
    "Time constant of Integrator block";
  parameter Modelica.Units.SI.Time Td(min=0)=1
    "Time constant of Derivative block";
  parameter Real yMax(start=1)=1
    "Upper limit of output";
  parameter Real yMin=0
    "Lower limit of output";
  parameter Real Ni(min=100*Modelica.Constants.eps)=1
    "Ni*Ti is time constant of anti-windup compensation";
  parameter Real Nd(min=100*Modelica.Constants.eps)=1
    "The higher Nd, the more ideal the derivative block";

  // Assumptions tab
  parameter Boolean allowFlowReversal = false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports.";

  //Dynamics tab for evaporator energy and mass balance
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state";
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of mass balance: dynamic (3 initialization options) or steady state";

  // Initialization tab
  parameter Modelica.Units.SI.AbsolutePressure p_start=30000
    "Start value of pressure";
  parameter Modelica.Units.SI.Volume VWat_start=V*0.8
    "Start value of liquid volume in the evaporator";
  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_start=0.055
    "Start value of volumetric flow rate of liquid water";
  parameter Modelica.Units.SI.AbsolutePressure p_a_start=30000
    "Start value of inlet pressure for pump";
  parameter Modelica.Units.SI.AbsolutePressure p_b_start=30000
    "Start value of outlet pressure for pump";
  parameter Boolean use_T_start=false
    "Boolean to indicate if T_start is used";
  parameter Real T_start(
    unit="K",
    displayUnit="degC")=777.625
    "Start value of temperature for pump";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start=1e5
    "Start value of specific enthalpy for pump";

  Buildings.Fluid.CHPs.DistrictCHP.BottomCycle botCyc(
    final a=a,
    final a_SteMas=a_SteMas,
    final TSta=TSta,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final V=V,
    final p_start=p_start,
    final VWat_start=VWat_start,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd=Nd,
    final VWat_flow_start=VWat_flow_start,
    final TSte=TSte,
    final VWat_set=VWat_set,
    final p_a_start=p_a_start,
    final p_b_start=p_b_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start,
    steBoi(fixed_p_start=false))
    "Bottom cycle: feed in water and heated up to produce superheat steam"
    annotation (Placement(transformation(extent={{-10,-30},{10,-12}})));

  Modelica.Blocks.Sources.Constant ambTemp(k=15 + 273.15)
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumW,
    use_p_in=false,
    p=30000,
    T=504.475,
    nPorts=1)
    "Water source"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = MediumS,
    p=1000000,
    T=523.15,
    nPorts=1) "Steam boundary condition"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Blocks.Sources.Constant exhTem(k=750)
    "Temperature of the exhaust gas from top cycle"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=-178,
    rising=500,
    width=3000,
    falling=500,
    period=6000,
    offset=500,
    startTime=500)
    "Exhaust mass flow rate changes (kg/s)"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.CombiTimeTable valDat(
    tableOnFile=true,
    tableName="tab1",
    y(unit={"s","kg/s","W","kg/s"}),
    columns={2,3,4,5},
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/CHPs/DistrictCHP/Validation/BottomCycle.mos"))
    "Validation data from example model in ThermoPower Library"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

equation

  connect(exhTem.y, botCyc.TExh) annotation (Line(points={{-59,70},{-20,70},{
          -20,-13.8},{-12,-13.8}},
                               color={0,0,127}));
  connect(ambTemp.y, botCyc.TAmb) annotation (Line(points={{-59,30},{-30,30},{
          -30,-16.5},{-12,-16.5}},
                               color={0,0,127}));
  connect(trapezoid.y, botCyc.mExh_flow) annotation (Line(points={{-59,-10},{
          -40,-10},{-40,-19.2},{-12,-19.2}},
                                         color={0,0,127}));
  connect(sou.ports[1], botCyc.port_a) annotation (Line(points={{-30,-40},{-20,
          -40},{-20,-21},{-10,-21}}, color={0,127,255}));
  connect(botCyc.port_b, bou.ports[1]) annotation (Line(points={{10,-21},{20,
          -21},{20,-40},{30,-40}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(revisions="<html>
<ul>
<li>
November 18, 2025, by Viswanathan Ganesh:<br/>
Included validations data and updated scripts.
</li>
<li>
October 1, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info= "<html>
<p>
This validation model compares the proposed CHP bottoming-cycle model with the
high-fidelity model from the ThermoPower Library (TPL), focusing on the regulation
of steam drum levels and evaporator void fraction.
</p>
<p>
The ThermoPower Library (TPL) provides an example model for maintaining steam drum
level, found in 
<a href=\"https://github.com/casella/ThermoPower/blob/e2b011ac7fd90f9cf5771f29f1aefa160550b6ee/ThermoPower/Examples.mo#L3119\">
ThermoPower.Examples.RankineCycle.Simulators.ClosedLoop</a>.
This model simulates a closed-loop control system designed to regulate the
evaporator’s void fraction, which represents the proportion of the gas phase within
the total drum volume. The comparison below shows the results between this bottoming
cycle model and the TPL model.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/DistrictCHP/BCModelComparison.svg\"
alt=\"ModelComparison\" />
</p>
<p>
When the simulation time has been extended from the default 3000 seconds
to 31,536,000 seconds (one year) to evaluate the performance for annual simulations,
this model can complete annual simulations in approximately 30-40 seconds, 
compared to 3 hours with the TPL model. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/DistrictCHP/BCAnnSimCPU_Comparison.svg\"
alt=\"CPUComparison\" />
</p>
</html>"),
experiment(
  StopTime=3000,
  Tolerance=1E-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/DistrictCHP/Validation/BottomCycle.mos"
   "Simulate and plot"));
end BottomCycle;

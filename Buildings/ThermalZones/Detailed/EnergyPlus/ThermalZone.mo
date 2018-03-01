within Buildings.ThermalZones.Detailed.EnergyPlus;
model ThermalZone "Model to connect to an EnergyPlus thermal zone"
  import Buildings;
  extends Modelica.Blocks.Icons.Block;
  parameter String fmuName "Name of the FMU file that contains this zone";

  parameter String zoneName "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Integer nPorts=0 "Number of fluid ports (equals to 2 for one inlet and one outlet)" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));

  ////////////////////////////////////////////////////////////////////////////
  // Media declaration. This is identical to
  // Buildings.Fluid.Interfaces.LumpedVolumeDeclarations, except
  // that the comments have been changed to avoid a confusion about
  // what energyDynamics refers to.
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Ports
  parameter Boolean use_C_flow=false
    "Set to true to enable input connector for trace substance that is connected to room air"
    annotation (Dialog(group="Ports"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
    "Type of independent mass fraction balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Type of trace substance balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));

  parameter Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the zone air volume"
    annotation(Dialog(tab="Dynamics", group="Zone air"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of zone air pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of zone air temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
       quantity=Medium.substanceNames) = Medium.X_default
    "Start value of zone air mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of zone air trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
       quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
    "Nominal value of zone air trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  Modelica.Blocks.Interfaces.RealInput qGai_flow[3](each unit="W/m2")
    "Radiant, convective and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}})));

  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_flow if use_C_flow
    "Trace substance mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume" annotation (Placement(transformation(extent={{-10,-10},
            {10,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(
        extent={{-40,-10},{40,10}},
        rotation=180,
        origin={0,-150})));
  Modelica.Blocks.Interfaces.RealOutput TAir(
    final unit="K",
    displayUnit="degC")
    "Air temperature of the zone"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
        iconTransformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TRad(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature of the zone" annotation (Placement(transformation(
          extent={{200,-50},{220,-30}}), iconTransformation(extent={{-10,-50},{10,
            -30}})));

  Modelica.Blocks.Math.Gain gaiCO2(
    u(final unit="W"),
    y(final unit="kg/s"),
    k=3.82E-8
      *Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
      /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM)
    "CO2 emission in kg/s per Watt heat released by people"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));

protected
  constant Modelica.SIunits.SpecificEnergy h_fg=
    Medium.enthalpyOfCondensingGas(273.15+37) "Latent heat of water vapor";

  Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZon(
    final fmuName=fmuName,
    final zoneName=zoneName,
    final nFluPor=nPorts) "FMU zone adapter"
    annotation (Placement(transformation(extent={{120,104},{140,124}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final allowFlowReversal=true,
    final use_C_flow=use_C_flow) "Air volume of the thermal zone"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.ThermalZones.Detailed.BaseClasses.HeatGain heaGai(final AFlo=fmuZon.AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Modelica.Blocks.Math.Gain mWat_flow(
    final k(unit="kg/J") = 1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s")) "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Math.Add QConLat_flow(final k1=1, final k2=1)
    "Total latent heat gains of the zone"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Math.Add QGaiSenLat_flow(final k1=1, final k2=1)
    "Sensible and latent heat gains of the zone"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Math.Add QConTot_flow(final k1=1, final k2=1)
    "Total convective sensible heat gains of the zone"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow conQCon_flow
    "Converter for convective heat flow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Modelica.Blocks.Sources.RealExpression TIn[nPorts](
    final y=Medium.temperature(state=
        Medium.setState_phX(
        p=ports.p,
        h=ports.h_outflow,
        X=ports.Xi_outflow))) "Inlet air temperatures"
    annotation (Placement(transformation(extent={{70,124},{90,144}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow[nPorts](
    final y=ports.m_flow)
    "Inlet mass flow rates"
    annotation (Placement(transformation(extent={{70,140},{90,160}})));

  final parameter String substanceName = "CO2" "Name of trace substance";

  final parameter Modelica.SIunits.MolarMass MM=
    Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
    "Molar mass of the trace substance";
  final parameter Real s[:]= {
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false))
    then 1 else 0 for i in 1:Medium.nC}
    "Vector with zero everywhere except where CO2 is";

  Modelica.Blocks.Math.MatrixGain toC(final K=s) if
       use_C_flow
    "Conversion to a vector of species concentration"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Modelica.Blocks.Math.Add CTot_flow[Medium.nC](
    each final k1=1,
    each final k2=1) if use_C_flow
    "Total trace substance flow rate"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
initial equation
  assert(fmuName <> "", "Must provide the name of the fmu file.");
  assert(zoneName <> "", "Must provide the name of the zone.");
equation
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(points={{-182,100},{-220,
          100}},                            color={0,0,127}));
  connect(vol.heatPort, heaPorAir) annotation (Line(points={{-10,-90},{-40,-90},
          {-40,0},{0,0}}, color={191,0,0}));
  connect(senTAir.port, heaPorAir)
    annotation (Line(points={{20,0},{0,0}}, color={191,0,0}));
  connect(senTAir.T, TAir)
    annotation (Line(points={{40,0},{210,0}}, color={0,0,127}));
  connect(fmuZon.TRad, TRad) annotation (Line(points={{141,120},{160,120},{160,-40},
          {210,-40}}, color={0,0,127}));
  connect(fmuZon.T, senTAir.T) annotation (Line(points={{118,124},{52,124},{52,0},
          {40,0}}, color={0,0,127}));
  connect(vol.X_w, fmuZon.X_w) annotation (Line(points={{12,-94},{60,-94},{60,120},
          {118,120}},color={0,0,127}));
  connect(heaGai.QRad_flow, fmuZon.QGaiRad_flow)
    annotation (Line(points={{-158,106},{118,106}},color={0,0,127}));
  connect(heaGai.QCon_flow, QConTot_flow.u1) annotation (Line(points={{-158,100},
          {-132,100},{-132,56},{-122,56}}, color={0,0,127}));
  connect(fmuZon.QGaiCon_flow, QConTot_flow.u2) annotation (Line(points={{141,116},
          {150,116},{150,80},{-128,80},{-128,44},{-122,44}}, color={0,0,127}));
  connect(heaGai.QLat_flow, QConLat_flow.u1) annotation (Line(points={{-158,94},
          {-142,94},{-142,26},{-122,26}}, color={0,0,127}));
  connect(fmuZon.QGaiLat_flow, QConLat_flow.u2) annotation (Line(points={{141,112},
          {154,112},{154,76},{-146,76},{-146,14},{-122,14}}, color={0,0,127}));
  connect(QGaiSenLat_flow.u1, QConTot_flow.y) annotation (Line(points={{-82,46},
          {-90,46},{-90,50},{-99,50}}, color={0,0,127}));
  connect(QGaiSenLat_flow.u2, QConLat_flow.y) annotation (Line(points={{-82,34},
          {-90,34},{-90,20},{-99,20}}, color={0,0,127}));
  connect(QGaiSenLat_flow.y, conQCon_flow.Q_flow)
    annotation (Line(points={{-59,40},{-40,40}}, color={0,0,127}));
  connect(conQCon_flow.port, heaPorAir)
    annotation (Line(points={{-20,40},{0,40},{0,0}}, color={191,0,0}));
  connect(QConLat_flow.y, mWat_flow.u) annotation (Line(points={{-99,20},{-90,20},
          {-90,0},{-82,0}}, color={0,0,127}));
  connect(mWat_flow.y, vol.mWat_flow) annotation (Line(points={{-59,0},{-50,0},{
          -50,-82},{-12,-82}}, color={0,0,127}));
  connect(mIn_flow.y, fmuZon.m_flow) annotation (Line(points={{91,150},{100,150},
          {100,116},{118,116}}, color={0,0,127}));
  connect(TIn.y, fmuZon.TInlet) annotation (Line(points={{91,134},{98,134},{98,112},
          {118,112}}, color={0,0,127}));
  connect(fmuZon.QPeo_flow, gaiCO2.u) annotation (Line(points={{141,108},{146,
          108},{146,-180},{-172,-180},{-172,-140},{-142,-140}}, color={0,0,127}));
  connect(toC.u[1], gaiCO2.y)
    annotation (Line(points={{-102,-140},{-119,-140}}, color={0,0,127}));
  connect(CTot_flow.y, vol.C_flow) annotation (Line(points={{-39,-120},{-26,-120},
          {-26,-96},{-12,-96}}, color={0,0,127}));
  connect(toC.y, CTot_flow.u2) annotation (Line(points={{-79,-140},{-70,-140},{-70,
          -126},{-62,-126}}, color={0,0,127}));
  connect(C_flow, CTot_flow.u1) annotation (Line(points={{-220,-120},{-160,-120},
          {-160,-114},{-62,-114}}, color={0,0,127}));
  annotation (
  defaultComponentName="zon",
   Icon(coordinateSystem(preserveAspectRatio=false,
   extent={{-200,-200},{200,200}}),
                         graphics={
        Rectangle(
          extent={{-160,-160},{160,160}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,138},{140,-140}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
          Bitmap(extent={{30,48},{132,150}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/EnergyPlus/EnergyPlusLogo.png"),
        Text(
          extent={{-112,130},{-8,100}},
          lineColor={0,0,0},
          textString="%fmuName"),
        Text(
          extent={{-110,98},{-6,68}},
          lineColor={0,0,0},
          textString="%zoneName"),
        Rectangle(
          extent={{140,70},{160,-70}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,-22},{-22,-50}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="radiation"),
        Text(
          extent={{-60,12},{-22,-10}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="air"),
        Rectangle(
          extent={{146,70},{154,-70}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-220,100},{-144,68}},
          lineColor={0,0,127},
          textString="q"),
        Text(
          extent={{-188,-94},{-112,-126}},
          lineColor={0,0,127},
          textString="C_flow",
          visible=use_C_flow)}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})),
    Documentation(info="<html>
<p>
Model for a thermal zone that is implemented in EnergyPlus.
</p>
<p>
This model instantiates the FMU with the name <code>fmuName</code> and
connects to the thermal zone with name <code>zoneName</code>.
If the FMU is already instantiated by another instance of this model,
it will use the already instantiated FMU.
</p>
<p>
Note that the <code>zoneName</code> can only be specified once
for each FMU. (Otherwise, there would be two models interacting
with the same thermal zone.). If it is specified more than
once, the simulation will stop with an error.
</p>
<h4>Heat gains and CO2 added by people</h4>
<p>
If the EnergyPlus model computes internal heat gains
such as from people or equipment, then their sensible convective
and latent heat gains are added to the the room model.
Similarly, if people are modeled in EnergyPlus (using the
EnergyPlus <code>People</code> object), <i>and</i> if the
Modelica <code>Medium</code> contains CO2 (e.g., if
<code>Medium.nC &gt; 0</code> and
there is a <code>Medium.substanceName = \"CO2\"</code>),
then the CO2 emitted by the people is added to this volume.
However, \"Generic Contaminant\" modeled in EnergyPlus is not
added to the air volume. (Because EnergyPlus does not declare the
name of the species or its molar mass and hence it cannot be matched
to species in Modelica or converted to emitted mass flow rate.)
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1129\">issue 1129</a>.
</li>
</ul>
</html>"));
end ThermalZone;

within Buildings.Examples.VAVReheat.BaseClasses;
model VAVReheatBox "Supply box of a VAV system with a hot water reheat coil"
  extends Modelica.Blocks.Icons.Block;
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  replaceable package MediumW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water" annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate";
  parameter Real ratVFloHea(start=0.3, min=0, max=1, unit="1")
    "Maximum air flow rate ratio in heating mode";
  parameter Modelica.SIunits.Volume VRoo "Room volume";
  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    start=55 + 273.15,
    displayUnit="degC")
    "Reheat coil nominal inlet water temperature";
  parameter Modelica.SIunits.Temperature THotWatOut_nominal(
    start=THotWatInl_nominal-10,
    displayUnit="degC")
    "Reheat coil nominal outlet water temperature";
  parameter Modelica.SIunits.Temperature TAirInl_nominal(
    start=12 + 273.15,
    displayUnit="degC")
    "Inlet air nominal temperature";
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    start=m_flow_nominal * ratVFloHea * cpAir * (32 + 273.15 - TAirInl_nominal))
    "Nominal heating heat flow rate";
  final parameter Modelica.SIunits.MassFlowRate mHotWat_flow_nominal=
    QHea_flow_nominal / (cpWatLiq * (THotWatInl_nominal - THotWatOut_nominal))
    "Nominal mass flow rate of hot water to reheat coil";
  Modelica.Fluid.Interfaces.FluidPort_a port_aAir(
    redeclare package Medium=MediumA)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_bAir(
    redeclare package Medium=MediumA)
    "Fluid connector b (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Blocks.Interfaces.RealInput yVAV
    "Signal for VAV damper"
    annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual VAV damper position"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHotWat(redeclare package Medium =
      MediumW) "Hot water inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHotWat(redeclare package Medium =
      MediumW) "Hot water outlet port"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TSup "Supply Air Temperature"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput VSup_flow
    "Supply Air Volumetric Flow Rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent vav(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=20,
    allowFlowReversal=allowFlowReversal,
    dpFixed_nominal=130)                 "VAV box for room" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU terHea(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mHotWat_flow_nominal,
    m2_flow_nominal=m_flow_nominal*ratVFloHea,
    Q_flow_nominal=QHea_flow_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal=0,
    from_dp2=true,
    dp2_nominal=0,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    T_a1_nominal=THotWatInl_nominal,
    T_a2_nominal=TAirInl_nominal)
    "Reheat coil"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-6,-30})));
  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Supply Air Temperature Sensor"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,40})));
  Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Supply Air Volumetric Flow Rate Sensor"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,80})));
protected
  constant Modelica.SIunits.SpecificHeatCapacity cpAir=
    Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";
  constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Water specific heat capacity";
equation
  connect(vav.y, yVAV) annotation (Line(points={{-12,10},{-40,10},{-40,60},{-120,
          60}}, color={0,0,127}));
  connect(vav.y_actual, y_actual)
    annotation (Line(points={{-7,15},{-7,24},{20,24},{20,0},{110,0}},
                                                          color={0,0,127}));
  connect(port_aAir, terHea.port_a2) annotation (Line(points={{0,-100},{0,-40}},
                                color={0,127,255}));
  connect(vav.port_a, terHea.port_b2)
    annotation (Line(points={{-4.44089e-16,0},{3.55271e-15,0},{3.55271e-15,-20}},
                                                           color={0,127,255}));
  connect(port_aHotWat, terHea.port_a1) annotation (Line(points={{-100,0},{-12,
          0},{-12,-20}},       color={0,127,255}));
  connect(port_bHotWat, terHea.port_b1) annotation (Line(points={{-100,-60},{
          -12,-60},{-12,-40}}, color={0,127,255}));
  connect(y_actual, y_actual)
    annotation (Line(points={{110,0},{110,0}},   color={0,0,127}));
  connect(vav.port_b, senTem.port_a) annotation (Line(points={{6.66134e-16,20},{
          0,20},{0,30},{-4.44089e-16,30}}, color={0,127,255}));
  connect(senTem.port_b, senVolFlo.port_a)
    annotation (Line(points={{0,50},{0,70},{-6.66134e-16,70}},
                                             color={0,127,255}));
  connect(senVolFlo.port_b, port_bAir)
    annotation (Line(points={{4.44089e-16,90},{0,90},{0,100}},
                                                     color={0,127,255}));
  connect(senVolFlo.V_flow, VSup_flow) annotation (Line(points={{11,80},{110,80}},
                             color={0,0,127}));
  connect(senTem.T, TSup) annotation (Line(points={{11,40},{110,40}},
                color={0,0,127}));
  annotation (Icon(
    graphics={
        Rectangle(
          extent={{-108.07,-16.1286},{93.93,-20.1286}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={-18.1286,6.07},
          rotation=90),
        Rectangle(
          extent={{-20,-12},{22,-52}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          pattern=LinePattern.None),
        Rectangle(
          extent={{100.8,-22},{128.8,-44}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192},
          origin={-32,-76.8},
          rotation=90),
        Rectangle(
          extent={{102.2,-11.6667},{130.2,-25.6667}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={-17.6667,-78.2},
          rotation=90),
        Polygon(
          points={{-12,32},{16,48},{16,46},{-12,30},{-12,32}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-20,-20},{14,-20},{14,-22},{-20,-22},{-20,-20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-20,-44},{14,-44},{14,-46},{-20,-46},{-20,-44}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,-26},{14,-20},{14,-22},{0,-28},{0,-26}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,-26},{14,-32},{14,-34},{0,-28},{0,-26}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,-38},{14,-44},{14,-46},{0,-40},{0,-38}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{0,-38},{14,-32},{14,-34},{0,-40},{0,-38}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-18},{-20,-24}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-42},{-20,-48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,3},{12,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-97,-12},
          rotation=90),
        Rectangle(
          extent={{-12,3},{12,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-97,-54},
          rotation=90)}),       Documentation(info="<html>
<p>
Model for a VAV terminal box with a water reheat coil and pressure independent damper.
The pressure independent damper model includes an idealized flow rate controller
and requires a discharge air flow rate set-point (normalized to the nominal value)
as a control signal.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2021, by Baptiste Ravache:<br/>
First implementation, based on <a href=\"modelica://Buildings.Obsolete.Examples.VAVReheat.BaseClasses.VAVBranch\">
Buildings.Obsolete.Examples.VAVReheat.BaseClasses.VAVBranch</a><br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
</ul>
</html>"));
end VAVReheatBox;

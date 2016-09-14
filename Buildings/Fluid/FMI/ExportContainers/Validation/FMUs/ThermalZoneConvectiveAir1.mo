within Buildings.Fluid.FMI.ExportContainers.Validation.FMUs;
block ThermalZoneConvectiveAir1 "Validation of simple thermal zone"
  extends Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective(
    redeclare package Medium = Buildings.Media.Air,
    nPorts =  2);

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";

  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={0,200}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,200})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
    QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{60,110},{40,130}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=V,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2,
    mSenFac=3)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Sources.Constant TOutSou(k=303.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
protected
  FixedResistances.FixedResistanceDpM res1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=10,
    linearized=true) "Flow resistance"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  FixedResistances.FixedResistanceDpM res2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=10,
    linearized=true) "Flow resistance"
    annotation (Placement(transformation(extent={{80,122},{100,142}})));
equation
  connect(theCon.port_b,vol. heatPort)
    annotation (Line(points={{0,120},{0,120},{20,120},{20,70},{40,70}},
                                                    color={191,0,0}));
  connect(preHea.port,vol. heatPort)
    annotation (Line(points={{40,120},{20,120},{20,70},{40,70}},
                                                            color={191,0,0}));
  connect(TOut1.port,theCon. port_a)
    annotation (Line(points={{-40,120},{-40,120},{-20,120}},
                                                     color={191,0,0}));
  connect(vol.heatPort, theZonAda.heaPorAir) annotation (Line(points={{40,70},{40,
          70},{20,70},{20,152},{-120,152}}, color={191,0,0}));
  connect(TOutSou.y, TOut1.T)
    annotation (Line(points={{-79,120},{-62,120}}, color={0,0,127}));
  connect(TOut, TOutSou.y) annotation (Line(points={{0,200},{0,170},{-70,170},{-70,
          120},{-79,120}}, color={0,0,127}));
  connect(theZonAda.ports[1], res1.port_a) annotation (Line(points={{-120,160},
          {-20,160},{80,160}}, color={0,127,255}));
  connect(theZonAda.ports[2], res2.port_a) annotation (Line(points={{-120,160},
          {-26,160},{60,160},{60,132},{80,132}}, color={0,127,255}));
  connect(res2.port_b, vol.ports[1]) annotation (Line(points={{100,132},{110,
          132},{110,46},{48,46},{48,60}}, color={0,127,255}));
  connect(res1.port_b, vol.ports[2]) annotation (Line(points={{100,160},{112,
          160},{114,160},{114,52},{114,50},{52,50},{52,60}}, color={0,127,255}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
        Text(
          extent={{-26,176},{24,156}},
          lineColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>
This example validates that 
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective
</a> 
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/ThermalZoneConvectiveAir1.mos"
        "Export FMU"));
end ThermalZoneConvectiveAir1;

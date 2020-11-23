within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Loads.BaseClasses;
partial model PartialBuildingWithETS_bck
  "Partial model of a building with an energy transfer station"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=max(
      ets.m1HexChi_flow_nominal, ets.mEva_flow_nominal),
    final m_flow_small=1E-4*m_flow_nominal,
    final show_T=false,
    final allowFlowReversal=allowFlowReversalDis);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal on the building side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalDis = false
    "Set to true to allow flow reversal on the district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nSup = 2
    "Number of supply lines"
    annotation(Dialog(group="ETS model parameters"), Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dT_nominal=5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=273.15 + 18
    "Chilled water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
     TChiWatSup_nominal + dT_nominal
     "Chilled water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature THeaWatSup_nominal=273.15 + 40
    "Heating water supply temperature"
    annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
     THeaWatSup_nominal - dT_nominal
     "Heating water return temperature"
     annotation(Dialog(group="ETS model parameters"));
  parameter Modelica.SIunits.Pressure dp_nominal=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="ETS model parameters"));
  parameter Real COP_nominal=5
    "Heat pump COP"
    annotation(Dialog(group="ETS model parameters"));
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TSetChiWat
    "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput TSetHeaWat
    "Heating water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  // COMPONENTS
  replaceable DHC.Loads.BaseClasses.PartialBuilding bui(
      redeclare final package Medium = Medium,
      final nPorts_a=1,
      final nPorts_b=1,
      final allowFlowReversal=allowFlowReversalBui)
    "Building"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  replaceable EnergyTransferStations.ETSSimplified ets(
    final dT_nominal=dT_nominal,
    final TChiWatSup_nominal=TChiWatSup_nominal,
    final TChiWatRet_nominal=TChiWatRet_nominal,
    final THeaWatSup_nominal=THeaWatSup_nominal,
    final THeaWatRet_nominal=THeaWatRet_nominal,
    final dp_nominal=dp_nominal,
    final COP_nominal=COP_nominal,
    QChiWat_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
    QHeaWat_flow_nominal=sum(bui.terUni.QHea_flow_nominal),
    nPorts_aBui=1,
    nPorts_bBui=1,
    nPorts_bDis=1,
    nPorts_aDis=1)
    constrainedby DHC.EnergyTransferStations.BaseClasses.PartialETS(
      nSup=nSup,
      redeclare final package Medium = Medium,
      final allowFlowReversalBui=allowFlowReversalBui,
      final allowFlowReversalDis=allowFlowReversalDis)
    "Energy transfer station"
    annotation (Placement(transformation(extent={{-20,-62},{20,-22}})));

equation
  connect(TSetChiWat, ets.TSetChiWat) annotation (Line(points={{-120,40},{-74,
          40},{-74,-44.6667},{-21.3333,-44.6667}},
                                               color={0,0,127}));
  connect(TSetHeaWat, ets.TSetHeaWat) annotation (Line(points={{-120,70},{-68,
          70},{-68,-39.3333},{-21.3333,-39.3333}},
                                               color={0,0,127}));
  connect(bui.ports_b[1], ets.ports_aBui[1]) annotation (Line(points={{10,44},{
          40,44},{40,0},{-60,0},{-60,-24},{-20,-24},{-20,-24.6667}}, color={0,
          127,255}));
  connect(ets.ports_bBui[1], bui.ports_a[1]) annotation (Line(points={{20,
          -24.6667},{60,-24.6667},{60,20},{-40,20},{-40,44},{-10,44}}, color={0,
          127,255}));
  connect(ets.ports_bDis[1], port_b) annotation (Line(points={{20,-59.3333},{80,
          -59.3333},{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, ets.ports_aDis[1]) annotation (Line(points={{-100,0},{-80,0},
          {-80,-59.3333},{-20,-59.3333}}, color={0,127,255}));
  annotation (
    DefaultComponentName="bui",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-60,-34},{0,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-34},{0,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-40},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-28},{60,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{-60,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-40,60},{40,60},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-40,60},{40,-40}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{-30,30},{-10,50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,30},{30,50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-30,-10},{-10,10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,-10},{30,10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
        Rectangle(
          extent={{-20,-3},{20,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={63,-20},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-63,-21},
          rotation=90),
        Rectangle(
          extent={{-19,-3},{19,3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-57,-13},
          rotation=90),
        Rectangle(
          extent={{-19,3},{19,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={57,-13},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialBuildingWithETS_bck;

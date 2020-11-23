within Buildings.Experimental.DHC.Loads.BaseClasses;
partial model PartialBuildingWithETS
  "Partial model of a building with an energy transfer station"
  replaceable package MediumBui=Modelica.Media.Interfaces.PartialMedium
    "Building side medium"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),choice(redeclare
          package Medium =
                      Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumDis=Modelica.Media.Interfaces.PartialMedium
    "District side medium"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),choice(redeclare
          package Medium =
                     Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Integer nPorts_aHeaWat=0
    "Number of heating water fluid ports"
    annotation (Evaluate=true);
  final parameter Integer nPorts_bHeaWat=nPorts_aHeaWat
    "Number of heating water fluid ports"
    annotation (Evaluate=true);
  parameter Integer nPorts_aChiWat=0
    "Number of chilled water fluid ports"
    annotation (Evaluate=true);
  final parameter Integer nPorts_bChiWat=nPorts_aChiWat
    "Number of chilled water fluid ports"
    annotation (Evaluate=true);
  final parameter Boolean have_heaWat=nPorts_aHeaWat > 0
    "Set to true if the ETS supplies heating water"
    annotation (Evaluate=true);
  final parameter Boolean have_chiWat=nPorts_aChiWat > 0
    "Set to true if the ETS supplies chilled water"
    annotation (Evaluate=true);
  parameter Boolean have_hotWat=true
    "Set to true if the ETS supplies domestic hot water"
    annotation (Evaluate=true);
  parameter Boolean have_fanETS=true
    "Set to true if fans drawn power is computed for ETS equipement"
    annotation (Evaluate=true);
  parameter Boolean have_pumETS=true
    "Set to true if pumps drawn power is computed for ETS equipement"
    annotation (Evaluate=true);
  parameter Boolean have_fanBui=true
    "Set to true if fans drawn power is computed for building equipement"
    annotation (Evaluate=true);
  parameter Boolean have_pumBui=true
    "Set to true if pumps drawn power is computed for building equipement"
    annotation (Evaluate=true);
  parameter Boolean have_eleHeaETS=true
    "Set to true if the ETS has electric heating"
    annotation (Evaluate=true);
  parameter Boolean have_eleCooETS=true
    "Set to true if the ETS has electric cooling"
    annotation (Evaluate=true);
  parameter Boolean have_eleHeaBui=true
    "Set to true if the building has decentralized electric heating equipment"
    annotation (Evaluate=true);
  parameter Boolean have_eleCooBui=true
    "Set to true if the building has decentralized electric cooling equipment"
    annotation (Evaluate=true);
  parameter Boolean have_weaBus=true
    "Set to true for weather bus"
    annotation (Evaluate=true);
  parameter Boolean allowFlowReversalBui=false
    "Set to true to allow flow reversal on building side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversalDis=false
    "Set to true to allow flow reversal on district side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal=0
    "Design heat flow rate for chilled water production (<0)"
    annotation (Dialog(group="Nominal condition",enable=have_chiWat));
  parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal=0
    "Design heat flow rate for heating water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_heaWat));
  parameter Modelica.SIunits.HeatFlowRate QHotWat_flow_nominal=0
    "Design heat flow rate for hot water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_hotWat));
  final parameter Boolean have_eleHea=have_eleHeaBui or have_eleHeaETS
    "Set to true if the building or ETS has electric heating equipment"
    annotation (Evaluate=true);
  final parameter Boolean have_eleCoo=have_eleCooBui or have_eleCooETS
    "Set to true if the building or ETS has electric cooling equipment"
    annotation (Evaluate=true);
  final parameter Boolean have_fan=have_fanBui or have_fanETS
    "Set to true if the power drawn by fan motors is computed"
    annotation (Evaluate=true);
  final parameter Boolean have_pum=have_pumBui or have_pumETS
    "Set to true if the power drawn by pump motors is computed"
    annotation (Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aDis(
    redeclare package Medium=MediumDis,
    m_flow(
      min=
        if allowFlowReversalDis then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=MediumDis.h_default,
      nominal=MediumDis.h_default))
    "Fluid connector for district water supply"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDis(
    redeclare package Medium=MediumDis,
    m_flow(
      max=
        if allowFlowReversalDis then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=MediumDis.h_default,
      nominal=MediumDis.h_default))
    "Fluid connector for district water return"
    annotation (Placement(transformation(extent={{130,-10},{150,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement( transformation(extent={{-20,100},{20,140}}),
      iconTransformation(extent={{-10,58},{10,78}})));
  // COMPONENTS
  replaceable DHC.Loads.BaseClasses.PartialBuilding bui(
    final nPorts_aHeaWat=nPorts_aHeaWat,
    final nPorts_bHeaWat=nPorts_bHeaWat,
    final nPorts_aChiWat=nPorts_aChiWat,
    final nPorts_bChiWat=nPorts_bChiWat,
    final have_eleHea=have_eleHeaBui,
    final have_eleCoo=have_eleCooBui,
    final have_watHea=have_heaWat,
    final have_watCoo=have_chiWat,
    final have_fan=have_fanBui,
    final have_pum=have_pumBui,
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Building model "
    annotation (Placement(transformation(extent={{-30,8},{30,68}})));
  replaceable DHC.EnergyTransferStations.BaseClasses.PartialETS ets(
    final nPorts_aHeaWat=nPorts_aHeaWat,
    final nPorts_bHeaWat=nPorts_bHeaWat,
    final nPorts_aChiWat=nPorts_aChiWat,
    final nPorts_bChiWat=nPorts_bChiWat,
    final have_eleHea=have_eleHeaETS,
    final have_eleCoo=have_eleCooETS,
    final have_heaWat=have_heaWat,
    final have_chiWat=have_chiWat,
    final have_hotWat=have_hotWat,
    final have_fan=have_fanETS,
    final have_pum=have_pumETS,
    redeclare final package MediumBui = MediumBui,
    redeclare final package MediumDis = MediumDis,
    final allowFlowReversalBui=allowFlowReversalBui,
    final allowFlowReversalDis=allowFlowReversalDis)
    "Energy transfer station model"
    annotation (Placement(transformation(extent={{-30,-84},{30,-24}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(
    final unit="W") if bui.have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{140,110},{180,150}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(
    final unit="W") if bui.have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{140,90},{180,130}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(final unit="W") if
    have_eleHea "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(final unit="W") if
    have_eleCoo "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(final unit="W") if
     have_fan "Power drawn by fan motors" annotation (
      Placement(transformation(extent={{140,30},{180,70}}), iconTransformation(
          extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final unit="W") if have_pum "Power drawn by pump motors" annotation (
      Placement(transformation(extent={{140,10},{180,50}}), iconTransformation(
          extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPHea(
    final nin=Modelica.Math.BooleanVectors.countTrue({have_eleHeaBui, have_eleHeaETS})) if
       have_eleHea
    "Total power drawn by heating equipment"
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(
    final nin=Modelica.Math.BooleanVectors.countTrue({have_eleCooBui, have_eleCooETS})) if
       have_eleCoo
    "Total power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{90,60},{110,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPFan(
    final nin=Modelica.Math.BooleanVectors.countTrue({have_fanBui, have_fanETS})) if
       have_fan
    "Total power drawn by fan motors"
    annotation (Placement(transformation(extent={{110,40},{130,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    final nin=Modelica.Math.BooleanVectors.countTrue({have_pumBui, have_pumETS})) if
       have_pum
    "Total power drawn by pump motors"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));
equation
  connect(bui.ports_bHeaWat, ets.ports_aHeaWat) annotation (Line(points={{30,32},
          {54,32},{54,-14},{-60,-14},{-60,-28},{-30,-28}},        color={0,127,255}));
  connect(ets.ports_bHeaWat, bui.ports_aHeaWat) annotation (Line(points={{30,-28},
          {60,-28},{60,0},{-60,0},{-60,32},{-30,32}},         color={0,127,255}));
  connect(bui.ports_bChiWat, ets.ports_aChiWat) annotation (Line(points={{30,20},
          {40,20},{40,-20},{-40,-20},{-40,-38},{-30,-38}},        color={0,127,255}));
  connect(ets.ports_bChiWat, bui.ports_aChiWat) annotation (Line(points={{30,-38},
          {46,-38},{46,-8},{-40,-8},{-40,20},{-30,20}},         color={0,127,255}));
  connect(port_aDis, ets.port_aDis) annotation (Line(points={{-140,0},{-120,0},{
          -120,-80},{-30,-80}}, color={0,127,255}));
  connect(ets.port_bDis, port_bDis) annotation (Line(points={{30,-80},{120,-80},
          {120,0},{140,0}}, color={0,127,255}));
  connect(weaBus, bui.weaBus) annotation (Line(
      points={{0,120},{0,90},{0,59.4},{0.1,59.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, ets.weaBus) annotation (Line(
      points={{0,120},{0,72},{4,72},{4,-26},{-23.2,-26},{-23.2,-36.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bui.QHea_flow, QHea_flow) annotation (Line(points={{32,64},{40,64},{40,
          130},{160,130}}, color={0,0,127}));
  connect(bui.QCoo_flow, QCoo_flow) annotation (Line(points={{32,60},{46,60},{46,
          110},{160,110}}, color={0,0,127}));
  connect(totPHea.y, PHea)
    annotation (Line(points={{132,90},{160,90}}, color={0,0,127}));
  connect(totPCoo.y, PCoo)
    annotation (Line(points={{112,70},{160,70}}, color={0,0,127}));
  connect(totPFan.y, PFan)
    annotation (Line(points={{132,50},{160,50}}, color={0,0,127}));
  connect(totPPum.y, PPum)
    annotation (Line(points={{112,30},{160,30}}, color={0,0,127}));
  connect(bui.PHea, totPHea.u[1]) annotation (Line(points={{32,56},{60,56},{60,90},
          {108,90}}, color={0,0,127}));
  connect(ets.PHea, totPHea.u[2]) annotation (Line(points={{32,-48},{62,-48},{62,
          90},{108,90}}, color={0,0,127}));
  connect(bui.PCoo, totPCoo.u[1]) annotation (Line(points={{32,52},{64,52},{64,70},
          {88,70}}, color={0,0,127}));
  connect(ets.PCoo, totPCoo.u[2]) annotation (Line(points={{32,-52},{66,-52},{66,
          70},{88,70}}, color={0,0,127}));
  connect(bui.PFan, totPFan.u[1]) annotation (Line(points={{32,48},{68,48},{68,50},
          {108,50}}, color={0,0,127}));
  connect(ets.PFan, totPFan.u[2]) annotation (Line(points={{32,-56},{70,-56},{70,
          50},{108,50}}, color={0,0,127}));
  connect(bui.PPum, totPPum.u[1]) annotation (Line(points={{32,44},{72,44},{72,30},
          {88,30}}, color={0,0,127}));
  connect(ets.PPum, totPPum.u[2]) annotation (Line(points={{32,-60},{74,-60},{74,
          30},{88,30}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end PartialBuildingWithETS;

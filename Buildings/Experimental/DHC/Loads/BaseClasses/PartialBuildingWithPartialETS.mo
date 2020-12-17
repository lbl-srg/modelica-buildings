within Buildings.Experimental.DHC.Loads.BaseClasses;
partial model PartialBuildingWithPartialETS
  "Partial model of a building with an energy transfer station"
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  replaceable package MediumSer=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium";
  replaceable package MediumSerHea_a=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium at heating inlet"
    annotation(Dialog(enable=
      typ == TypDisSys.CombinedGeneration1 or
      typ == TypDisSys.HeatingGeneration1));
  replaceable package MediumBui=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Building side medium";
  parameter Integer nPorts_heaWat=0
    "Number of heating water fluid ports"
    annotation (Evaluate=true);
  parameter Integer nPorts_chiWat=0
    "Number of chilled water fluid ports"
    annotation (Evaluate=true);
  parameter Real facMul = 1
    "Multiplier factor"
    annotation (Evaluate=true);
  parameter Boolean allowFlowReversalSer=false
    "Set to true to allow flow reversal on service side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversalBui=false
    "Set to true to allow flow reversal on building side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  // The following parameters are propagated up from building and ETS components.
  final parameter TypDisSys typ=ets.typ
    "Type of district system";
  final parameter Boolean have_heaWat=ets.have_heaWat
    "Set to true if the ETS supplies heating water"
    annotation (Evaluate=true);
  final parameter Boolean have_hotWat=ets.have_hotWat
    "Set to true if the ETS supplies domestic hot water"
    annotation (Evaluate=true);
  final parameter Boolean have_chiWat=ets.have_chiWat
    "Set to true if the ETS supplies chilled water"
    annotation (Evaluate=true);
  final parameter Boolean have_eleHea=bui.have_eleHea or ets.have_eleHea
    "Set to true if the building or ETS has electric heating equipment"
    annotation (Evaluate=true);
  final parameter Boolean have_eleCoo=bui.have_eleCoo or ets.have_eleCoo
    "Set to true if the building or ETS has electric cooling equipment"
    annotation (Evaluate=true);
  final parameter Boolean have_fan=bui.have_fan or ets.have_fan
    "Set to true if the power drawn by fan motors is computed"
    annotation (Evaluate=true);
  final parameter Boolean have_pum=bui.have_pum or ets.have_pum
    "Set to true if the power drawn by pump motors is computed"
    annotation (Evaluate=true);
  final parameter Boolean have_weaBus=bui.have_weaBus or ets.have_weaBus
    "Set to true for weather bus"
    annotation (Evaluate=true);
  final parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal=
    ets.QChiWat_flow_nominal
    "Design heat flow rate for chilled water production (<0)"
    annotation (Dialog(group="Nominal condition",enable=have_chiWat));
  final parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal=
    ets.QHeaWat_flow_nominal
    "Design heat flow rate for heating water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_heaWat));
  final parameter Modelica.SIunits.HeatFlowRate QHotWat_flow_nominal=
    ets.QHotWat_flow_nominal
    "Design heat flow rate for hot water production (>0)"
    annotation (Dialog(group="Nominal condition",enable=have_hotWat));
  // Parameters for connect clauses.
  final parameter Integer idxPHeaETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPCooETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPFanETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  final parameter Integer idxPPumETS=max(
    Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum}),
    1)
    "Index for connecting the ETS output connector"
    annotation (Evaluate=true);
  // IO CONNECTORS
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
      iconTransformation(extent={{-10,52},{10,72}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QHea_flow(
    final unit="W") if bui.have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{220,180},{260,220}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={50,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(
    final unit="W") if bui.have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{220,160},{260,200}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={70,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{220,140},{260,180}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{220,120},{260,160}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{220,100},{260,140}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,10},{140,50}})));
  // COMPONENTS
  replaceable DHC.Loads.BaseClasses.PartialBuilding bui(
    redeclare final package Medium=MediumBui,
    final nPorts_aHeaWat=nPorts_heaWat,
    final nPorts_bHeaWat=nPorts_heaWat,
    final nPorts_aChiWat=nPorts_chiWat,
    final nPorts_bChiWat=nPorts_chiWat,
    final allowFlowReversal=allowFlowReversalBui)
    "Building model "
    annotation (Placement(transformation(extent={{-30,8},{30,68}})));
  replaceable DHC.EnergyTransferStations.BaseClasses.PartialETS ets(
    redeclare final package MediumBui=MediumBui,
    redeclare final package MediumSer=MediumSer,
    redeclare final package MediumSerHea_a=MediumSerHea_a,
    final nPorts_aHeaWat=nPorts_heaWat,
    final nPorts_bHeaWat=nPorts_heaWat,
    final nPorts_aChiWat=nPorts_chiWat,
    final nPorts_bChiWat=nPorts_chiWat,
    final allowFlowReversalSer=allowFlowReversalSer,
    final allowFlowReversalBui=allowFlowReversalBui)
    "Energy transfer station model"
    annotation (Placement(transformation(extent={{-30,-86},{30,-26}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPHea(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}))
    "Total power drawn by heating equipment"
    annotation (Placement(transformation(extent={{160,150},{180,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}))
    "Total power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPFan(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}))
    "Total power drawn by fan motors"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum}))
    "Total power drawn by pump motors"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-230,-130},{-210,-110}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{210,-130},{230,-110}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerHea(
    redeclare package Medium = MediumSerHea_a,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSerHea_a.h_default, nominal=MediumSerHea_a.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service supply line"
    annotation (Placement(
      transformation(extent={{-230,-170},{-210,-150}}), iconTransformation(
        extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerHea(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service return line"
    annotation (Placement(
        transformation(extent={{210,-170},{230,-150}}), iconTransformation(
          extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service supply line"
    annotation (Placement(transformation(extent={{-230,-210},{-210,-190}}),
       iconTransformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service return line"
    annotation (Placement(
      transformation(extent={{210,-210},{230,-190}}), iconTransformation(
        extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQHea_flow(
    final k=facMul) if bui.have_heaLoa "Multiplier"
    annotation (Placement(transformation(extent={{190,190},{210,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulQCoo_flow(
    final k=facMul) if bui.have_cooLoa
    "Multiplier"
    annotation (Placement(transformation(extent={{190,170},{210,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPHea(
    final k=facMul) if have_eleHea "Multiplier"
    annotation (Placement(transformation(extent={{190,150},{210,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPCoo(
    final k=facMul) if have_eleCoo "Multiplier"
    annotation (Placement(transformation(extent={{190,130},{210,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPFan(
    final k=facMul) if have_fan "Multiplier"
    annotation (Placement(transformation(extent={{190,110},{210,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPPum(
    final k=facMul) if have_pum "Multiplier"
    annotation (Placement(transformation(extent={{190,90},{210,110}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaSerAmbInl(
    redeclare final package Medium = MediumSer,
    final k=1/facMul,
    final allowFlowReversal=allowFlowReversalSer) if
    typ == TypDisSys.CombinedGeneration5 "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaSerAmbOut(
    redeclare final package Medium = MediumSer,
    final k=facMul,
    final allowFlowReversal=allowFlowReversalSer) if
    typ == TypDisSys.CombinedGeneration5 "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaSerHeaInl(
    redeclare final package Medium = MediumSerHea_a,
    final k=1/facMul,
    final allowFlowReversal=allowFlowReversalSer) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaSerHeaOut(
    redeclare final package Medium = MediumSer,
    final k=facMul,
    final allowFlowReversal=allowFlowReversalSer) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaSerCooInl(
    redeclare final package Medium = MediumSer,
    final k=1/facMul,
    final allowFlowReversal=allowFlowReversalSer) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaSerCooOut(
    redeclare final package Medium = MediumSer,
    final k=facMul,
    final allowFlowReversal=allowFlowReversalSer) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
initial equation
  assert(ets.have_heaWat == bui.have_heaWat,
    "In "+getInstanceName()+": The ETS component is configured with have_heaWat="+
    String(ets.have_heaWat)+" whereas the building is configured with have_heaWat="+
    String(bui.have_heaWat));
  assert(ets.have_chiWat == bui.have_chiWat,
    "In "+getInstanceName()+": The ETS component is configured with have_chiWat="+
    String(ets.have_chiWat)+" whereas the building is configured with have_chiWat="+
    String(bui.have_chiWat));
  if have_heaWat then
    assert(nPorts_heaWat > 0,
    "In "+getInstanceName()+": The ETS component is configured with have_heaWat="+
    String(ets.have_heaWat)+" but the number of fluid ports for chilled water
    (nPorts_heaWat) is zero.");
  end if;
  if have_chiWat then
    assert(nPorts_chiWat > 0,
    "In "+getInstanceName()+": The ETS component is configured with have_chiWat="+
    String(ets.have_chiWat)+" but the number of fluid ports for chilled water
    (nPorts_chiWat) is zero.");
  end if;
equation
  connect(bui.ports_bHeaWat,ets.ports_aHeaWat)
    annotation (Line(points={{30,32},{54,32},{54,-14},{-60,-14},{-60,-30},{-30,-30}},color={0,127,255}));
  connect(ets.ports_bHeaWat,bui.ports_aHeaWat)
    annotation (Line(points={{30,-30},{60,-30},{60,0},{-60,0},{-60,32},{-30,32}},color={0,127,255}));
  connect(bui.ports_bChiWat,ets.ports_aChiWat)
    annotation (Line(points={{30,20},{40,20},{40,-20},{-40,-20},{-40,-40},{-30,-40}},color={0,127,255}));
  connect(ets.ports_bChiWat,bui.ports_aChiWat)
    annotation (Line(points={{30,-40},{46,-40},{46,-8},{-40,-8},{-40,20},{-30,20}},color={0,127,255}));
  connect(weaBus,bui.weaBus)
    annotation (Line(points={{0,200},{0,59.4},{0.1,59.4}},       color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBus,ets.weaBus)
    annotation (Line(points={{0,200},{0,72},{4,72},{4,-26},{0.1,-26},{0.1,-29.4}},color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(bui.PHea,totPHea.u[1])
    annotation (Line(points={{32,56},{126,56},{126,160},{158,160}},
                                                               color={0,0,127}));
  connect(ets.PHea,totPHea.u[idxPHeaETS])
    annotation (Line(points={{34,-48},{130,-48},{130,158},{158,158},{158,160}},
                                                                 color={0,0,127}));
  connect(bui.PCoo,totPCoo.u[1])
    annotation (Line(points={{32,52},{64,52},{64,140},{138,140}},
                                                              color={0,0,127}));
  connect(ets.PCoo,totPCoo.u[idxPCooETS])
    annotation (Line(points={{34,-52},{66,-52},{66,138},{138,138},{138,140}},
                                                                color={0,0,127}));
  connect(bui.PFan,totPFan.u[1])
    annotation (Line(points={{32,48},{132,48},{132,120},{158,120}},
                                                               color={0,0,127}));
  connect(ets.PFan,totPFan.u[idxPFanETS])
    annotation (Line(points={{34,-56},{136,-56},{136,118},{158,118},{158,120}},
                                                                 color={0,0,127}));
  connect(bui.PPum,totPPum.u[1])
    annotation (Line(points={{32,44},{72,44},{72,100},{138,100}},
                                                              color={0,0,127}));
  connect(ets.PPum,totPPum.u[idxPPumETS])
    annotation (Line(points={{34,-60},{74,-60},{74,98},{138,98},{138,100}},
                                                                color={0,0,127}));
  connect(bui.QHea_flow, mulQHea_flow.u) annotation (Line(points={{32,64},{118,64},
          {118,200},{188,200}}, color={0,0,127}));
  connect(mulQHea_flow.y, QHea_flow)
    annotation (Line(points={{212,200},{240,200}}, color={0,0,127}));
  connect(bui.QCoo_flow, mulQCoo_flow.u) annotation (Line(points={{32,60},{122,60},
          {122,180},{188,180}}, color={0,0,127}));
  connect(mulQCoo_flow.y, QCoo_flow)
    annotation (Line(points={{212,180},{240,180}}, color={0,0,127}));
  connect(totPHea.y, mulPHea.u)
    annotation (Line(points={{182,160},{188,160}}, color={0,0,127}));
  connect(mulPHea.y, PHea)
    annotation (Line(points={{212,160},{240,160}}, color={0,0,127}));
  connect(totPCoo.y, mulPCoo.u)
    annotation (Line(points={{162,140},{188,140}}, color={0,0,127}));
  connect(mulPCoo.y, PCoo)
    annotation (Line(points={{212,140},{240,140}}, color={0,0,127}));
  connect(totPFan.y, mulPFan.u)
    annotation (Line(points={{182,120},{188,120}}, color={0,0,127}));
  connect(mulPFan.y, PFan)
    annotation (Line(points={{212,120},{240,120}}, color={0,0,127}));
  connect(totPPum.y, mulPPum.u)
    annotation (Line(points={{162,100},{188,100}}, color={0,0,127}));
  connect(mulPPum.y, PPum)
    annotation (Line(points={{212,100},{240,100}}, color={0,0,127}));
  connect(port_aSerCoo, scaSerCooInl.port_a)
    annotation (Line(points={{-220,-200},{-200,-200}}, color={0,127,255}));
  connect(scaSerCooInl.port_b, ets.port_aSerCoo) annotation (Line(points={{-180,
          -200},{-160,-200},{-160,-84},{-30,-84}}, color={0,127,255}));
  connect(scaSerCooOut.port_b, port_bSerCoo)
    annotation (Line(points={{200,-200},{220,-200}}, color={0,127,255}));
  connect(ets.port_bSerCoo, scaSerCooOut.port_a) annotation (Line(points={{30,-84},
          {160,-84},{160,-200},{180,-200}}, color={0,127,255}));
  connect(port_aSerHea, scaSerHeaInl.port_a)
    annotation (Line(points={{-220,-160},{-200,-160}}, color={0,127,255}));
  connect(scaSerHeaInl.port_b, ets.port_aSerHea) annotation (Line(points={{-180,
          -160},{-164,-160},{-164,-80},{-30,-80}}, color={0,127,255}));
  connect(port_aSerAmb, scaSerAmbInl.port_a)
    annotation (Line(points={{-220,-120},{-200,-120}}, color={0,127,255}));
  connect(scaSerAmbInl.port_b, ets.port_aSerAmb) annotation (Line(points={{-180,
          -120},{-168,-120},{-168,-76},{-30,-76}}, color={0,127,255}));
  connect(ets.port_bSerHea, scaSerHeaOut.port_a) annotation (Line(points={{30,-80},
          {164,-80},{164,-160},{180,-160}}, color={0,127,255}));
  connect(scaSerHeaOut.port_b, port_bSerHea)
    annotation (Line(points={{200,-160},{220,-160}}, color={0,127,255}));
  connect(ets.port_bSerAmb, scaSerAmbOut.port_a) annotation (Line(points={{30,-76},
          {168,-76},{168,-120},{180,-120}}, color={0,127,255}));
  connect(scaSerAmbOut.port_b, port_bSerAmb)
    annotation (Line(points={{200,-120},{220,-120}}, color={0,127,255}));
  annotation (
    DefaultComponentName="bui",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,6},{-60,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-100,-86},{-22,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling),
        Polygon(
          points={{0,74},{-40,54},{40,54},{0,74}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-40,54},{40,-46}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-30,24},{-10,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,24},{30,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-16},{-10,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-16},{30,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0}),
        Rectangle(
          extent={{60,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-11,6},{11,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5,
          origin={66,-17},
          rotation=-90),
        Rectangle(
          extent={{40,-16},{60,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-11,6},{11,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5,
          origin={-66,-17},
          rotation=-90),
        Rectangle(
          extent={{-60,-16},{-40,-28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{40,-34},{100,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-100,-34},{-40,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-14,-6},{14,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling,
          origin={-28,-60},
          rotation=90),
        Rectangle(
          extent={{-14,-6},{14,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={28,-60},
          rotation=90,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling),
        Rectangle(
          extent={{22,-86},{100,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-220},{220,220}})),
    Documentation(info="<html>
<p>
Partial model to be used for modeling
</p>
<ul>
<li>
an energy transfer station and the optional in-building primary systems,
based on a model extending 
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS\">
Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS</a>, and
</li>
<li>
the served building, based on a model extending 
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding</a>.
</li>
</ul>
<p>
See the schematics below for a description of the physical boundaries
of the composing systems.
</p>
<p>
The parameters defining the set of outside connectors of this class
are <i>propagated up</i> from the ETS and building components.
The connect clauses between the ETS and the building connectors 
are automatically generated based on the previous parameters and the 
additional parameters <code>nPorts_heaWat</code> and <code>nPorts_chiWat</code>
that need to be specified.
In case of a heating service line, the model allows for using two
different media at the inlet <code>port_aSerHea</code> and at the oulet
<code>port_bSerHea</code> to represent a steam supply and condensate
return.
</p>
<h4>Scaling</h4>
<p>
Scaling is implemented by means of a multiplier factor <code>facMul</code>
being applied to each extensive quantity (mass and heat flow rate, electric power)
computed by the model.
<br/>
</p>
<p>
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Loads/PartialBuildingWithPartialETS.png\"/>
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 14, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBuildingWithPartialETS;

within Buildings.DHC.Loads.BaseClasses;
partial model PartialBuildingWithPartialETS
  "Partial model of a building with an energy transfer station"
  import TypDisSys=Buildings.DHC.Types.DistrictSystemType
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
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPorts_chiWat=0
    "Number of chilled water fluid ports"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Real facMul = 1
    "Multiplier factor"
    annotation (Evaluate=true, Dialog(group="Scaling"));
  parameter Boolean allowFlowReversalSer=false
    "Set to true to allow flow reversal on service side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversalBui=false
    "Set to true to allow flow reversal on building side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  // The following parameters are propagated up from building and ETS components.
  final parameter TypDisSys typ=ets.typ
    "Type of district system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_heaWat=ets.have_heaWat
    "Set to true if the ETS supplies heating water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_hotWat=ets.have_hotWat
    "Set to true if the ETS supplies domestic hot water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_chiWat=ets.have_chiWat
    "Set to true if the ETS supplies chilled water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_eleHea=bui.have_eleHea or ets.have_eleHea
    "Set to true if the building or ETS has electric heating system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Integer nFue=ets.nFue
    "Number of fuel types (0 means no combustion system)"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_eleCoo=bui.have_eleCoo or ets.have_eleCoo
    "Set to true if the building or ETS has electric cooling system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_fan=bui.have_fan or ets.have_fan
    "Set to true if fan power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_pum=bui.have_pum or ets.have_pum
    "Set to true if pump power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_weaBus=bui.have_weaBus or ets.have_weaBus
    "Set to true to use a weather bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal(min=0)=
    ets.QHeaWat_flow_nominal "Nominal capacity of heating system (>=0)"
    annotation (Dialog(group="Nominal condition", enable=have_heaWat));
  final parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0)=
    ets.QHotWat_flow_nominal
    "Nominal capacity of hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition", enable=have_hotWat));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal(max=0)=
    ets.QChiWat_flow_nominal "Nominal capacity of cooling system (<=0)"
    annotation (Dialog(group="Nominal condition", enable=have_chiWat));
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
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default))
 if typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-310,-210},{-290,-190}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default))
 if typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerHea(
    redeclare package Medium = MediumSerHea_a,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSerHea_a.h_default, nominal=MediumSerHea_a.h_default))
 if typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service supply line"
    annotation (Placement(
      transformation(extent={{-310,-250},{-290,-230}}), iconTransformation(
        extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerHea(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default))
 if typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service return line"
    annotation (Placement(
        transformation(extent={{290,-250},{310,-230}}), iconTransformation(
          extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default))
 if typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service supply line"
    annotation (Placement(transformation(extent={{-310,-290},{-290,-270}}),
       iconTransformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default))
 if typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service return line"
    annotation (Placement(
      transformation(extent={{290,-290},{310,-270}}), iconTransformation(
        extent={{90,-90},{110,-70}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QHea_flow(
    final unit="W") if bui.have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{300,260},{340,300}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={50,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(
    final unit="W") if bui.have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{300,220},{340,260}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={70,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating system"
    annotation (Placement(transformation(extent={{300,182},{340,222}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling system"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{300,60},{340,100}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QFue_flow[nFue](
    each final unit="W") if nFue>0
    "Fuel energy input rate"
    annotation (
      Placement(transformation(extent={{300,20},{340,60}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={90,120})));
  // COMPONENTS
  replaceable Buildings.DHC.Loads.BaseClasses.PartialBuilding bui(
    redeclare final package Medium=MediumBui,
    final nPorts_aHeaWat=nPorts_heaWat,
    final nPorts_bHeaWat=nPorts_heaWat,
    final nPorts_aChiWat=nPorts_chiWat,
    final nPorts_bChiWat=nPorts_chiWat,
    final allowFlowReversal=allowFlowReversalBui)
    "Building model "
    annotation (Placement(transformation(extent={{-30,8},{30,68}})));
  replaceable Buildings.DHC.EnergyTransferStations.BaseClasses.PartialETS ets(
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
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPHea(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}))
    "Total power drawn by heating system"
    annotation (Placement(transformation(extent={{242,192},{262,212}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPCoo(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}))
    "Total power drawn by cooling system"
    annotation (Placement(transformation(extent={{240,150},{260,170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPFan(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}))
    "Total power drawn by fan motors"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPPum(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum})) if have_pum
    "Total power drawn by pump motors"
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQHea_flow(u(
        final unit="W"), final k=facMul) if bui.have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{270,270},{290,290}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQCoo_flow(u(
        final unit="W"), final k=facMul) if bui.have_cooLoa "Scaling"
    annotation (Placement(transformation(extent={{270,230},{290,250}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPHea(u(final
        unit="W"), final k=facMul) if have_eleHea "Scaling"
    annotation (Placement(transformation(extent={{270,192},{290,212}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPCoo(u(final
        unit="W"), final k=facMul) if have_eleCoo "Scaling"
    annotation (Placement(transformation(extent={{270,150},{290,170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPFan(u(final
        unit="W"), final k=facMul) if have_fan "Scaling"
    annotation (Placement(transformation(extent={{270,110},{290,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPPum(u(final
        unit="W"), final k=facMul) if have_pum "Scaling"
    annotation (Placement(transformation(extent={{270,70},{290,90}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulSerAmbInl(
    redeclare final package Medium = MediumSer,
    final k=1/facMul,
    final allowFlowReversal=allowFlowReversalSer)
 if typ == TypDisSys.CombinedGeneration5 "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-280,-210},{-260,-190}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulSerAmbOut(
    redeclare final package Medium = MediumSer,
    final k=facMul,
    final allowFlowReversal=allowFlowReversalSer)
 if typ == TypDisSys.CombinedGeneration5 "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{260,-210},{280,-190}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulSerHeaInl(
    redeclare final package Medium = MediumSerHea_a,
    final k=1/facMul,
    final allowFlowReversal=allowFlowReversalSer)
 if typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5 "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-280,-250},{-260,-230}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulSerHeaOut(
    redeclare final package Medium = MediumSer,
    final k=facMul,
    final allowFlowReversal=allowFlowReversalSer)
 if typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5 "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{260,-250},{280,-230}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulSerCooInl(
    redeclare final package Medium = MediumSer,
    final k=1/facMul,
    final allowFlowReversal=allowFlowReversalSer)
 if typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-280,-290},{-260,-270}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulSerCooOut(
    redeclare final package Medium = MediumSer,
    final k=facMul,
    final allowFlowReversal=allowFlowReversalSer)
 if typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{260,-290},{280,-270}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQFue_flow[nFue](
      u(each final unit="W"), each final k=facMul) if nFue > 0 "Scaling"
    annotation (Placement(transformation(extent={{270,30},{290,50}})));
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
    annotation (Line(points={{0,280},{0,59.4},{0.1,59.4}},       color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBus,ets.weaBus)
    annotation (Line(points={{0,280},{0,72},{4,72},{4,-26},{0,-26},{0,-25.9}},    color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(bui.PHea,totPHea.u[1])
    annotation (Line(points={{32,56},{208,56},{208,202},{240,202}},
                                                               color={0,0,127}));
  connect(ets.PHea,totPHea.u[idxPHeaETS])
    annotation (Line(points={{34,-48},{210,-48},{210,200},{240,200},{240,202}},
                                                                 color={0,0,127}));
  connect(bui.PCoo,totPCoo.u[1])
    annotation (Line(points={{32,52},{218,52},{218,160},{238,160}},
                                                              color={0,0,127}));
  connect(ets.PCoo,totPCoo.u[idxPCooETS])
    annotation (Line(points={{34,-52},{220,-52},{220,158},{238,158},{238,160}},
                                                                color={0,0,127}));
  connect(bui.PFan,totPFan.u[1])
    annotation (Line(points={{32,48},{224,48},{224,120},{238,120}},
                                                               color={0,0,127}));
  connect(ets.PFan,totPFan.u[idxPFanETS])
    annotation (Line(points={{34,-56},{226,-56},{226,118},{238,118},{238,120}},
                                                                 color={0,0,127}));
  connect(bui.PPum,totPPum.u[1])
    annotation (Line(points={{32,44},{232,44},{232,80},{238,80}},
                                                              color={0,0,127}));
  connect(ets.PPum,totPPum.u[idxPPumETS])
    annotation (Line(points={{34,-60},{230,-60},{230,82},{238,82},{238,80}},
                                                                color={0,0,127}));
  connect(bui.QHea_flow, mulQHea_flow.u) annotation (Line(points={{32,64},{200,64},
          {200,280},{268,280}}, color={0,0,127}));
  connect(mulQHea_flow.y, QHea_flow)
    annotation (Line(points={{292,280},{320,280}}, color={0,0,127}));
  connect(bui.QCoo_flow, mulQCoo_flow.u) annotation (Line(points={{32,60},{204,60},
          {204,240},{268,240}}, color={0,0,127}));
  connect(mulQCoo_flow.y, QCoo_flow)
    annotation (Line(points={{292,240},{320,240}}, color={0,0,127}));
  connect(totPHea.y, mulPHea.u)
    annotation (Line(points={{264,202},{268,202}}, color={0,0,127}));
  connect(mulPHea.y, PHea)
    annotation (Line(points={{292,202},{320,202}}, color={0,0,127}));
  connect(totPCoo.y, mulPCoo.u)
    annotation (Line(points={{262,160},{268,160}}, color={0,0,127}));
  connect(mulPCoo.y, PCoo)
    annotation (Line(points={{292,160},{320,160}}, color={0,0,127}));
  connect(totPFan.y, mulPFan.u)
    annotation (Line(points={{262,120},{268,120}}, color={0,0,127}));
  connect(mulPFan.y, PFan)
    annotation (Line(points={{292,120},{300,120},{300,122},{306,122},{306,120},{
          320,120}},                               color={0,0,127}));
  connect(totPPum.y, mulPPum.u)
    annotation (Line(points={{262,80},{268,80}},   color={0,0,127}));
  connect(mulPPum.y, PPum)
    annotation (Line(points={{292,80},{320,80}},   color={0,0,127}));
  connect(port_aSerCoo,mulSerCooInl. port_a)
    annotation (Line(points={{-300,-280},{-280,-280}}, color={0,127,255}));
  connect(mulSerCooInl.port_b, ets.port_aSerCoo) annotation (Line(points={{-260,
          -280},{-160,-280},{-160,-84},{-30,-84}}, color={0,127,255}));
  connect(mulSerCooOut.port_b, port_bSerCoo)
    annotation (Line(points={{280,-280},{300,-280}}, color={0,127,255}));
  connect(ets.port_bSerCoo,mulSerCooOut. port_a) annotation (Line(points={{30,-84},
          {160,-84},{160,-280},{260,-280}}, color={0,127,255}));
  connect(port_aSerHea,mulSerHeaInl. port_a)
    annotation (Line(points={{-300,-240},{-280,-240}}, color={0,127,255}));
  connect(mulSerHeaInl.port_b, ets.port_aSerHea) annotation (Line(points={{-260,
          -240},{-164,-240},{-164,-80},{-30,-80}}, color={0,127,255}));
  connect(port_aSerAmb,mulSerAmbInl. port_a)
    annotation (Line(points={{-300,-200},{-280,-200}}, color={0,127,255}));
  connect(mulSerAmbInl.port_b, ets.port_aSerAmb) annotation (Line(points={{-260,
          -200},{-168,-200},{-168,-76},{-30,-76}}, color={0,127,255}));
  connect(ets.port_bSerHea,mulSerHeaOut. port_a) annotation (Line(points={{30,-80},
          {164,-80},{164,-240},{260,-240}}, color={0,127,255}));
  connect(mulSerHeaOut.port_b, port_bSerHea)
    annotation (Line(points={{280,-240},{300,-240}}, color={0,127,255}));
  connect(ets.port_bSerAmb,mulSerAmbOut. port_a) annotation (Line(points={{30,-76},
          {168,-76},{168,-200},{260,-200}}, color={0,127,255}));
  connect(mulSerAmbOut.port_b, port_bSerAmb)
    annotation (Line(points={{280,-200},{300,-200}}, color={0,127,255}));
  connect(mulQFue_flow.y, QFue_flow)
    annotation (Line(points={{292,40},{320,40}}, color={0,0,127}));
  connect(ets.QFue_flow, mulQFue_flow.u) annotation (Line(points={{34,-64},{260,
          -64},{260,40},{268,40}}, color={0,0,127}));
  annotation (
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
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-100,-34},{-40,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
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
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={28,-60},
          rotation=90,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling),
        Rectangle(
          extent={{22,-86},{100,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})),
    Documentation(info="<html>
<p>
Partial model to be used for modeling
</p>
<ul>
<li>
an energy transfer station and the optional in-building primary systems,
based on a model extending
<a href=\"modelica://Buildings.DHC.EnergyTransferStations.BaseClasses.PartialETS\">
Buildings.DHC.EnergyTransferStations.BaseClasses.PartialETS</a>, and
</li>
<li>
the served building, based on a model extending
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.DHC.Loads.BaseClasses.PartialBuilding</a>.
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
Scaling is implemented by means of a multiplier factor <code>facMul</code>.
Each extensive quantity (mass and heat flow rate, electric power)
<i>flowing out</i> through fluid ports, or connected to an
<i>output connector</i> is multiplied by <code>facMul</code>.
Each extensive quantity (mass and heat flow rate, electric power)
<i>flowing in</i> through fluid ports, or connected to an
<i>input connector</i> is multiplied by <code>1/facMul</code>.
This allows modeling, with a single instance,
multiple identical buildings with identical energy transfer stations,
served by the same service line.
</p>
<p>
<br/>
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/DHC/Loads/PartialBuildingWithPartialETS.png\"/>
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 21, 2022, by Kathryn Hinkelman:<br>
Added conditional requirement <code>have_pum</code> to instance
<code>totPPum</code> for cases where ETS and building both don't have pumping.<br>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">#2912</a>.
</li>
<li>
December 14, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBuildingWithPartialETS;

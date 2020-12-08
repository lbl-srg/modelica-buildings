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
  parameter Boolean allowFlowReversal1=false
    "Set to true to allow flow reversal on district side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversal2=false
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
    annotation (Placement(transformation(extent={{-20,100},{20,140}}),iconTransformation(extent={{-10,58},{10,78}})));
  // COMPONENTS
  replaceable DHC.Loads.BaseClasses.PartialBuilding bui(
    redeclare final package Medium=MediumBui,
    final nPorts_aHeaWat=nPorts_heaWat,
    final nPorts_bHeaWat=nPorts_heaWat,
    final nPorts_aChiWat=nPorts_chiWat,
    final nPorts_bChiWat=nPorts_chiWat,
    final allowFlowReversal=allowFlowReversal2)
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
    final allowFlowReversal2=allowFlowReversal2,
    final allowFlowReversal1=allowFlowReversal1)
    "Energy transfer station model"
    annotation (Placement(transformation(extent={{-30,-86},{30,-26}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(
    final unit="W") if bui.have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{140,110},{180,150}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=-90,origin={70,-110})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(
    final unit="W") if bui.have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{140,90},{180,130}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=-90,origin={90,-110})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{140,10},{180,50}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPHea(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleHea,ets.have_eleHea}))
    "Total power drawn by heating equipment"
    annotation (Placement(transformation(extent={{110,80},{130,100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_eleCoo,ets.have_eleCoo}))
    "Total power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{90,60},{110,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPFan(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_fan,ets.have_fan}))
    "Total power drawn by fan motors"
    annotation (Placement(transformation(extent={{110,40},{130,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    final nin=Modelica.Math.BooleanVectors.countTrue(
      {bui.have_pum,ets.have_pum}))
    "Total power drawn by pump motors"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-150,-50},{-130,-30}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{130,-50},{150,-30}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerHea(
    redeclare package Medium = MediumSerHea_a,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSerHea_a.h_default, nominal=MediumSerHea_a.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service supply line"
    annotation (Placement(
      transformation(extent={{-150,-90},{-130,-70}}),   iconTransformation(
        extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerHea(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service return line"
    annotation (Placement(
        transformation(extent={{130,-90},{150,-70}}),   iconTransformation(
          extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service supply line"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}}),
       iconTransformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service return line"
    annotation (Placement(
      transformation(extent={{130,-130},{150,-110}}), iconTransformation(
        extent={{90,-90},{110,-70}})));
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
    annotation (Line(points={{0,120},{0,90},{0,59.4},{0.1,59.4}},color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBus,ets.weaBus)
    annotation (Line(points={{0,120},{0,72},{4,72},{4,-26},{0.1,-26},{0.1,-29.4}},color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(bui.QHea_flow,QHea_flow)
    annotation (Line(points={{32,64},{40,64},{40,130},{160,130}},color={0,0,127}));
  connect(bui.QCoo_flow,QCoo_flow)
    annotation (Line(points={{32,60},{46,60},{46,110},{160,110}},color={0,0,127}));
  connect(totPHea.y,PHea)
    annotation (Line(points={{132,90},{160,90}},color={0,0,127}));
  connect(totPCoo.y,PCoo)
    annotation (Line(points={{112,70},{160,70}},color={0,0,127}));
  connect(totPFan.y,PFan)
    annotation (Line(points={{132,50},{160,50}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{112,30},{160,30}},color={0,0,127}));
  connect(bui.PHea,totPHea.u[1])
    annotation (Line(points={{32,56},{60,56},{60,90},{108,90}},color={0,0,127}));
  connect(ets.PHea,totPHea.u[idxPHeaETS])
    annotation (Line(points={{32,-50},{62,-50},{62,90},{108,90}},color={0,0,127}));
  connect(bui.PCoo,totPCoo.u[1])
    annotation (Line(points={{32,52},{64,52},{64,70},{88,70}},color={0,0,127}));
  connect(ets.PCoo,totPCoo.u[idxPCooETS])
    annotation (Line(points={{32,-54},{66,-54},{66,70},{88,70}},color={0,0,127}));
  connect(bui.PFan,totPFan.u[1])
    annotation (Line(points={{32,48},{68,48},{68,50},{108,50}},color={0,0,127}));
  connect(ets.PFan,totPFan.u[idxPFanETS])
    annotation (Line(points={{32,-58},{70,-58},{70,50},{108,50}},color={0,0,127}));
  connect(bui.PPum,totPPum.u[1])
    annotation (Line(points={{32,44},{72,44},{72,30},{88,30}},color={0,0,127}));
  connect(ets.PPum,totPPum.u[idxPPumETS])
    annotation (Line(points={{32,-62},{74,-62},{74,30},{88,30}},color={0,0,127}));
  connect(port_aSerAmb, ets.port_aSerAmb) annotation (Line(points={{-140,-40},{-60,
          -40},{-60,-76},{-30,-76}}, color={0,127,255}));
  connect(port_aSerHea, ets.port_aSerHea)
    annotation (Line(points={{-140,-80},{-30,-80}}, color={0,127,255}));
  connect(port_aSerCoo, ets.port_aSerCoo) annotation (Line(points={{-140,-120},{
          -40,-120},{-40,-84},{-30,-84}}, color={0,127,255}));
  connect(ets.port_bSerCoo, port_bSerCoo) annotation (Line(points={{30,-84},{40,
          -84},{40,-120},{140,-120}}, color={0,127,255}));
  connect(ets.port_bSerHea, port_bSerHea)
    annotation (Line(points={{30,-80},{140,-80}}, color={0,127,255}));
  connect(ets.port_bSerAmb, port_bSerAmb) annotation (Line(points={{30,-76},{60,
          -76},{60,-40},{140,-40}}, color={0,127,255}));
  annotation (
    DefaultComponentName="bui",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
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
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0}),
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
          rotation=90)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-140},{140,140}})));
end PartialBuildingWithPartialETS;
